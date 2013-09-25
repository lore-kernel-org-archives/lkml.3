Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3IYF41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 01:56:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38007 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3IYF40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 01:56:26 -0400
Date: Wed, 25 Sep 2013 07:55:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v5 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
Message-ID: <20130925055556.GA3081@twins.programming.kicks-ass.net>
References: <cover.1380057198.git.tim.c.chen@linux.intel.com>
 <1380061366.3467.54.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380061366.3467.54.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 03:22:46PM -0700, Tim Chen wrote:
> We will need the MCS lock code for doing optimistic spinning for rwsem.
> Extracting the MCS code from mutex.c and put into its own file allow us
> to reuse this code easily for rwsem.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  kernel/mutex.c |   58 ++++++-------------------------------------------------
>  1 files changed, 7 insertions(+), 51 deletions(-)

Wasn't this patch supposed to add include/linux/mcslock.h ?
