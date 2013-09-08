Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab3IHMJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:09:10 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36899 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3IHMJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:09:08 -0400
Date: Sun, 8 Sep 2013 14:09:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: Fix wrong time unit conversion
Message-ID: <20130908120903.GF4501@somewhere>
References: <1378571708-27825-1-git-send-email-fweisbec@gmail.com>
 <20130908102555.GB4501@somewhere>
 <4267687.NqCexiBK9O@vostro.rjw.lan>
 <1984927.sOjagQ01EH@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1984927.sOjagQ01EH@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 01:53:13PM +0200, Rafael J. Wysocki wrote:
> On Sunday, September 08, 2013 01:49:42 PM Rafael J. Wysocki wrote:
> > On Sunday, September 08, 2013 12:25:57 PM Frederic Weisbecker wrote:
> > > On Sat, Sep 07, 2013 at 09:59:38PM +0200, Andreas Schwab wrote:
> > > > See also <http://permalink.gmane.org/gmane.linux.kernel.cpufreq/11672>.
> > > > 
> > > > Andreas.
> > > 
> > > Ah I missed it.
> > > 
> > > Raphael, if it is not too late, may be you could still set Andreas as the original author?
> > 
> > Done.
> 
> BTW, CCing power management patches to linux-pm@vger.kernel.org helps a bit,
> because I can see them in patchwork then and that makes overlooking them or
> forgetting about them much less likely.

Ok, I'll do that next time.

Thanks.
