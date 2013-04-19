Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030475Ab3DSMre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:47:34 -0400
Received: from mail.neotion.com ([91.121.222.125]:56092 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030341Ab3DSMrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:47:33 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Apr 2013 08:47:32 EDT
Message-ID: <51713B86.2090001@neotion.com>
Date: Fri, 19 Apr 2013 14:41:42 +0200
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
Organization: Neotion
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-mmc@vger.kernel.org
CC: Chris Ball <cjb@laptop.org>, Namjae Jeon <linkinjeon@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add boot_enable attribute to eMMC device for boot mode
 operation selection
X-Enigmail-Version: 1.5.1
OpenPGP: id=1166F485
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since eMMC 4.3 a special boot mode operation was introduced to retrieve
data from the eMMC device with a very simple procedure. Since the Linux
kernel exports these device boot partitions, it may be useful to select
the boot partition from the user space.

The patch has been tested on a Toshiba eMMC conforming with eMMC 4.5
specifications.

Neil Armstrong (3):
  Add BOOT_PARTITION_ENABLE definition to MMC EXT_CSD PART_CONFIG
  Add boot_enable sysfs attribute to select MMC boot operation
    partition
  Add Documentation for MMC boot_enable attribute

 Documentation/mmc/mmc-dev-parts.txt |    6 +++
 drivers/mmc/card/block.c            |   72
++++++++++++++++++++++++++++++++++-
 include/linux/mmc/mmc.h             |    1 +
 3 files changed, 78 insertions(+), 1 deletions(-)


