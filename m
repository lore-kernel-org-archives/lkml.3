Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3KVPJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:09:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab3KVPJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:09:37 -0500
Date: Fri, 22 Nov 2013 16:09:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/4] perf diff: give Delta column an appropriate color
Message-ID: <20131122150927.GA10881@krava.brq.redhat.com>
References: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
 <1385044427-13995-3-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385044427-13995-3-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 08:03:45PM +0530, Ramkumar Ramachandra wrote:
> Colorize the numbers in the Delta column either green or red depending
> on whether the it is positive or negative.
> 

this patch changes the diff output for 'perf diff'

file '1' - old perf
file '2' - your change

I expected only the difference would be only color
not numbers.

thanks,
jirka

---
--- 1   2013-11-22 16:05:36.224136167 +0100
+++ 2   2013-11-22 16:05:40.399152889 +0100
@@ -9,128 +9,128 @@
     11.78%   -0.14%  libc-2.17.so       [.] fputs_unlocked
      9.77%   +0.02%  libc-2.17.so       [.] __GI___mempcpy
      1.61%   +0.21%  yes                [.] fputs_unlocked@plt
-     0.08%           [kernel.kallsyms]  [k] system_call                           
-     0.07%           [kernel.kallsyms]  [k] __srcu_read_lock                      
-     0.06%           [kernel.kallsyms]  [k] __srcu_read_unlock                    
+     0.08%   -0.01%  [kernel.kallsyms]  [k] system_call                           
+     0.07%   -0.01%  [kernel.kallsyms]  [k] __srcu_read_lock                      
+     0.06%   -0.01%  [kernel.kallsyms]  [k] __srcu_read_unlock                    
      0.05%   -0.03%  [kernel.kallsyms]  [k] native_write_msr_safe
      0.04%   -0.03%  [kernel.kallsyms]  [k] apic_timer_interrupt
-     0.04%           libc-2.17.so       [.] __GI___libc_write                     
-     0.04%           [kernel.kallsyms]  [k] __audit_syscall_exit                  
-     0.04%           [kernel.kallsyms]  [k] vfs_write                             
-     0.03%           [kernel.kallsyms]  [k] fget_light                            
-     0.03%           [kernel.kallsyms]  [k] __audit_syscall_entry                 
-     0.03%           [kernel.kallsyms]  [k] fsnotify                              
-     0.02%           libc-2.17.so       [.] _IO_do_write@@GLIBC_2.2.5             
+     0.04%   +0.00%  libc-2.17.so       [.] __GI___libc_write                     
+     0.04%   +0.01%  [kernel.kallsyms]  [k] __audit_syscall_exit                  
+     0.04%   +0.00%  [kernel.kallsyms]  [k] vfs_write                             
+     0.03%   -0.01%  [kernel.kallsyms]  [k] fget_light                            
+     0.03%   -0.00%  [kernel.kallsyms]  [k] __audit_syscall_entry                 
+     0.03%   -0.00%  [kernel.kallsyms]  [k] fsnotify                              
+     0.02%   -0.00%  libc-2.17.so       [.] _IO_do_write@@GLIBC_2.2.5             
      0.02%   +0.01%  libc-2.17.so       [.] _IO_file_write@@GLIBC_2.2.5
      0.02%   -0.01%  [kernel.kallsyms]  [k] task_tick_fair
-     0.02%           libc-2.17.so       [.] _IO_default_xsputn                    
+     0.02%   -0.00%  libc-2.17.so       [.] _IO_default_xsputn                    
      0.02%   -0.01%  [kernel.kallsyms]  [k] native_read_tsc
      0.02%   -0.01%  [kernel.kallsyms]  [k] _raw_spin_lock
-     0.01%           libc-2.17.so       [.] _IO_file_overflow@@GLIBC_2.2.5        
-     0.01%           [kernel.kallsyms]  [k] do_timer                              
+     0.01%   -0.00%  libc-2.17.so       [.] _IO_file_overflow@@GLIBC_2.2.5        
+     0.01%   -0.01%  [kernel.kallsyms]  [k] do_timer                              
      0.01%   -0.01%  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
-     0.01%           [kernel.kallsyms]  [k] sys_write                             
-     0.01%           [kernel.kallsyms]  [k] irqtime_account_irq                   
-     0.01%           [kernel.kallsyms]  [k] __fsnotify_parent                     
-     0.01%           [kernel.kallsyms]  [k] irqtime_account_process_tick.isra.2   
-     0.01%           [kernel.kallsyms]  [k] native_read_msr_safe                  
-     0.01%           [kernel.kallsyms]  [k] rw_verify_area                        
-     0.01%           [kernel.kallsyms]  [k] sched_clock_cpu                       
-     0.01%           [kernel.kallsyms]  [k] rcu_check_callbacks                   
-     0.01%           [kernel.kallsyms]  [k] run_timer_softirq                     
-     0.01%           [kernel.kallsyms]  [k] path_put                              
-     0.01%           [kernel.kallsyms]  [k] unroll_tree_refs                      
-     0.01%           [kernel.kallsyms]  [k] hrtimer_interrupt                     
-     0.01%           [kernel.kallsyms]  [k] security_file_permission              
-     0.01%           [kernel.kallsyms]  [k] kfree                                 
-     0.01%           [kernel.kallsyms]  [k] native_sched_clock                    
-     0.01%           [kernel.kallsyms]  [k] _raw_spin_lock_irqsave                
-     0.01%           [kernel.kallsyms]  [k] trigger_load_balance                  
-     0.01%           [kernel.kallsyms]  [k] update_cfs_shares                     
-     0.01%           [kernel.kallsyms]  [k] __acct_update_integrals               
-     0.01%           [kernel.kallsyms]  [k] __update_cpu_load                     
-     0.01%           [kernel.kallsyms]  [k] __do_softirq                          
+     0.01%   +0.01%  [kernel.kallsyms]  [k] sys_write                             
+     0.01%   -0.00%  [kernel.kallsyms]  [k] irqtime_account_irq                   
+     0.01%   -0.00%  [kernel.kallsyms]  [k] __fsnotify_parent                     
+     0.01%   -0.01%  [kernel.kallsyms]  [k] irqtime_account_process_tick.isra.2   
+     0.01%   +0.00%  [kernel.kallsyms]  [k] native_read_msr_safe                  
+     0.01%   +0.00%  [kernel.kallsyms]  [k] rw_verify_area                        
+     0.01%   -0.01%  [kernel.kallsyms]  [k] sched_clock_cpu                       
+     0.01%   -0.01%  [kernel.kallsyms]  [k] rcu_check_callbacks                   
+     0.01%   -0.01%  [kernel.kallsyms]  [k] run_timer_softirq                     
+     0.01%   -0.00%  [kernel.kallsyms]  [k] path_put                              
+     0.01%   -0.00%  [kernel.kallsyms]  [k] unroll_tree_refs                      
+     0.01%   -0.01%  [kernel.kallsyms]  [k] hrtimer_interrupt                     
+     0.01%   +0.00%  [kernel.kallsyms]  [k] security_file_permission              
+     0.01%   +0.00%  [kernel.kallsyms]  [k] kfree                                 
+     0.01%   -0.00%  [kernel.kallsyms]  [k] native_sched_clock                    
+     0.01%   -0.00%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave                
+     0.01%   -0.00%  [kernel.kallsyms]  [k] trigger_load_balance                  
+     0.01%   -0.00%  [kernel.kallsyms]  [k] update_cfs_shares                     
+     0.01%   -0.00%  [kernel.kallsyms]  [k] __acct_update_integrals               

