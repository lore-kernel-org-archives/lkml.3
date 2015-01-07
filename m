Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbbAGQNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:13:51 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15693 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751863AbbAGQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:13:49 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/6v/IjYXA2fWaCWzv9t6e4sH9wSae3s7Y=
X-DKIM: OpenDKIM Filter v2.0.1 titan BE76563FCB5
Date: Wed, 7 Jan 2015 11:13:33 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Bjorn Andersson <bjorn@kryo.se>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Toan Le <toanle@apm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] genirq: Allow the irqchip state of an IRQ to be
 save/restored
Message-ID: <20150107161333.GL24989@titan.lakedaemon.net>
References: <1417623503-30261-1-git-send-email-marc.zyngier@arm.com>
 <1417623503-30261-2-git-send-email-marc.zyngier@arm.com>
 <CAJAp7OijMW4_VMp29K1UxtURJT-WgwwsN-O1x3Lqi-gHrAj6Sw@mail.gmail.com>
 <5486C2D6.6020006@arm.com>
 <20150107160502.GJ24989@titan.lakedaemon.net>
 <54AD5A52.4090608@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AD5A52.4090608@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 04:09:54PM +0000, Marc Zyngier wrote:
> On 07/01/15 16:05, Jason Cooper wrote:
...
> > Did I miss the new version of this?
> 
> I'm rebasing all my stuff at the moment. Expect something later today
> (or tomorrow morning worse case).

Ok, wasn't trying to rush.  I had a few days of mail anomalies, so I was
just double checking that it didn't go missing.

thx,

Jason.
