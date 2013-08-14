Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab3HNUJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:09:51 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5924 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab3HNUJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:09:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Aug 2013 13:09:49 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <mturquette@linaro.org>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-usb@vger.kernel.org>,
        <pgaikwad@nvidia.com>, <pdeschrijver@nvidia.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH RESEND] Clock changes for Tegra30 USB Host support
Date: Wed, 14 Aug 2013 23:09:38 +0300
Message-ID: <1376510979-21562-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch is required for USB support on Tegra30 due to a likely hardware
bug in the PLL_U oscillator which clocks the USB complex.

The other USB patches for Tegra30 and Tegra114 are already on their way
to 3.12, this is the only one left for Tegra30.

Peter, Prashant, any comments on this patch?

Tuomas Tynkkynen (1):
  clk: tegra30: Don't wait for PLL_U lock bit

 drivers/clk/tegra/clk-tegra30.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.8.1.5

