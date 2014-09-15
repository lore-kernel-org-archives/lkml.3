Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaIOTOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:14:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40611 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754485AbaIOTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:14:04 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, jonsmirl@gmail.com,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv6 0/2] Add Allwinner SoCs PWM support
Date: Mon, 15 Sep 2014 21:13:54 +0200
Message-Id: <1410808436-21460-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch seseries adds support for the PWM controller found on the Allwinner
SoCs.

The first patch adds the driver itself.
The second patch adds the DT binding documentation

Changes in v6:
 - Took into account comments from Thierry
 - Removed the prescaler bypass from sun4i (reported by Jon Smirl)
 - Rounding period half up when not using the prescaler (reported by Jon Smirl)
 - Corrected issues reported by Simon (PWM_PRD_MASK, channel 1 and off-by-one
   error)


Alexandre Belloni (2):
  pwm: Add Allwinner SoC support
  pwm: sunxi: document OF bindings

 .../devicetree/bindings/pwm/pwm-sunxi.txt          |  20 ++
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-sunxi.c                            | 371 +++++++++++++++++++++
 4 files changed, 401 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sunxi.txt
 create mode 100644 drivers/pwm/pwm-sunxi.c

-- 
1.9.1

