Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3LTEsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:48:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab3LTEsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:48:53 -0500
Date: Thu, 19 Dec 2013 23:48:26 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] pid: change task_struct::pid to read-only
Message-ID: <20131220044826.GF14944@madcap2.tricolour.ca>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
 <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
 <20131217095801.GF21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217095801.GF21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/17, Peter Zijlstra wrote:
> On Mon, Dec 16, 2013 at 04:03:38PM -0500, Richard Guy Briggs wrote:
> > task->pid is only ever assigned once (well ok, twice).  For system health and
> > secure logging confidence, make it const to make it much more intentional when
> > it is being changed.
> > ---
> > 
> > Peter, as you had suggested, does this approach work for you in terms of making
> > task_struct::pid a lot more difficult to accidentally change to try to preserve
> > its integrity?
> 
> Yeah, looks good to me.

Ok, who would carry this patch?  You?  AKPM?  Me?

Any opinions about Oleg's macro idea?

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
