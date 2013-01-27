Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3A0NiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:38:18 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33993 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab3A0NiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:38:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130127130905.GD3933@gmail.com>
References: <1359203052-5159-1-git-send-email-ling.ma@alipay.com>
	<20130127130905.GD3933@gmail.com>
Date: Sun, 27 Jan 2013 21:38:13 +0800
Message-ID: <CAOGi=dOdTaZs_KZrNbpFSjzx+evoAA_dL=nGToXBu9bhOB3Rjg@mail.gmail.com>
Subject: Re: [PATCH V2] [x86]: Compiler Option Os is better on latest x86
From: Ling Ma <ling.ma.program@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Ma Ling <ling.ml@alipay.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo

Thanks for your correcting.
Because thinking of  most of 32bit CPU belong to low-end CPUs(smaller
cache), they should more  emphasize  i-cache miss, I chose Os for
them.
I will test it and send out result ASAP.

Regards
Ling

2013/1/27, Ingo Molnar <mingo@kernel.org>:
>
> * ling.ma.program@gmail.com <ling.ma.program@gmail.com> wrote:
>
>> In this version we also append CONFIG_CC_OPTIMIZE_FOR_SIZE for i386.
>
> Were those measurements done on i386 as well? I'd be content
> with keeping the current minimal - and mostly documentary -
> patch that only does this on 64-bit. I just wanted to record the
> current benchmark numbers mostly.
>
> Also see the discussion with Linus - this is by no far an
> unconditionally good option and we'll probably have to wait for
> more GCC action (-Ok or so) before being able to enable size
> optimizations everywhere without unacceptable trade-offs.
>
> Thanks,
>
> 	Ingo
>
