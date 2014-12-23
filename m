Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaLWPdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:33:10 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:53407 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbaLWPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:33:05 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1419297154.git.micky_ching@realsil.com.cn>
References: <cover.1419297154.git.micky_ching@realsil.com.cn>
Date: Tue, 23 Dec 2014 16:33:04 +0100
Message-ID: <CAPDyKFqcDxtBF5ANXMq=ELLXuomuZ_5gaxnQyq7NZZdoQrAx9g@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] mmc: rtsx: add support for sdio card
From: Ulf Hansson <ulf.hansson@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: Chris Ball <chris@printf.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 December 2014 at 02:19,  <micky_ching@realsil.com.cn> wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> v5:
>   fix patch(5) building error, no code change diff v4.
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

Thanks! Re-applied for next.

Kind regards
Uffe

>
> --
> 1.9.1
>
