Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbaFPOYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:24:34 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40105 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaFPOYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140616122032.GS14323@lee--X1>
References: <cover.1402037562.git.micky_ching@realsil.com.cn>
	<9021eae37d96aa027d00ae4a7b6cd84dbbd1b6b5.1402037564.git.micky_ching@realsil.com.cn>
	<20140616122032.GS14323@lee--X1>
Date: Mon, 16 Jun 2014 16:24:31 +0200
Message-ID: <CAPDyKFpJ5tToJOk6try-jrRCCzcKtJkszNE5Nuc3Uarhpta1BQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: rtsx: add dma transfer function
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: micky <micky_ching@realsil.com.cn>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <chris@printf.net>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2014 14:20, Lee Jones <lee.jones@linaro.org> wrote:
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> rtsx driver using a single function for transfer data, dma map/unmap are
>> placed in one fix function. We need map/unmap dma in different place(for
>> mmc async driver), so add three function for dma map, dma transfer and
>> dma unmap.
>>
>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>> ---
>>  drivers/mfd/rtsx_pcr.c       |   76 ++++++++++++++++++++++++++----------------
>>  include/linux/mfd/rtsx_pci.h |    6 ++++
>>  2 files changed, 54 insertions(+), 28 deletions(-)
>
> I don't see any glaring issues with this patch.  Does it rely on the
> first patch, or vise versa, or can it just be applied?

The mmc part in patch2 relies on this one, but please go ahead and
apply the mfd patch if you see it good.

I can later provide my ack for the mmc parts, in patch2, when it's a
reviewed properly and thus you can take it through your tree.

Kind regards
Uffe
