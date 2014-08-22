Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbaHVMJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:09:49 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:39414 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbaHVMJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:09:48 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers/ipack/devices/ipoctal.h: Fix typo in include guard
Date: Fri, 22 Aug 2014 14:09:23 +0200
Message-Id: <1408709363-13361-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/ipack/devices/ipoctal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ipack/devices/ipoctal.h b/drivers/ipack/devices/ipoctal.h
index 28f1c42..7fede0e 100644
--- a/drivers/ipack/devices/ipoctal.h
+++ b/drivers/ipack/devices/ipoctal.h
@@ -12,7 +12,7 @@
  * Software Foundation; version 2 of the License.
  */
 
-#ifndef _IPOCTAL_H
+#ifndef _IPOCTAL_H_
 #define _IPOCTAL_H_
 
 #define NR_CHANNELS		8
-- 
1.9.2

