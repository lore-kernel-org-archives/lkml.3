Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab3L0KnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:43:16 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:23707 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257Ab3L0KnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:43:14 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAQAIFZvVJbsleR/2dsb2JhbABYKIJjgzq3KAICgRQXdIJmHCMYgQIQASaICAHINY4xHwRJhD0EiUGOVQGSFIM6L4EtCBc
Date: Fri, 27 Dec 2013 10:44:10 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, akpm@linux-foundation.org
Subject: [PATCH 1/1] filesystems: Update 00-INDEX in
 Documentation/filesystems
Message-Id: <20131227104410.9e6c368ae9d6e0ea3d2a0a0d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the following documentation-files with description :
 -autofs4-mount-control.txt
 -btrfs.txt
 -debugfs.txt
 -devpts.txt
 -fiemap.txt
 -gfs2-glocks.txt
 -gfs2-uevents.txt
 -omfs.txt
 -path-lookup.txt
 -qnx6.txt
 -quota.txt
 -squashfs.txt
 -sysfs-tagging.txt
 -ubifs.txt
 -xfs-delayed-logging-design.txt
 -xfs-self-describing-metadata.txt

Add the following documentation directories with description :
 -caching
 -cifs (replacing cifs.txt)
 -pohmelfs

Remove the following documentation-files reference:
 -dentry-locking.txt
 -reiser4.txt

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 Documentation/filesystems/00-INDEX | 58 +++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 8042050..632211c 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -10,24 +10,32 @@ afs.txt
 	- info and examples for the distributed AFS (Andrew File System) fs.
 affs.txt
 	- info and mount options for the Amiga Fast File System.
+autofs4-mount-control.txt
+	- info on device control operations for autofs4 module.
 automount-support.txt
 	- information about filesystem automount support.
 befs.txt
 	- information about the BeOS filesystem for Linux.
 bfs.txt
 	- info for the SCO UnixWare Boot Filesystem (BFS).
+btrfs.txt
+	- info for the BTRFS filesystem.
+caching/
+	- directory containing filesystem cache documentation.
 ceph.txt
-	- info for the Ceph Distributed File System
-cifs.txt
-	- description of the CIFS filesystem.
+	- info for the Ceph Distributed File System.
+cifs/
+	- directory containing CIFS filesystem documentation and example code.
 coda.txt
 	- description of the CODA filesystem.
 configfs/
 	- directory containing configfs documentation and example code.
 cramfs.txt
 	- info on the cram filesystem for small storage (ROMs etc).
-dentry-locking.txt
-	- info on the RCU-based dcache locking model.
+debugfs.txt
+	- info on the debugfs filesystem.
+devpts.txt
+	- info on the devpts filesystem.
 directory-locking
 	- info about the locking scheme used for directory operations.
 dlmfs.txt
@@ -35,7 +43,7 @@ dlmfs.txt
 dnotify.txt
 	- info about directory notification in Linux.
 dnotify_test.c
-	- example program for dnotify
+	- example program for dnotify.
 ecryptfs.txt
 	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 efivarfs.txt
@@ -48,12 +56,18 @@ ext3.txt
 	- info, mount options and specifications for the Ext3 filesystem.
 ext4.txt
 	- info, mount options and specifications for the Ext4 filesystem.
-files.txt
-	- info on file management in the Linux kernel.
 f2fs.txt
 	- info and mount options for the F2FS filesystem.
+fiemap.txt
+	- info on fiemap ioctl.
+files.txt
+	- info on file management in the Linux kernel.
 fuse.txt
 	- info on the Filesystem in User SpacE including mount options.
+gfs2-glocks.txt
+	- info on the Global File System 2 - Glock internal locking rules.
+gfs2-uevents.txt
+	- info on the Global File System 2 - uevents.
 gfs2.txt
 	- info on the Global File System 2.
 hfs.txt
@@ -84,40 +98,58 @@ ntfs.txt
 	- info and mount options for the NTFS filesystem (Windows NT).
 ocfs2.txt
 	- info and mount options for the OCFS2 clustered filesystem.
+omfs.txt
+	- info on the Optimized MPEG FileSystem.
+path-lookup.txt
+	- info on path walking and name lookup locking.
+pohmelfs/
+	- directory containing pohmelfs filesystem documentation.
 porting
 	- various information on filesystem porting.
 proc.txt
 	- info on Linux's /proc filesystem.
+qnx6.txt
+	- info on the QNX6 filesystem.
+quota.txt
+	- info on Quota subsystem.
 ramfs-rootfs-initramfs.txt
 	- info on the 'in memory' filesystems ramfs, rootfs and initramfs.
-reiser4.txt
-	- info on the Reiser4 filesystem based on dancing tree algorithms.
 relay.txt
 	- info on relay, for efficient streaming from kernel to user space.
 romfs.txt
 	- description of the ROMFS filesystem.
 seq_file.txt
-	- how to use the seq_file API
+	- how to use the seq_file API.
 sharedsubtree.txt
 	- a description of shared subtrees for namespaces.
 spufs.txt
 	- info and mount options for the SPU filesystem used on Cell.
+squashfs.txt
+	- info on the squashfs filesystem.
 sysfs-pci.txt
 	- info on accessing PCI device resources through sysfs.
+sysfs-tagging.txt
+	- info on sysfs tagging to avoid duplicates.
 sysfs.txt
 	- info on sysfs, a ram-based filesystem for exporting kernel objects.
 sysv-fs.txt
 	- info on the SystemV/V7/Xenix/Coherent filesystem.
 tmpfs.txt
 	- info on tmpfs, a filesystem that holds all files in virtual memory.
+ubifs.txt
+	- info on the Unsorted Block Images FileSystem.
 udf.txt
 	- info and mount options for the UDF filesystem.
 ufs.txt
 	- info on the ufs filesystem.
 vfat.txt
-	- info on using the VFAT filesystem used in Windows NT and Windows 95
+	- info on using the VFAT filesystem used in Windows NT and Windows 95.
 vfs.txt
-	- overview of the Virtual File System
+	- overview of the Virtual File System.
+xfs-delayed-logging-design.txt
+	- info on the XFS Delayed Logging Design.
+xfs-self-describing-metadata.txt
+	- info on XFS Self Describing Metadata.
 xfs.txt
 	- info and mount options for the XFS filesystem.
 xip.txt
-- 
1.8.1.4
