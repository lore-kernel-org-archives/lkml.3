Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3FJRKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:10:00 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32252 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887Ab3FJRJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:09:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18UtV85Q8ukko7LR8JjO8dBwN/kMhRbFxM=
Date: Mon, 10 Jun 2013 13:09:21 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] clocksource: add Marvell Orion SoC timer
Message-ID: <20130610170921.GM23859@titan.lakedaemon.net>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1370856955-10514-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <51B5F8FE.5090508@linaro.org>
 <51B5FF51.6090708@gmail.com>
 <51B60267.9000600@linaro.org>
 <51B6031B.4030204@gmail.com>
 <51B6079E.5090602@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B6079E.5090602@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 07:06:38PM +0200, Daniel Lezcano wrote:
> On 06/10/2013 06:47 PM, Sebastian Hesselbarth wrote:
> > On 06/10/13 18:44, Daniel Lezcano wrote:
> >> On 06/10/2013 06:31 PM, Sebastian Hesselbarth wrote:
> >>> On 06/10/13 18:04, Daniel Lezcano wrote:
> >>>> On 06/10/2013 11:35 AM, Sebastian Hesselbarth wrote:
> >>>>> This patch add a DT enabled driver for timers found on Marvell Orion
> >>>>> SoCs
> >>>>> (Kirkwood, Dove, Orion5x, and Discovery Innovation). It installs a
> >>>>> free-
> >>>>> running clocksource on timer0 and a clockevent source on timer1.
> >>>>> Corresponding device tree documentation is also added.
> >>>>>
> >>>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >>>>
> >>>> It looks good for me.
> >>>>
> >>>> Sebastian,
> >>>>
> >>>> shall I take it through my tree (it will go to Thomas's tree) ?
> >>>
> >>> Daniel,
> >>>
> >>> I checked MAINTAINERS and thought clocksource, i.e. patch 2/6, would go
> >>> through Thomas' or John's tree? If you want to take it, I am fine with
> >>> it but guess I am not the one to choose here ;)
> >>
> >> Actually, I am giving a hand to John and Thomas. I take the patches for
> >> clockevents (and also for clocksource if both are mixed and John did not
> >> pick it yet) and Thomas pulls from my tree [1].
> >>
> >> If there is no dependency with any other patches of your patchset, which
> >> seems to be the case, I will queue it for 3.11.
> > 
> > Ok, thanks!
> 
> I have a lot of ^M in the patch ... dos2unix removed them but I am
> wondering how they get there ?

He sent it with git-send-mail, how are you extracting it from
Thunderbird?

thx,

Jason.
