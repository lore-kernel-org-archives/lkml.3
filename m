Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbbAXATT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:19:19 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:1720 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbbAXATN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:19:13 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: [PATCH v2 0/2] Qualcomm PM8941 power key driver
Date: Fri, 23 Jan 2015 16:19:05 -0800
Message-ID: <1422058747-13486-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add dt bindings and a device driver for the power key block in
the Qualcomm PM8941 pmic.

Changes since v1:
 * Use a reboot_notifier to set power off/reboot mode
 * Use irq flags from devicetree
 * Some style fixes

Courtney Cavin (2):
  input: Add Qualcomm PM8941 power key driver
  input: pm8941-pwrkey: Add DT binding documentation

 .../bindings/input/qcom,pm8941-pwrkey.txt          |  43 ++++
 drivers/input/misc/Kconfig                         |  12 +
 drivers/input/misc/Makefile                        |   1 +
 drivers/input/misc/pm8941-pwrkey.c                 | 281 +++++++++++++++++++++
 4 files changed, 337 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8941-pwrkey.txt
 create mode 100644 drivers/input/misc/pm8941-pwrkey.c

-- 
1.9.1

