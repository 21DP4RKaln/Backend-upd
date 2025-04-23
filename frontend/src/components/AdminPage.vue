<template>
    <div class="admin-page">
      <div v-if="!isAdmin" class="unauthorized-message">
        <h2>{{ $t('admin.unauthorized.title') }}</h2>
        <p>{{ $t('admin.unauthorized.message') }}</p>
        <router-link to="/" class="btn btn-primary">{{ $t('admin.unauthorized.backHome') }}</router-link>
      </div>
  
      <div v-else class="admin-container">
        <h1 class="admin-title">{{ $t('admin.title') }}</h1>
        
        <div class="admin-stats">
          <div class="stat-card">
            <div class="stat-icon">👥</div>
            <div class="stat-value">{{ stats.totalUsers }}</div>
            <div class="stat-label">{{ $t('admin.stats.totalUsers') }}</div>
          </div>
          <div class="stat-card">
            <div class="stat-icon">📝</div>
            <div class="stat-value">{{ stats.totalTasks }}</div>
            <div class="stat-label">{{ $t('admin.stats.totalTasks') }}</div>
          </div>
          <div class="stat-card">
            <div class="stat-icon">🏆</div>
            <div class="stat-value">{{ stats.totalAchievements }}</div>
            <div class="stat-label">{{ $t('admin.stats.totalAchievements') }}</div>
          </div>
        </div>
        
        <div class="admin-tabs">
          <button 
            class="tab-button" 
            :class="{ active: activeTab === 'users' }" 
            @click="activeTab = 'users'"
          >
            {{ $t('admin.tabs.users') }}
          </button>
          <button 
            class="tab-button" 
            :class="{ active: activeTab === 'tasks' }" 
            @click="activeTab = 'tasks'"
          >
            {{ $t('admin.tabs.tasks') }}
          </button>
          <button 
            class="tab-button" 
            :class="{ active: activeTab === 'achievements' }" 
            @click="activeTab = 'achievements'"
          >
            {{ $t('admin.tabs.achievements') }}
          </button>
        </div>
        
        <!-- Users Tab Content -->
        <div v-if="activeTab === 'users'" class="tab-content">
          <div class="content-header">
            <h2>{{ $t('admin.users.title') }}</h2>
            <button class="btn btn-primary" @click="showAddUserModal = true">
              <span>{{ $t('admin.users.addUser') }}</span>
            </button>
          </div>
          
          <div class="search-filter">
            <input 
              type="text" 
              v-model="userSearchQuery" 
              :placeholder="$t('admin.search')" 
              class="search-input"
            />
          </div>
          
          <div class="table-container">
            <table class="data-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>{{ $t('admin.users.name') }}</th>
                  <th>{{ $t('admin.users.email') }}</th>
                  <th>{{ $t('admin.users.role') }}</th>
                  <th>{{ $t('admin.actions') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in filteredUsers" :key="user.id">
                  <td>{{ user.id }}</td>
                  <td>{{ user.name }}</td>
                  <td>{{ user.email }}</td>
                  <td>
                    <span class="role-badge" :class="user.role.toLowerCase()">
                      {{ user.role }}
                    </span>
                  </td>
                  <td class="actions-cell">
                    <button class="action-btn edit" @click="editUser(user)">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                    <button class="action-btn delete" @click="confirmDeleteUser(user)">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M10 11v6M14 11v6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        
        <!-- Tasks Tab Content -->
        <div v-if="activeTab === 'tasks'" class="tab-content">
          <div class="content-header">
            <h2>{{ $t('admin.tasks.title') }}</h2>
          </div>
          
          <div class="search-filter">
            <input 
              type="text" 
              v-model="taskSearchQuery" 
              :placeholder="$t('admin.search')" 
              class="search-input"
            />
          </div>
          
          <div class="table-container">
            <table class="data-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>{{ $t('admin.tasks.description') }}</th>
                  <th>{{ $t('admin.tasks.category') }}</th>
                  <th>{{ $t('admin.tasks.priority') }}</th>
                  <th>{{ $t('admin.tasks.date') }}</th>
                  <th>{{ $t('admin.tasks.status') }}</th>
                  <th>{{ $t('admin.tasks.user') }}</th>
                  <th>{{ $t('admin.actions') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="task in filteredTasks" :key="task.id">
                  <td>{{ task.id }}</td>
                  <td>{{ task.description }}</td>
                  <td>{{ task.category }}</td>
                  <td>
                    <span class="priority-badge" :class="task.priority">
                      {{ task.priority }}
                    </span>
                  </td>
                  <td>{{ formatDate(task.year, task.month, task.day) }}</td>
                  <td>
                    <span class="status-badge" :class="task.completed ? 'completed' : 'pending'">
                      {{ task.completed ? $t('admin.tasks.completed') : $t('admin.tasks.pending') }}
                    </span>
                  </td>
                  <td>{{ getUserName(task.user.id) }}</td>
                  <td class="actions-cell">
                    <button class="action-btn delete" @click="confirmDeleteTask(task)">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M10 11v6M14 11v6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        
        <!-- Achievements Tab Content -->
        <div v-if="activeTab === 'achievements'" class="tab-content">
          <div class="content-header">
            <h2>{{ $t('admin.achievements.title') }}</h2>
          </div>
          
          <div class="search-filter">
            <input 
              type="text" 
              v-model="achievementSearchQuery" 
              :placeholder="$t('admin.search')" 
              class="search-input"
            />
          </div>
          
          <div class="table-container">
            <table class="data-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>{{ $t('admin.achievements.title') }}</th>
                  <th>{{ $t('admin.achievements.description') }}</th>
                  <th>{{ $t('admin.achievements.category') }}</th>
                  <th>{{ $t('admin.achievements.points') }}</th>
                  <th>{{ $t('admin.achievements.user') }}</th>
                  <th>{{ $t('admin.achievements.unlockDate') }}</th>
                  <th>{{ $t('admin.actions') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="achievement in filteredAchievements" :key="achievement.id">
                  <td>{{ achievement.id }}</td>
                  <td>{{ achievement.title }}</td>
                  <td>{{ achievement.description }}</td>
                  <td>{{ achievement.category }}</td>
                  <td>{{ achievement.points }}</td>
                  <td>{{ getUserName(achievement.user.id) }}</td>
                  <td>{{ formatDateTime(achievement.unlockedAt) }}</td>
                  <td class="actions-cell">
                    <button class="action-btn delete" @click="confirmDeleteAchievement(achievement)">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M10 11v6M14 11v6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      
      <!-- Add User Modal -->
      <div v-if="showAddUserModal" class="modal">
        <div class="modal-content">
          <div class="modal-header">
            <h3>{{ $t('admin.users.addUser') }}</h3>
            <button class="close-btn" @click="showAddUserModal = false">×</button>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label for="name">{{ $t('admin.users.name') }}</label>
              <input type="text" id="name" v-model="newUser.name" required>
            </div>
            <div class="form-group">
              <label for="email">{{ $t('admin.users.email') }}</label>
              <input type="email" id="email" v-model="newUser.email" required>
            </div>
            <div class="form-group">
              <label for="password">{{ $t('admin.users.password') }}</label>
              <input type="password" id="password" v-model="newUser.password" required>
            </div>
            <div class="form-group">
              <label for="role">{{ $t('admin.users.role') }}</label>
              <select id="role" v-model="newUser.role">
                <option value="USER">USER</option>
                <option value="ADMIN">ADMIN</option>
              </select>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-cancel" @click="showAddUserModal = false">{{ $t('admin.cancel') }}</button>
            <button class="btn btn-primary" @click="addUser">{{ $t('admin.save') }}</button>
          </div>
        </div>
      </div>
      
      <!-- Edit User Modal -->
      <div v-if="showEditUserModal" class="modal">
        <div class="modal-content">
          <div class="modal-header">
            <h3>{{ $t('admin.users.editUser') }}</h3>
            <button class="close-btn" @click="showEditUserModal = false">×</button>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label for="edit-name">{{ $t('admin.users.name') }}</label>
              <input type="text" id="edit-name" v-model="editingUser.name" required>
            </div>
            <div class="form-group">
              <label for="edit-email">{{ $t('admin.users.email') }}</label>
              <input type="email" id="edit-email" v-model="editingUser.email" required>
            </div>
            <div class="form-group">
              <label for="edit-password">{{ $t('admin.users.newPassword') }}</label>
              <input type="password" id="edit-password" v-model="editingUser.password" placeholder="Leave blank to keep current password">
            </div>
            <div class="form-group">
              <label for="edit-role">{{ $t('admin.users.role') }}</label>
              <select id="edit-role" v-model="editingUser.role">
                <option value="USER">USER</option>
                <option value="ADMIN">ADMIN</option>
              </select>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-cancel" @click="showEditUserModal = false">{{ $t('admin.cancel') }}</button>
            <button class="btn btn-primary" @click="updateUser">{{ $t('admin.save') }}</button>
          </div>
        </div>
      </div>
      
      <!-- Confirmation Modal -->
      <div v-if="showConfirmModal" class="modal">
        <div class="modal-content">
          <div class="modal-header">
            <h3>{{ confirmModalTitle }}</h3>
            <button class="close-btn" @click="showConfirmModal = false">×</button>
          </div>
          <div class="modal-body">
            <p>{{ confirmModalMessage }}</p>
          </div>
          <div class="modal-footer">
            <button class="btn btn-cancel" @click="showConfirmModal = false">{{ $t('admin.cancel') }}</button>
            <button class="btn btn-danger" @click="confirmAction">{{ $t('admin.delete') }}</button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, computed, onMounted } from 'vue';
  import apiService from '../services/api';
  
  export default {
    setup() {
      // State
      const isAdmin = computed(() => {
        return localStorage.getItem('user_role') === 'ADMIN';
      });
      
      const activeTab = ref('users');
      const stats = ref({
        totalUsers: 0,
        totalTasks: 0,
        totalAchievements: 0
      });
      
      // Users
      const users = ref([]);
      const userSearchQuery = ref('');
      const showAddUserModal = ref(false);
      const showEditUserModal = ref(false);
      const newUser = ref({
        name: '',
        email: '',
        password: '',
        role: 'USER'
      });
      const editingUser = ref({
        id: null,
        name: '',
        email: '',
        password: '',
        role: 'USER'
      });
      
      const filteredUsers = computed(() => {
        if (!userSearchQuery.value) return users.value;
        const query = userSearchQuery.value.toLowerCase();
        return users.value.filter(user => 
          user.name.toLowerCase().includes(query) || 
          user.email.toLowerCase().includes(query) ||
          user.role.toLowerCase().includes(query)
        );
      });
      
      // Tasks
      const tasks = ref([]);
      const taskSearchQuery = ref('');
      
      const filteredTasks = computed(() => {
        if (!taskSearchQuery.value) return tasks.value;
        const query = taskSearchQuery.value.toLowerCase();
        return tasks.value.filter(task => 
          task.description.toLowerCase().includes(query) || 
          task.category.toLowerCase().includes(query) ||
          task.priority.toLowerCase().includes(query)
        );
      });
      
      // Achievements
      const achievements = ref([]);
      const achievementSearchQuery = ref('');
      
      const filteredAchievements = computed(() => {
        if (!achievementSearchQuery.value) return achievements.value;
        const query = achievementSearchQuery.value.toLowerCase();
        return achievements.value.filter(achievement => 
          achievement.title.toLowerCase().includes(query) || 
          achievement.description.toLowerCase().includes(query) ||
          achievement.category.toLowerCase().includes(query)
        );
      });
      
      // Confirmation Modal
      const showConfirmModal = ref(false);
      const confirmModalTitle = ref('');
      const confirmModalMessage = ref('');
      const confirmAction = ref(() => {});
      
      // Methods
      const loadStats = async () => {
        try {
          const adminId = localStorage.getItem('user_id');
          const response = await apiService.get(`/admin/stats?adminId=${adminId}`);
          stats.value = response.data;
        } catch (error) {
          console.error('Error loading stats:', error);
        }
      };
      
      const loadUsers = async () => {
        try {
          const adminId = localStorage.getItem('user_id');
          const response = await apiService.get(`/admin/users?adminId=${adminId}`);
          users.value = response.data;
        } catch (error) {
          console.error('Error loading users:', error);
        }
      };
      
      const loadTasks = async () => {
        try {
          const adminId = localStorage.getItem('user_id');
          const response = await apiService.get(`/admin/tasks?adminId=${adminId}`);
          tasks.value = response.data;
        } catch (error) {
          console.error('Error loading tasks:', error);
        }
      };
      
      const loadAchievements = async () => {
        try {
          const adminId = localStorage.getItem('user_id');
          const response = await apiService.get(`/admin/achievements?adminId=${adminId}`);
          achievements.value = response.data;
        } catch (error) {
          console.error('Error loading achievements:', error);
        }
      };
      
      const addUser = async () => {
        try {
          const adminId = localStorage.getItem('user_id');
          const response = await apiService.post(`/admin/users?adminId=${adminId}`, newUser.value);
          users.value.push(response.data);
          showAddUserModal.value = false;
          
          // Reset form
          newUser.value = {
            name: '',
            email: '',
            password: '',
            role: 'USER'
          };
          
          // Refresh stats
          loadStats();
        } catch (error) {
          console.error('Error adding user:', error);
          alert('Error adding user: ' + (error.response?.data?.error || error.message));
        }
      };
      
      const editUser = (user) => {
        editingUser.value = {
          id: user.id,
          name: user.name,
          email: user.email,
          password: '',
          role: user.role
        };
        showEditUserModal.value = true;
      };
      
      const updateUser = async () => {
        try {
          const adminId = localStorage.getItem('user_id');
          const response = await apiService.put(`/admin/users/${editingUser.value.id}?adminId=${adminId}`, editingUser.value);
          
          // Update user in list
          const index = users.value.findIndex(u => u.id === editingUser.value.id);
          if (index !== -1) {
            users.value[index] = response.data;
          }
          
          showEditUserModal.value = false;
        } catch (error) {
          console.error('Error updating user:', error);
          alert('Error updating user: ' + (error.response?.data?.error || error.message));
        }
      };
      
      const confirmDeleteUser = (user) => {
        confirmModalTitle.value = 'Delete User';
        confirmModalMessage.value = `Are you sure you want to delete the user "${user.name}"? This action cannot be undone.`;
        confirmAction.value = () => deleteUser(user.id);
        showConfirmModal.value = true;
      };
      
      const deleteUser = async (userId) => {
        try {
          const adminId = localStorage.getItem('user_id');
          await apiService.delete(`/admin/users/${userId}?adminId=${adminId}`);
          
          // Remove user from list
          users.value = users.value.filter(u => u.id !== userId);
          
          // Refresh stats
          loadStats();
          
          showConfirmModal.value = false;
        } catch (error) {
          console.error('Error deleting user:', error);
          alert('Error deleting user: ' + (error.response?.data?.error || error.message));
        }
      };
      
      const confirmDeleteTask = (task) => {
        confirmModalTitle.value = 'Delete Task';
        confirmModalMessage.value = `Are you sure you want to delete the task "${task.description}"? This action cannot be undone.`;
        confirmAction.value = () => deleteTask(task.id);
        showConfirmModal.value = true;
      };
      
      const deleteTask = async (taskId) => {
        try {
          const adminId = localStorage.getItem('user_id');
          await apiService.delete(`/admin/tasks/${taskId}?adminId=${adminId}`);
          
          // Remove task from list
          tasks.value = tasks.value.filter(t => t.id !== taskId);
          
          // Refresh stats
          loadStats();
          
          showConfirmModal.value = false;
        } catch (error) {
          console.error('Error deleting task:', error);
          alert('Error deleting task: ' + (error.response?.data?.error || error.message));
        }
      };
      
      const confirmDeleteAchievement = (achievement) => {
        confirmModalTitle.value = 'Delete Achievement';
        confirmModalMessage.value = `Are you sure you want to delete the achievement "${achievement.title}"? This action cannot be undone.`;
        confirmAction.value = () => deleteAchievement(achievement.id);
        showConfirmModal.value = true;
      };
      
      const deleteAchievement = async (achievementId) => {
        try {
          const adminId = localStorage.getItem('user_id');
          await apiService.delete(`/admin/achievements/${achievementId}?adminId=${adminId}`);
          
          // Remove achievement from list
          achievements.value = achievements.value.filter(a => a.id !== achievementId);
          
          // Refresh stats
          loadStats();
          
          showConfirmModal.value = false;
        } catch (error) {
          console.error('Error deleting achievement:', error);
          alert('Error deleting achievement: ' + (error.response?.data?.error || error.message));
        }
      };
      
      const getUserName = (userId) => {
        const user = users.value.find(u => u.id === userId);
        return user ? user.name : `User #${userId}`;
      };
      
      const formatDate = (year, month, day) => {
        return `${year}-${String(month+1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
      };
      
      const formatDateTime = (dateTimeString) => {
        if (!dateTimeString) return '';
        const date = new Date(dateTimeString);
        return date.toLocaleString();
      };
      
      onMounted(() => {
        if (isAdmin.value) {
          loadStats();
          loadUsers();
          loadTasks();
          loadAchievements();
        }
      });
      
      return {
        isAdmin,
        activeTab,
        stats,
        users,
        userSearchQuery,
        filteredUsers,
        tasks,
        taskSearchQuery,
        filteredTasks,
        achievements,
        achievementSearchQuery,
        filteredAchievements,
        showAddUserModal,
        showEditUserModal,
        newUser,
        editingUser,
        showConfirmModal,
        confirmModalTitle,
        confirmModalMessage,
        confirmAction,
        loadStats,
        loadUsers,
        loadTasks,
        loadAchievements,
        addUser,
        editUser,
        updateUser,
        confirmDeleteUser,
        deleteUser,
        confirmDeleteTask,
        deleteTask,
        confirmDeleteAchievement,
        deleteAchievement,
        getUserName,
        formatDate,
        formatDateTime
      };
    }
  };
  </script>
  
  <style scoped>
  .admin-page {
    padding: 2rem;
    min-height: 100vh;
  }
  
  .unauthorized-message {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    animation: fadeIn 0.3s ease;
  }
  
  .modal-content {
    background: var(--bg-gradient-start);
    border-radius: 12px;
    width: 90%;
    max-width: 500px;
    border: 1px solid var(--color-border);
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
    animation: zoomIn 0.3s ease;
  }
  
  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1.5rem;
    border-bottom: 1px solid var(--color-border);
  }
  
  .modal-header h3 {
    margin: 0;
    color: var(--color-text);
    font-size: 1.25rem;
  }
  
  .close-btn {
    background: none;
    border: none;
    color: var(--color-text-secondary);
    font-size: 1.5rem;
    cursor: pointer;
    transition: all 0.3s ease;
  }
  
  .close-btn:hover {
    color: var(--color-text);
    transform: rotate(90deg);
  }
  
  .modal-body {
    padding: 1.5rem;
  }
  
  .modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    padding: 1rem 1.5rem;
    border-top: 1px solid var(--color-border);
  }
  
  .form-group {
    margin-bottom: 1.5rem;
  }
  
  .form-group label {
    display: block;
    margin-bottom: 0.5rem;
    color: var(--color-text);
    font-size: 0.9rem;
  }
  
  .form-group input, .form-group select {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid var(--color-border);
    border-radius: 8px;
    background: var(--color-card-bg);
    color: var(--color-text);
    transition: all 0.3s ease;
  }
  
  .form-group input:focus, .form-group select:focus {
    outline: none;
    border-color: var(--color-primary);
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
  }
  
  .btn {
    padding: 0.75rem 1.5rem;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    border: none;
  }
  
  .btn-primary {
    background: var(--color-primary);
    color: white;
  }
  
  .btn-primary:hover {
    background: var(--color-primary-dark);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
  }
  
  .btn-cancel {
    background: transparent;
    color: var(--color-text);
    border: 1px solid var(--color-border);
  }
  
  .btn-cancel:hover {
    background: var(--color-card-bg-hover);
    transform: translateY(-2px);
  }
  
  .btn-danger {
    background: #f56565;
    color: white;
  }
  
  .btn-danger:hover {
    background: #e53e3e;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(245, 101, 101, 0.3);
  }
  
  @keyframes fadeIn {
    from {
      opacity: 0;
    }
    to {
      opacity: 1;
    }
  }
  
  @keyframes zoomIn {
    from {
      opacity: 0;
      transform: scale(0.95);
    }
    to {
      opacity: 1;
      transform: scale(1);
    }
  }
  
  /* Responsive styles */
  @media (max-width: 768px) {
    .admin-page {
      padding: 1rem;
    }
    
    .admin-title {
      font-size: 2rem;
    }
    
    .admin-tabs {
      overflow-x: auto;
      white-space: nowrap;
      padding-bottom: 0.5rem;
    }
    
    .tab-button {
      padding: 0.75rem 1.25rem;
    }
    
    .modal-content {
      width: 95%;
    }
  }
  
  @media (max-width: 480px) {
    .admin-stats {
      grid-template-columns: 1fr;
    }
    
    .content-header {
      flex-direction: column;
      align-items: flex-start;
      gap: 1rem;
    }
    
    .modal-footer {
      flex-direction: column;
    }
    
    .btn {
      width: 100%;
    }
  }
  </style>