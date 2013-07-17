Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3GQQ3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:29:23 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65392 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3GQQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:29:20 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, rob@landley.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, rdunlap@xenotime.net,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] doc: Fix typo in doucmentations
Date: Thu, 18 Jul 2013 01:29:12 +0900
Message-Id: <1374078552-10528-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct typo (double words) in documentations.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/arm/OMAP/omap_pm                                   | 2 +-
 Documentation/block/cfq-iosched.txt                              | 2 +-
 Documentation/devicetree/bindings/arm/vexpress-sysreg.txt        | 4 ++--
 Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt | 2 +-
 Documentation/dma-buf-sharing.txt                                | 2 +-
 Documentation/fb/fbcon.txt                                       | 2 +-
 Documentation/fb/viafb.txt                                       | 2 +-
 Documentation/filesystems/ext4.txt                               | 2 +-
 Documentation/filesystems/nfs/pnfs.txt                           | 2 +-
 Documentation/filesystems/relay.txt                              | 2 +-
 Documentation/filesystems/sysfs-tagging.txt                      | 2 +-
 Documentation/i2c/upgrading-clients                              | 4 ++--
 Documentation/rapidio/rapidio.txt                                | 2 +-
 Documentation/sound/alsa/compress_offload.txt                    | 2 +-
 Documentation/sysfs-rules.txt                                    | 2 +-
 Documentation/virtual/kvm/api.txt                                | 2 +-
 Documentation/x86/boot.txt                                       | 2 +-
 17 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/arm/OMAP/omap_pm b/Documentation/arm/OMAP/omap_pm
index 9012bb0..4ae915a 100644
--- a/Documentation/arm/OMAP/omap_pm
+++ b/Documentation/arm/OMAP/omap_pm
@@ -78,7 +78,7 @@ to NULL.  Drivers should use the following idiom:
 The most common usage of these functions will probably be to specify
 the maximum time from when an interrupt occurs, to when the device
 becomes accessible.  To accomplish this, driver writers should use the
-set_max_mpu_wakeup_lat() function to to constrain the MPU wakeup
+set_max_mpu_wakeup_lat() function to constrain the MPU wakeup
 latency, and the set_max_dev_wakeup_lat() function to constrain the
 device wakeup latency (from clk_enable() to accessibility).  For
 example,
diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
index 9887f04..f3bc729 100644
--- a/Documentation/block/cfq-iosched.txt
+++ b/Documentation/block/cfq-iosched.txt
@@ -69,7 +69,7 @@ one, this value should be decreased relative to fifo_expire_async.
 group_idle
 -----------
 This parameter forces idling at the CFQ group level instead of CFQ
-queue level. This was introduced after after a bottleneck was observed
+queue level. This was introduced after a bottleneck was observed
 in higher end storage due to idle on sequential queue and allow dispatch
 from a single queue. The idea with this parameter is that it can be run with
 slice_idle=0 and group_idle=8, so that idling does not happen on individual
diff --git a/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt b/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
index 9cf3f25..5580e9c 100644
--- a/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
+++ b/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
@@ -32,8 +32,8 @@ numbers - see motherboard's TRM for more details.
 The node describing a config device must refer to the sysreg node via
 "arm,vexpress,config-bridge" phandle (can be also defined in the node's
 parent) and relies on the board topology properties - see main vexpress
-node documentation for more details. It must must also define the
-following property:
+node documentation for more details. It must also define the following
+property:
 - arm,vexpress-sysreg,func : must contain two cells:
   - first cell defines function number (eg. 1 for clock generator,
     2 for voltage regulators etc.)
diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
index 648d60e..7ccae49 100644
--- a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
@@ -37,7 +37,7 @@ Bank: 3 (A, B and C)
   0xffffffff 0x7fff3ccf  /* pioB */
   0xffffffff 0x007fffff  /* pioC */
 
-For each peripheral/bank we will descibe in a u32 if a pin can can be
+For each peripheral/bank we will descibe in a u32 if a pin can be
 configured in it by putting 1 to the pin bit (1 << pin)
 
 Let's take the pioA on peripheral B
diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 0b23261..e31a2a9 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -321,7 +321,7 @@ Access to a dma_buf from the kernel context involves three steps:
 
    When the importer is done accessing the range specified in begin_cpu_access,
    it needs to announce this to the exporter (to facilitate cache flushing and
-   unpinning of any pinned resources). The result of of any dma_buf kmap calls
+   unpinning of any pinned resources). The result of any dma_buf kmap calls
    after end_cpu_access is undefined.
 
    Interface:
diff --git a/Documentation/fb/fbcon.txt b/Documentation/fb/fbcon.txt
index 99ea58e..4a9739a 100644
--- a/Documentation/fb/fbcon.txt
+++ b/Documentation/fb/fbcon.txt
@@ -150,7 +150,7 @@ C. Boot options
 
 C. Attaching, Detaching and Unloading
 
-Before going on on how to attach, detach and unload the framebuffer console, an
+Before going on how to attach, detach and unload the framebuffer console, an
 illustration of the dependencies may help.
 
 The console layer, as with most subsystems, needs a driver that interfaces with
diff --git a/Documentation/fb/viafb.txt b/Documentation/fb/viafb.txt
index 444e34b..1cb2462 100644
--- a/Documentation/fb/viafb.txt
+++ b/Documentation/fb/viafb.txt
@@ -32,7 +32,7 @@
     Start viafb with default settings:
         #modprobe viafb
 
-    Start viafb with with user options:
+    Start viafb with user options:
         #modprobe viafb viafb_mode=800x600 viafb_bpp=16 viafb_refresh=60
                   viafb_active_dev=CRT+DVI viafb_dvi_port=DVP1
                   viafb_mode1=1024x768 viafb_bpp=16 viafb_refresh1=60
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index f7cbf57..a92c5aa 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -2,7 +2,7 @@
 Ext4 Filesystem
 ===============
 
-Ext4 is an an advanced level of the ext3 filesystem which incorporates
+Ext4 is an advanced level of the ext3 filesystem which incorporates
 scalability and reliability enhancements for supporting large filesystems
 (64 bit) in keeping with increasing disk capacities and state-of-the-art
 feature requirements.
diff --git a/Documentation/filesystems/nfs/pnfs.txt b/Documentation/filesystems/nfs/pnfs.txt
index 52ae07f..adc81a3 100644
--- a/Documentation/filesystems/nfs/pnfs.txt
+++ b/Documentation/filesystems/nfs/pnfs.txt
@@ -12,7 +12,7 @@ struct pnfs_layout_hdr
 ----------------------
 The on-the-wire command LAYOUTGET corresponds to struct
 pnfs_layout_segment, usually referred to by the variable name lseg.
-Each nfs_inode may hold a pointer to a cache of of these layout
+Each nfs_inode may hold a pointer to a cache of these layout
 segments in nfsi->layout, of type struct pnfs_layout_hdr.
 
 We reference the header for the inode pointing to it, across each
diff --git a/Documentation/filesystems/relay.txt b/Documentation/filesystems/relay.txt
index 510b722..33e2f36 100644
--- a/Documentation/filesystems/relay.txt
+++ b/Documentation/filesystems/relay.txt
@@ -31,7 +31,7 @@ Semantics
 
 Each relay channel has one buffer per CPU, each buffer has one or more
 sub-buffers.  Messages are written to the first sub-buffer until it is
-too full to contain a new message, in which case it it is written to
+too full to contain a new message, in which case it is written to
 the next (if available).  Messages are never split across sub-buffers.
 At this point, userspace can be notified so it empties the first
 sub-buffer, while the kernel continues writing to the next.
diff --git a/Documentation/filesystems/sysfs-tagging.txt b/Documentation/filesystems/sysfs-tagging.txt
index caaaf12..eb843e4 100644
--- a/Documentation/filesystems/sysfs-tagging.txt
+++ b/Documentation/filesystems/sysfs-tagging.txt
@@ -24,7 +24,7 @@ flag between KOBJ_NS_TYPE_NONE and KOBJ_NS_TYPES, and s_ns will
 point to the namespace to which it belongs.
 
 Each sysfs superblock's sysfs_super_info contains an array void
