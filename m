Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab3IHLmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 07:42:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38516 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3IHLmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 07:42:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: Fix wrong time unit conversion
Date: Sun, 08 Sep 2013 13:53:13 +0200
Message-ID: <1984927.sOjagQ01EH@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <4267687.NqCexiBK9O@vostro.rjw.lan>
References: <1378571708-27825-1-git-send-email-fweisbec@gmail.com> <20130908102555.GB4501@somewhere> <4267687.NqCexiBK9O@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 08, 2013 01:49:42 PM Rafael J. Wysocki wrote:
> On Sunday, September 08, 2013 12:25:57 PM Frederic Weisbecker wrote:
> > On Sat, Sep 07, 2013 at 09:59:38PM +0200, Andreas Schwab wrote:
> > > See also <http://permalink.gmane.org/gmane.linux.kernel.cpufreq/11672>.
> > > 
> > > Andreas.
> > 
> > Ah I missed it.
> > 
> > Raphael, if it is not too late, may be you could still set Andreas as the original author?
> 
> Done.

BTW, CCing power management patches to linux-pm@vger.kernel.org helps a bit,
because I can see them in patchwork then and that makes overlooking them or
forgetting about them much less likely.

Thanks,
Rafael

