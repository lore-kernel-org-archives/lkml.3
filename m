Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3FRFAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:00:30 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38431 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3FRFA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:00:29 -0400
From: girishks2000@gmail.com
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org, Girish K S <ks.giri@samsung.com>
Subject: [RESEND PATCH v1 0/3] Polling support for s3c64xx spi controller
Date: Tue, 18 Jun 2013 10:30:08 +0530
Message-Id: <51bfe96b.4266420a.3737.3523@mx.google.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Girish K S <ks.giri@samsung.com>

This patch series adds support for the polling mode only. Also 2nd patch
in the series adds support for dedicated cs pin. After Thomas's patch for
using default gpio is merged(commit id: 00ab539), one of the patch in this
series is dropped and new series is generated.

Girish K S (3):
  spi: s3c64xx: added support for polling mode
  spi: s3c64xx: Added provision for dedicated cs pin
  spi: s3c64xx: Added support for exynos5440 spi

 drivers/spi/spi-s3c64xx.c |  197 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 140 insertions(+), 57 deletions(-)

-- 
1.7.5.4

