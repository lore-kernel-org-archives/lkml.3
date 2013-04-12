Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3DLRrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:47:17 -0400
Received: from mout.gmx.net ([212.227.15.18]:54653 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3DLRrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:47:16 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+u5qEJHjeuwiXWi7P7ivAcJlBN0Y3a5pp4ETakGo
	ersA+VwS/qSDpG
Message-ID: <516848A0.20402@gmx.de>
Date: Fri, 12 Apr 2013 19:47:12 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: build error with latest git kernel for a user mode linux build
References: <51681FAA.7030108@gmx.de> <CAFLxGvzUQ3yi_rRL94MLi2ajC4Rb+GWDw-ijZGajGA=WTgaaGQ@mail.gmail.com> <516843C4.5030104@gmx.de> <CAFLxGvyp+zZx_TTyz1Zji5BGxd=JUFzhp594sxPLHgZ6kpsBCA@mail.gmail.com>
In-Reply-To: <CAFLxGvyp+zZx_TTyz1Zji5BGxd=JUFzhp594sxPLHgZ6kpsBCA@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 07:41 PM, richard -rw- weinberger wrote:
> You .config build perfectly fine here.
> Have you tried a "make mrproper"?

$ cp .config ../; make mrproper; make mrproper ARCH=um; make mrproper ARCH=um SUBARCH=x86; cp ../.config .; make ARCH=um SUBARCH=x86 oldconfig; make ARCH=um SUBARCH=x86 linux
  CLEAN   .
  CLEAN   .tmp_versions
...
  GEN     include/generated/bounds.h
  CC      arch/um/kernel/asm-offsets.s
In file included from /home/tfoerste/devel/linux/arch/um/include/asm/mman.h:5:0,
                 from /home/tfoerste/devel/linux/arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                 from arch/um/kernel/asm-offsets.c:1:
/home/tfoerste/devel/linux/arch/um/include/shared/as-layout.h:9:35: fatal error: generated/asm-offsets.h: No such file or directory
compilation terminated.
make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2




:-(

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
