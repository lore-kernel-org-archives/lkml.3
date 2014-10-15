Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaJOPbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:31:06 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27844 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbaJOPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:31:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19XE+JAuv9ars6E2PGGpL3r6v9vj0jmJHg=
X-DKIM: OpenDKIM Filter v2.0.1 titan DEB985FF72B
Date: Wed, 15 Oct 2014 11:30:49 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Benoit Masson <benoitm@perenite.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
Message-ID: <20141015153049.GE17447@titan.lakedaemon.net>
References: <20141003141102.GJ3895@titan.lakedaemon.net>
 <542EBB93.108@gmail.com>
 <A9781A2E-F3CA-4E8A-833C-D167B456D9F7@perenite.com>
 <542EC3A3.1060605@gmail.com>
 <1ACB5318-863E-40D8-8B27-41F1C0D0A4B8@perenite.com>
 <5432BFB1.2060300@gmail.com>
 <CE7A9795-C2AF-451A-8018-3A0B8788BF60@perenite.com>
 <20141015144259.GB17447@titan.lakedaemon.net>
 <543E898D.10606@gmail.com>
 <20141015145539.GB18413@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015145539.GB18413@lunn.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 04:55:39PM +0200, Andrew Lunn wrote:
> > >Do you have a link to an email thread or the patch Subject line?  I can
> > >confirm it's missing from mvebu/fixes...
> > 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275487.html
> > 
> > But you and Andrew should check what Arnd suggested. IIRC, there
> > was also an appropriate follow-up patch discussion started by
> > Andrew.
> 
> There was a lot of back and forth with Arnd. In the end, he gave up
> arguing because too many voices did not like his solution. So my
> original version stands.

Yes, this appears to have been a mistake on my part.  In the
conversation regarding patch #2 of V2, you said you were going to work
on implementing something and would report back.  I applied that to the
whole series instead of just to the second patch.  At any rate, applied
to mvebu/fixes now.

> However, the patch at the end of 
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275528.html
> 
> is useful, and it would be nice if it could be merged as well.

I'll take a look.

thx,

Jason.
