Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3FNQMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:12:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15420 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3FNQMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:12:17 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=tkaDFPjYVEIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=apdwqXrHFoAA:10 a=iwrn97SKuRVz8EZBcckA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371226336.9844.328.camel@gandalf.local.home>
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
From: Steven Rostedt <rostedt@goodmis.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Jun 2013 12:12:16 -0400
In-Reply-To: <CAK7N6vrCuWd4Q2hquJK9-HED4xyjC7hsCOUdvK3dHEetatzcfw@mail.gmail.com>
References: <20130613131057.GA15997@somewhere>
	 <20130613140207.GW133453@redhat.com> <20130613142210.GD16339@somewhere>
	 <20130613144515.GX133453@redhat.com> <20130613145601.GE16339@somewhere>
	 <20130613152059.GA133453@redhat.com>
	 <1371138491.9844.288.camel@gandalf.local.home>
	 <CAK7N6vqtnoNzRNodN6T0wysMYgPD+-SgPZLXAvRu3px7TUUvHQ@mail.gmail.com>
	 <1371143779.9844.297.camel@gandalf.local.home>
	 <CAK7N6vqOQijcZEEuJKFbHKEaULnx8bCkaxSpBaiTe1+VGT+D5w@mail.gmail.com>
	 <20130614122608.GK5146@linux.vnet.ibm.com>
	 <CAK7N6vrCuWd4Q2hquJK9-HED4xyjC7hsCOUdvK3dHEetatzcfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 21:33 +0530, anish singh wrote:

> May I know why we zeroed in on 1Hz? Is there any logical reason
> or just because it is above 0Hz?
> >

We had to keep a tick. What number would you have picked?

-- Steve


