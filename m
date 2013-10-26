Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3JZABv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 20:01:51 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4153 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab3JZABq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 20:01:46 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Wendy Ng" <wendy.ng@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Eduardo Valentin" <eduardo.valentin@ti.com>
cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Tim Kryger" <tim.kryger@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Wendy Ng" <wendy.ng@broadcom.com>
Subject: [PATCH 0/3] thermal: bcm281xx: Add Temperature Monitor driver
Date: Fri, 25 Oct 2013 17:00:26 -0700
Message-ID: <1382745629-1123-1-git-send-email-wendy.ng@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-WSS-ID: 7E75D9C01SC1674937-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds the support of the Temperature Monitor driver
for Broadcom bcm281xx SoCs. This TMON driver can be used with the
Thermal Framework.

This patch series incoporates the feedback from the old series:
V1: https://lkml.org/lkml/2013/9/23/424
V2: https://lkml.org/lkml/2013/9/27/555

Note that this patch series is dependent on the following patches:
https://lkml.org/lkml/2013/9/26/787
http://www.spinics.net/lists/arm-kernel/msg274963.html
https://lkml.org/lkml/2013/10/3/645

Wendy Ng (3):
  thermal: bcm281xx: Add Temperature Monitor driver
  ARM: configs:enable thermal framework for bcm281xx
  ARM: dts: Add TMON driver support to bcm281xx

 .../bindings/thermal/bcm-kona-thermal.txt          |   24 +++
 arch/arm/boot/dts/bcm11351-brt.dts                 |    4 +
 arch/arm/boot/dts/bcm11351.dtsi                    |   29 ++++
 arch/arm/boot/dts/bcm28155-ap.dts                  |    4 +
 arch/arm/configs/bcm_defconfig                     |    4 +-
 drivers/thermal/Kconfig                            |   11 ++
 drivers/thermal/Makefile                           |    1 +
 drivers/thermal/bcm_kona_tmon.c                    |  173 ++++++++++++++++++++
 8 files changed, 249 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
 create mode 100644 drivers/thermal/bcm_kona_tmon.c

-- 
1.7.9.5


