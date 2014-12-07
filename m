Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaLGXLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 18:11:24 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49836 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaLGXLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 18:11:22 -0500
MIME-Version: 1.0
In-Reply-To: <5484D240.30506@nod.at>
References: <1417990021-18696-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <5484D240.30506@nod.at>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 8 Dec 2014 00:11:00 +0100
Message-ID: <CAFo99gYvkzCTi6FZXfPOCqafNYn6y4H4hx62KqJjex60KV70_A@mail.gmail.com>
Subject: Re: [PATCH] arch: powerpc: kernel: signal_32.c: Remove unused function
To: Richard Weinberger <richard@nod.at>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Ok, sorry :-(

But I really do not. I've hacked together a script that will scan all
the code for the function, and test builds with some different config
options turned on.


Kind regards
Rickard Strandqvist


2014-12-07 23:18 GMT+01:00 Richard Weinberger <richard@nod.at>:
> Am 07.12.2014 um 23:07 schrieb Rickard Strandqvist:
>> Remove the function sys_debug_setcontext() that is not used anywhere.
>>
>> This was partially found by using a static code analysis program called cppcheck.
>
> Please don't blindly trust code analysis tools.
> The function you're removing *is* in use.
>
>   LD      init/built-in.o
> arch/powerpc/kernel/built-in.o: In function `sys_call_table':
> (.rodata+0x744): undefined reference to `sys_debug_setcontext'
> make: *** [vmlinux] Error 1
>
> Thanks,
> //richard
