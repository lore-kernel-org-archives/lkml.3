Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaDQJsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:48:32 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:36528 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaDQJsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:48:20 -0400
Date: Thu, 17 Apr 2014 11:48:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140417094815.GA9348@gmail.com>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu>
 <20140416141514.GS11182@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Wed, 16 Apr 2014, Vince Weaver wrote:
> 
> > On Wed, 16 Apr 2014, Peter Zijlstra wrote:
> > 
> > > Does the below make any difference? I've only ran it through some light
> > > testing to make sure it didn't insta-explode on running.
> > > 
> > > (perf stat make -j64 -s in fact)
> > 
> > I'm running with your patch now and so far so good.
> 
> spoke too soon, just got this with your patch applied
> (I wasn't running ftrace so no trace with this one):

Is there some place where I can pick up the latestest of your fuzzer?

PeterZ has trouble reproducing the corruption locally - I'd like to 
run it too, maybe I have hardware that triggers it more readily.

Plus it would be nice to get your latest .config as well, that you are 
using to generate this crash. (You can send it in private mail as well 
if you wish.)

Thanks,

	Ingo
