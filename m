Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3FOW5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 18:57:21 -0400
Received: from muin.pair.com ([209.68.1.55]:50976 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab3FOW5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 18:57:20 -0400
MIME-Version: 1.0
In-Reply-To: <1371061871.18413.44@snotra>
References: <1371041258-15298-1-git-send-email-ogabbay@advaoptical.com>
	<51B88EED.6090709@linutronix.de>
	<1371061871.18413.44@snotra>
Date: Sat, 15 Jun 2013 17:57:18 -0500
Message-ID: <CAOZdJXVjdkMF5rpTVd9tnwCRDqXWtJTUAbywcuzoVehRrgPPsg@mail.gmail.com>
Subject: Re: [PATCH] MDIO: FSL_PQ_MDIO: Fix bug on incorrect offset of tbipa register
From: Timur Tabi <timur@tabi.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oded Gabbay <ogabbay@advaoptical.com>,
        Stef van Os <stef.van.os@prodrive.nl>, Timur Tabi <timur@tabi.org>,
        Dongsheng.Wang@freescale.com, Paul Mackerras <paulus@samba.org>,
        netdev@vger.kernel.org,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        David Miller <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>, B38951@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 1:31 PM, Scott Wood <scottwood@freescale.com> wrote:
>
> I'm not sure it's stable material if this is something that has never
> worked...
>
> The device tree binding will also need to be fixed to note the difference in
> "reg" between "fsl,gianfar-mdio" and "fsl-gianfar-tbi" -- and should give an
> example of the latter.

I don't remember how much I tested it, but I'm pretty sure that at
some of the suspect devices did work for me.  My goal was to maintain
compatibility with existing device trees, and just refactor the code
so that it's easier to read.
