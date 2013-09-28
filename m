Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3I1IwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 04:52:11 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:63232 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3I1IwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 04:52:07 -0400
Date: Sat, 28 Sep 2013 10:52:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20130928085203.GD26167@gmail.com>
References: <20130923191256.584672290@linux.com>
 <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com>
 <20130924080347.GH28538@gmail.com>
 <00000141505b72a3-6935722e-fdfb-4c46-b52c-bc40609144ac-000000@email.amazonses.com>
 <20130924151847.GB8494@gmail.com>
 <00000141509c4346-586ca654-989b-4a6a-ae30-592d2f8f11a8-000000@email.amazonses.com>
 <20130924172600.GD10261@gmail.com>
 <000001415604292f-63d4c50d-23e2-43ea-af60-f0e385c71661-000000@email.amazonses.com>
 <20130925182654.GB16693@gmail.com>
 <000001415fd9d3d8-7800dc31-9e8f-4981-963c-7d9851dafe75-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001415fd9d3d8-7800dc31-9e8f-4981-963c-7d9851dafe75-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Wed, 25 Sep 2013, Ingo Molnar wrote:
> 
> > > And then instead of thanks I get insults sprinkled with some paranoia.
> >
> > Pointing out your lack of cooperation (such as repeatedly ignoring 
> > maintainer feedback) is not an "insult" - it's my duty as a maintainer 
> > to protect other submitters who do their homework and it's also my 
> > duty as a maintainer to keep crappy patches from entering the kernel. 
> > Resisting low-quality patches like yours and pointing out patch 
> > submission errors and inefficiencies is my job.
> 
> Thats paranoia. [...]

Pointing out your track record is not paranoia nor an insult - it's merely 
embarrassing to you. And it's not just me: I heard similar complaints 
about you from other maintainers as well and I had to use a heavy NAK here 
to make you cooperate and listen already...

> [...] No lack of cooperation. Feedback to patches during development is 
> normal until they reach proper maturity for merging. Thats why these 
> things are usually versioned.

What I'm complaining about is you _ignoring_ feedback - such as when you 
ignored PeterZ's feedback.

This is kernel development 101: every new version of a series must address 
_all_ previously given feedback - or if does not do so it should very 
prominently explain why it has not done so.

If you "don't have time" to do it properly then you need to wait more 
between posting new versions of a series, to not make other people waste 
time reviewing the series and discovering that the review they gave 
against a prior series got ignored by you...

Thanks,

	Ingo
