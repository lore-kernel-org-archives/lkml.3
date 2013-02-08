Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946807Ab3BHSkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:40:16 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:43144 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098Ab3BHSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:40:13 -0500
Date: Fri, 8 Feb 2013 13:40:10 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ARM: sched: correct update_sched_clock()
In-Reply-To: <20130208150317.GT17833@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1302081331000.6300@xanadu.home>
References: <1360128076-8555-1-git-send-email-iamjoonsoo.kim@lge.com> <CACRpkdbwoExxKbbvBKpt_Wh9KsgCXQW566N-0BaeL3oGY8pvLg@mail.gmail.com> <20130206163355.GH17833@n2100.arm.linux.org.uk> <20130208065125.GA20440@lge.com>
 <20130208150317.GT17833@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013, Russell King - ARM Linux wrote:

> On Fri, Feb 08, 2013 at 03:51:25PM +0900, Joonsoo Kim wrote:
> > I try to put it into patch tracker, but I fail to put it.
> > I use following command.
> > 
> > git send-email --to patches@arm.linux.org.uk 0001-ARM-sched-correct~~~~~
> > 
> > Am I wrong?
> > Could you teach me how to put patch into your patch tracker?
> > I already read "help" on your website, but I can't find any stuff for
> > "git send-email".
> 
> I've never used git to send email, so I'm afraid I can't help with that.
> Maybe someone with more experience with sending email from git can
> comment?

The commit text for the patch needs to contain the following 2 lines at 
the very bottom in order to match the patch system's expectations:

PATCH FOLLOWS
KernelVersion: v3.8

The KernelVersion value needs to be adjusted of course.

Note: I never tried it myself but it ought to work.

Nicolas
