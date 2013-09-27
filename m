Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3I0Dg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:36:57 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:45840 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab3I0Dgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:36:54 -0400
Date: Thu, 26 Sep 2013 23:36:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info' in
 all related extern functions
Message-ID: <20130927033651.GA9768@htj.dyndns.org>
References: <5242331B.4010309@asianux.com>
 <20130925005802.GA25777@htj.dyndns.org>
 <5242372C.4010509@asianux.com>
 <20130925011404.GB25777@htj.dyndns.org>
 <52424094.3020504@asianux.com>
 <524267CD.4030007@asianux.com>
 <5243CD18.1060805@asianux.com>
 <5243D487.8000602@asianux.com>
 <20130926131544.GB31249@mtj.dyndns.org>
 <5244DFA5.5090200@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5244DFA5.5090200@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Chen.

On Fri, Sep 27, 2013 at 09:30:13AM +0800, Chen Gang wrote:
> As an integrator or large source code maintainer, we cannot only depend
> on testing, or tracing log, or some short directly causes; we also need
> find and solve issues by checking sub-systems' interface or documents.

Do you seriously think that you're the only one thinking the above?
You're repeating something obvious.  The problem is that that's *all*
you're doing.  Anyone who has *some* coding experience would know that
and you didn't move even an inch forward from there.

What you have done is obvious from your initial commit message, you
read some random piece of code, found something slightly inconsistent
with your concept of ideal construction, grepped a bit, and whipped up
that patch.  It's such a perfect cliche of inexperience.  It's
something immediately obvious and *exactly* why you were asked to
actually try out your hypothesis.  It was supposed to serve two
purposes - either proving or disproving your patch && if your
knee-jerk patch was wrong, which I thought was likely given the
circumstances, making you think *why* you got it wrong and learn from
the experience.

When asked to actually verify your patch, you thought it was something
you were unfairly asked to do, and when your previous analysis was
shown to be wrong as so easily predicted, instead of thinking about
why you got that wrong and learning from the experience, you're now
just repeating the same crap in the opposite direction.

You're missing massive amount of steps between recognizing that
something is inconsistent and producing a proper improvement for it
and failing to recognize your shortcoming even when it failed right in
front of your face.  You need to understand how the subsystem and code
actually work before making changes, study the callers and history of
the code especially if the code has been stable / stale for long
period of time, verify your assumptions using objective measures, and
present that in your patch.  For a patch like this, preferably with
some risk analysis.

So, please take some time to mull over why your initial patch was
completely wrong and I didn't even have to read the code to predict
that your patch has high chance of being wrong.  Now, you're doing the
*exactly* same thing in the opposite direction.  You should be able to
recognize that there's something very wrong with that.

Thanks.

-- 
tejun
