Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaKEPPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:15:52 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42509 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932141AbaKEPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:15:49 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv9 0/2] Add Allwinner SoCs PWM support
Date: Wed,  5 Nov 2014 16:15:43 +0100
Message-Id: <1415200545-26238-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds support for the PWM controller found on the Allwinner
SoCs.

The first patch adds the driver itself.
The second patch adds the DT binding documentation

Changes in v8:
 - renamed the driver sun4i as the PWM IP is different in the next sunxi SoCs
 - Took into account comments from Thierry

Changes in v9:
 - moved from using a mutex to a spinlock

Alexandre Belloni (2):
  pwm: Add Allwinner SoC support
  pwm: sunxi: document OF bindings

 .../devicetree/bindings/pwm/pwm-sun4i.txt          |  20 ++
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-sun4i.c                            | 366 +++++++++++++++++++++
 4 files changed, 396 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sun4i.txt
 create mode 100644 drivers/pwm/pwm-sun4i.c

-- 
2.1.0

