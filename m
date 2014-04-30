Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbaD3GGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:06:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55736 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaD3GGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:06:35 -0400
Date: Wed, 30 Apr 2014 08:06:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Subject: Re: [PATCH] lib/spinlock_debug: avoid one thread can not obtain the
 spinlock for a long time.
Message-ID: <20140430060625.GV11096@twins.programming.kicks-ass.net>
References: <1398877471.21870.6.camel@wxm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398877471.21870.6.camel@wxm-ubuntu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 01:04:31PM -0400, Wang, Xiaoming wrote:
> loops_per_jiffy is larger than expectation that possible
> causes one thread can not obtain the spin lock for a long time.
> So use cpu_clock() to reach timeout in one second which can
> avoid HARD LOCKUP.

This is just not making sense.. one thing is broken so then you tape on
another? Fix the first already.

Also, why do you care?
