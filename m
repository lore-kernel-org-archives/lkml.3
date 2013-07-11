Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3GKKtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:49:19 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54310 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab3GKKtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:49:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130711104307.GB28131@pd.tnic>
References: <CAF2Nc0xVKS+aL0CXdDFQHSapvRxM35KZkjeKeigQ7X43+2NVBA@mail.gmail.com>
	<20130711104307.GB28131@pd.tnic>
Date: Thu, 11 Jul 2013 12:49:17 +0200
Message-ID: <CAF2Nc0xjxtWkpmurODWKNMCC9D+4Xf6gMnQAqAiec6zn4V0z3w@mail.gmail.com>
Subject: Re: Error 2: No rule to make target kernel/timeconst.pl
From: Konrad Vrba <konrad.vrba@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/13, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jul 11, 2013 at 12:28:20PM +0200, Konrad Vrba wrote:
>> Hello,
>> I have following error while compiling new stable kernel 3.10:
>>
>>   CC      kernel/fork.o
>>   CC      kernel/exec_domain.o
>>   CC      kernel/panic.o
>>   CC      kernel/printk.o
>>   CC      kernel/cpu.o
>>   CC      kernel/exit.o
>>   CC      kernel/itimer.o
>> make[1]: *** No rule to make target `kernel/timeconst.pl', needed by
>> `kernel/timeconst.h'.  Stop.
>> make: *** [kernel] Error 2
>>
>> Could somebody please advise how to fix this ?
>
> Can you save your config first, cleanup the build dir from kbuild stuff:
>
> make mrproper
>
> and then try building again?
>
> FWIW, 3.10 and later builds just fine here.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
>

cleaning up with 'make mrproper'  does not help.
I still get the same error
