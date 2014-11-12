Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaKLViA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:38:00 -0500
Received: from mail-pa0-f73.google.com ([209.85.220.73]:53612 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:37:58 -0500
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
Subject: [PATCH 0/2] IMG SPFI driver
Date: Wed, 12 Nov 2014 13:37:52 -0800
Message-Id: <1415828274-24727-1-git-send-email-abrestic@chromium.org>
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

Andrew Bresticker (2):
  of: Add binding document for IMG SPFI controller
  spi: Add driver for IMG SPFI controller

 Documentation/devicetree/bindings/spi/spi-img.txt |  37 ++
 drivers/spi/Kconfig                               |   7 +
 drivers/spi/Makefile                              |   1 +
 drivers/spi/spi-img.c                             | 703 ++++++++++++++++++++++
 4 files changed, 748 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-img.txt
 create mode 100644 drivers/spi/spi-img.c

-- 
2.1.0.rc2.206.gedb03e5

