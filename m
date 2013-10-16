Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653Ab3JPUOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:14:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36185 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761477Ab3JPUOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:14:22 -0400
Date: Wed, 16 Oct 2013 22:14:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131016201410.GA26785@twins.programming.kicks-ass.net>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
 <1381949500-501-2-git-send-email-treding@nvidia.com>
 <20131016200645.GD10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016200645.GD10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:06:45PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 16, 2013 at 08:51:39PM +0200, Thierry Reding wrote:
> > Today's linux-next merge of the tip tree got a conflict in
> > 
> > 	include/linux/wait.h
> > 
> > caused by commits 1ab2460 (wait: add wait_event_cmd()) and fb869b6
> > (sched/wait: Clean up wait.h details a bit).
> 
> Gargh, where did that come from?!

Also, wth does that live?


# git show 1ab2460
fatal: ambiguous argument '1ab2460': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
# git remote show next
* remote next
  Fetch URL: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

And I made sure to update the remote.
