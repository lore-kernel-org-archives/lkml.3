Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaJXMeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:34:23 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35821 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaJXMeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:34:21 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: catalin.marinas@arm.com, corbet@lwn.net, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] Documentation: Add CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF case
Date: Fri, 24 Oct 2014 21:25:00 +0900
Message-Id: <1414153500-29150-3-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.451.g98349e5
In-Reply-To: <1414153500-29150-1-git-send-email-standby24x7@gmail.com>
References: <1414153500-29150-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a case with CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/kmemleak.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index f4f033c..0f2bbd8 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -62,6 +62,10 @@ Memory may be allocated or freed before kmemleak is initialised and
 these actions are stored in an early log buffer. The size of this buffer
 is configured via the CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE option.
 
+If CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF are enabled, the kmemleak is
+disabled by default. Passing "kmemleak=on" on the kernel command
+line enables the function. 
+
 Basic Algorithm
 ---------------
 
-- 
2.1.2.451.g98349e5

