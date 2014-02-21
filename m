Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbaBUBNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:13:11 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:44956 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaBUBNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:13:07 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1L1CZcD026191, This message is accepted by code: ctloc85258
Message-ID: <5306A8C3.8080703@realsil.com.cn>
Date: Fri, 21 Feb 2014 09:15:47 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <chris@printf.net>, <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v2 0/3] mmc: rtsx: fix bug and support nonblocking request
References: <cover.1392626511.git.micky_ching@realsil.com.cn>
In-Reply-To: <cover.1392626511.git.micky_ching@realsil.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Could you please give me some idea about this patch-set?
I send this patch-set many times, but didn't get any reply.

Best Regards.
micky <micky_ching@realsil.com.cn>

On 02/17/2014 04:45 PM, micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> First we fix the card poweroff bug: the card power is not shutdown when sd/mmc
> card removed, this will make UHS-card failed to running in high speed mode if we
> insert the card again.
>
> We offer a concise tuning searching method, it is much easier to read.
>
> At last we add support for nonblocking request, which will improve card read
> speed at about 10% write speed about 5% normally.
>
> Micky Ching (3):
>    mmc: rtsx: fix card poweroff bug
>    mmc: rtsx: modify phase searching method for tuning
>    mmc: rtsx: add support for pre_req and post_req
>
>   drivers/mfd/rtsx_pcr.c            |  132 ++++++---
>   drivers/mmc/host/rtsx_pci_sdmmc.c |  529 ++++++++++++++++++++++++++-----------
>   include/linux/mfd/rtsx_common.h   |    1 +
>   include/linux/mfd/rtsx_pci.h      |    8 +-
>   4 files changed, 481 insertions(+), 189 deletions(-)
>
> --
> 1.7.9.5
> .
>

