Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab3DYMqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:46:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:43723 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab3DYMqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:46:21 -0400
Date: Thu, 25 Apr 2013 14:46:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mike Galbraith <bitbucket@online.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tim Sander <tim.sander@hbm.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
In-Reply-To: <1366893787.10248.4.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1304251445520.21884@ionos>
References: <1366760662.9609.176.camel@gandalf.local.home>  <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de>  <1366893374.6139.5.camel@marge.simpson.net> <1366893787.10248.4.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Steven Rostedt wrote:
> On Thu, 2013-04-25 at 14:36 +0200, Mike Galbraith wrote:
> > hrtimer: fix hrtimer free zone build bug
> 
> Perhaps the better solution is to select HIGH_RES_TIMERS when
> PREEMPT_RT_FULL is selected?

No, why ?
