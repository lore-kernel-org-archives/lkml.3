Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145AbaFNXe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 19:34:26 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:37902 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaFNXeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 19:34:25 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] staging: imx-drm: ipu-v3: ipu-common.c:  Cleaning up return of uninitialized variable  
Date: Sun, 15 Jun 2014 01:35:20 +0200
Message-Id: <1402788921-15458-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before when there was an error a uninitialized variable would be returnd.
Now it returns -ENODEV

This was found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  staging: imx-drm: ipu-v3: ipu-common.c:  Cleaning up return of uninitialized variable

 drivers/staging/imx-drm/ipu-v3/ipu-common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.10.4

