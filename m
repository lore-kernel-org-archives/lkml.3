Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbbA0QrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:47:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:39497 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbbA0QrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:47:18 -0500
Date: Tue, 27 Jan 2015 17:47:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 3/5] sched/deadline: Fix wrong cpudl_find() in
 check_preempt_equal_dl()
Message-ID: <20150127164716.GH21418@twins.programming.kicks-ass.net>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
 <1421642980-10045-3-git-send-email-pang.xunlei@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421642980-10045-3-git-send-email-pang.xunlei@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 04:49:38AM +0000, Xunlei Pang wrote:
> In check_preempt_equal_dl(), cpudl_find() is called with a NULL
> later_mask, thus cpudl_find() here doesn't check cpudl::free_cpus
> at all.
> 
> This patch takles this issue by always passing a non-NULL later_mask
> to cpudl_find(), thereby fixing this issue.

Fix what issue? Afaict this is an optimization not a fix.
