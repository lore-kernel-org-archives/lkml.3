Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3H0DGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:06:52 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:45217 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469Ab3H0DGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:06:50 -0400
Date: Tue, 27 Aug 2013 11:01:20 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Jason Cooper <jason@lakedaemon.net>
CC: "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/3] arm: mvebu: fix resource leak
Message-ID: <20130827110120.0a9fab2a@xhacker>
In-Reply-To: <20130826204523.GD24470@titan.lakedaemon.net>
References: <1377517018-7716-1-git-send-email-jszhang@marvell.com>
	<20130826204523.GD24470@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason,

On Mon, 26 Aug 2013 13:45:23 -0700
Jason Cooper <jason@lakedaemon.net> wrote:

> On Mon, Aug 26, 2013 at 07:36:55PM +0800, Jisheng Zhang wrote:
> > These patches try to fix resource leak by adding missing of_node_put(),
> > iounmap or using devm_ioremap_resource() if available.
> > 
> > v4:
> >   - re-generate since Ezequiel's patches add DT support to the
> > mvebu-mbus driver
> 
> grrr.  I hate to ask this, but can you please rebase patches 1 and 2
> against mvebu/fixes-non-critical?  No need to add back in the mvebu-mbus
> hunk.

patch 1 also fixes one similar trivial issue introduced since 994c8c94b419e
"ARM: mvebu: Remove the harcoded BootROM window allocation" in linux-next tree

patch 2 is updated to fix similar trivial issue introduce since 6839cfa82f99
"bus: mvebu-mbus: Introduce device tree binding"

These two commits aren't included in mvebu/fixes-non-criticial yet. Could you
please give suggestion?

Thanks in advance,
Jisheng
