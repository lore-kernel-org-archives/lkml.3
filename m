Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaBNJvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:51:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39916 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaBNJvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:51:48 -0500
Date: Fri, 14 Feb 2014 10:51:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/9] Add MAX_NICE, MIN_NICE and NICE_WIDTH macros in
 prio.h.
Message-ID: <20140214095143.GH27965@twins.programming.kicks-ass.net>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <52FDE06A.1020909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FDE06A.1020909@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 05:22:50PM +0800, Dongsheng Yang wrote:
> Hi Ingo & Peter,
>     What's your opinion on this patchset?

I queued it; I wasn't convinced but people seem to like it, which is
good enough.
