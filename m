Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaHKJxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:53:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaHKJw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:52:59 -0400
Date: Mon, 11 Aug 2014 11:52:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org
Subject: Re: Implement lbr-as-callgraph v9
Message-ID: <20140811095218.GA20085@krava.brq.redhat.com>
References: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 10:17:00AM -0700, Andi Kleen wrote:
> [Forward ported to latest tip/perf/core]
> [Even more review feedback and some bugs addressed.]
> [Only port to changes in perf/core. No other changes.]
> [Rebase to latest perf/core]
> [Another rebase. No changes]
> 
> This patchkit implements lbr-as-callgraphs in per freport,
> as an alternative way to present LBR information.
> 
> Current perf report does a histogram over the branch edges,
> which is useful to look at basic blocks, but doesn't tell
> you anything about the larger control flow behaviour.
> 
> This patchkit adds a new option --branch-history that
> adds the branch paths to the callgraph history instead.
> 
> This allows to reason about individual branch paths leading
> to specific samples.
> 
> Also available at
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/lbr-callgraph4

hi,
does the branch contain the v9?

thanks,
jirka
