Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3CVDej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:34:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7337 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab3CVDei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:34:38 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=k73MykfMmY8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=TJ5gPuUbub8A:10 a=D19gQVrFAAAA:8 a=qrMiz8ANoua7e3LMJiQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363923275.6345.93.camel@gandalf.local.home>
Subject: Re: PREEMPT_RT vs 'hrtimer: Prevent hrtimer_enqueue_reprogram race'
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Leonid Shatz <leonid.shatz@ravellosystems.com>,
        Ingo Molnar <mingo@elte.hu>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Date: Thu, 21 Mar 2013 23:34:35 -0400
In-Reply-To: <1363922685.3728.21.camel@deadeye.wl.decadent.org.uk>
References: <1363914713.31336.191.camel@deadeye.wl.decadent.org.uk>
	 <1363919473.6345.88.camel@gandalf.local.home>
	 <1363922685.3728.21.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 03:24 +0000, Ben Hutchings wrote:

> > Note, I posted a fix on Tuesday:
> > 
> > https://lkml.org/lkml/2013/3/19/369
> 
> Thanks.  I did search GMANE with some obvious terms but I think its
> index is lagging.

It didn't help that my subject had no mention of -rt in it :-(

> I'm rebasing the rt patch series generated with
> 'git format-patch v3.2.39..v3.2.39-rt59-rebase' on top of v3.2.41 (plus
> Debian changes, which introduce some trivial textual conflicts).

Ah, OK, I do it the opposite way. As the stable rt git never rebases, I
always merge the latest stable into my tree. I then create a rebased
tree as well. When I do that, I'm sure I'll end up fixing the patches up
pretty much the same as you have.

Thanks,

-- Steve



