Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab3LHT1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 14:27:46 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:27812 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930Ab3LHT1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 14:27:43 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0TALvHpFJXQD2Q/2dsb2JhbABZJ4Jggza2YQICgRYXdIJmHCMYgQI3iAYBwF+PEB2EHQOJQI5TAZITgzYv
Date: Sun, 8 Dec 2013 19:28:31 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, akpm@linux-foundation.org, npiggin@gmail.com,
        rdunlap@infradead.org
Subject: [PATCH 1/1] ramdisk: documentation update
Message-Id: <20131208192831.6b1ef921e4c2774cc4af5504@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-ramdisk_blocksize doesn't exist anymore
-Module parameters added to documentation

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 Documentation/blockdev/ramdisk.txt | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/blockdev/ramdisk.txt b/Documentation/blockdev/ramdisk.txt
index fa72e97..fe2ef97 100644
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
-default is 4096 (4 MB) (8192 (8 MB) on S390).
+default is 4096 (4 MB).
+
+2b) Module parameters
 
-	ramdisk_blocksize=N
-	===================
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
+	See ramdisk_size.
 
 3) Using "rdev -r"
 ------------------
-- 
1.8.4
