Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbaDHOsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:48:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37450 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbaDHOss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:48:48 -0400
Date: Tue, 8 Apr 2014 10:49:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        kpreempt-tech@lists.sourceforge.net
Subject: Re: Soft lockup regression since kernel 3.13
Message-ID: <20140408084935.GM11096@twins.programming.kicks-ass.net>
References: <20140402232948.GA4725@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402232948.GA4725@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 04:29:48PM -0700, David Cohen wrote:
> Is this a known issue being worked currently?

Yah; could you try current linus.git ? Others report that that tree now
works and I think I know what it the root cause of all this.

All I need to do is figure out a sane patch for .13 and .14 :/
