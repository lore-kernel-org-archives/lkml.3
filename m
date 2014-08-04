Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbaHDEmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:42:54 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:43814 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHDEmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:42:50 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <f482964f44f390baf9d4052b183bb406>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: mark yao <mark.yao@rock-chips.com>
To: heiko@sntech.de, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, olof@lixom.net, djkurtz@chromium.org,
        xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com,
        cf@rock-chips.com, zyw@rock-chips.com, zwl@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        zhangqing@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, mark yao <yzq@rock-chips.com>
Subject: [PATCH 0/9] Add drm driver for Rockchip Socs
Date: Mon,  4 Aug 2014 12:41:14 +0800
Message-Id: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mark yao <yzq@rock-chips.com>

This a series of patches is a DRM Driver for Rockchip Socs, driver provides
an abstraction for the graphics hardware, as lcd controller and
connector interface.

add rk3288 lcd controller.
add rk3288 lvds and rk3288 edp connector.

Tested on rk3288 sdk board, use lvds or edp connector, boot and display OK

mark yao (9):
  drm: Add drm driver for Rockchip Socs
  Add devicetree bindings for panels used by the Rockchip DRM
  drm: add driver for panels used by the Rockchip DRM
  Add devicetree bindings for Rockchip lcd controller
  drm: add Rockchip rk3288 lcd controller driver
  Add devicetree bindings for Rockchip Soc LVDS
  drm: add Rockchip Soc rk3288 lvds connector
  Add devicetree bindings for Rockchip Soc EDP
  drm: add Rockchip Soc rk3288 edp connector


-- 
1.7.9.5


