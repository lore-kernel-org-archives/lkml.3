Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaCEOSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:18:41 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.118]:37179 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbaCEOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:18:39 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-13.tower-194.messagelabs.com!1394029115!14000492!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1394018471.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 5 Mar 2014 14:18:32 +0000
Subject: [PATCH v2 0/2] mfd: da9055: Add DT support & documentation for PMIC
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds DT support for the MFD core of the da9055 PMIC, and adds
the accompanying DT binding documentation for the device.

v2: Small tidy-ups to documentation (remove new-line, use IRQ related defines)

Adam Thomson (2):
  mfd: da9055: Add DT support for PMIC
  mfd: da9055: Add DT binding documentation for PMIC

 Documentation/devicetree/bindings/mfd/da9055.txt |   72 ++++++++++++++++++++++
 drivers/mfd/da9055-i2c.c                         |    8 +++
 2 files changed, 80 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9055.txt

