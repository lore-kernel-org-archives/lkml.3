Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3FNPlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:41:50 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34397 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab3FNPlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:41:49 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/5] pinctrl: fix some issues with new pinconfig dt parsing
Date: Fri, 14 Jun 2013 17:41:45 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306141741.46077.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some issues with the recently submitted generic pinconfig parsing from dt
came up, so fix these in this follow-up series.

Hopefully I did catch all of them.

Tested on my rk3066 device.

Heiko Stuebner (5):
  pinctrl: update the documentation for some pinconfig params
  pinctrl: clarify some dt pinconfig options
  pinctrl: handle zero found dt pinconfig properties better
  pinctrl: dynamically alloc temp array when parsing dt pinconf options
  pinctrl: rockchip: correctly handle arguments of pinconf options

 .../bindings/pinctrl/pinctrl-bindings.txt          |   22 +++++++++++-
 drivers/pinctrl/pinconf-generic.c                  |   38 +++++++++++++++-----
 drivers/pinctrl/pinctrl-rockchip.c                 |   37 ++++++++++++++++---
 include/linux/pinctrl/pinconf-generic.h            |   18 ++++++----
 4 files changed, 93 insertions(+), 22 deletions(-)

-- 
1.7.10.4

