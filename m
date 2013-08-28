Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3H1PS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:18:57 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18381 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3H1PSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:18:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Aug 2013 08:18:55 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <mturquette@linaro.org>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-usb@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 2nd RESEND] Clock changes for Tegra30 USB Host support
Date: Wed, 28 Aug 2013 18:18:46 +0300
Message-ID: <1377703127-7020-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch is required for USB support on Tegra30 due to a hardware
quirk in the PLL_U oscillator which clocks the USB complex.

The other USB patches for Tegra30 and Tegra114 are already on their way
to 3.12, so it would be nice to have this one as well in 3.12.

Diff from previous: Added swarren's Tested-by & Acked-by.

Tuomas Tynkkynen (1):
  clk: tegra30: Don't wait for PLL_U lock bit

 drivers/clk/tegra/clk-tegra30.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.8.1.5

