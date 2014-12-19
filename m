Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaLSKgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 05:36:48 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:49414 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaLSKgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 05:36:46 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1417758564.git.micky_ching@realsil.com.cn>
References: <cover.1417758564.git.micky_ching@realsil.com.cn>
Date: Fri, 19 Dec 2014 11:36:46 +0100
Message-ID: <CAPDyKFoGQBgpkYS1AatTSM9y3iaOOCtCGRgw2MOeQEWb_Ca-tw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] mmc: rtsx: add support for sdio card
From: Ulf Hansson <ulf.hansson@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2014 at 06:54,  <micky_ching@realsil.com.cn> wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> v4:
>   split patch in more detailed patches. no code changes diff v3.
>
> v3:
>   rtsx_pci_sdmmc.c:
>     - dump_reg_range
>       - remove unused pointer check
>       - fix start index
> v2:
>   rtsx_pci.h:
>     - remove unused rtsx_pci_write_le32
>     - add SD_CMD_START
>   rtsx_pci_sdmmc.c:
>     - dump_reg_range
>       - alloc data on stack
>     - remove forward declaration
>     - use SD_CMD_START replace magic number 0x40
>     - move initialize assignment to error handling
>
> This patch is used to change transfer mode for sdio card support
> by SD interface.
>
>
>
> Micky Ching (6):
>   mfd: rtsx: add func to split u32 into register
>   mmc: rtsx: add dump_reg_range to simplify dump register
>   mmc: rtsx: init cookie at probe/card_event
>   mmc: rtsx: add helper function to simplify code
>   mmc: rtsx: add support for sdio card
>   mmc: rtsx: swap function position to avoid pre declaration
>
>  drivers/mmc/host/rtsx_pci_sdmmc.c | 522 +++++++++++++++++++++-----------------
>  include/linux/mfd/rtsx_pci.h      |   9 +
>  2 files changed, 296 insertions(+), 235 deletions(-)
>
> --
> 1.9.1
>

Thanks! Queued for 3.20.

Kind regards
Uffe
