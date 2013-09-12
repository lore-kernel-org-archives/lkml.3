Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3ILLMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:12:42 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12821 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682Ab3ILLMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:12:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsGANagMVJ20h7s/2dsb2JhbABbgwe+bIJ0gRoXdIIlAQEFOB4iARAIAxgJFg8JAwIBAgEnHgYNAQcCh328J49rB4QdA4k1oDaDMiw
Message-ID: <5231A1A3.3060804@internode.on.net>
Date: Thu, 12 Sep 2013 20:42:35 +0930
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130820 Icedove/17.0.8
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, andr345@gmail.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
References: <20130719232459.GA18039@gondor.apana.org.au> <1374277033.22432.384.camel@schen9-DESK> <1374283864.22432.393.camel@schen9-DESK> <20130720053021.GA19689@gondor.apana.org.au> <201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp> <201309112043.HBD04609.FOtLSOFVQHFOJM@I-love.SAKURA.ne.jp> <20130912042622.GA15181@gondor.apana.org.au>
In-Reply-To: <20130912042622.GA15181@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Herbert Xu wrote, on 12/09/13 13:56:
> On Wed, Sep 11, 2013 at 08:43:19PM +0900, Tetsuo Handa wrote:
>> Hello.
>>
>> I'm again having the boot failure problem due to commit 68411521 'Reinstate
>> "crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform
>> framework"' in linux.git .
>
> OK, can you please try this patch on top of the current tree?
>
> This way at least you'll have a working system until your initramfs
> tool is fixed to do the right thing.
>
> diff --git a/crypto/Makefile b/crypto/Makefile
[deleted]
> Thanks,
>

Thanks for the help, I can confirm that with Herbet's patch applied I am 
now booting fine on Debian using

CONFIG_SCSI=Y
CONFIG_ATA=M
CONFIG_BLK_DEV_SD=M

on both an x86-64 (AMD Athlon64) machine with SATA boot disk and an i386 
(Pentium 4) machine with PATA boot disk.

Regards,

Arthur.
