Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbaCRUne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:43:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:57003 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbaCRUnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:43:32 -0400
Date: Tue, 18 Mar 2014 21:43:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joe Perches <joe@perches.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: can: c_can: Reduce interrupt load by 50%
In-Reply-To: <1395174900.2812.87.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1403182142390.18573@ionos.tec.linutronix.de>
References: <20140318171007.528610837@linutronix.de>  <20140318171127.923041002@linutronix.de>  <alpine.DEB.2.02.1403182114470.18573@ionos.tec.linutronix.de> <1395174900.2812.87.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Joe Perches wrote:

> On Tue, 2014-03-18 at 21:18 +0100, Thomas Gleixner wrote:
> > The driver handles pointlessly TWO interrupts per packet. The reason
> > is that it enables the status interrupt which fires for each rx and tx
> > packet and it enables the per message object interrupts as well.
> 
> Are the message object interrupts a possible workaround
> for any defective hardware?

Nope. I already explained what they are for, but you snipped that
part.
 
> > performance improment
> 
> Now that the code's not being written by amateurs?

You found a typo. Great, you can keep it!
