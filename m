Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaFWHdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:33:40 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12276 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaFWHdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:33:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Jun 2014 00:23:57 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/2] ARM: tegra: roth: pinmux fixes
Date: Mon, 23 Jun 2014 16:32:57 +0900
Message-ID: <1403508779-25896-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two small but important fixes to SHIELD's pinmux configuration.
The use of invalid properties caused the pinmux to not be applied
at all. Also the setting for sdmmc clock lines resulted in random
errors or even the impossibility to probe attached devices.

Alexandre Courbot (2):
  ARM: tegra: roth: fix unsupported pinmux properties
  ARM: tegra: roth: enable input on mmc clock pins

 arch/arm/boot/dts/tegra114-roth.dts | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

-- 
2.0.0

