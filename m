Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaFGDDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 23:03:38 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51721 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbaFGDCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 23:02:38 -0400
From: Thomas Wood <tommyandrena@gmail.com>
To: dan.carpenter@oracle.com
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Thomas Wood <tommyandrena@gmail.com>
Subject: [PATCH v2 3/5] staging: ft1000: ft1000-usb: ft1000_debug.c: Remove unnecessary whitespace.
Date: Fri,  6 Jun 2014 20:02:16 -0700
Message-Id: <1402110138-13713-4-git-send-email-tommyandrena@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
References: <20140602103056.GY15585@mwanda>
 <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove whitespace before a quoted newline.
Remove space between function name and it's parameter list.

Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 1395c2b..5e371b7 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -556,7 +556,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 
 			if (info->CardReady) {
 
-				/* DEBUG("FT1000:ft1000_ioctl: try to SET_DPRAM \n"); */
+				/* DEBUG("FT1000:ft1000_ioctl: try to SET_DPRAM\n"); */
 
 				/* Get the length field to see how many bytes to copy */
 				result = get_user(msgsz, (__u16 __user *)argp);
@@ -712,7 +712,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 					break;
 				msglen = htons(msglen);
 				/* DEBUG("FT1000:ft1000_ioctl:msg length = %x\n", msglen); */
-				if (copy_to_user (&pioctl_dpram->pseudohdr, pdpram_blk->pbuffer, msglen)) {
+				if (copy_to_user(&pioctl_dpram->pseudohdr, pdpram_blk->pbuffer, msglen)) {
 					DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
 					result = -EFAULT;
 					break;
-- 
1.9.1

