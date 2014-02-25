Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaBYLj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:39:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBYLj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:39:56 -0500
Date: Tue, 25 Feb 2014 12:39:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 0/7] Perf core cleanups for shared perf_event_contexts
Message-ID: <20140225113953.GP9987@twins.programming.kicks-ass.net>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <20140219134340.GB19774@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219134340.GB19774@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:43:41PM +0000, Mark Rutland wrote:
> While you have concerns with the later patches in the series, do you
> have any concerns with teh first three (as below), or would you be happy
> to take them?

I've taken 1 and 2. I can take 3 if you confirm and update its
Changelog.

Thanks!
