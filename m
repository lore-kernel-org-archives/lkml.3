Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbbALNXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:23:24 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62817 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbALNXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:23:21 -0500
MIME-Version: 1.0
Date: Mon, 12 Jan 2015 14:23:20 +0100
Message-ID: <CAPDyKFqLjy+kAWswigYXOC3WJvntt9qD9jzAeX1eOvXK2xWifg@mail.gmail.com>
Subject: [GIT PULL] MMC fixes for v.3.19, take 2
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus <torvalds@linux-foundation.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a few mmc fixes for 3.19, take 2.

Details are as usual found in the signed tag. Please pull this in!

Kind regards
Ulf Hansson


The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ulf.hansson/mmc.git tags/mmc-v3.19-3

for you to fetch changes up to 1f7f26528fb159e71f081df1d1050c218ff1d74d:

  mmc: sdhci-pci: Add support for Intel SPT (2015-01-12 10:14:58 +0100)

----------------------------------------------------------------
MMC host:
- sdhci-pci|acpi: Support some new IDs
- sdhci: Fix sleep from atomic context
- sdhci-pxav3: Prevent hang during ->probe()
- sdhci: Disable re-tuning for HS400

----------------------------------------------------------------
Adrian Hunter (6):
      mmc: sdhci: Tuning should not change max_blk_count
      mmc: sdhci: Add out_unlock to sdhci_execute_tuning
      mmc: sdhci: Simplify use of tuning timer
      mmc: sdhci: Disable re-tuning for HS400
      mmc: sdhci-acpi: Add ACPI HID INT344D
      mmc: sdhci-pci: Add support for Intel SPT

Krzysztof Kozlowski (1):
      mmc: sdhci: Fix sleep in atomic after inserting SD card

Thomas Petazzoni (1):
      mmc: sdhci-pxav3: do the mbus window configuration after enabling clocks

 drivers/mmc/host/sdhci-acpi.c  |  2 ++
 drivers/mmc/host/sdhci-pci.c   | 25 ++++++++++++++
 drivers/mmc/host/sdhci-pci.h   |  3 ++
 drivers/mmc/host/sdhci-pxav3.c | 15 ++++-----
 drivers/mmc/host/sdhci.c       | 74 +++++++++++++++++++++++++++---------------
 include/linux/mmc/sdhci.h      |  1 +
 6 files changed, 86 insertions(+), 34 deletions(-)
