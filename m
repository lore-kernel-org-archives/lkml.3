Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab3CLWKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:10:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15082 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab3CLWKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:10:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 15:10:01 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [Patch v3 1/4] mfd: tps65090: Fix enum in header file
Date: Tue, 12 Mar 2013 18:08:06 -0400
Message-ID: <1363126089-9071-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The enum is missing the definition for the first bit, which makes all
the rest off by one. Add definition for the TPS65090_IRQ_INTERRUPT bit
which at 0.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v3:
 - no changes since v2
v2:
 - no changes since v1

 include/linux/mfd/tps65090.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 6694cf4..9ce231f 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -27,6 +27,7 @@
 
 /* TPS65090 IRQs */
 enum {
+	TPS65090_IRQ_INTERRUPT,
 	TPS65090_IRQ_VAC_STATUS_CHANGE,
 	TPS65090_IRQ_VSYS_STATUS_CHANGE,
 	TPS65090_IRQ_BAT_STATUS_CHANGE,
-- 
1.7.9.5

