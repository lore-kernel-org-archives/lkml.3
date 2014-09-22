Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaIVTBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:01:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaIVTBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:01:34 -0400
Date: Mon, 22 Sep 2014 21:01:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mark D Rustad <mark.d.rustad@intel.com>
Cc: sparse@chrisli.org, linux-kernel@vger.kernel.org,
        richard.weinberger@gmail.com, linux-sparse@vger.kernel.org,
        mingo@redhat.com, jeffrey.t.kirsher@intel.com,
        computersforpeace@gmail.com
Subject: Re: [PATCH] sched: Remove nested extern
Message-ID: <20140922190128.GA2805@worktop.programming.kicks-ass.net>
References: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
 <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:55:11AM -0700, Mark D Rustad wrote:
> Avoid W=2 nested-externs warning by moving the nested extern to
> a normal extern. This eliminates that warning which is generated
> for every inclusion of sched.h in a kernel build when W=2 is used.
> This also removes a point of maintenance if the definition of
> delayacct_on were ever to change.
> 

Yeah, so why is that warning worth using? Just disable the warn if
you're bothered by it.
