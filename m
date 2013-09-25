Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3IYQq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:46:57 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:36211 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab3IYQq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:46:57 -0400
Date: Wed, 25 Sep 2013 16:46:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu
 ops
In-Reply-To: <20130924172600.GD10261@gmail.com>
Message-ID: <000001415604292f-63d4c50d-23e2-43ea-af60-f0e385c71661-000000@email.amazonses.com>
References: <20130923191256.584672290@linux.com> <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com> <20130924080347.GH28538@gmail.com> <00000141505b72a3-6935722e-fdfb-4c46-b52c-bc40609144ac-000000@email.amazonses.com>
 <20130924151847.GB8494@gmail.com> <00000141509c4346-586ca654-989b-4a6a-ae30-592d2f8f11a8-000000@email.amazonses.com> <20130924172600.GD10261@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.25-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013, Ingo Molnar wrote:

> > > > And this kind of insulting behavior is really discouraging people to
> > > > do work on the kernel.
>
> You can stop playing the victim card: you are not a newbie anymore by any
> definition, you've been hacking the Linux kernel for how long, 10+ years,
> writing hundreds of patches? People expect higher quality series from you
> and you need to learn to address criticism of your workflow as well.
>
> You won't find a _single_ mail in the last 15+ years of lkml where I
> reacted strongly to a newbie being dense or abusive. Newbies can make all
> sorts of mistakes, it's part of the learning process - but after 10 years
> you are not a newbie anymore...

This has nothing to do with newbieness but with general communication
behavior. I am not a full time kernel developer (nor would I want to be
because it seems to cause some sort of cabin fever) and need to take time
off my other duties in order to work on these patches. Time is limited.

And then instead of thanks I get insults sprinkled with some paranoia.

