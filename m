Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaGKRsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:48:23 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56737 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbaGKRsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:48:21 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org, chris@printf.net, ulf.hansson@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH 0/3] mmc: sdhci-msm: Minor fixes and cleanups
Date: Fri, 11 Jul 2014 20:48:10 +0300
Message-Id: <1405100893-32107-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains fixes in the documentation, cleanups
and enables COMPILE_TEST for better testing coverage.

Georgi Djakov (3):
  mmc: sdhci-msm: Fix the binding example
  mmc: sdhci-msm: Remove unnecessary header file inclusion
  mmc: sdhci-msm: Get COMPILE_TEST support

 .../devicetree/bindings/mmc/sdhci-msm.txt          |    8 ++++----
 drivers/mmc/host/Kconfig                           |    2 +-
 drivers/mmc/host/sdhci-msm.c                       |    1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

-- 
1.7.9.5

