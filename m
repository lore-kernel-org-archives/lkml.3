Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab3GEQBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3GEQB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:01:29 -0400
Date: Fri, 5 Jul 2013 12:00:43 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Yet more softlockups.
Message-ID: <20130705160043.GF325@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <20130705143821.GB325@redhat.com>
 <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 05:15:07PM +0200, Thomas Gleixner wrote:
 > On Fri, 5 Jul 2013, Dave Jones wrote:
 > 
 > > BUG: soft lockup - CPU#3 stuck for 23s! [trinity-child1:14565]
 > > perf samples too long (2519 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
 > > INFO: NMI handler (perf_event_nmi_handler) took too long to run: 238147.002 msecs
 > 
 > So we see a softlockup of 23 seconds and the perf_event_nmi_handler
 > claims it did run 23.8 seconds.
 > 
 > Are there more instances of NMI handler messages ?

[ 2552.006181] perf samples too long (2511 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[ 2552.008680] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 500392.002 msecs

	Dave

