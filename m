Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbaCRSXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:23:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:56337 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbaCRSW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:22:58 -0400
Date: Tue, 18 Mar 2014 19:23:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joe Perches <joe@perches.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch 08/12] can: c_can: Makethe code readable
In-Reply-To: <1395164220.2812.59.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1403181922100.18573@ionos.tec.linutronix.de>
References: <20140318171007.528610837@linutronix.de>  <20140318171127.430027680@linutronix.de> <1395164220.2812.59.camel@joe-AO722>
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

> On Tue, 2014-03-18 at 17:19 +0000, Thomas Gleixner wrote:
> 
> [patch]
> 
> Hi
> 
> The multi-while loop
> 
> 	while ((obj = ffs(pend)) && quota > 0) {
> 		...
> 	} while ((obj = ffs(pend)) && quota > 0);
> 
> looks, umm, unusual.

Indeed. That's a leftover of a previous variant. I'll sent out a
corrected one.

Thanks

	tglx

