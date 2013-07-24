Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3GXRVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:21:31 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64238 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3GXRUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:20:43 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: [PATCH-RESEND 6/8] staging/lustre: fix Kconfig bool defaults
Date: Thu, 25 Jul 2013 01:17:29 +0800
Message-Id: <1374686251-3152-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374686251-3152-1-git-send-email-bergwolf@gmail.com>
References: <1374686251-3152-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be y instead of true.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
---
 drivers/staging/lustre/lustre/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 9ae7fa8..e3b3c74 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -52,4 +52,4 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
 config LUSTRE_TRANSLATE_ERRNOS
 	bool
 	depends on LUSTRE_FS && !X86
-	default true
+	default y
-- 
1.7.1

