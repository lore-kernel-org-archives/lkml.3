Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3FKP2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:28:02 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48182 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751343Ab3FKP17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:27:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19T3fdKioDgvBt/j+2oklIZiNaDkvSf7KE=
Date: Tue, 11 Jun 2013 11:27:23 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Marvell Orion SoC irqchip and clocksource
Message-ID: <20130611152723.GR23859@titan.lakedaemon.net>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130611123521.GA3996@localhost>
 <51B71AF6.1090108@gmail.com>
 <alpine.LFD.2.02.1306111512480.22970@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1306111512480.22970@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 03:13:16PM +0200, Thomas Gleixner wrote:
> On Tue, 11 Jun 2013, Sebastian Hesselbarth wrote:
> > On 06/11/13 14:35, Ezequiel Garcia wrote:
> > With Thomas Gleixner's Review now only somebody has to take the irqchip
> > patch then all three drivers are queued for next release.
> 
> I can take it through tip if nobody else wants it :)

Great!  I'll queue up 3-6 for the next merge window.  That way we avoid
all branch dependencies. :)

thx,

Jason.
