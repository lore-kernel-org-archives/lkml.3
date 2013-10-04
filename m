Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab3JDGYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 02:24:32 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40530 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3JDGYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 02:24:31 -0400
Date: Fri, 4 Oct 2013 08:24:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 11/11] perf: Avoid uninitialized sample type reference in
 __perf_event__output_id_sample
Message-ID: <20131004062427.GD11399@gmail.com>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-12-git-send-email-andi@firstfloor.org>
 <20131002085730.GD12926@twins.programming.kicks-ass.net>
 <20131002172507.GG2125@tassilo.jf.intel.com>
 <20131002173619.GW3081@twins.programming.kicks-ass.net>
 <20131003064201.GF25345@gmail.com>
 <20131003181652.GH2125@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003181652.GH2125@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > Forcing multiple, unnecessary rounds of emails instead of clearly 
> > volunteering all technical information that is related to the matter 
> > is something Andi is still doing routinely.
> 
> Sorry all the information was in the full email thread (including the 
> intro). And the patch description clearly described the problem in your 
> code.
> 
> As the patches spanned many subsystems you were only copied on the 
> patches that affect your subsystem, and not on the intro (as git 
> send-email doesn't seem to support that)
> 
> Here are possible alternatives. Please let me know which ones you prefer 
> and I'll try to adapt to your specific preferences in the future:
> 
> [ ] Always copy you guys on all patches of 
> subsystem spanning patch kits that are mostly of no relevance
> to you. 
> 
> [ ] Repeat the complete intro in every patch.
> 
> [ ] You think uninitialized are not a problem and you
> don't want to see any patches related to that.
> 
> [ ] You are not interested in fixing static checker problems in your
> subsystem and don't want to see any patches related to that.

  [x] Fix your changelog. Any commit log that is not self-describing to a
  maintainer like PeterZ is faulty by definition - regardless of any intro
  somewhere else. Changelogs ultimately detach from intros, they will be 
  read by others in the kernel repo, reviewing changes, looking for bugs,
  following development, etc., and if the relevant context is lost then
  that changelog is _BROKEN_. This is kernel development 101.

  [x] You should stop making idiotic excuses for broken changelogs. The
  fact that we had to complain about the quality of your patches and 
  changelogs for years should give you a big, huge hint that the problem 
  is still on your side. Writing snarky responses to maintainer questions 
  does not improve your changelogs, it only wastes PeterZ's, my and other 
  people's time.

Thanks,

	Ingo
