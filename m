Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3HEQKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:10:23 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:61646 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3HEQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:10:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130805105620.GO2515@console-pimps.org>
References: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
	<1375462582-16423-2-git-send-email-leif.lindholm@linaro.org>
	<20130805105620.GO2515@console-pimps.org>
Date: Mon, 5 Aug 2013 09:10:19 -0700
Message-ID: <CA+8MBbJwU-Wc7eHG9bqqWenkSzsv9pV5DXaU_mLkdhja1vF34g@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ia64: add early_memremap() alias for early_ioremap()
From: Tony Luck <tony.luck@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 3:56 AM, Matt Fleming <matt@console-pimps.org> wrote:
>> @@ -424,6 +424,7 @@ extern void __iomem * ioremap(unsigned long offset, unsigned long size);
>>  extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
>>  extern void iounmap (volatile void __iomem *addr);
>>  extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
>> +#define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
>>  extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
>>  static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
>
> Tony, can I get your Acked-by for this?

Acked-by: Tony Luck <tony.luck@intel.com>

[Cut & paste this ack to other parts of the series that touch ia64]

-Tony
