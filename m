Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3FYHXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:23:43 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40556 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3FYHXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:23:42 -0400
Date: Tue, 25 Jun 2013 09:23:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, peterz@infradead.org,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: Re: [PATCH] perf, x86: Support full width counting v3
Message-ID: <20130625072338.GA12190@gmail.com>
References: <1372121749-12164-1-git-send-email-andi@firstfloor.org>
 <20130625072212.GA11420@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625072212.GA11420@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Looks good - the changelog needs more work: please first outline the 
> current behavior (how we can only write 32 bit values into the counter, 
> even though the counter range is larger on most CPUs).
> 
> Then also outline the Haswell problems more precisely. What happens, 
> why, with what probability and why do we care?

For the latter it's enough to put a reference like this into the 
changelog:

  See the patch "perf/x86/intel: Avoid checkpointed counters causing 
  excessive TSX aborts" for more details.

Thanks,

	Ingo
