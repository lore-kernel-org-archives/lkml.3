Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3AVAz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:55:26 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35354 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab3AVAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:55:15 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 4/4] tile: select HAVE_SYSCALL_TRACEPOINTS
Date: Mon, 21 Jan 2013 19:54:58 -0500
Message-Id: <1358816098-13070-4-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1358816098-13070-1-git-send-email-simon.marchi@polymtl.ca>
References: <1358816098-13070-1-git-send-email-simon.marchi@polymtl.ca>
X-Poly-FromMTA: ([132.207.72.18]) at Tue, 22 Jan 2013 00:55:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 8cab409..1adb853 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -22,6 +22,7 @@ config TILE
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_SYSCALL_TRACEPOINTS
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
-- 
1.7.1

