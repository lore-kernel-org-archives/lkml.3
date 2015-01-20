Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbbATJSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:18:15 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54061 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbbATJSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:18:13 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Joonwoo Park <joonwoop@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 0/3] pinctrl: Qualcomm msm8916 pinctrl driver
Date: Tue, 20 Jan 2015 11:17:53 +0200
Message-Id: <1421745476-6276-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a pinctrl driver for Snapdragon 410 (msm8916) SoC. The first
patch increase the register address variable size, next adds a binding document
and the last patch adds the pinctrl driver

Comments are welcome!

regards,
Stan

Joonwoo Park (2):
  pinctrl: qcom: increase variable size for register addresses
  pinctrl: qcom: Add msm8916 pinctrl driver

Stanimir Varbanov (1):
  DT: pinctrl: Document Qualcomm MSM8916 pinctrl binding

 .../bindings/pinctrl/qcom,msm8916-pinctrl.txt      |  186 +++
 drivers/pinctrl/qcom/Kconfig                       |    8 +
 drivers/pinctrl/qcom/Makefile                      |    1 +
 drivers/pinctrl/qcom/pinctrl-msm.h                 |   10 +-
 drivers/pinctrl/qcom/pinctrl-msm8916.c             | 1280 ++++++++++++++++++++
 5 files changed, 1480 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,msm8916-pinctrl.txt
 create mode 100644 drivers/pinctrl/qcom/pinctrl-msm8916.c

