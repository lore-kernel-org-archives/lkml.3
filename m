Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbbAZLV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:21:57 -0500
Received: from regular1.263xmail.com ([211.150.99.132]:54732 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbbAZLVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:21:53 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <d8aa667c8761618477bd121d943a771a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Addy Ke <addy.ke@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, jh80.chung@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        sonnyrao@chromium.org, amstan@chromium.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH 0/2] fix bug that cause tuning failure
Date: Mon, 26 Jan 2015 19:19:33 +0800
Message-Id: <1422271175-19445-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy Ke (2):
  mmc: core: use card pointer as the first parameter of execute_tuning()
  mmc: dw_mmc: wait until card ready if tuning fails

 drivers/mmc/core/core.c           |  2 +-
 drivers/mmc/core/mmc_ops.h        |  1 -
 drivers/mmc/host/dw_mmc.c         | 51 +++++++++++++++++++++++++++++++++------
 drivers/mmc/host/rtsx_pci_sdmmc.c |  3 ++-
 drivers/mmc/host/rtsx_usb_sdmmc.c |  3 ++-
 include/linux/mmc/card.h          |  2 ++
 include/linux/mmc/host.h          |  2 +-
 7 files changed, 52 insertions(+), 12 deletions(-)

-- 
1.8.3.2


