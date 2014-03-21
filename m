Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966796AbaCUBEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:04:48 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43986 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965721AbaCUBEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 21:04:43 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, rob@landley.net,
        linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] doc: Fix double words "the the" in documentations
Date: Fri, 21 Mar 2014 10:04:30 +0900
Message-Id: <1395363870-10360-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix double words "the the" in various files
within Documentations.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/filesystems/autofs4-mount-control.txt | 2 +-
 Documentation/futex-requeue-pi.txt                  | 2 +-
 Documentation/input/multi-touch-protocol.txt        | 2 +-
 Documentation/kmemcheck.txt                         | 2 +-
 Documentation/memory-barriers.txt                   | 2 +-
 Documentation/networking/spider_net.txt             | 2 +-
 Documentation/power/devices.txt                     | 2 +-
 Documentation/security/Smack.txt                    | 2 +-
 Documentation/trace/ring-buffer-design.txt          | 2 +-
 Documentation/usb/WUSB-Design-overview.txt          | 2 +-
 Documentation/virtual/kvm/api.txt                   | 2 +-
 Documentation/vm/unevictable-lru.txt                | 2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/autofs4-mount-control.txt b/Documentation/filesystems/autofs4-mount-control.txt
index 4c95935..aff2211 100644
--- a/Documentation/filesystems/autofs4-mount-control.txt
+++ b/Documentation/filesystems/autofs4-mount-control.txt
@@ -255,7 +255,7 @@ AUTOFS_DEV_IOCTL_OPENMOUNT and AUTOFS_DEV_IOCTL_CLOSEMOUNT
 
 Obtain and release a file descriptor for an autofs managed mount point
 path. The open call requires an initialized struct autofs_dev_ioctl with
-the the path field set and the size field adjusted appropriately as well
+the path field set and the size field adjusted appropriately as well
 as the arg1 field set to the device number of the autofs mount. The
 device number can be obtained from the mount options shown in
 /proc/mounts. The close call requires an initialized struct
diff --git a/Documentation/futex-requeue-pi.txt b/Documentation/futex-requeue-pi.txt
index 9dc1ff4..31b1661 100644
--- a/Documentation/futex-requeue-pi.txt
+++ b/Documentation/futex-requeue-pi.txt
@@ -67,7 +67,7 @@ pthread_cond_wait_pi(cond, mutex)
 	   lock(cond->__data.__lock);
 	} while(...)
 	unlock(cond->__data.__lock);
-        /* the kernel acquired the the mutex for us */
+        /* the kernel acquired the mutex for us */
 }
 
 pthread_cond_broadcast_pi(cond)
diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index de139b1..7b4f59c 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -372,7 +372,7 @@ simple scheme, which is compatible with earlier usage, is:
 
 Rationale: We have no information about the orientation of the touching
 ellipse, so approximate it with an inscribed circle instead. The tool
-ellipse should align with the the vector (T - C), so the diameter must
+ellipse should align with the vector (T - C), so the diameter must
 increase with distance(T, C). Finally, assume that the touch diameter is
 equal to the tool thickness, and we arrive at the formulas above.
 
diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
index 9398a50..a41bdeb 100644
--- a/Documentation/kmemcheck.txt
+++ b/Documentation/kmemcheck.txt
@@ -541,7 +541,7 @@ initialized. This is the beginning of the struct:
 92         } _sifields;
 93 } siginfo_t;
 
-On 64-bit, the int is 4 bytes long, so it must the the union member that has
+On 64-bit, the int is 4 bytes long, so it must the union member that has
 not been initialized. We can verify this using gdb:
 
 	$ gdb vmlinux
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 11c1d20..556f951 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1401,7 +1401,7 @@ code.  Here are some examples of these sorts of optimizations:
 			process_message(msg);
 	}
 
-     There is nothing to prevent the the compiler from transforming
+     There is nothing to prevent the compiler from transforming
      process_level() to the following, in fact, this might well be a
      win for single-threaded code:
 
