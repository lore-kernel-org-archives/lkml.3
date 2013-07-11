Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3GKKn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:43:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49250 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab3GKKn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:43:26 -0400
Date: Thu, 11 Jul 2013 12:43:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konrad Vrba <konrad.vrba@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Error 2: No rule to make target kernel/timeconst.pl
Message-ID: <20130711104307.GB28131@pd.tnic>
References: <CAF2Nc0xVKS+aL0CXdDFQHSapvRxM35KZkjeKeigQ7X43+2NVBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF2Nc0xVKS+aL0CXdDFQHSapvRxM35KZkjeKeigQ7X43+2NVBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:28:20PM +0200, Konrad Vrba wrote:
> Hello,
> I have following error while compiling new stable kernel 3.10:
> 
>   CC      kernel/fork.o
>   CC      kernel/exec_domain.o
>   CC      kernel/panic.o
>   CC      kernel/printk.o
>   CC      kernel/cpu.o
>   CC      kernel/exit.o
>   CC      kernel/itimer.o
> make[1]: *** No rule to make target `kernel/timeconst.pl', needed by
> `kernel/timeconst.h'.  Stop.
> make: *** [kernel] Error 2
> 
> Could somebody please advise how to fix this ?

Can you save your config first, cleanup the build dir from kbuild stuff:

make mrproper

and then try building again?

FWIW, 3.10 and later builds just fine here.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
