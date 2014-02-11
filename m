Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBKPwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:52:54 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:61408 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaBKPww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:52:52 -0500
MIME-Version: 1.0
Date: Tue, 11 Feb 2014 09:52:51 -0600
Message-ID: <CAL_JsqLW7YzMTcMw1bMqQ4bJeG6W61GgRNBwCiciyBMW5wU5uQ@mail.gmail.com>
Subject: DeviceTree fixes for 3.14
From: Rob Herring <robherring2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull DT fixes for 3.14.

Rob

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/dt-fixes-for-3.14

for you to fetch changes up to 860a445c25aa2f99aa5881603a1f4ed2cec64025:

  DT: Add vendor prefix for Spansion Inc. (2014-02-05 10:39:17 -0600)

----------------------------------------------------------------
DeviceTree fixes for 3.14:

- Fix compile error drivers/spi/spi-rspi.c with !CONFIG_OF
- Fix warnings for unused/uninitialized variables with !CONFIG_OF
- Fix PCIe bus matching for powerpc
- Add documentation for various vendor strings

----------------------------------------------------------------
Emilio López (1):
      of: add vendor prefix for Allwinner Technology

Geert Uytterhoeven (2):
      of/device: Nullify match table in of_match_device() for CONFIG_OF=n
      DT: Add vendor prefix for Spansion Inc.

Heiko Stuebner (1):
      dt-bindings: add vendor-prefix for neonode

Kleber Sacilotto de Souza (1):
      of: fix PCI bus match for PCIe slots

Kumar Gala (1):
      of: Update qcom vendor prefix description

Marek Belisko (1):
      of: add vendor prefix for Honeywell

Rob Herring (1):
      of: restructure for_each macros to fix compile warnings

 .../devicetree/bindings/vendor-prefixes.txt        |   6 +-
 drivers/of/address.c                               |   5 +-
 include/linux/of.h                                 | 153 +++++++++++----------
 include/linux/of_device.h                          |   4 +-
 4 files changed, 95 insertions(+), 73 deletions(-)
