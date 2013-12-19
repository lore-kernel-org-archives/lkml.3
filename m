Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab3LSKeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:34:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46631 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3LSKeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:34:13 -0500
Date: Thu, 19 Dec 2013 11:34:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: BUG: MAX_LOCKDEP_ENTRIES too low!
Message-ID: <20131219103401.GE30183@twins.programming.kicks-ass.net>
References: <52B289F4.7060205@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B289F4.7060205@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 12:53:56AM -0500, Sasha Levin wrote:
> Hi all,
> 
> I think that my bloated kernel managed to create way too many entries in the
> dependency table. If that sounds right, I can send a patch to increase those.
> 
> Attached /proc/lock_stat as requested as well.

/proc/lockdep_stats not lock_stat :-)

Do you still happen to have that?
