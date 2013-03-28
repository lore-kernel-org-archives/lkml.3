Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3C1EhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:37:24 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:62870 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3C1EhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:37:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130327214347.f2a573510416b86223c58be1@canb.auug.org.au>
References: <1364210495-7938-1-git-send-email-prabhakar.csengg@gmail.com> <20130327214347.f2a573510416b86223c58be1@canb.auug.org.au>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 28 Mar 2013 10:07:00 +0530
Message-ID: <CA+V-a8urWyzaU-nKh7sumr3tbmswixzWsumVHMpis6=fgD3Z+g@mail.gmail.com>
Subject: Re: [PATCH] ARM: davinci: use is IS_ENABLED macro
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Wed, Mar 27, 2013 at 4:13 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi,
>
> On Mon, 25 Mar 2013 16:51:35 +0530 Prabhakar lad <prabhakar.csengg@gmail.com> wrote:
>>
>> --- a/arch/arm/mach-davinci/board-da830-evm.c
>> +++ b/arch/arm/mach-davinci/board-da830-evm.c
>> @@ -298,7 +298,7 @@ static const short da830_evm_emif25_pins[] = {
>>       -1
>>  };
>>
>> -#if defined(CONFIG_MMC_DAVINCI) || defined(CONFIG_MMC_DAVINCI_MODULE)
>> +#if IS_ENABLED(CONFIG_MMC_DAVINCI)
>>  #define HAS_MMC      1
>>  #else
>>  #define HAS_MMC      0
>
> Why not
>
> #define HAS_MMC         IS_ENABLED(CONFIG_MMC_DAVINCI)
>
> and similarly in the rest?
>
Stephen's suggestion looks good to me, if you haven’t queued it i'll post a v2,
or if you have already queued it I'll create a patch on top of the
same patch fixing it.
lemme know how would you want it.

Regards,
--Prabhakar

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
