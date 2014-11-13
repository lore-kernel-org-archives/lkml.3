Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaKMDI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 22:08:28 -0500
Received: from mail-oi0-f74.google.com ([209.85.218.74]:51056 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaKMDIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 22:08:25 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: [PATCH V2 0/2] spi: IMG SPFI driver
Date: Wed, 12 Nov 2014 19:08:14 -0800
Message-Id: <1415848096-20079-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the Sychronous Peripheral Flash Interface
master found on IMG SoCs.  The controller supports up to 5 chip-select
lines and single, dual, and optionally quad, mode transfers.

Tested on a platform using the MIPS-based Pistachio SoC with additional
out-of-tree patches - support for Pistachio will be submitted soon.

Based on 3.18-rc4.

Changes from v1:
 - added runtime PM support
 - renamed spi-img -> spi-img-spfi
 - addressed Mark's review comments

Andrew Bresticker (2):
  spi: Add binding document for IMG SPFI controller
  spi: Add driver for IMG SPFI controller

 .../devicetree/bindings/spi/spi-img-spfi.txt       |  37 +
 drivers/spi/Kconfig                                |   7 +
 drivers/spi/Makefile                               |   1 +
 drivers/spi/spi-img-spfi.c                         | 745 +++++++++++++++++++++
 4 files changed, 790 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-img-spfi.txt
 create mode 100644 drivers/spi/spi-img-spfi.c

-- 
2.1.0.rc2.206.gedb03e5

