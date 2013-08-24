Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3HXD5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 23:57:48 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:47520 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693Ab3HXD5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 23:57:47 -0400
Date: Sat, 24 Aug 2013 11:55:45 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] pinctrl: mvebu: add missing iounmap
Message-ID: <20130824115545.6b4abecb@xhacker>
In-Reply-To: <20130823201925.GA2417@localhost>
References: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
	<1377175611-4241-5-git-send-email-jszhang@marvell.com>
	<20130822132207.GA27167@localhost>
	<CACRpkdZKGUGnnwEt0W6hQKhA0NnHWtkeBuaz-chDS=9rZD9y7A@mail.gmail.com>
	<20130823201925.GA2417@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus and Ezequiel,

On Fri, 23 Aug 2013 13:19:26 -0700
Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:

> On Fri, Aug 23, 2013 at 08:06:02PM +0200, Linus Walleij wrote:
> > On Thu, Aug 22, 2013 at 3:22 PM, Ezequiel Garcia
> > <ezequiel.garcia@free-electrons.com> wrote:
> > > On Thu, Aug 22, 2013 at 08:46:51PM +0800, Jisheng Zhang wrote:
> > >> Add missing iounmap to prove error path and remove path
> > >>
> > >> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> > >> ---
> > >>  drivers/pinctrl/mvebu/pinctrl-mvebu.c | 24 +++++++++++++++++-------
> > >>  1 file changed, 17 insertions(+), 7 deletions(-)
> > >
> > > How about using devm_ioremap_resource() instead?
> > 
> > Yeah that's the right solution, Jisheng can you fix this?
> > 
> 
> I think he already did that, there's a v2 floating around
> with such change. I plan to give it a test, maybe tomorrow,
> if I can find some spare time.
> 

Yep. Here is the V2

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-August/194072.html

Thank you for your help,
Jisheng

