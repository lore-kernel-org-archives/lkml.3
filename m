Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaIFSkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 14:40:10 -0400
Received: from senator.holtmann.net ([87.106.208.187]:58396 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaIFSkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 14:40:09 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] memfd: Add memfd.h to uapi headers
Date: Sat,  6 Sep 2014 20:40:33 +0200
Message-Id: <1410028833-31840-1-git-send-email-marcel@holtmann.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like a good idea to actually expose include/uapi/linux/memfd.h
so that it gets installed and can be used by userspace.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 include/uapi/linux/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 24e9033f8b3f..939df6973102 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -240,6 +240,7 @@ header-y += matroxfb.h
 header-y += mdio.h
 header-y += media.h
 header-y += mei.h
+header-y += memfd.h
 header-y += mempolicy.h
 header-y += meye.h
 header-y += mic_common.h
-- 
1.9.3

