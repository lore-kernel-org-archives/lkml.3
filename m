Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3FHX7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 19:59:11 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37101 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3FHX7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 19:59:10 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/2] pinctrl: common handling of generic pinconfig props in dt
Date: Sun, 9 Jun 2013 01:59:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306090159.05383.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

following your suggestions for a common handling of things like pulls in dt,
I've come up with the following solution - hopefully I've gotten the correct
meaning of your explanaitions.

It handles all the pinconfigs that either ignore the argument, or have very
simple one, like PIN_CONFIG_OUTPUT does.

I've also attached my current rockchip pinctrl driver to show how it is using
this currently.


Heiko Stuebner (2):
  pinctrl: add devicetree constants for simple generic pnconfig options
  pinctrl: add function to separate combined pinconfig values

 .../bindings/pinctrl/pinctrl-bindings.txt          |    9 +++
 drivers/pinctrl/pinconf-generic.c                  |   61 ++++++++++++++++++++
 drivers/pinctrl/pinconf.h                          |    6 ++
 include/dt-bindings/pinctrl/pinconfig.h            |   37 ++++++++++++
 4 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 include/dt-bindings/pinctrl/pinconfig.h

-- 
1.7.2.3

