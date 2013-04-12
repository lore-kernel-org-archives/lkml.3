Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3DLPAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:00:05 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54286 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3DLPAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <51681FAA.7030108@gmx.de>
References: <51681FAA.7030108@gmx.de>
Date: Fri, 12 Apr 2013 17:00:02 +0200
Message-ID: <CAFLxGvzUQ3yi_rRL94MLi2ajC4Rb+GWDw-ijZGajGA=WTgaaGQ@mail.gmail.com>
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

On Fri, Apr 12, 2013 at 4:52 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> I get :
> ..
>   CC      kernel/bounds.s
>   GEN     include/generated/bounds.h
>   CC      arch/um/kernel/asm-offsets.s
> In file included from /home/tfoerste/devel/linux/arch/um/include/asm/mman.h:5:0,
>                  from /home/tfoerste/devel/linux/arch/x86/um/shared/sysdep/kernel-offsets.h:5,
>                  from arch/um/kernel/asm-offsets.c:1:
> /home/tfoerste/devel/linux/arch/um/include/shared/as-layout.h:9:35: fatal error: generated/asm-offsets.h: No such file or directory
> compilation terminated.
> make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2

Did you specify ARCH=um and SUBARCH=?

--
Thanks,
//richard
