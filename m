Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3DLRlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:41:18 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40937 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3DLRlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <516843C4.5030104@gmx.de>
References: <51681FAA.7030108@gmx.de>
	<CAFLxGvzUQ3yi_rRL94MLi2ajC4Rb+GWDw-ijZGajGA=WTgaaGQ@mail.gmail.com>
	<516843C4.5030104@gmx.de>
Date: Fri, 12 Apr 2013 19:41:15 +0200
Message-ID: <CAFLxGvyp+zZx_TTyz1Zji5BGxd=JUFzhp594sxPLHgZ6kpsBCA@mail.gmail.com>
Subject: Re: build error with latest git kernel for a user mode linux build
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 7:26 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> On 04/12/2013 05:00 PM, richard -rw- weinberger wrote:
>> Did you specify ARCH=um and SUBARCH=?
> Only ARCH=um, but the full line give the same :
>
> $ make ARCH=um SUBARCH=x86
> scripts/kconfig/conf --silentoldconfig arch/x86/um/Kconfig
>   CHK     include/generated/uapi/linux/version.h
> make[3]: Nothing to be done for `all'.
> make[1]: `arch/x86/um/user-offsets.s' is up to date.
>   CHK     include/generated/utsrelease.h
>   CC      arch/um/kernel/asm-offsets.s
> In file included from /home/tfoerste/devel/linux/arch/um/include/asm/mman.h:5:0,
>                  from /home/tfoerste/devel/linux/arch/x86/um/shared/sysdep/kernel-offsets.h:5,
>                  from arch/um/kernel/asm-offsets.c:1:
> /home/tfoerste/devel/linux/arch/um/include/shared/as-layout.h:9:35: fatal error: generated/asm-offsets.h: No such file or directory
> compilation terminated.
> make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2

You .config build perfectly fine here.
Have you tried a "make mrproper"?

Thanks,
//richard
