Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaCFJgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:36:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49264 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaCFJgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:36:46 -0500
Date: Thu, 6 Mar 2014 10:36:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH tip 1/2] sched/fair: Push down check for high priority
 class task into idle_balance()
Message-ID: <20140306093635.GH9987@twins.programming.kicks-ass.net>
References: <1394098315.19290.10.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394098315.19290.10.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 01:31:55PM +0400, Kirill Tkhai wrote:
> We close idle_exit_fair() bracket in case of we've pulled something or we've received
> task of high priority class.
> 

Thanks Kirill.
