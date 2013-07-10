Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3GJPlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:41:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab3GJPlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:41:11 -0400
Date: Wed, 10 Jul 2013 11:40:29 -0400
From: Dave Jones <davej@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Yet more softlockups.
Message-ID: <20130710154029.GB11309@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <20130705143821.GB325@redhat.com>
 <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
 <20130705160043.GF325@redhat.com>
 <20130706072408.GA14865@gmail.com>
 <20130710151324.GA11309@redhat.com>
 <20130710152015.GA757@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710152015.GA757@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 05:20:15PM +0200, Markus Trippelsdorf wrote:
 > On 2013.07.10 at 11:13 -0400, Dave Jones wrote:
 > > I get this right after booting..
 > > 
 > > [  114.516619] perf samples too long (4262 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
 > 
 > You can disable this warning by:
 > 
 > echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent

Yes, but why is this even being run when I'm not running perf ?

The only NMI source running should be the watchdog.

	Dave

