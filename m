Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaBFQqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:46:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53406 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbaBFQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:46:05 -0500
Date: Thu, 6 Feb 2014 17:45:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched/wait: suppress sparse 'variable shadowing' warning
Message-ID: <20140206164558.GV2936@laptop.programming.kicks-ass.net>
References: <20140206111346.712edc04@gandalf.local.home>
 <1391704121.12789.20.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391704121.12789.20.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 05:28:41PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This warning seems to show up a lot now, since ___wait_event()
> is (indirectly) used inside wait_event_timeout(), which also
> has a variable called __ret. Rename the one in ___wait_event()
> to ___ret (another leading underscore) to suppress the warning.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks!
