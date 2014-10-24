Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbaJXMe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:34:28 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63610 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbaJXMeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:34:25 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: catalin.marinas@arm.com, corbet@lwn.net, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/2] Documentation: Add default kmemleak off case in kernel-parameters.txt
Date: Fri, 24 Oct 2014 21:24:59 +0900
Message-Id: <1414153500-29150-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.451.g98349e5
In-Reply-To: <1414153500-29150-1-git-send-email-standby24x7@gmail.com>
References: <1414153500-29150-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing explanation about CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y case.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/kernel-parameters.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 74339c5..f2ebc74 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1587,6 +1587,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	kmemleak=	[KNL] Boot-time kmemleak enable/disable
 			Valid arguments: on, off
 			Default: on
+			Built with CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y,
+			the default is off.
 
 	kmemcheck=	[X86] Boot-time kmemcheck enable/disable/one-shot mode
 			Valid arguments: 0, 1, 2
-- 
2.1.2.451.g98349e5

