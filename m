Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaDOQvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:51:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55407 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaDOQvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:51:51 -0400
Date: Tue, 15 Apr 2014 18:51:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, chegu_vinod@hp.com,
        mgorman@suse.de
Subject: Re: [PATCH 3/3] sched,numa: do not set preferred_node on migration
 to a second choice node
Message-ID: <20140415165142.GZ11096@twins.programming.kicks-ass.net>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
 <1397235629-16328-4-git-send-email-riel@redhat.com>
 <20140414125635.GE11182@twins.programming.kicks-ass.net>
 <534D43B1.9020405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D43B1.9020405@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:35:29AM -0400, Rik van Riel wrote:
> I have looked at the comment and the changelog some
> more, and it is not clear to me what you are missing,
> or what I could be explaining better...

Yeah, can't blame you. I couldn't explain myself either, other than
having this feeling there's something there.

In any case, I can't blame you for that, and I did queue the patches.
