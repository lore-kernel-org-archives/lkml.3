Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaCKMpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:45:47 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:36689 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbaCKMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:45:44 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 0/3] xtensa xtfpga SPI controller driver
Date: Tue, 11 Mar 2014 16:44:48 +0400
Message-Id: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this series adds driver for SPI controller used on xtfpga xtensa platform,
device tree binding documentation and an entry to MAINTAINERS.

Max Filippov (3):
  spi: add xtfpga SPI controller driver
  spi/xtensa-xtfpga: add DT binding documentation
  MAINTAINERS: add xtfpga platform section

 .../devicetree/bindings/spi/spi-xtensa-xtfpga.txt  |   9 ++
 MAINTAINERS                                        |   6 +
 drivers/spi/Kconfig                                |  13 ++
 drivers/spi/Makefile                               |   1 +
 drivers/spi/spi-xtensa-xtfpga.c                    | 165 +++++++++++++++++++++
 5 files changed, 194 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-xtensa-xtfpga.txt
 create mode 100644 drivers/spi/spi-xtensa-xtfpga.c

-- 
1.8.1.4

