Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3GQTSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:18:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34282 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755932Ab3GQTSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:18:33 -0400
Message-ID: <1374088711.1949.107.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: add the generic sched_clock under
 timekeeping
From: Joe Perches <joe@perches.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Wed, 17 Jul 2013 12:18:31 -0700
In-Reply-To: <20130717191222.GW6950@tarshish>
References: <a38977cc6608170b69b21b8a5ee985685c7e8a0d.1374055149.git.baruch@tkos.co.il>
	 <51E6E91C.1090700@linaro.org> <20130717191222.GW6950@tarshish>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 22:12 +0300, Baruch Siach wrote:
[]
> > >diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > >@@ -7129,6 +7129,7 @@ M:	Thomas Gleixner <tglx@linutronix.de>
[]
> > >+F:	include/linux/sched_clock.h
[]
> > >+F:	kernel/time/sched_clock.c
> > 
> > It seems like we could probably simplify this bit to kernel/time/*, no?
> 
> This would add jiffies.c and all the tick-* files that are currently covered 
> by the "HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS" section.

Another option would be to move files into
a separate directory, but I think it's not
a big deal either way.

