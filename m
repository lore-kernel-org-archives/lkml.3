Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3JWKhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:37:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45352 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752409Ab3JWKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:37:51 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] MIPS: remove duplicate define
Date: Wed, 23 Oct 2013 12:37:44 +0200
Message-Id: <1382524664-3309-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a duplicate define from
arch/mips/boot/ecoff.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/mips/boot/ecoff.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/boot/ecoff.h b/arch/mips/boot/ecoff.h
index 83e5c38..7a75ce2 100644
--- a/arch/mips/boot/ecoff.h
+++ b/arch/mips/boot/ecoff.h
@@ -12,7 +12,6 @@ typedef struct filehdr {
 } FILHDR;
 #define FILHSZ	sizeof(FILHDR)
 
-#define OMAGIC		0407
 #define MIPSEBMAGIC	0x160
 #define MIPSELMAGIC	0x162
 
-- 
1.8.1.2

