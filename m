Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3FCLA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:00:59 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:40212 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3FCLA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:00:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,792,1363132800"; 
   d="scan'208";a="5254557"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Ian Campbell <ian.campbell@citrix.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc/boot: Ignore .dtb files.
Date: Mon, 3 Jun 2013 12:00:56 +0100
Message-ID: <1370257256-24045-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 arch/powerpc/boot/.gitignore |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/boot/.gitignore b/arch/powerpc/boot/.gitignore
index c32ae5c..8fa258e 100644
--- a/arch/powerpc/boot/.gitignore
+++ b/arch/powerpc/boot/.gitignore
@@ -16,6 +16,7 @@ mktree
 uImage
 cuImage.*
 dtbImage.*
+*.dtb
 treeImage.*
 zImage
 zImage.initrd
-- 
1.7.10.4

