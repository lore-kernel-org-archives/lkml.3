Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaHPPbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 11:31:22 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47216 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaHPPbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 11:31:20 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140815164150.5085b324@bbrezillon>
References: <1408031156-13573-1-git-send-email-nicolas.ferre@atmel.com>
	<20140815142225.GF5063@titan.lakedaemon.net>
	<20140815164150.5085b324@bbrezillon>
Date: Sat, 16 Aug 2014 08:31:19 -0700
Message-ID: <CAOesGMj_WYK=i_15kAy06zUKRjd9cyoYOMV2iUKuoW4Az_ZqCw@mail.gmail.com>
Subject: Re: [GIT PULL] at91: move of AIC drivers for 3.17: fixes #1
From: Olof Johansson <olof@lixom.net>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        "arm@kernel.org" <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 7:41 AM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:
> Hi Jason,
>
> On Fri, 15 Aug 2014 10:22:25 -0400
> Jason Cooper <jason@lakedaemon.net> wrote:
>
>> Nicolas,
>>
>> On Thu, Aug 14, 2014 at 05:45:56PM +0200, Nicolas Ferre wrote:
>> > Arnd, Olof, Kevin,
>> >
>> > Boris moved both of our AIC drivers to their new home: the drivers/irqchip
>> > directory taking advantage of the genirc framework. For DT-enabled SoCs, we can
>> > use these drivers (aic and aic5) right now: Jason merged them and they are
>> > available in early 3.17 merge window.
>> > So, I build this pull-request for enabling the use of these drivers now as:
>> > - we are very early in 3.17 development
>> > - it allowed us to avoid having to depend on Jason's branch before the opening
>> >   of the merge window
>>
>> Then why did I create a topic branch for you to base on?
>>
>>   git://git.infradead.org/users/jcooper/linux.git irqchip/atmel-aic
>
> Don't blame Nicolas for this, he was in vacation when you created this
> branch (he came back this week), and I should have told you that he
> couldn't use it for this release cycle.
>
>>
>> > - it removes some code from the mach-at91 directory: including the whole
>> >   aic5 driver
>> > - we'd have quite a bit of time to solve issues if we found a bug
>> > - the code is basically moved so it should be error free.
>>
>> Well, this is certainly up to Arnd, Olof and Kevin, but it seems a bit
>> unusual.  You're basically asking to merge changes into the current window
>> that has had _no_ time in -next...  Sounds like a recipe for trouble to
>> me.
>>
>> In the future, please let me know if you're not going to need a topic
>> branch.
>
> This is all my fault, I'm the one who asked Nicolas to get these patches
> merged in 3.17, and, as I said, I should have told you that he was in
> vacation and thus could not use your topic branch for this release
> cycle.
>
> Anyway, I understand your concern about merging stuff that have not been
> tested on linux-next.
>
> Arnd, Olof, Kevin, I'd totally understand if you refuses to takes these
> patches for this release cycle.

Yeah, this isn't 3.17 material at this time -- the merge window is
practically over. We'll be happy to queue it for 3.18 starting next
week.


-Olof
