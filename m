Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3HZKEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:04:05 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:41670 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675Ab3HZKED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:04:03 -0400
Date: Mon, 26 Aug 2013 17:59:25 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] pinctrl: mvebu: Convert to use
 devm_ioremap_resource
Message-ID: <20130826175925.5774a277@xhacker>
In-Reply-To: <20130824150624.GA12907@localhost>
References: <1377225242-5854-1-git-send-email-jszhang@marvell.com>
	<1377225242-5854-5-git-send-email-jszhang@marvell.com>
	<20130824150624.GA12907@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ezequiel,

On Sat, 24 Aug 2013 08:06:25 -0700
Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:

> Hi Jisheng,
> 
> On Fri, Aug 23, 2013 at 10:34:02AM +0800, Jisheng Zhang wrote:
> > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> > ---
> >  drivers/pinctrl/mvebu/pinctrl-mvebu.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> 
> Mmm.. I would prefer to see a better commit log for this patch.
> In particular, the current code is buggy (for there's a leak) and
> this patch fixes it.
> Care to write something meaningful and re-send? (except the patch

Done. Could you please review again?

> Mike already took, I guess).
> 
> With that changes you can add:
> 
> Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>T
Thank you for your help
> 
> for the whole series.

Best Regards,
Jisheng


