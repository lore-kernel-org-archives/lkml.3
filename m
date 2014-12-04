Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaLDDqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 22:46:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbaLDDp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 22:45:59 -0500
Date: Wed, 3 Dec 2014 22:45:12 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141204034512.GA25065@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	John Stultz <john.stultz@linaro.org>
References: <20141203200906.GA3118@redhat.com>
 <CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com>
 <alpine.DEB.2.11.1412032141040.16275@nanos>
 <CA+55aFw8L06BxpsVnbdiNaU2WSFo=tafND25uV_SHUig=CC1AA@mail.gmail.com>
 <alpine.DEB.2.11.1412032249050.16275@nanos>
 <20141203232115.GA13266@redhat.com>
 <alpine.DEB.2.11.1412040043170.16275@nanos>
 <20141204002044.GA15239@redhat.com>
 <alpine.DEB.2.11.1412040156070.16275@nanos>
 <20141204013200.GB17727@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204013200.GB17727@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 08:32:00PM -0500, Dave Jones wrote:
 > On Thu, Dec 04, 2014 at 01:59:01AM +0100, Thomas Gleixner wrote:
 > 
 >  > > Also, should I run it in isolation, with nothing else going on,
 >  > > or under load where I see problems ?
 >  > 
 >  > isolated is usually the best thing as it has the highest density of
 >  > reads.
 > 
 > Ok, it's been running for just over an hour with no 'fails' yet.
 > How long should I leave it ?

Ok, I left it running for four hours with no observed failures.
I'd leave it running longer, but I might not have this machine
in the new year, so I'm running out of time to complete bisections
if they take a day or two to complete each step.

	Dave

