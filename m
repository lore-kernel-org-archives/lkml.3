Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3DVHJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:09:46 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62397 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3DVHJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:09:45 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, t.figa@samsung.com,
        broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/3] Polling support for s3c64xx spi controller
Date: Mon, 22 Apr 2013 12:39:22 +0530
Message-Id: <1366614565-3743-1-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the polling mode only. Also 2nd patch
in the series adds support for dedicated cs pin. After Thomas's patch for
using default gpio is merged(commit id: 00ab539), one of the patch in this
series is dropped and new series is generated.

Girish K S (3):
  spi: s3c64xx: added support for polling mode
  spi: s3c64xx: Added provision for dedicated cs pin
  spi: s3c64xx: Added support for exynos5440 spi

 drivers/spi/spi-s3c64xx.c |  192 +++++++++++++++++++++++++++++++-------------
 1 files changed, 135 insertions(+), 57 deletions(-)

-- 
1.7.5.4

