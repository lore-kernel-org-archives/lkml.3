Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3DYNYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:24:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56710 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab3DYNYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:24:00 -0400
Message-ID: <1366896232.6139.21.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tim Sander <tim.sander@hbm.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 25 Apr 2013 15:23:52 +0200
In-Reply-To: <alpine.LFD.2.02.1304251507370.21884@ionos>
References: <1366760662.9609.176.camel@gandalf.local.home>
	 <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de>
	 <1366893374.6139.5.camel@marge.simpson.net>
	 <1366893787.10248.4.camel@gandalf.local.home>
	 <alpine.LFD.2.02.1304251445520.21884@ionos>
	 <1366894324.10248.6.camel@gandalf.local.home>
	 <alpine.LFD.2.02.1304251507370.21884@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:90QClqFU4DT0/6IY6tz0FhioOMn/ZoLetPAIYnwHkPe
 KoXO3UEbyySS7ibqvUdZH8WHN+C9XqZV82Z7Deph0aN1wE/Sq0
 +DLyZVBf3lBJtHVxFcnQC4I4MRpM4I0evhK24bE2eCHNR324rR
 WmuILYfwepvaN5by1QONXJCCaiW7l0k0E2TDJXVGDkE5AJUvWe
 LzzcRqZciEYEBdBrKYNe6O/TQiEfKBgKFStqeeOGiSR2lcnn43
 EFf1TE9MypJV7I40D1QTBPCgSOFvFB2nd4a5lRdV45kQUW/SzS
 awAEbBjEEW10mwvRsydP1t7jZhTSp+x9jUpoG2p6mq7GKRug/4
 rwmDqxv7bemowxBo841MZgMa5XRxaCR8S2hb5maMRAot7u1CmZ
 t8BbmxubxekhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 15:09 +0200, Thomas Gleixner wrote: 
> On Thu, 25 Apr 2013, Steven Rostedt wrote:
> 
> > On Thu, 2013-04-25 at 14:46 +0200, Thomas Gleixner wrote:
> > > On Thu, 25 Apr 2013, Steven Rostedt wrote:
> > > > On Thu, 2013-04-25 at 14:36 +0200, Mike Galbraith wrote:
> > > > > hrtimer: fix hrtimer free zone build bug
> > > > 
> > > > Perhaps the better solution is to select HIGH_RES_TIMERS when
> > > > PREEMPT_RT_FULL is selected?
> > > 
> > > No, why ?
> > 
> > Why not? ;-)
> > 
> > Except for the lack of support, one would think that if you want real
> > time responses, you would also want a real time clock.
> 
> Well, if your application is driven by an external interrupt, then you
> do not need highres timers at all.

(hey, that's cheating, generic config vs specialized;)

