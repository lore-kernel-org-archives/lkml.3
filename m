Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaLXJja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 04:39:30 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:56730 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaLXJjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 04:39:14 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: lgirdwood@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <25de3310f05e59de61e616ff467fd6bc>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: lgirdwood@gmail.com, heiko@sntech.de, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, sonnyrao@chromium.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH v2 0/3] ASoC: rockchip: i2s: fix watermark to 16 and maxburst to 4
Date: Wed, 24 Dec 2014 17:36:59 +0800
Message-Id: <1419413822-11539-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419325709-15374-1-git-send-email-jay.xu@rock-chips.com>
References: <1419325709-15374-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make Bus DMA works more efficiency, DMA may work in burst mode,
   we set the watermark of transmit and receive reach to 16 bits.

Jianqun Xu (3):
  ASoC: rockchip: i2s: fix error defination of transmit data level
  ASoC: rockchip: i2s: set TDL and RDL to 16 samples
  ASoC: rockchip: i2s: fix maxburst of dma data to 4

 sound/soc/rockchip/rockchip_i2s.c | 8 ++++++--
 sound/soc/rockchip/rockchip_i2s.h | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
changes since v1:
- modify commit message suggested by dgreid
- add patch to fix maxburst
1.9.1


