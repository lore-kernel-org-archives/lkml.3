Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3GOKpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:45:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50578 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab3GOKpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:45:02 -0400
Message-ID: <1373885096.3146.11.camel@hornet>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Pawel Moll <pawel.moll@arm.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Date: Mon, 15 Jul 2013 11:44:56 +0100
In-Reply-To: <51CB1BA5.9010307@gmail.com>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet>
	 <51CB1BA5.9010307@gmail.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 15 Jul 2013 10:44:57.0138 (UTC) FILETIME=[5903E920:01CE8148]
X-MC-Unique: 113071511445901701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 17:49 +0100, David Ahern wrote:
> With all the perf ioctl extensions tossed out the past day or so I 
> wanted to revive this request. Still need a solution to the problem of 
> correlating perf_clock to other clocks ...

And I second. We've been trying to squeeze the solution into the posix
clock framework (and vdso) but it didn't get anywhere, really. I've
spoken to John last week and although there is one more potential
"solution" (and the quotes are meaningful ;-), it seems that the
perf-specific ioctl would work for all interested individuals for now.

Paweł


