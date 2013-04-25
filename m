Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab3DYMwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:52:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26234 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3DYMwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:52:06 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BTRBD928usAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YPD5nf4ZmOMA:10 a=VOaEUkru_7MZYEqCL0kA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366894324.10248.6.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tim Sander <tim.sander@hbm.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 25 Apr 2013 08:52:04 -0400
In-Reply-To: <alpine.LFD.2.02.1304251445520.21884@ionos>
References: <1366760662.9609.176.camel@gandalf.local.home>
	  <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de>
	  <1366893374.6139.5.camel@marge.simpson.net>
	 <1366893787.10248.4.camel@gandalf.local.home>
	 <alpine.LFD.2.02.1304251445520.21884@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 14:46 +0200, Thomas Gleixner wrote:
> On Thu, 25 Apr 2013, Steven Rostedt wrote:
> > On Thu, 2013-04-25 at 14:36 +0200, Mike Galbraith wrote:
> > > hrtimer: fix hrtimer free zone build bug
> > 
> > Perhaps the better solution is to select HIGH_RES_TIMERS when
> > PREEMPT_RT_FULL is selected?
> 
> No, why ?

Why not? ;-)

Except for the lack of support, one would think that if you want real
time responses, you would also want a real time clock.

-- Steve


