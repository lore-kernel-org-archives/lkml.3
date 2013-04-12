Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3DLR0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:26:35 -0400
Received: from mout.gmx.net ([212.227.15.18]:57230 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab3DLR0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:26:33 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18q2LMrR/Qq4PB2MDT91zrrPgJasbK4ye8Myjdqij
	f02JE4eT0F5BA+
Message-ID: <516843C4.5030104@gmx.de>
Date: Fri, 12 Apr 2013 19:26:28 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: build error with latest git kernel for a user mode linux build
References: <51681FAA.7030108@gmx.de> <CAFLxGvzUQ3yi_rRL94MLi2ajC4Rb+GWDw-ijZGajGA=WTgaaGQ@mail.gmail.com>
In-Reply-To: <CAFLxGvzUQ3yi_rRL94MLi2ajC4Rb+GWDw-ijZGajGA=WTgaaGQ@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 05:00 PM, richard -rw- weinberger wrote:
> Did you specify ARCH=um and SUBARCH=?
Only ARCH=um, but the full line give the same :

$ make ARCH=um SUBARCH=x86
scripts/kconfig/conf --silentoldconfig arch/x86/um/Kconfig
  CHK     include/generated/uapi/linux/version.h
make[3]: Nothing to be done for `all'.
make[1]: `arch/x86/um/user-offsets.s' is up to date.
  CHK     include/generated/utsrelease.h
  CC      arch/um/kernel/asm-offsets.s
In file included from /home/tfoerste/devel/linux/arch/um/include/asm/mman.h:5:0,
                 from /home/tfoerste/devel/linux/arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                 from arch/um/kernel/asm-offsets.c:1:
/home/tfoerste/devel/linux/arch/um/include/shared/as-layout.h:9:35: fatal error: generated/asm-offsets.h: No such file or directory
compilation terminated.
make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
