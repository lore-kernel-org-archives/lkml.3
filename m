Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaH2WNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:13:36 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:43706 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889AbaH2WNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:13:33 -0400
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <b595d8cb1160b69494c11a72ef257377>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        yongjun_wei@trendmicro.com.cn, heiko@sntech.de, dianders@chromium.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH 0/2] rockchip-i2s: add power setting for I2S controller and fix some critical bugs
Date: Fri, 29 Aug 2014 15:07:04 -0700
Message-Id: <1409350027-17604-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add optional power setting for i2s controller found on rk3066, rk3168 and rk3288
processors from rockchip, should according to hardware design.

Default setting for I2S controller is powered by 3.3V, there needs this patch if
it's powered by 1.8V by hardware design.

Jianqun (2):
  rockchip-i2s: dt: add grf requested properties to set power of I2S controller
  rockchip-i2s: add power setting for I2S controller, also fix some bugs

 .../devicetree/bindings/sound/rockchip-i2s.txt     |  6 +-
 sound/soc/rockchip/rockchip_i2s.c                  | 93 +++++++++++++---------
 sound/soc/rockchip/rockchip_i2s.h                  | 13 +--
 3 files changed, 68 insertions(+), 44 deletions(-)

-- 
1.8.3.2

