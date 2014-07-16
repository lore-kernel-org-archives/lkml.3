Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbaGPEOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:14:30 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:45773 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaGPEON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:14:13 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] alpha: Remove checkpatch error in mkk.b
Date: Wed, 16 Jul 2014 00:14:02 -0400
Message-Id: <1405484042-6879-4-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405484042-6879-1-git-send-email-xerofoify@gmail.com>
References: <1405484042-6879-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a error I get when I run checkpatch on this file, relating
to the asterisk for declaritations needing to be next to the name of the
variable/structure and not the type of variable/structure.
---
 arch/alpha/boot/tools/mkbb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/boot/tools/mkbb.c b/arch/alpha/boot/tools/mkbb.c
index 69f347e..dac34c2 100644
--- a/arch/alpha/boot/tools/mkbb.c
+++ b/arch/alpha/boot/tools/mkbb.c
@@ -82,7 +82,7 @@ typedef union __bootblock {
 #define	bootblock_label		__u1.__label
 #define bootblock_checksum	__u2.__checksum
 
-int main(int argc, char ** argv)
+int main(int argc, char **argv)
 {
 	bootblock		bootblock_from_disk;
 	bootblock		bootloader_image;
-- 
1.9.1

