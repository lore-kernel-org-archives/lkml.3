Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3H2X25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:28:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52594 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3H2X2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:28:48 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH 0/3] crypto: omap-des: Add driver for OMAP DES module
Date: Thu, 29 Aug 2013 18:27:50 -0500
Message-ID: <1377818873-21174-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 and AM437x SoCs have a DES3DES module which is capable of performing DES
encrypt/decrypt and 3DES ede encrypt/decrypt operations. Following patch series
adds support for the same.

Tests have been performed with crypto/testmgr and all tests are successful.

Joel Fernandes (3):
  crypto: omap-des: Add omap-des driver for OMAP4/AM43xx
  crypto: omap-des: Add config and build options
  crypto: omap-des: Add triple DES (des3_ede) support to driver

 drivers/crypto/Kconfig    |   11 +
 drivers/crypto/Makefile   |    1 +
 drivers/crypto/omap-des.c | 1239 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1251 insertions(+)
 create mode 100644 drivers/crypto/omap-des.c

-- 
1.8.1.2

