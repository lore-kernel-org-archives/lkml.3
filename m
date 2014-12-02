Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaLBOt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:49:56 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:38413 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaLBOty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:49:54 -0500
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: lgirdwood@gmail.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <1ca9c6da4f813741b6a35c4c52b37dfa>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun Xu <jay.xu@rock-chips.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        jay.xu@rock-chips.com, sonnyrao@chromium.org, heiko@sntech.de
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH 0/2] rockchip: i2s: patches to add optional clock output from
Date: Tue,  2 Dec 2014 22:49:24 +0800
Message-Id: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock output from rockchip SoCs' CRU to chip outside is from the same source
as hclk which is for i2s controller. We make it optional because some audio
codec outside not need the master clock from SoC but from other clock source.

Jianqun Xu (2):
  ASoC: rockchip-i2s: dt: add an optional property "i2s_clk_out"
  ASoC: rockchip: i2s: add support for grabbing output clock to codec

 Documentation/devicetree/bindings/sound/rockchip-i2s.txt |  8 ++++++--
 sound/soc/rockchip/rockchip_i2s.c                        | 11 +++++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

-- 
1.9.1

