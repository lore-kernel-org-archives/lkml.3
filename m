Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3LGHvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 02:51:36 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:16572 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776Ab3LGHvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 02:51:35 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqERAKDSolJXQzq+/2dsb2JhbABZJ4Jggza2ZAICgRkXdIJmHCMYahg3h3ADEwG5QA2HMYx9ghMdhB0DiUCMaYFqAYxahTmDNi8
Date: Sat, 7 Dec 2013 07:52:21 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: npiggin@gmail.com
Subject: [PATCH 1/1] ramdisk: documentation update
Message-Id: <20131207075221.5401d0c4fdebe5515c4f1643@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-ramdisk_blocksize doesn't exist anymore.
-Module parameters added to documentation.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 Documentation/blockdev/ramdisk.txt | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/Documentation/blockdev/ramdisk.txt b/Documentation/blockdev/ramdisk.txt
index fa72e97..5dca7b1 100644
--- a/Documentation/blockdev/ramdisk.txt
+++ b/Documentation/blockdev/ramdisk.txt
@@ -36,21 +36,30 @@ allowing one to squeeze more programs onto an average installation or
 rescue floppy disk.
 
 
-2) Kernel Command Line Parameters
+2) Parameters
 ---------------------------------
 
+2a) Kernel Command Line Parameters
+
 	ramdisk_size=N
 	==============
 
 This parameter tells the RAM disk driver to set up RAM disks of N k size.  The
 default is 4096 (4 MB) (8192 (8 MB) on S390).
 
-	ramdisk_blocksize=N
-	===================
+2b) Module parameters
+
+	rd_nr
+	=====
+	/dev/ramX devices created.
 
-This parameter tells the RAM disk driver how many bytes to use per block.  The
-default is 1024 (BLOCK_SIZE).
+	max_part
+	========
+	Maximum partition number.
 
+	rd_size
+	=======
+	cf ramdisk_size.
 
 3) Using "rdev -r"
 ------------------
@@ -157,6 +166,10 @@ users may wish to combine steps (d) and (f) by using a pipe.
 Changelog:
 ----------
 
+12-2013 :	Removed ramdisk_blocksize (obsolete)
+		Adding module parameters.
+		Fabian Frederick <fabf@skynet.be>
+
 10-22-04 :	Updated to reflect changes in command line options, remove
 		obsolete references, general cleanup.
 		James Nelson (james4765@gmail.com)
-- 
1.8.4
