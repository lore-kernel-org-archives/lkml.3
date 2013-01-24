Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3AXKUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:20:11 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49605 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3AXKUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:20:04 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH V3 0/4] i2c: s3c2410: Add devm_* apis and cleanup
Date: Thu, 24 Jan 2013 15:41:05 +0530
Message-Id: <1359022269-12593-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up the probe function of i2c-s3c2410 driver.
These have been tested on Exynos4210 based Origen board.

Changes since V2:
  * Rebased to v3.8-rc4.
  * devm_request_and_ioremap() has already been implemented.

Changes since V1:
  * devm_request_mem_region and devm_ioremap calls were replaced by
devm_request_and_ioremap() call.
  * All devm_* related modifications (earlier patches 2-5) were merged
to a single patch.


Tushar Behera (4):
  i2c: s3c2410: Remove unnecessary label err_noclk
  i2c: s3c2410: Convert to use devm_* APIs
  i2c: s3c2410: Move location of clk_prepare_enable() call in probe
    function
  i2c: s3c2410: Remove err_cpufreq label

 drivers/i2c/busses/i2c-s3c2410.c |   59 +++++++++++++------------------------
 1 files changed, 21 insertions(+), 38 deletions(-)

-- 
1.7.4.1

