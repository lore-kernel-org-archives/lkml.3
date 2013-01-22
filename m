Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3AVJrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:47:14 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:57004 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752389Ab3AVJrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:47:12 -0500
Date: Tue, 22 Jan 2013 09:45:17 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zij@mx0.arm.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
Message-ID: <20130122094517.GD12295@mudshark.cambridge.arm.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
 <20130116131318.GF16543@mudshark.cambridge.arm.com>
 <20130116133033.GC1042@krava.brq.redhat.com>
 <20130117102325.GA3699@mudshark.cambridge.arm.com>
 <20130121191325.GB24859@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121191325.GB24859@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 07:13:25PM +0000, Jiri Olsa wrote:
> On Thu, Jan 17, 2013 at 10:23:26AM +0000, Will Deacon wrote:
> > On Wed, Jan 16, 2013 at 01:30:33PM +0000, Jiri Olsa wrote:
> > > On Wed, Jan 16, 2013 at 01:13:18PM +0000, Will Deacon wrote:
> > > > On Tue, Jan 15, 2013 at 01:39:50PM +0000, Jiri Olsa wrote:
> > > > > The formula can currently contain any event from the set::events
> > > > > plus any number (int). There'll be support in future for outside
> > > > > values runtime and other if needed.
> > > > 
> > > > Just to say that I *really* like this idea! If we extended it to include
> > > > other operators then it would help us on ARM, where we often have events
> > > > like 'cache accesses' and 'cache misses' but not 'cache hits'.
> > > 
> > > great, thanks for sharing this
> > > 
> > > The current operators set is just basic one to show the idea,
> > > it can/will be expanded.
> > 
> > Makes sense.
> 
> any particular operators you'd like to see in?

I think the basic: add, subtract, divide operators are the most useful to
start with.

Cheers,

Will
