Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbaD2RmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:42:11 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55678 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaD2RmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:42:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18EqCAX7ne0XWL075s18ow3gui2KPszNSg=
X-DKIM: OpenDKIM Filter v2.0.1 titan AB15C56740D
Date: Tue, 29 Apr 2014 13:41:58 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] irqchip: mvebu: fixes for v3.15
Message-ID: <20140429174158.GN28159@titan.lakedaemon.net>
References: <20140429125554.GH28159@titan.lakedaemon.net>
 <alpine.DEB.2.02.1404291925210.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404291925210.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 07:26:01PM +0200, Thomas Gleixner wrote:
> On Tue, 29 Apr 2014, Jason Cooper wrote:
> > Thomas Petazzoni (2):
> >       irqchip: armada-370-xp: fix invalid cast of signed value into unsigned variable
> >       irqchip: armada-370-xp: implement the ->check_device() msi_chip operation
> 
> Please make sure next time, that the sentence starts with an upper
> case letter.

gah!  sorry.  I even checked that they matched other log entries, but
only the 'irqchip: armada-370-xp: ' part but missed the capitalization.
Will do next time.  Thanks for pulling despite the oversight.

> Pulled and pushed inot tip/irq/urgent

thx,

Jason.
