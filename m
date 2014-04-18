Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaDRRIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:08:32 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:53899 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaDRRIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:08:25 -0400
MIME-Version: 1.0
Date: Fri, 18 Apr 2014 12:08:24 -0500
Message-ID: <CAL_JsqK2k45hQ_CQTxYpTnW_gq1ougOGipm_QToBKz9T=r4Leg@mail.gmail.com>
Subject: [GIT PULL] Devicetree fixes for 3.15
From: Rob Herring <robherring2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull DT fixes for 3.15.

Thanks,
Rob

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/dt-fixes-for-3.15

for you to fetch changes up to 20cd477c398decd6a8461ac48609b6c0ab4c7567:

  of: add empty of_find_node_by_path() for !OF (2014-04-18 08:36:10 -0500)

----------------------------------------------------------------
Devicetree fixes for 3.15:
- Fix error handling in of_update_property
- Fix section mismatch warnings in __reserved_mem_check_root
- Add empty of_find_node_by_path for !OF builds
- Add various missing binding documentation

----------------------------------------------------------------
Alexander Shiyan (2):
      of: Add vendor prefix for Digi International Inc.
      of: add empty of_find_node_by_path() for !OF

Andrew Lunn (3):
      DT: bindings: add missing Marvell Kirkwood SoC documentation
      DT: Vendor: Add prefixes used by Kirkwood devices
      DT: I2C: Add trivial bindings used by kirkwood boards

Dinh Nguyen (1):
      dt-bindings: add vendor-prefix for Newhaven Display

Guenter Roeck (1):
      of: Clean up of_update_property

Javier Martinez Canillas (1):
      of: add vendor prefix for ISEE 2007 S.L.

Stefan Wahren (1):
      of: add vendor prefix for I2SE GmbH

Steffen Trumtrar (1):
      DT: add vendor prefix for EBV Elektronik

Xiubo Li (1):
      of: Fix the section mismatch warnings.

 .../devicetree/bindings/arm/marvell,kirkwood.txt   | 97 ++++++++++++++++++++++
 .../devicetree/bindings/i2c/trivial-devices.txt    | 16 ++++
 .../devicetree/bindings/vendor-prefixes.txt        | 18 +++-
 drivers/of/base.c                                  | 10 +--
 drivers/of/fdt.c                                   |  2 +-
 include/linux/of.h                                 |  5 ++
 6 files changed, 139 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,kirkwood.txt
