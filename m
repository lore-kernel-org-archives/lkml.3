Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3IHK0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 06:26:03 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62331 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3IHK0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 06:26:01 -0400
Date: Sun, 8 Sep 2013 12:25:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: Fix wrong time unit conversion
Message-ID: <20130908102555.GB4501@somewhere>
References: <1378571708-27825-1-git-send-email-fweisbec@gmail.com>
 <87txhwh07p.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txhwh07p.fsf@igel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 09:59:38PM +0200, Andreas Schwab wrote:
> See also <http://permalink.gmane.org/gmane.linux.kernel.cpufreq/11672>.
> 
> Andreas.

Ah I missed it.

Raphael, if it is not too late, may be you could still set Andreas as the original author?

Thanks.

> 
> -- 
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
> "And now for something completely different."
