Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab3KGMHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:07:52 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51469 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3KGMHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:07:48 -0500
Date: Thu, 7 Nov 2013 12:07:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/7] ARM: ux500: Remove ATAG support for SDI (MMC)
Message-ID: <20131107120742.GP30901@lee--X1>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
 <1383732348-18576-4-git-send-email-lee.jones@linaro.org>
 <CAPDyKFrd+UHYjZw7=8sf=gmATQ8rPubAVrjWYpbhODak+hOhZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFrd+UHYjZw7=8sf=gmATQ8rPubAVrjWYpbhODak+hOhZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -struct mmci_platform_data mop500_sdi0_data = {
> > -       .f_max          = 100000000,
> > -       .capabilities   = MMC_CAP_4_BIT_DATA |
> > -                               MMC_CAP_SD_HIGHSPEED |
> > -                               MMC_CAP_MMC_HIGHSPEED |
> > -                               MMC_CAP_ERASE |
> > -                               MMC_CAP_UHS_SDR12 |
> > -                               MMC_CAP_UHS_SDR25,
> 
> I guess all the above caps is having binders in DT then?

They're not there yet, no. But this stuff is not used anymore in
Mainline hence the patch. I attempted to supply bindings for them, but
they were rejected. Would you like to have a stab at that?

We are suffering with some MMC issues presently on Snowball, this
could well be the cause.

> Dito
> Dito

Likewise.

NB: When you post review comments, try not to forget to <snip> all
unrelated cruft. Scrolling down for pages to find them is not optimal.


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