-*ns[KOBJ_NS_TYPES].  When a a task in a tagging namespace
+*ns[KOBJ_NS_TYPES].  When a task in a tagging namespace
 kobj_nstype first mounts sysfs, a new superblock is created.  It
 will be differentiated from other sysfs mounts by having its
 s_fs_info->ns[kobj_nstype] set to the new namespace.  Note that
diff --git a/Documentation/i2c/upgrading-clients b/Documentation/i2c/upgrading-clients
index d699162..8e5fbd8 100644
--- a/Documentation/i2c/upgrading-clients
+++ b/Documentation/i2c/upgrading-clients
@@ -196,8 +196,8 @@ static int example_probe(struct i2c_client *i2c_client,
 
 Update the detach method, by changing the name to _remove and
 to delete the i2c_detach_client call. It is possible that you
-can also remove the ret variable as it is not not needed for
-any of the core functions.
+can also remove the ret variable as it is not needed for any
+of the core functions.
 
 - static int example_detach(struct i2c_client *client)
 + static int example_remove(struct i2c_client *client)
diff --git a/Documentation/rapidio/rapidio.txt b/Documentation/rapidio/rapidio.txt
index 717f5aa..28fbd87 100644
--- a/Documentation/rapidio/rapidio.txt
+++ b/Documentation/rapidio/rapidio.txt
@@ -300,7 +300,7 @@ initialization.
 -------------------------------------------
 
 RapidIO subsystem code organization allows addition of new enumeration/discovery
-methods as new configuration options without significant impact to to the core
+methods as new configuration options without significant impact to the core
 RapidIO code.
 
 A new enumeration/discovery method has to be attached to one or more mport
diff --git a/Documentation/sound/alsa/compress_offload.txt b/Documentation/sound/alsa/compress_offload.txt
index 0bcc551..ac8d20b 100644
--- a/Documentation/sound/alsa/compress_offload.txt
+++ b/Documentation/sound/alsa/compress_offload.txt
@@ -73,7 +73,7 @@ The main requirements are:
 
 Design
 
-The new API shares a number of concepts with with the PCM API for flow
+The new API shares a number of concepts with the PCM API for flow
 control. Start, pause, resume, drain and stop commands have the same
 semantics no matter what the content is.
 
diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
index c1a1fd6..a5f985e 100644
--- a/Documentation/sysfs-rules.txt
+++ b/Documentation/sysfs-rules.txt
@@ -47,7 +47,7 @@ versions of the sysfs interface.
         at device creation and removal
       - the unique key to the device at that point in time
       - the kernel's path to the device directory without the leading
-        /sys, and always starting with with a slash
+        /sys, and always starting with a slash
       - all elements of a devpath must be real directories. Symlinks
         pointing to /sys/devices must always be resolved to their real
         target and the target path must be used to access the device.
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index ef925ea..858aecf 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -53,7 +53,7 @@ incompatible change are allowed.  However, there is an extension
 facility that allows backward-compatible extensions to the API to be
 queried and used.
 
-The extension mechanism is not based on on the Linux version number.
+The extension mechanism is not based on the Linux version number.
 Instead, kvm defines extension identifiers and a facility to query
 whether a particular extension identifier is available.  If it is, a
 set of ioctls is available for application use.
diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index fc66d42..f4f268c 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -58,7 +58,7 @@ Protocol 2.11:	(Kernel 3.6) Added a field for offset of EFI handover
 		protocol entry point.
 
 Protocol 2.12:	(Kernel 3.8) Added the xloadflags field and extension fields
-	 	to struct boot_params for for loading bzImage and ramdisk
+	 	to struct boot_params for loading bzImage and ramdisk
 		above 4G in 64bit.
 
 **** MEMORY LAYOUT
-- 
1.8.3.3.754.g9c3c367

