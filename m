Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaLDNwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:52:34 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:51188 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaLDNwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:52:32 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1417484016.git.micky_ching@realsil.com.cn>
References: <cover.1417484016.git.micky_ching@realsil.com.cn>
Date: Thu, 4 Dec 2014 14:52:32 +0100
Message-ID: <CAPDyKFr-Ov0UEGFJOa+kewzKYf+aAFQkuSuxJiyRNx7ETS9eEg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mmc: rtsx: add support for sdio card
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

On 2 December 2014 at 02:36,  <micky_ching@realsil.com.cn> wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> v3:
>   rtsx_pci_sdmmc.c:
>     - dump_reg_range
>       - remove unused pointer check
>       - fix start index

I can't find v3.

Kind regards
Uffe

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
> Micky Ching (2):
>   mfd: rtsx: add func to split u32 into register
>   mmc: rtsx: add support for sdio card
>
>  drivers/mmc/host/rtsx_pci_sdmmc.c | 522 +++++++++++++++++++++-----------------
>  include/linux/mfd/rtsx_pci.h      |   9 +
>  2 files changed, 296 insertions(+), 235 deletions(-)
>
> --
> 1.9.1
>
