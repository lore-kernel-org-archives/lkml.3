Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaDRAre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:47:34 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:1248 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaDRAr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:47:28 -0400
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="25375269"
From: Tim Kryger <tim.kryger@linaro.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] SDHCI should use more common MMC structs and functions
Date: Thu, 17 Apr 2014 17:46:59 -0700
Message-ID: <1397782021-31396-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series updates SDHCI to use the common regulator infrastructure that mmc
core provides.

Tim Kryger (2):
  mmc: sdhci: Use supplies in common mmc_host struct
  mmc: sdhci: Use common mmc_regulator_get_supply

 drivers/mmc/host/sdhci.c  |   96 +++++++++++++++++----------------------------
 include/linux/mmc/sdhci.h |    3 --
 2 files changed, 35 insertions(+), 64 deletions(-)

-- 
1.7.9.5

