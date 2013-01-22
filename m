Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3AVVxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:53:10 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:56972 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752531Ab3AVVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:53:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19sMLQlp3R8axgVY5beTUNS
Date: Tue, 22 Jan 2013 13:52:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130122215257.GU22517@atomide.com>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <20130121232322.GK15361@atomide.com>
 <50FE307F.9000701@ti.com>
 <201301220931.24570.arnd@arndb.de>
 <50FE666B.10902@ti.com>
 <20130122145113.GK23505@n2100.arm.linux.org.uk>
 <50FEE175.90504@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FEE175.90504@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John Stultz <john.stultz@linaro.org> [130122 11:02]:
> 
> Correct, with HRT, we actually trigger the HZ-frequency timer tick
> from an hrtimer (which expires based on the system time driven by
> the clocksource). Thus even if there is a theoretical error between
> the ideal HZ and what the hardware can do, that error will not
> propagate forward.

If there's no cumulative error, sounds like the way to go is to select
HRT for ARM multiplatform builds and set the HZ to 100 then.

Regards,

Tony
