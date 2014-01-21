Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaAUUpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:45:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37341 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbaAUUpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:45:38 -0500
Date: Tue, 21 Jan 2014 21:45:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@kernel.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix sched_entity avg statistics update
Message-ID: <20140121204534.GT11314@laptop.programming.kicks-ass.net>
References: <1390320738-4555-1-git-send-email-vincent.guittot@linaro.org>
 <xm26d2jlkwn1.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <CAKfTPtDEKnM+er0NLxCKN4gK_KP3hnzPd13k7qqYtyWKCgdP4w@mail.gmail.com>
 <CAPM31RLjHnn=Ma7peuDUqK75bANw7Mb-UT-1QmzG0c8LAObQ8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RLjHnn=Ma7peuDUqK75bANw7Mb-UT-1QmzG0c8LAObQ8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 12:31:18PM -0800, Paul Turner wrote:
> I think I need to go through and do a comments patch like we did with
> the wake-affine math; it's too easy to make a finicky mistake like
> this when not touching this path for a while.

If you're going to do that, please consider fixing the XXX on line 4783:

 * [XXX write more on how we solve this.. _after_ merging pjt's patches that
 *      rewrite all of this once again.]
