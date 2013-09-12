Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3ILIZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:25:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38513 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752527Ab3ILIZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:25:19 -0400
Message-ID: <52317A6D.1020902@free-electrons.com>
Date: Thu, 12 Sep 2013 10:25:17 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Miao <realmz6@gmail.com>
CC: Mike Frysinger <vapier@gentoo.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] blackfin: remove unused parameters in Kconfig
References: <1378271336-25134-1-git-send-email-michael.opdenacker@free-electrons.com> <CAMk6uB=3gJvszwyvmcQExgQH_hQvQxEeTj3U+-PLozffNVDnZw@mail.gmail.com> <52306D7C.2020605@free-electrons.com> <CAMk6uBmAXNytUECB7+_eC+OxgCGn91RM+ea9_UkL7f2_PdyssA@mail.gmail.com>
In-Reply-To: <CAMk6uBmAXNytUECB7+_eC+OxgCGn91RM+ea9_UkL7f2_PdyssA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thank you for your replies!

On 09/12/2013 04:41 AM, Steven Miao wrote:
>
>
> On Wed, Sep 11, 2013 at 9:17 PM, Michael Opdenacker
> <michael.opdenacker@free-electrons.com
> <mailto:michael.opdenacker@free-electrons.com>> wrote:
>
>     Hi Steven,
>
>     Thank you for having a look at my patch!
>
>     On 09/11/2013 11:25 AM, Steven Miao wrote:
>     >
>     >
>     >     -config PM_BFIN_WAKE_PB15_POL
>     >     -       int "Wake-up priority"
>     >     -       depends on PM_BFIN_WAKE_PB15
>     >     -       default 0
>     >     -       help
>     >     -         Wake-Up priority 0(low) 1(high)
>     >     -
>     >
>     > this config will be used for wakeup pin PB15 priority on BF60x
>
>     I don't understand how this config parameter is used. It isn't found
>     *anywhere else*  in the kernel source code.
>
>     Is this parameter interpreted outside of the kernel build system? In
>     user space for example?
>
> It will be used in bf609_cpu_pm_enter()
> @arch/blackfin/mach-bf609/pm.c. Have you updated your code to the
> latest revision? There was a typo in old revision.

Where can I find this new code? I just used Linus' tree, and I didn't
find PM_BFIN_WAKE_PB15_POL on
http://git.kernel.org/cgit/linux/kernel/git/lliubbo/blackfin.git/tree/arch/blackfin/mach-bf609/pm.c
either.

My apologies if I lack familiarity with the Blackfin project.

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

