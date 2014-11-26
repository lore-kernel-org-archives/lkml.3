Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaKZGgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:36:15 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27919 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338AbaKZGgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:36:13 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ldhu0zTxhCZSWtQwozs4RNwVNKo+ChwI=
X-DKIM: OpenDKIM Filter v2.0.1 titan A4195624215
Date: Wed, 26 Nov 2014 01:36:07 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Cernekee <cernekee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: bcm7120-l2: fix error handling of
 irq_of_parse_and_map
Message-ID: <20141126063607.GY22670@titan.lakedaemon.net>
References: <20141114221614.GA37395@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114221614.GA37395@dtor-ws>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 02:16:14PM -0800, Dmitry Torokhov wrote:
> Return value of irq_of_parse_and_map() is unsigned int, with 0
> indicating failure, so testing for negative result never works.
> 
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
> 
> Not tested, found by casual code inspection.
> 
>  drivers/irqchip/irq-bcm7120-l2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Both applied to irqchip/urgent with Florian's Ack and Kevin's Tested-by.

thx,

Jason.
