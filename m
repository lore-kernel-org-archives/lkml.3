Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3IZRKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:10:45 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1663 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751508Ab3IZRKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:10:40 -0400
Message-ID: <52446A89.1080409@nod.at>
Date: Thu, 26 Sep 2013 19:10:33 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/8] um: Do not use SUBARCH
References: <1377073172-3662-1-git-send-email-richard@nod.at> <1377073172-3662-3-git-send-email-richard@nod.at> <CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com> <52441025.9030308@nod.at> <CALkWK0k5neR50h+AWEF5AgnpbgWMitZUnbv_caVzt6HiUA6mXg@mail.gmail.com> <52441407.9010603@nod.at> <CALkWK0=FG4COEjv5+mu1JRiiFQ2k6vop1mhFPmAT4bjtYeK6nA@mail.gmail.com> <52442108.1020304@nod.at> <CALkWK0nm=9n7DiV0MaGKVLMs=vxAiiQUx=OFuOg-DinkdMej5A@mail.gmail.com> <CALkWK0ndMtyQxE0uK4H-Ly6oy+tRn-SFc=_1WoC2QAp2uy0dtw@mail.gmail.com> <CAMuHMdU3LdDhbp_AKjD7b8Wytbqfp29DrPwTdtwQa2hUNdcy3Q@mail.gmail.com> <524443AC.3040409@nod.at> <CALkWK0kcd03t9W4O24wiVBQ8SZQ8ZcrbvQaUkcCm+y5n=d1wPw@mail.gmail.com> <52444CED.40401@nod.at> <CALkWK0=u8CdtmbaOtA5=jxuWsei2ZQhxDwSsnhAR=ZRBNyoH6Q@mail.gmail.com>
In-Reply-To: <CALkWK0=u8CdtmbaOtA5=jxuWsei2ZQhxDwSsnhAR=ZRBNyoH6Q@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 18:06, schrieb Ramkumar Ramachandra:
> Richard Weinberger wrote:
>> And, of course, this makes your patch valid.
>> Can you also please ensure that your new defconfigs are minimal?
> 
> Yeah, it's close to a minimal configuration for the 3.10 kernel
> (latest at the time of patch submission). I was aiming to minimize the
> diff between the current defconfig and the two new defconfigs in
> configs/. The slim diffstat does the talking:
> 
>  arch/um/Kconfig.common                          |   5 -
>  arch/um/Makefile                                |  11 ++
>  arch/um/{defconfig => configs/i386_defconfig}   | 209 +++++++++++++-------
>  arch/um/{defconfig => configs/x86_64_defconfig} | 250 +++++++++++++++---------
>  arch/x86/um/Kconfig                             |   5 +
>  5 files changed, 306 insertions(+), 174 deletions(-)
>  copy arch/um/{defconfig => configs/i386_defconfig} (86%)
>  rename arch/um/{defconfig => configs/x86_64_defconfig} (83%)
> 
> If we find some deficiencies, we can always update it. For now, please
> commit these two patches.

Please resend them with savedefconfig applied.
There is no need to have three commits for that.

Thanks,
//richard

