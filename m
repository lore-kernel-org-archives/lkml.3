Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaBMKsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:48:03 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:57538 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754346AbaBMKr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:47:59 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-3.tower-39.messagelabs.com!1392288350!13299030!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 13 Feb 2014 10:45:48 +0000
Subject: [PATCH 0/2] mfd: da9055: Add DT support & documentation for PMIC
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds DT support for the MFD core of the da9055 PMIC, and adds
the accompanying DT binding documentation for the device.

Adam Thomson (2):
  mfd: da9055: Add DT support for PMIC
  mfd: da9055: Add DT binding documentation for PMIC

 Documentation/devicetree/bindings/mfd/da9055.txt |   73 ++++++++++++++++++++++
 drivers/mfd/da9055-i2c.c                         |    8 +++
 2 files changed, 81 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9055.txt

