Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3HWUTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:19:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52699 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756109Ab3HWUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:19:32 -0400
Date: Fri, 23 Aug 2013 17:19:26 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jisheng Zhang <jszhang@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] pinctrl: mvebu: add missing iounmap
Message-ID: <20130823201925.GA2417@localhost>
References: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
 <1377175611-4241-5-git-send-email-jszhang@marvell.com>
 <20130822132207.GA27167@localhost>
 <CACRpkdZKGUGnnwEt0W6hQKhA0NnHWtkeBuaz-chDS=9rZD9y7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZKGUGnnwEt0W6hQKhA0NnHWtkeBuaz-chDS=9rZD9y7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 08:06:02PM +0200, Linus Walleij wrote:
> On Thu, Aug 22, 2013 at 3:22 PM, Ezequiel Garcia
> <ezequiel.garcia@free-electrons.com> wrote:
> > On Thu, Aug 22, 2013 at 08:46:51PM +0800, Jisheng Zhang wrote:
> >> Add missing iounmap to prove error path and remove path
> >>
> >> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> >> ---
> >>  drivers/pinctrl/mvebu/pinctrl-mvebu.c | 24 +++++++++++++++++-------
> >>  1 file changed, 17 insertions(+), 7 deletions(-)
> >
> > How about using devm_ioremap_resource() instead?
> 
> Yeah that's the right solution, Jisheng can you fix this?
> 

I think he already did that, there's a v2 floating around
with such change. I plan to give it a test, maybe tomorrow,
if I can find some spare time.

Regards,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
