Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3L3WBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 17:01:30 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53998 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3L3WB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 17:01:29 -0500
MIME-Version: 1.0
Date: Mon, 30 Dec 2013 16:01:28 -0600
Message-ID: <CAL_JsqK7p94eMnY10sjmgsADWe2VCBUY64xhhx6Aoin--VxZTQ@mail.gmail.com>
Subject: [GIT PULL] Devicetree fixes for 3.13
From: Rob Herring <robherring2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull a couple of DT fixes for 3.13.

Rob

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/dt-fixes-for-3.13

for you to fetch changes up to f0082e3cf70e19dce4e96494078ec3ddb89550d3:

  Merge remote-tracking branch 'grant/devicetree/merge' into dt-fixes
(2013-12-30 12:09:47 -0600)

----------------------------------------------------------------

- Fix 2 regressions found on PPC
- Allow NULL ptr in unflatten_and_copy_device_tree
- Update my email address

----------------------------------------------------------------
Cédric Le Goater (1):
      of/irq: Fix device_node refcount in of_irq_parse_raw()

Geert Uytterhoeven (1):
      of/Kconfig: Spelling s/one/once/

James Hogan (1):
      of: Fix NULL dereference in unflatten_and_copy()

Rob Herring (3):
      Revert "of/address: Handle #address-cells > 2 specially"
      MAINTAINERS: Update Rob Herring's email address
      Merge remote-tracking branch 'grant/devicetree/merge' into dt-fixes

 MAINTAINERS          |  6 +++---
 drivers/of/Kconfig   |  2 +-
 drivers/of/address.c |  8 --------
 drivers/of/fdt.c     | 12 ++++++++++--
 drivers/of/irq.c     |  5 +----
 5 files changed, 15 insertions(+), 18 deletions(-)
