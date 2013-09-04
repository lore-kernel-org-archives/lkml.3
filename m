Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3IDETZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:19:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64950 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab3IDETY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:19:24 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5226B4C7.9050509@roeck-us.net>
Date: Tue, 03 Sep 2013 21:19:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Liqin Chen <liqin299@gmail.com>
CC: Lennox Wu <lennox.wu@gmail.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Remove support for score architecture
References: <1377914435-24206-1-git-send-email-linux@roeck-us.net> <CAF0htA6gW3h82p2sBBpFEi4s0MkQ-NUn79VXWLieZmYNuUPA6w@mail.gmail.com> <5224247E.3050600@roeck-us.net> <CAF0htA6sYZOvLt_JczGpfjEJZep6cAquJV9tZ2FwYC+C6ngzXQ@mail.gmail.com> <5224CB12.50206@roeck-us.net> <CAFP0e=Gio_o6QFboVGe3aBCM0zFrsrJuNBthj63RXr+=SDPp7Q@mail.gmail.com>
In-Reply-To: <CAFP0e=Gio_o6QFboVGe3aBCM0zFrsrJuNBthj63RXr+=SDPp7Q@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 09:54 PM, Liqin Chen wrote:
>
> 2013/9/3 Guenter Roeck <linux@roeck-us.net <mailto:linux@roeck-us.net>>
>
>     On 09/02/2013 08:18 AM, Lennox Wu wrote:
>
>         Before we start the development of the S+core, Sunplus had licensed
>         ARM and MIPS. We develop S+core for other reason such as the price.
>         Some products on the web of Sunplus adopt S+core , for example
>         the SPV7050.(http://w3.sunplus.__com/products/spv7050.asp <http://w3.sunplus.com/products/spv7050.asp>) These products
>         could still be bought from the market. Some high-end products adopt
>         ARM or MIPS. So, there is no conflict for a company adopts multiple
>         architectures.
>
>         As I said, we recognize that we rarely update because of the limited
>         applications and rare requests from customers. Maybe we don’t
>         understand the culture enough; we think that it is unnecessary if we
>         have no new bugs or new functions, the thought seems wrong. We can
>         commit some patches in the near future.
>
>
>     The point is not about submitting patches, it is about maintaining the code.
>     Even if you don't add functionality, one would expect that you ensure that
>     new kernel versions compile and run on your hardware.
>
>     Since January 2012, 68 patches have been applied to arch/score, pretty
>     much all of them addressing kernel API changes or global cleanup.
>     Only two of them got an Ack by one of the score maintainers.
>     This strongly suggests that you don't keep track of what is going on,
>     and at the very least raises the question if you do compile and test
>     new kernel versions on a regular basis. Even if you do, no one knows
>     about it, because ....
>
>     As part of this process, I would expect the architecture maintainer to
>     accept incoming patches, test the same, and send pull requests to Linus.
>     The last time this happened was early 2011; since then all score patches
>     were sent to Linus through Andrew and a few other maintainers.
>     Actually, I don't see many signoffs from a score maintainer at all,
>     even from the very beginning.
>
>     As pointed out, the MAINTAINERS entry for score points to a
>     non-existing domain, as does the e-mail address of one of the
>     maintainers.
>
>     I would not call that "maintained".
>
>
>
> Hi Al Viro, Guenter Roeck, Arnd Bergmann and all,
>
> I still supports the S+core team to maintain their codes, although I
> left sunplus co. in 2011.
>
> I keep reading the mailing list and testing these patches for S+core,
> I think the main problems are they have not echoed to any comments on
> score's questions. Maybe they think the current situation is good
> enough for their customers, and they don’t understand the rules of the
> group enough. Even so, they should update score code to the latest
> status, include my mail address.
>
> We will discuss how to maintain the code of S+core. However, if all of
> you and Linus also think the S+core should be removed from the
> upstream, we will do it.
>

Trying to build gcc for score says:

*** Configuration score-unknown-elf is obsolete.
*** Specify --enable-obsolete to build it anyway.
*** Support will be REMOVED in the next major release of GCC,
*** unless a maintainer comes forward.

That does not sound very encouraging.

Guenter

