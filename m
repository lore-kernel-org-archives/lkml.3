Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab3HMMIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:08:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab3HMMIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:08:07 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=F0my4ousGMIA:10 a=mDXKN6JPlx33xzqja4gA:9 a=CjuIK1q_8ugA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 08:08:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Carsten Emde <C.Emde@osadl.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
Message-ID: <20130813080806.4a16d8d1@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1308131253040.4089@ionos.tec.linutronix.de>
References: <20130812163413.GI23040@linutronix.de>
	<20130812154810.433858a5@gandalf.local.home>
	<CAP=VYLrd_ZU94Nf0X+FtT3M2Xx85t9FF13o-hV+_xHi7EjTf=w@mail.gmail.com>
	<5209880E.6080902@osadl.org>
	<alpine.DEB.2.02.1308131253040.4089@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 12:54:26 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 13 Aug 2013, Carsten Emde wrote:
> > On 08/13/2013 02:47 AM, Paul Gortmaker wrote:
> > > On Mon, Aug 12, 2013 at 3:48 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > I'm behind on 3.4-rt, 3.2-rt and of course 3.0-rt. Hopefully, I'll get
> > > > them all out this week.
> > > 
> > > I expect that the 3.10-rt kernel will replace the older RT kernels.
> > 
> > We should not forget 3.2 that will be maintained until March
> > 2016. Thus, let's focus on 3.2 and 3.10 (maintained until August
> > 2015) and abandon all other 3.x RT versions.
> 
> Yes, please. We need all man power on 3.10 and let's keep 3.2 as a
> long term supported version along with the nice work from the debian
> kernel team.
> 

Unfortunately, the company that is paying me, is interested in some of
the other versions.

-- Steve
