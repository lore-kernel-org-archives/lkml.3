Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab3IHB5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 21:57:17 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36552 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3IHB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 21:57:16 -0400
Date: Sat, 7 Sep 2013 18:57:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] cpufreq: Fix wrong time unit conversion
Message-ID: <20130908015709.GK3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1378571708-27825-1-git-send-email-fweisbec@gmail.com>
 <87txhwh07p.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txhwh07p.fsf@igel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090801-7164-0000-0000-00000170E39A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 09:59:38PM +0200, Andreas Schwab wrote:
> See also <http://permalink.gmane.org/gmane.linux.kernel.cpufreq/11672>.

Does look quite similar, now that you mention it.

Perhaps if Frederic has not already sent his patch he could add your
Signed-off-by to his patch?

							Thanx, Paul

