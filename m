Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3JWKhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:37:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45340 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752733Ab3JWKhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:37:12 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: jejb@parisc-linux.org, deller@gmx.de
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] parisc: remove duplicate define
Date: Wed, 23 Oct 2013 12:37:08 +0200
Message-Id: <1382524628-3265-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a duplicate define from
arch/parisc/math-emu/float.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/parisc/math-emu/float.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/parisc/math-emu/float.h b/arch/parisc/math-emu/float.h
index ce76f6d..7a51f97 100644
--- a/arch/parisc/math-emu/float.h
+++ b/arch/parisc/math-emu/float.h
@@ -484,7 +484,6 @@ typedef int VOID;
  * |                                                     |G|L|E|U|X|
  * +-------+-------+-------+-------+-------+-------+-------+-------+
  */
-#define Allexception(object) (object)
 #define Greaterthanbit(object) Bitfield_extract( 27, 1,object)
 #define Lessthanbit(object) Bitfield_extract( 28, 1,object)
 #define Equalbit(object) Bitfield_extract( 29, 1,object)
-- 
1.8.1.2