diff --git a/Documentation/networking/spider_net.txt b/Documentation/networking/spider_net.txt
index 4b4adb8..b0b75f8 100644
--- a/Documentation/networking/spider_net.txt
+++ b/Documentation/networking/spider_net.txt
@@ -73,7 +73,7 @@ Thus, in an idle system, the GDACTDPA, tail and head pointers will
 all be pointing at the same descr, which should be "empty". All of the
 other descrs in the ring should be "empty" as well.
 
-The show_rx_chain() routine will print out the the locations of the
+The show_rx_chain() routine will print out the locations of the
 GDACTDPA, tail and head pointers. It will also summarize the contents
 of the ring, starting at the tail pointer, and listing the status
 of the descrs that follow.
diff --git a/Documentation/power/devices.txt b/Documentation/power/devices.txt
index a66c982..47d46df 100644
--- a/Documentation/power/devices.txt
+++ b/Documentation/power/devices.txt
@@ -391,7 +391,7 @@ When resuming from freeze, standby or memory sleep, the phases are:
 	the resume methods.  This generally involves undoing the actions of the
 	preceding suspend_late phase.
 
-    3	The resume methods should bring the the device back to its operating
+    3	The resume methods should bring the device back to its operating
 	state, so that it can perform normal I/O.  This generally involves
 	undoing the actions of the suspend phase.
 
diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
index 7a2d30c..5ea996f 100644
--- a/Documentation/security/Smack.txt
+++ b/Documentation/security/Smack.txt
@@ -3,7 +3,7 @@
     "Good for you, you've decided to clean the elevator!"
     - The Elevator, from Dark Star
 
-Smack is the the Simplified Mandatory Access Control Kernel.
+Smack is the Simplified Mandatory Access Control Kernel.
 Smack is a kernel based implementation of mandatory access
 control that includes simplicity in its primary design goals.
 
diff --git a/Documentation/trace/ring-buffer-design.txt b/Documentation/trace/ring-buffer-design.txt
index 7d350b4..ff747b6 100644
--- a/Documentation/trace/ring-buffer-design.txt
+++ b/Documentation/trace/ring-buffer-design.txt
@@ -683,7 +683,7 @@ against nested writers.
   cmpxchg(tail_page, temp_page, next_page)
 
 The above will update the tail page if it is still pointing to the expected
-page. If this fails, a nested write pushed it forward, the the current write
+page. If this fails, a nested write pushed it forward, the current write
 does not need to push it.
 
 
diff --git a/Documentation/usb/WUSB-Design-overview.txt b/Documentation/usb/WUSB-Design-overview.txt
index 4c5e379..1cd07c0 100644
--- a/Documentation/usb/WUSB-Design-overview.txt
+++ b/Documentation/usb/WUSB-Design-overview.txt
@@ -25,7 +25,7 @@ updated content.
     * Design-overview.txt-1.8
 
 This code implements a Ultra Wide Band stack for Linux, as well as
-drivers for the the USB based UWB radio controllers defined in the
+drivers for the USB based UWB radio controllers defined in the
 Wireless USB 1.0 specification (including Wireless USB host controller
 and an Intel WiNET controller).
 
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 4714f28..b3aa09a 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1476,7 +1476,7 @@ struct kvm_lapic_state {
 	char regs[KVM_APIC_REG_SIZE];
 };
 
-Copies the input argument into the the Local APIC registers.  The data format
+Copies the input argument into the Local APIC registers.  The data format
 and layout are the same as documented in the architecture manual.
 
 
diff --git a/Documentation/vm/unevictable-lru.txt b/Documentation/vm/unevictable-lru.txt
index a68db769..744f82f 100644
--- a/Documentation/vm/unevictable-lru.txt
+++ b/Documentation/vm/unevictable-lru.txt
@@ -453,7 +453,7 @@ putback_lru_page() function to add migrated pages back to the LRU.
 mmap(MAP_LOCKED) SYSTEM CALL HANDLING
 -------------------------------------
 
-In addition the the mlock()/mlockall() system calls, an application can request
+In addition the mlock()/mlockall() system calls, an application can request
 that a region of memory be mlocked supplying the MAP_LOCKED flag to the mmap()
 call.  Furthermore, any mmap() call or brk() call that expands the heap by a
 task that has previously called mlockall() with the MCL_FUTURE flag will result
-- 
1.9.0

