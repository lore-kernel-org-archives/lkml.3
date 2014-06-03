Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaFCNQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:16:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbaFCNQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:16:46 -0400
Date: Tue, 3 Jun 2014 09:16:09 -0400
From: Dave Jones <davej@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: sched: Disallow sched_attr::sched_policy < 0
Message-ID: <20140603131609.GA26267@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>
References: <20140602021319.9A5F9660C19@gitolite.kernel.org>
 <20140602202204.GA26649@redhat.com>
 <20140603080826.GK11096@twins.programming.kicks-ass.net>
 <CAFLxGvz4yKJfWyRqh5wnG-05m9P3oxcrvVZLH-Yap8dFz-0ctg@mail.gmail.com>
 <20140603083228.GN11096@twins.programming.kicks-ass.net>
 <538D8B96.7080503@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538D8B96.7080503@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 10:47:18AM +0200, Richard Weinberger wrote:
 > Am 03.06.2014 10:32, schrieb Peter Zijlstra:
 > > On Tue, Jun 03, 2014 at 10:15:44AM +0200, Richard Weinberger wrote:
 > >>> Once upon a time GCC also did warns like that, but my compiler is silent
 > >>> :-(
 > 
 > -Wtype-limits is what you're looking for.
 > 
 > /me currently builds some kernel configs to find out how much noise it triggers...
 
Probably quite a bit I'd bet. There's a load of similar bugs in
coverity's db. Some of them look benign, and are probably there just in
case someone ever changes the type of a var, but it's non-obvious
sometimes if the values a function receives can ever actually be < 0

	Dave

