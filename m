Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab3D3Iwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:52:42 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:57304 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759453Ab3D3Iwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:52:38 -0400
Date: Tue, 30 Apr 2013 10:52:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, bp@alien8.de, arjan@linux.intel.com,
        khilman@linaro.org, cl@linux.com, peterz@infradead.org,
        tglx@linutronix.de, olivier.baetz@novasparks.com,
        rdunlap@infradead.org, bp@suse.de
Subject: Re: [GIT PULL tip/timers/nohz] Documentation for adaptive ticks
Message-ID: <20130430085234.GB23017@gmail.com>
References: <20130428000130.GA19985@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130428000130.GA19985@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This change adds documentation for CONFIG_NO_HZ_IDLE and CONFIG_NO_HZ_FULL.
> It is available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/nohz
> 
> for you to fetch changes up to 0c87f9b5ca5bdda1a868b0d7df4bec92e41a468d:
> 
>   nohz_full: Add documentation. (2013-04-27 16:41:43 -0700)
> 
> 							Thanx, Paul
> 
> ----------------------------------------------------------------
> Paul E. McKenney (1):
>       nohz_full: Add documentation.
> 
>  Documentation/timers/NO_HZ.txt | 273 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 273 insertions(+)
>  create mode 100644 Documentation/timers/NO_HZ.txt

Pulled into tip:timers/nohz, thanks Paul!

	Ingo
