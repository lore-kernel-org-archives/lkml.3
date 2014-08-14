Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbaHNOZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:25:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42540 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaHNOZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:25:44 -0400
X-AuditID: cbfee61a-f79e46d00000134f-3e-53ecc6e60782
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 0/5] usb: phy: samsung: remove old USB PHY code
Date: Thu, 14 Aug 2014 16:25:22 +0200
Message-id: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e+xoO6zY2+CDfbM07DYOGM9q8XB+/UW
	m65fZ7Vou3KQ3eLH6wtsFr0LrrJZXHjaw2ZxtukNu8XlXXPYLGac38dksWhZK7MDt8eda3vY
	PPq2rGL0OH5jO5PH501yASxRXDYpqTmZZalF+nYJXBkH/55kL7jLXTHh8lnWBsZ+zi5GTg4J
	AROJf0eb2CFsMYkL99azdTFycQgJTGeUeHzkBiOE08Uk0bH+IVgVm4CVxMT2VYwgtoiAmkTP
	4q1gRcwC95kkNj88zQqSEBawl+j4fhvMZhFQlZj3YBZYM6+Ah0TTzp9MEOsUJbqfTWCbwMi9
	gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwED2T2sG4ssHiEKMAB6MSD2/D9jfBQqyJ
	ZcWVuYcYJTiYlUR4p+8GCvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBa
	BJNl4uCUamBcP92jLM1s+y79urQ9H6+rvlL2m6KZtt/4Kg+L4dwHwkue9r8Xao6Y9KG5ZfL8
	xTEKIuHC/6OXHJvPG7joiYm+VCxXte1xmUjh8+mrrkjWrFi7jcO/4MinaE5xb17WnC2M+7Sz
	Fa0/8QgoLGVebns1rM2HKXylie42l/t7Pu391LZs8rkj77YrsRRnJBpqMRcVJwIAbWyQXh4C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series removes the old Samsung USB PHY drivers that
got replaced by the new ones using the generic PHY layer.

Depends on:
- next-20140813 branch of linux-next kernel

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (5):
  ARM: dts: remove old USB2 PHY node hook for Arndale
  ARM: dts: remove old USB2 PHY node for Exynos5250
  usb: phy: samsung: remove old USB 2.0 PHY driver
  usb: phy: samsung: remove old USB 3.0 PHY driver
  usb: phy: samsung: remove old common USB PHY code

 arch/arm/boot/dts/exynos5250-arndale.dts     |   4 -
 arch/arm/boot/dts/exynos5250.dtsi            |  15 -
 drivers/usb/phy/Kconfig                      |  23 --
 drivers/usb/phy/Makefile                     |   3 -
 drivers/usb/phy/phy-samsung-usb.c            | 241 ------------
 drivers/usb/phy/phy-samsung-usb.h            | 349 -----------------
 drivers/usb/phy/phy-samsung-usb2.c           | 541 ---------------------------
 drivers/usb/phy/phy-samsung-usb3.c           | 350 -----------------
 include/linux/platform_data/samsung-usbphy.h |  27 --
 9 files changed, 1553 deletions(-)
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.c
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.h
 delete mode 100644 drivers/usb/phy/phy-samsung-usb2.c
 delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c
 delete mode 100644 include/linux/platform_data/samsung-usbphy.h

-- 
1.8.2.3

