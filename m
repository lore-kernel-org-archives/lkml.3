Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3JHKry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:47:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33932 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3JHKrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:47:53 -0400
Date: Tue, 8 Oct 2013 12:47:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of
 dwarf parsing feature
Message-ID: <20131008104740.GU3081@twins.programming.kicks-ass.net>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
 <1380195398-4402-4-git-send-email-jean.pihet@linaro.org>
 <20130926124829.GA3284@krava.brq.redhat.com>
 <CAFrcx1nDe6mhxEuU4ROJGOmGFaYtVnnhXYirkmhRb1NEecNhtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1nDe6mhxEuU4ROJGOmGFaYtVnnhXYirkmhRb1NEecNhtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 12:44:32PM +0200, Jean Pihet wrote:
> Hi,
> 
> On 26 September 2013 14:48, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Thu, Sep 26, 2013 at 01:36:37PM +0200, Jean Pihet wrote:
> >> The newly added dwarf unwinding feature [1] requires:
> >> . a recent version (>= 1.1) of libunwind,
> >> . libunwind to be configured with --enable-debug-frame.
> >>
> >> [1] http://www.spinics.net/lists/kernel/msg1598951.html
> >>
> >> Add the corresponding API tests in the feature check list.
> >
> > Acked-by: Jiri Olsa <jolsa@redhat.com>
> >
> > thanks,
> > jirka
> 
> Thanks for the ack!
> 
> Is it possible to get an ack from the perf core maintainers?
> Also, is the patch going in Will's tree?

This being a tools patch you'd have to ask acme; also I know next to
nothing about all this unwind business except that its stupid expensive
;-)
