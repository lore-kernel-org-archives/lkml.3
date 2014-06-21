Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaFUXaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 19:30:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53528 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753566AbaFUXaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 19:30:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19xUu3l5QmleXpqg9F+B5jJYFNfMkIRWn0=
X-DKIM: OpenDKIM Filter v2.0.1 titan EA8BF596529
Date: Sat, 21 Jun 2014 19:30:10 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com,
        stable@vger.kernel.org
Subject: Re: [patch 01/13] irqchip: spear_shirq: Fix interrupt offset
Message-ID: <20140621233010.GI21711@titan.lakedaemon.net>
References: <20140619212606.431750473@linutronix.de>
 <20140619212712.872379208@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619212712.872379208@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:34:37PM -0000, Thomas Gleixner wrote:
> The ras3 block on spear320 claims to have 3 interrupts. In fact it has
> one and 6 reserved interrupts. Account the 6 reserved to this block so
> it has 7 interrupts total. That matches the datasheet and the device
> tree entries.
> 
> Broken since commit 80515a5a(ARM: SPEAr3xx: shirq: simplify and move
> the shared irq multiplexor to DT). Testing is overrated....
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/irqchip/spear-shirq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to irqchip/urgent noting that it's for stable v3.8+ with
Viresh's Ack.

thx,

Jason.
