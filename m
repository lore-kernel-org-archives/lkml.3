Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3FNQWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:22:14 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45173 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3FNQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <1371226336.9844.328.camel@gandalf.local.home>
References: <20130613131057.GA15997@somewhere>
	<20130613140207.GW133453@redhat.com>
	<20130613142210.GD16339@somewhere>
	<20130613144515.GX133453@redhat.com>
	<20130613145601.GE16339@somewhere>
	<20130613152059.GA133453@redhat.com>
	<1371138491.9844.288.camel@gandalf.local.home>
	<CAK7N6vqtnoNzRNodN6T0wysMYgPD+-SgPZLXAvRu3px7TUUvHQ@mail.gmail.com>
	<1371143779.9844.297.camel@gandalf.local.home>
	<CAK7N6vqOQijcZEEuJKFbHKEaULnx8bCkaxSpBaiTe1+VGT+D5w@mail.gmail.com>
	<20130614122608.GK5146@linux.vnet.ibm.com>
	<CAK7N6vrCuWd4Q2hquJK9-HED4xyjC7hsCOUdvK3dHEetatzcfw@mail.gmail.com>
	<1371226336.9844.328.camel@gandalf.local.home>
Date: Fri, 14 Jun 2013 21:52:10 +0530
Message-ID: <CAK7N6vq=NS0aZnAOXa-V8HWpNdjuee6Ye45zTT-K1+fRz-D0=Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
From: anish singh <anish198519851985@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 9:42 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2013-06-14 at 21:33 +0530, anish singh wrote:
>
>> May I know why we zeroed in on 1Hz? Is there any logical reason
>> or just because it is above 0Hz?
>> >
>
> We had to keep a tick. What number would you have picked?

Great.I will just confirming my understanding.Thanks.
>
> -- Steve
>
>
