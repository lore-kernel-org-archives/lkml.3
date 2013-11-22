Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3KVVyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:54:33 -0500
Received: from gloria.sntech.de ([95.129.55.99]:56463 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab3KVVy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:54:29 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 0/2] Add support for hym8563 rtcs
Date: Fri, 22 Nov 2013 22:54:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201311222254.07730.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the Haoyu Microelectronics HYM8563 rtc. This
chip is often used in designs around the Cortex-A9 SoCs from Rockchip to
provide rtc functionality and the 32kHz suspend clock the SoC needs.

Heiko Stuebner (2):
  Documentation: dt: Add dt hym8563 binding
  rtc: add hym8563 rtc-driver

 .../devicetree/bindings/rtc/haoyu,hym8563.txt      |   29 +
 drivers/rtc/Kconfig                                |   11 +
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-hym8563.c                          |  619 ++++++++++++++++++++
 4 files changed, 660 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
 create mode 100644 drivers/rtc/rtc-hym8563.c

-- 
1.7.10.4

