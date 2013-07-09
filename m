Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3GIHlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:41:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48809 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3GIHlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:41:36 -0400
Date: Tue, 9 Jul 2013 09:40:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, eranian@google.com, ak@linux.intel.com
Subject: Re: [PATCH] perf: Update event buffer tail when overwriting old
 events
Message-ID: <20130709074046.GF25631@dyad.programming.kicks-ass.net>
References: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com>
 <20130708121557.GA17211@twins.programming.kicks-ass.net>
 <87vc4kxnmb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc4kxnmb.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 03:18:20PM +0900, Namhyung Kim wrote:
> Hi Peter,
> 
> On Mon, 8 Jul 2013 14:15:57 +0200, Peter Zijlstra wrote:
> [SNIP]
> > +static void 
> > +perf_event_set_overflow(struct perf_event *event, struct ring_buffer *rb)
> > +{
> > +	if (event->overflow_handler != perf_event_output ||
> 
> I guess you wanted "&&" instead of "||" here.

Uhm.. yeah. /me dons the brown paper bag.
