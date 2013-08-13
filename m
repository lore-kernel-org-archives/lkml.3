Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab3HMKyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:54:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:48735 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3HMKyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:54:33 -0400
Date: Tue, 13 Aug 2013 12:54:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Carsten Emde <C.Emde@osadl.org>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
In-Reply-To: <5209880E.6080902@osadl.org>
Message-ID: <alpine.DEB.2.02.1308131253040.4089@ionos.tec.linutronix.de>
References: <20130812163413.GI23040@linutronix.de> <20130812154810.433858a5@gandalf.local.home> <CAP=VYLrd_ZU94Nf0X+FtT3M2Xx85t9FF13o-hV+_xHi7EjTf=w@mail.gmail.com> <5209880E.6080902@osadl.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013, Carsten Emde wrote:
> On 08/13/2013 02:47 AM, Paul Gortmaker wrote:
> > On Mon, Aug 12, 2013 at 3:48 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > I'm behind on 3.4-rt, 3.2-rt and of course 3.0-rt. Hopefully, I'll get
> > > them all out this week.
> > 
> > I expect that the 3.10-rt kernel will replace the older RT kernels.
> 
> We should not forget 3.2 that will be maintained until March
> 2016. Thus, let's focus on 3.2 and 3.10 (maintained until August
> 2015) and abandon all other 3.x RT versions.

Yes, please. We need all man power on 3.10 and let's keep 3.2 as a
long term supported version along with the nice work from the debian
kernel team.

Thanks,

	tglx
