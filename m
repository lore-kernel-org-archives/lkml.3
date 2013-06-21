Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161332Ab3FUF4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:56:32 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60682 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161096Ab3FUF4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:56:31 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org
Subject: [PATCH 0/2] support for non-gpio cs pin
Date: Fri, 21 Jun 2013 11:26:11 +0530
Message-Id: <1371794173-27266-1-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the dedicated cs pin and
support for exynos5440 spi controller. The first patch
"Polling support for s3c64xx spi controller" in the previous
serias is already applied to Mark's spi-next branch. So created
a new series with remaining 2 patches.


Girish K S (2):
  spi: s3c64xx: Added provision for dedicated cs pin
  spi: s3c64xx: Added support for exynos5440 spi

 drivers/spi/spi-s3c64xx.c |   46 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 38 insertions(+), 8 deletions(-)

-- 
1.7.5.4

