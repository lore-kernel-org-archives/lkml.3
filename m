Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaFDLss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:48:48 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6994 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaFDLrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:47:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Jun 2014 04:39:53 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 7/9] ahci: Increase AHCI_MAX_CLKS to 4
Date: Wed, 4 Jun 2014 14:32:37 +0300
Message-ID: <1401881559-18469-8-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra AHCI device requires four clocks, so increase the maximum
amount of handled clocks from three to four.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/ata/ahci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 05882e4..7137e1b 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -53,7 +53,7 @@
 
 enum {
 	AHCI_MAX_PORTS		= 32,
-	AHCI_MAX_CLKS		= 3,
+	AHCI_MAX_CLKS		= 4,
 	AHCI_MAX_SG		= 168, /* hardware max is 64K */
 	AHCI_DMA_BOUNDARY	= 0xffffffff,
 	AHCI_MAX_CMDS		= 32,
-- 
1.8.1.5

