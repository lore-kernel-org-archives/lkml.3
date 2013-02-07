Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab3BGRDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:03:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28222 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3BGRDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:03:50 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M5gr15I6uLgA:10 a=22uzNxQ2lQntyp8xS7IA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360256627.2621.77.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 07 Feb 2013 12:03:47 -0500
In-Reply-To: <CAFTL4hy-hz=okOC7mWTwP=eh_OrL48c5hoLuXyBRFMAgquLCtw@mail.gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	 <1360205415.2621.60.camel@gandalf.local.home>
	 <20130207111025.GD8945@gmail.com>
	 <CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
	 <1360255280.2621.70.camel@gandalf.local.home>
	 <CAFTL4hy-hz=okOC7mWTwP=eh_OrL48c5hoLuXyBRFMAgquLCtw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 17:45 +0100, Frederic Weisbecker wrote:

> >
> > config NO_HZ_TASK
> >         bool "Stop tick on specified CPUs when single task is running"
> >         default n
> >         depends on NO_HZ
> 
> Ok I launched another debate about that single task thing. I wish we
> don't make it a fundamental component but rather an implementation
> detail that can be dynamically dealt with in the future.

It's not just an implementation detail, as it is very visible to the
user. If they want to take advantage of a task NO_HZ they have to go
through a bit of loops to make sure only a single task is running on a
CPU. We should be broadcasting this requirement to educate the users on
exactly how they can take advantage of this feature.


>  Anyway let's
> talk about that on my previous answer.

I already did ;-)

-- Steve


