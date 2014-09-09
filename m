Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaIIJ5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:57:34 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43134 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaIIJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:57:31 -0400
From: Ankit Jindal <ankit.jindal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Ankit Jindal <ankit.jindal@linaro.org>
Subject: [PATCH 0/5] UIO driver for APM X-Gene QMTM
Date: Tue,  9 Sep 2014 15:26:54 +0530
Message-Id: <1410256619-3213-1-git-send-email-ankit.jindal@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enables user space access to APM X-Gene QMTM
using UIO framework.

The patchset also introduces new type UIO_MEM_PHYS_CACHE
for mem regions because APM X-Gene QMTM device supports
cache coherency with CPU caches.

Ankit Jindal (5):
  uio: Add new UIO_MEM_PHYS_CACHE type for mem regions
  Documentation: Update documentation for UIO_MEM_PHYS_CACHE
  drivers: uio: Add Xgene QMTM UIO driver
  dt-bindings: Add binding info for Xgene QMTM UIO driver
  MAINTAINERS: Add entry for APM Xgene QMTM UIO driver

 Documentation/DocBook/uio-howto.tmpl               |    3 +-
 .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   45 +++
 MAINTAINERS                                        |    7 +
 drivers/uio/Kconfig                                |    8 +
 drivers/uio/Makefile                               |    1 +
 drivers/uio/uio.c                                  |   22 +-
 drivers/uio/uio_xgene_qmtm.c                       |  289 ++++++++++++++++++++
 include/linux/uio_driver.h                         |    7 +-
 8 files changed, 369 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
 create mode 100644 drivers/uio/uio_xgene_qmtm.c

-- 
1.7.9.5

