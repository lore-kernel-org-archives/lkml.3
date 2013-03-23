Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3CWRSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:18:46 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:36431 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab3CWRSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:18:45 -0400
From: "Vincent" <vincent.stehle@laposte.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
Subject: [PATCH] gitignore: ignore hz.bc
Date: Sat, 23 Mar 2013 18:18:23 +0100
Message-Id: <1364059103-29842-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
---
 kernel/.gitignore |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/.gitignore b/kernel/.gitignore
index ab4f109..b3097bd 100644
--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -4,3 +4,4 @@
 config_data.h
 config_data.gz
 timeconst.h
+hz.bc
-- 
1.7.10.4

