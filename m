Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaJGBLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 21:11:49 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8898 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbaJGBLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 21:11:48 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: [PATCH 0/2] Qualcomm PM8941 power key driver
Date: Mon, 6 Oct 2014 18:11:59 -0700
Message-ID: <1412644321-27683-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add dt bindings and a device driver for the power key block in
the Qualcomm PM8941 pmic.

Courtney Cavin (2):
  input: Add Qualcomm PM8941 power key driver
  input: pm8941-pwrkey: Add DT binding documentation

 .../bindings/input/qcom,pm8941-pwrkey.txt          |   43 +++++
 drivers/input/misc/Kconfig                         |   12 ++
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/pm8941-pwrkey.c                 |  196 ++++++++++++++++++++
 4 files changed, 252 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8941-pwrkey.txt
 create mode 100644 drivers/input/misc/pm8941-pwrkey.c

-- 
1.7.9.5

