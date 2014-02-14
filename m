Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaBNQtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:49:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59832 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbaBNQtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:49:19 -0500
From: Joel Fernandes <joelf@ti.com>
To: <herbert@gondor.apana.org.au>, <rnayak@ti.com>
CC: <linux-crypto@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 0/2] Introduce omap-des driver for OMAP SoCs
Date: Fri, 14 Feb 2014 10:48:41 -0600
Message-ID: <1392396521-24326-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are revised patches for omap-des driver addressing review comments at:
https://lkml.org/lkml/2013/8/30/116

Joel Fernandes (2):
  crypto: omap-des: Add omap-des driver for OMAP4/AM43xx
  crypto: omap-des: Add config and build options

 drivers/crypto/Kconfig    |   11 +
 drivers/crypto/Makefile   |    1 +
 drivers/crypto/omap-des.c | 1218 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1230 insertions(+)
 create mode 100644 drivers/crypto/omap-des.c

-- 
1.7.9.5

