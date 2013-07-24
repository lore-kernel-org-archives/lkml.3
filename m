Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3GXIgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:36:21 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:32025 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855Ab3GXIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:36:11 -0400
From: mail-agent-noreply@emc.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: [PATCH 6/8] staging/lustre: fix Kconfig bool defaults
Date: Wed, 24 Jul 2013 16:31:30 +0800
Message-Id: <1374654692-13237-7-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374654692-13237-6-git-send-email-mail-agent-noreply@emc.com>
References: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-3-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-4-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-5-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-6-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

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

