Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaDALi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:38:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42615 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaDALSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Qais Yousef <qais.yousef@imgtec.com>, John Crispin <blogic@openwrt.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 103/144] MIPS: include linux/types.h
Date: Tue,  1 Apr 2014 12:15:07 +0100
Message-Id: <1396350948-29910-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qais Yousef <qais.yousef@imgtec.com>

commit 87c99203fea897fbdd84b681ad9fced2517dcf98 upstream.

The file uses u16 type but doesn't include its definition explicitly

I was getting this error when including this header in my driver:

  arch/mips/include/asm/mipsregs.h:644:33: error: unknown type name ‘u16’

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Reviewed-by: Steven J. Hill <Steven.Hill@imgtec.com>
Acked-by: David Daney <david.daney@cavium.com>
Signed-off-by: John Crispin <blogic@openwrt.org>
Patchwork: http://patchwork.linux-mips.org/patch/6212/
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/include/asm/mipsregs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index fed1c3e..b3b61fb 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -14,6 +14,7 @@
 #define _ASM_MIPSREGS_H
 
 #include <linux/linkage.h>
+#include <linux/types.h>
 #include <asm/hazards.h>
 #include <asm/war.h>
 
-- 
1.9.1

