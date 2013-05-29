Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965770Ab3E2LQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:16:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51413 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965590Ab3E2LQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:16:34 -0400
Date: Wed, 29 May 2013 13:16:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130529111628.GH12193@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-8-git-send-email-sasha.levin@oracle.com>
 <20130522092711.GI18810@twins.programming.kicks-ass.net>
 <51A507BE.5060001@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A507BE.5060001@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 03:38:38PM -0400, Sasha Levin wrote:
> On 05/22/2013 05:27 AM, Peter Zijlstra wrote:
> > I guess that begs the question do we really want to support !glibc?
> 
> I assumed we didn't want to give up on that based on your patch. I think that
> if we plan to get it into tools/lib/ we shouldn't give up on that straight away.

Ok, I suppose we'll find out quickly when people are trying this with
other libc implementations and creative malloc/lock setups.
