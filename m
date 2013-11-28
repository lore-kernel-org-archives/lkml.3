Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab3K1H0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:26:50 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60059 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3K1H0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:26:46 -0500
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: grant-likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com
Subject: [PATCH v1 0/2] of: irq: Ignore disabled interrupt controllers
Date: Wed, 27 Nov 2013 23:26:11 -0800
Message-Id: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

These two patches support the case where an interrupt controller is
marked as disabled. Patch 1 fixed the dts interrupt-map search logic to
ignore disabled interrupt controllers. Patch 2 stops disabled interrupt
controllers getting probed.

Peter Crosthwaite (2):
  of: irq: Ignore disabled intc's when searching map
  of: irq: Ignore disabled interrupt controllers

 drivers/of/irq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
1.8.4.4

