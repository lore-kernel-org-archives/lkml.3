Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3LWFrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:47:31 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:40897 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3LWFra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:47:30 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBN5hmZ2003221, This message is accepted by code: ctloc85258
Message-ID: <52B7CE20.5000507@realsil.com.cn>
Date: Mon, 23 Dec 2013 13:46:08 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v3 0/2] fix sd power bug and modify phase-searching method
References: <cover.1385947736.git.micky_ching@realsil.com.cn>
In-Reply-To: <cover.1385947736.git.micky_ching@realsil.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there anything wrong with this patch? It seems a long time, but I 
didn't got any reply.

On 12/03/2013 10:34 AM, micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> If the driver removed while sd card still in the slot, the card power
> will not power down correctly, if we insert the driver module again,
> UHS card will not switch to UHS mode. This bug is fix in this patch.
>
> We use another phase search method for tuning, which looks more
> simple, and reduce some source code.
>
> Micky Ching (2):
>    mmc: rtsx: fix card poweroff bug
>    mmc: rtsx: modify phase searching method for tuning
>
>   drivers/mmc/host/rtsx_pci_sdmmc.c |  115 +++++++++++--------------------------
>   include/linux/mfd/rtsx_pci.h      |    2 +-
>   2 files changed, 35 insertions(+), 82 deletions(-)
>
> --
> 1.7.9.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>

