Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3CFS2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 13:28:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34843 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3CFS2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 13:28:45 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Michal Marek <mmarek@suse.cz>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 1/6] ARM: tegra: device tree whitespace cleanup
Date: Wed,  6 Mar 2013 11:28:32 -0700
Message-Id: <1362594517-22099-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Remove white-space from empty line; triggers checkpatch.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Patches 3 and later in his series depends on the kbuild-related series I
just posted to rework the dtc+cpp logic. I hope to apply them to the Tegra
tree after merging the previous series from the arm-soc topic branch.
Patches 1 and 2 are just cleanup that the others depend on.

 arch/arm/boot/dts/tegra20.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 48d00a0..ab9402a 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -208,7 +208,7 @@
 		compatible = "nvidia,tegra20-das";
 		reg = <0x70000c00 0x80>;
 	};
-	
+
 	tegra_ac97: ac97 {
 		compatible = "nvidia,tegra20-ac97";
 		reg = <0x70002000 0x200>;
-- 
1.7.10.4

