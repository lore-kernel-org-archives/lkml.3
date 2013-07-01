Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab3GAFSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 01:18:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56063 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab3GAFSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 01:18:22 -0400
Message-ID: <51D110DC.2050107@ti.com>
Date: Mon, 1 Jul 2013 10:47:16 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>, <artem.bityutskiy@linux.intel.com>
CC: <linux-mtd@lists.infradead.org>, <spi-devel-general@lists.sourceforge.net>,
        <broonie@kernel.org>, <dwmw2@infradead.org>, <manonuevo@micron.com>,
        <tqnguyen@micron.com>, <grant.likely@linaro.org>, <balbi@ti.com>,
        <rnayak@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 0/3] spi/mtd generic framework,ti qspi controller and
 spansion driver
References: <1372232472-2641-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1372232472-2641-1-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Artem
On Wednesday 26 June 2013 01:11 PM, Sourav Poddar wrote:
> This patch series add support for the generic spi based flash
> framework(spinand_mtd), which can be used used by any spi based flash device to
> attach itself to mtd framework.
>
> The first patch of this series includes both the generic framework and the
> the micron device(spinand_lld) making use of the framework.
> I picked the first patch as a standalone patch. Can split the generic and
> the lld part based on community suggestions.
>
> The second patch is the ti qspi controller driver.
> The third patch is the spansion s25fl256s driver, making use of the the
> generic spinand_mtd frameowrk.
>
> Test info:
> Tested the generic framework(spinand_mtd.c) along with patch(2&3) on my dra7xx board
> for write/erase/read using nand utils.
>
> Compile tested(spinand_lld.c).
>
> Mona Anonuevo (1):
>    drivers: mtd: spinand: Add generic spinand frameowrk and micron
>      driver.
>
> Sourav Poddar (2):
>    drivers: spi: Add qspi flash controller
>    drivers: mtd: spinand: Add qspi spansion flash controller
>
>   drivers/mtd/Kconfig                 |    2 +
>   drivers/mtd/Makefile                |    2 +
>   drivers/mtd/spinand/Kconfig         |   31 ++
>   drivers/mtd/spinand/Makefile        |   10 +
>   drivers/mtd/spinand/spinand_lld.c   |  776 +++++++++++++++++++++++++++++++++++
>   drivers/mtd/spinand/spinand_mtd.c   |  690 +++++++++++++++++++++++++++++++
>   drivers/mtd/spinand/ti-qspi-flash.c |  373 +++++++++++++++++
>   drivers/spi/Kconfig                 |    6 +
>   drivers/spi/Makefile                |    1 +
>   drivers/spi/ti-qspi.c               |  352 ++++++++++++++++
>   include/linux/mtd/spinand.h         |  155 +++++++
>   11 files changed, 2398 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/mtd/spinand/Kconfig
>   create mode 100644 drivers/mtd/spinand/Makefile
>   create mode 100644 drivers/mtd/spinand/spinand_lld.c
>   create mode 100644 drivers/mtd/spinand/spinand_mtd.c
>   create mode 100644 drivers/mtd/spinand/ti-qspi-flash.c
>   create mode 100644 drivers/spi/ti-qspi.c
>   create mode 100644 include/linux/mtd/spinand.h
>

