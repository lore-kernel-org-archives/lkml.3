Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaKJRY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:24:56 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36629 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaKJRYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:24:52 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/eJP4l+eZD0AQ8PXhrFEYa
Date: Mon, 10 Nov 2014 09:24:05 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com
Subject: Re: [PATCH 00/13 v10] omap 8250 based UART + DMA
Message-ID: <20141110172404.GO31454@atomide.com>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
 <20141106031421.GA22185@kroah.com>
 <545B4D09.6070102@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B4D09.6070102@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [141106 02:29]:
> On 11/06/2014 04:14 AM, Greg KH wrote:
> > I've now applied the patches here that I could, if I have missed any,
> > please let me know and resend.
> 
> Thank you Greg. I pulled your tty-testing and it seems to work on
> am335x-evm/dra7-evm.
> 
> Tony, if you could please take the two .dts files then the series would
> be complete (that one dma patch was applied by Vinod during the merge
> window).

OK applying into omap-for-v3.19/dt thanks.

Tony
