Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaETEcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 00:32:46 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:57425 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaETEcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 00:32:45 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140520042525.GA18956@quad.lixom.net>
References: <1399484042-27432-1-git-send-email-nicolas.ferre@atmel.com>
	<536A6FD7.40402@atmel.com>
	<20140516232635.GB6423@quad.lixom.net>
	<20140517042216.GI29318@piout.net>
	<20140520042525.GA18956@quad.lixom.net>
Date: Mon, 19 May 2014 21:32:44 -0700
Message-ID: <CAOesGMjLqurfyGPuF_nhtg+MY+_NGLs_A318JQ=zBQJ1cM0NYA@mail.gmail.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.16 #1
From: Olof Johansson <olof@lixom.net>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        "arm@kernel.org" <arm@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        LinusW <linus.walleij@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Really adding Mark]

On Mon, May 19, 2014 at 9:25 PM, Olof Johansson <olof@lixom.net> wrote:
> [adding Mark]
>
> On Sat, May 17, 2014 at 06:22:16AM +0200, Alexandre Belloni wrote:
>> On 16/05/2014 at 16:26:35 -0700, Olof Johansson wrote :
>> > On Wed, May 07, 2014 at 07:39:35PM +0200, Nicolas Ferre wrote:
>> > > There is a little conflict with at91-3.16-dt that you already pulled in
>> > > arm-soc: here is the branch that resolves it:
>> > >
>> > > https://github.com/at91linux/linux-at91/commits/at91-3.16-resolved
>> >
>> > That resolution looks odd. Why is one clock under clocks { } and two of them
>> > are at the top level? Shouldn't they all be under the clocks subnode?
>> >
>> > I've merged in now with your resolution, but I think this needs revisiting.
>> >
>>
>> Actually, all the clocks should end up at the root, please refer to:
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/240219.html
>>
>> I feel that was one of the topics we should have discussed at ELC but we
>> ended up talking about DT ABI stability instead...
>
> I'm looking more for consistency than anything else. Having a few in the
> root and the few in a subnode certainly indicates that something's wrong.
>
> It's a good thing that we have several DT maintainers to spread the load,
> but it's also harder to learn the preferences of the maintainer(s) since
> there seems to be variety (some care more about some things than others).
>
> I'm not saying that Mark is wrong, but it's quite possible that someone
> else would disagree or not care enough to point it out. The current
> practice of having clocks under a subnode is prevalent almost everywhere
> in the tree, and this is a mostly new direction set by Mark. It makes
> it very hard to figure out what's the best way to do things when there's
> less consistency.
>
> Clearly, having clocks grouped in a subnode is common practice already, and
> makes some sense from a readability point of view.
>
> Anyway, I'll leave the rest for some DT maintainer to sort out. Please
> follow up with patches to switch over to one or the other model no matter
> what, please.
>
>
> -Olof
