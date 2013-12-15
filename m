Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3LOHCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 02:02:04 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5888 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab3LOHCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 02:02:00 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH 0/4] pinctrl-msm: Fixes for various issues
Date: Sat, 14 Dec 2013 23:01:50 -0800
Message-ID: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various fixes based on feedback from Stephen Boyd and kbuild test robot

Bjorn Andersson (4):
  pinctrl-msm: Fix spelling misstakes and missing consts
  pinctrl-msm: Tidy up error handling
  pinctrl-msm: Remove separate allocation of bitmaps
  pinctrl-msm: Rename compatible to be more specific

 ...sm8x74-pinctrl.txt => qcom,msm8974-pinctrl.txt} |    4 +-
 drivers/pinctrl/pinctrl-msm.c                      |  122 ++++++--------------
 drivers/pinctrl/pinctrl-msm8x74.c                  |    6 +-
 3 files changed, 43 insertions(+), 89 deletions(-)
 rename Documentation/devicetree/bindings/pinctrl/{qcom,msm8x74-pinctrl.txt => qcom,msm8974-pinctrl.txt} (97%)

-- 
1.7.9.5

