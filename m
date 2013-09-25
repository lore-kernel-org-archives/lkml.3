Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3IYCx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 22:53:57 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:61655 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3IYCx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 22:53:56 -0400
Message-ID: <52425041.6030609@gmail.com>
Date: Tue, 24 Sep 2013 21:53:53 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Grant Likely <grant.likely@linaro.org>, Dinh Nguyen <dinguyen@altera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: [GIT PULL] Devicetree fixes for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these 3 DT fixes for 3.12.

Rob

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git

for you to fetch changes up to 53126a2f679382f3eac370a012290f19c672f088:

  dts: Fix misspelling of Synopsys (2013-09-24 21:13:38 -0500)

----------------------------------------------------------------
DeviceTree fixes for 3.12

Clean-up to fix some warnings for !OF builds and spelling fixes in docs

- Clean-up openrisc prom.h
- Fix warnings caused by of_irq.h ifdefs
- Spelling fix for Synopsys

----------------------------------------------------------------
Dinh Nguyen (1):
      dts: Fix misspelling of Synopsys

Rob Herring (2):
      openrisc: clean-up prom.h
      of: clean-up ifdefs in of_irq.h

 .../devicetree/bindings/mmc/exynos-dw-mshc.txt     | 10 ++---
 .../devicetree/bindings/mmc/rockchip-dw-mshc.txt   | 10 ++---
 .../{synopsis-dw-mshc.txt => synopsys-dw-mshc.txt} |  8 ++--
 .../devicetree/bindings/pci/designware-pcie.txt    |  2 +-
 arch/openrisc/include/asm/prom.h                   | 44
----------------------
 include/linux/of_irq.h                             | 20 ++++------
 6 files changed, 23 insertions(+), 71 deletions(-)
 rename Documentation/devicetree/bindings/mmc/{synopsis-dw-mshc.txt =>
synopsys-dw-mshc.txt} (93%)
