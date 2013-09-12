Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3ILK34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:29:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48889 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3ILK3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:29:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] cpufreq: Prevent problems in update_policy_cpu() if last_cpu == new_cpu
Date: Thu, 12 Sep 2013 12:40:54 +0200
Message-ID: <2753290.JbKAdhJjui@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5231695D.5070404@linux.vnet.ibm.com>
References: <20130911201239.7832.72612.stgit@srivatsabhat.in.ibm.com> <CAKohpomsHSMWmGAACurpN1dYSsvHvH6w_SDpQ5c7CE_1R2MGMg@mail.gmail.com> <5231695D.5070404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 12, 2013 12:42:29 PM Srivatsa S. Bhat wrote:
> On 09/12/2013 12:14 PM, Viresh Kumar wrote:
> > On 12 September 2013 12:00, Srivatsa S. Bhat
> > <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> >> Looking at the rate at which we are bumping into each others thoughts, I think
> >> maybe we should switch from email to IRC ;-) ;-)
> > 
> > Unbelievable, Even I thought so this morning :)
> > 
> > One more thing that I wanted to say for some other threads..
> > Your changelogs are simply superb.. The amount of information that you put in
> > them is fantastic.. 
> 
> Thank you! :-) I'm glad to hear that!
> 
> Believe it or not, I spend almost an equal (if not more) amount of time ensuring
> that I get the changelog absolutely right, compared to the time I spend actually
> writing the code. The reason is that, I have been pleasantly surprised by the
> power of the changelog in numerous occasions: the very act of composing a proper 
> changelog forces me to think *much* more clearly than when writing code. And it
> often gives me the opportunity to rethink the *entire* approach/solution and not
> just the implementation, since I need to explain the full context in it, not
> just what the code does. And *that* exercise can reveal more complex/subtle bugs
> than mere code review can ever do. That's why I put so much emphasis on writing
> a perfect changelog :-) [Believe it or not, I have had times when I figured out
> that my entire solution was utterly nonsensical when I began writing the changelog,
> *after* reviewing and testing the code! ... and of course I had to rework the
> entire patch! ;-( ]
> 
> And to prevent myself from going overboard with writing the changelog (like making
> it way too verbose or convoluted with too much detail), I have a simple mechanism/
> handy rule in place:
> 
> The changelog should be such that, whoever reads the changelog should feel that
> the time he spent reading it was totally worth it. IOW, it should not simply
> regurgitate what is already obvious from the code. Instead it should provide
> insights into the subtle aspects or tradeoffs relevant to the patch; in short, it
> should explain the "_why_ behind the _what_" as clearly and in as few words as
> possible :-)
> 
> Well, atleast I _try_ to stick to that rule :-)

Can you please prepare a patch against Documentation/SubmittingPatches with the
above paragraph in it?  Seriously.

There are people who don't really see a reason for writing good patch
changelogs.

Thanks,
Rafael

