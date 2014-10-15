Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaJOCCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:02:00 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:46288 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbaJOCB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:01:58 -0400
X-IronPort-AV: E=Sophos;i="5.04,720,1406617200"; 
   d="scan'208";a="48459518"
From: Scott Branden <sbranden@broadcom.com>
To: Stephen Warren <swarren@wwwdotorg.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Griffin <peter.griffin@linaro.org>
CC: Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        Scott Branden <sbranden@broadcom.com>
Subject: [PATCH 0/1] sdhci-bcm2835: added quirk and removed udelay in write ops
Date: Tue, 14 Oct 2014 19:01:51 -0700
Message-ID: <1413338512-14546-1-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Scott Branden <sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains driver cleanup of sdhci-bcm2835.
Please note that this has not actually been tested on bcm2835 yet.
Testing comes from other devices with the same sdhci controller.

This patch is being put out for testing and acceptance on the 2835.
Please test and comment.

Scott Branden (1):
  mmc: sdhci-bcm2835: added quirk and removed udelay in write ops

 drivers/mmc/host/sdhci-bcm2835.c |  139 ++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 73 deletions(-)

-- 
1.7.9.5

