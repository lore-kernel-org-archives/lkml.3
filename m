Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaGBMPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:15:38 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36367 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGBMPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:15:37 -0400
Date: Wed, 2 Jul 2014 13:15:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <chris@printf.net>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 1/2] mfd: rtsx: add dma transfer function
Message-ID: <20140702121530.GF16724@lee--X1>
References: <cover.1402037562.git.micky_ching@realsil.com.cn>
 <9021eae37d96aa027d00ae4a7b6cd84dbbd1b6b5.1402037564.git.micky_ching@realsil.com.cn>
 <20140616122032.GS14323@lee--X1>
 <CAPDyKFpJ5tToJOk6try-jrRCCzcKtJkszNE5Nuc3Uarhpta1BQ@mail.gmail.com>
 <20140618080056.GM21030@lee--X1>
 <53B3CD60.80302@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53B3CD60.80302@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2014, micky wrote:

> On 06/18/2014 04:00 PM, Lee Jones wrote:
> >On Mon, 16 Jun 2014, Ulf Hansson wrote:
> >
> >>On 16 June 2014 14:20, Lee Jones <lee.jones@linaro.org> wrote:
> >>>>From: Micky Ching <micky_ching@realsil.com.cn>
> >>>>
> >>>>rtsx driver using a single function for transfer data, dma map/unmap are
> >>>>placed in one fix function. We need map/unmap dma in different place(for
> >>>>mmc async driver), so add three function for dma map, dma transfer and
> >>>>dma unmap.
> >>>>
> >>>>Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> >>>>---
> >>>>  drivers/mfd/rtsx_pcr.c       |   76 ++++++++++++++++++++++++++----------------
> >>>>  include/linux/mfd/rtsx_pci.h |    6 ++++
> >>>>  2 files changed, 54 insertions(+), 28 deletions(-)
> >>>I don't see any glaring issues with this patch.  Does it rely on the
> >>>first patch, or vise versa, or can it just be applied?
> >>The mmc part in patch2 relies on this one, but please go ahead and
> >>apply the mfd patch if you see it good.
> >>
> >>I can later provide my ack for the mmc parts, in patch2, when it's a
> >>reviewed properly and thus you can take it through your tree.
> >There's no rush.  Once you're happy with the MMC patch, Micky can
> >submit them both again with my Ack on the MFD part and I'll take them
> >as a set.
> >
> Hi Lee,
> 
> Can you pick this patch directly?  need resend it now?

No need to resend, I'll get round to applying it from here.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
