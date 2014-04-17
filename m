Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaDQO5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:57:33 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47594 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaDQO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:57:26 -0400
Date: Thu, 17 Apr 2014 10:57:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Glyn Normington <gnormington@gopivotal.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] control groups: documentation improvements
Message-ID: <20140417145723.GI15326@htj.dyndns.org>
References: <20140314140136.GF12613@htj.dyndns.org>
 <53230C7E.7060607@gopivotal.com>
 <533C05D8.8020600@gopivotal.com>
 <533C0DD9.1050809@gopivotal.com>
 <20140416210025.GE26632@htj.dyndns.org>
 <534FB0F5.3010904@gopivotal.com>
 <20140417131615.GH26632@htj.dyndns.org>
 <534FDB04.6050406@gopivotal.com>
 <20140417135528.GE15326@htj.dyndns.org>
 <534FEA74.70300@gopivotal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534FEA74.70300@gopivotal.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glyn.

On Thu, Apr 17, 2014 at 03:51:32PM +0100, Glyn Normington wrote:
> >It's kinda useless to go through all the precise terms to re-define
> >hierarchical grouping of tasks, which is both accurate and intuitive
> >enough.  Adding extra descriptions to clarify ambiguities and just to
> >reinforce the concept would be fine but trying to build the concept
> >from the ground is silly at best.  Starting with something intuitive
> >and refining it is a far better approach.
>
> I'm sorry you feel this way. A couple of us (full disclosure: both
> mathematicians) tried hard to get a precise understanding of cgroups
> from cgroups.txt, but several terms remained vague until we had done
> some experiments and discussed our findings on the mailing list.
> 
> The aim of the patch is to crisp up the definitions of those terms
> for other newcomers, so they won't have to go through the same
> exercise.

Oh, don't get me wrong.  The current documentation is neither
intuitive or precise.  I have hard time understanding what it's
saying, so probably even just increasing precision is an improvement.

> Interestingly, after we had understood the terms, cgroups.txt seemed
> much clearer than it did originally. But that's because we were
> tending to read our new-found understanding into the text. Might you
> not be doing the same?

Sure thing.  Please go ahead and improve it.  It's not good at all in
all fronts.

> So, how would you like to proceed? You could reject the patch
> outright if you think our experience is unrepresentative. Or, for
> the benefit of other newcomers, we are willing to try reworking the
> parts you find unreadable if you could kindly pick them out. The
> choice is yours. :-)

Again, I think it's an improvement but was just hoping you could add a
bit more intuitive explanations so that it's more approchable.  The
two properties aren't mutually exclusive.

> Thanks for the clarification. If you agree to proceed, we should be
> able to find a simpler way to cover this paragraph.

I really don't mind being verbose if it makes things clearer and
easier to understand.

Thanks!

-- 
tejun
