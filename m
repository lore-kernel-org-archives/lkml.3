Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaLGW3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:29:06 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52258 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaLGW3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:29:03 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alistair Popple <alistair@popple.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walter <dwalter@google.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] arch: powerpc: kernel: vio.c:  Remove unused function
Date: Sun,  7 Dec 2014 23:31:42 +0100
Message-Id: <1417991502-20223-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function cmo_high_show() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/kernel/vio.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 5bfdab9..11657d2 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1032,11 +1032,6 @@ viobus_cmo_pool_rd_attr(reserve, size);
 viobus_cmo_pool_rd_attr(excess, size);
 viobus_cmo_pool_rd_attr(excess, free);
 
-static ssize_t cmo_high_show(struct bus_type *bt, char *buf)
-{
-	return sprintf(buf, "%lu\n", vio_cmo.high);
-}
-
 static ssize_t cmo_high_store(struct bus_type *bt, const char *buf,
 			      size_t count)
 {
-- 
1.7.10.4

