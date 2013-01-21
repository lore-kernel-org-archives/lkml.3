Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3AUTOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:14:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab3AUTOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:14:05 -0500
Date: Mon, 21 Jan 2013 20:13:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zij@mx0.arm.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
Message-ID: <20130121191325.GB24859@krava.brq.redhat.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
 <20130116131318.GF16543@mudshark.cambridge.arm.com>
 <20130116133033.GC1042@krava.brq.redhat.com>
 <20130117102325.GA3699@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130117102325.GA3699@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:23:26AM +0000, Will Deacon wrote:
> On Wed, Jan 16, 2013 at 01:30:33PM +0000, Jiri Olsa wrote:
> > On Wed, Jan 16, 2013 at 01:13:18PM +0000, Will Deacon wrote:
> > > On Tue, Jan 15, 2013 at 01:39:50PM +0000, Jiri Olsa wrote:
> > > > The formula can currently contain any event from the set::events
> > > > plus any number (int). There'll be support in future for outside
> > > > values runtime and other if needed.
> > > 
> > > Just to say that I *really* like this idea! If we extended it to include
> > > other operators then it would help us on ARM, where we often have events
> > > like 'cache accesses' and 'cache misses' but not 'cache hits'.
> > 
> > great, thanks for sharing this
> > 
> > The current operators set is just basic one to show the idea,
> > it can/will be expanded.
> 
> Makes sense.

any particular operators you'd like to see in?

jirka
