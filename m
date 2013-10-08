Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3JHOcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:32:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39564 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128Ab3JHOcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:32:33 -0400
Date: Tue, 8 Oct 2013 15:31:32 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jean Pihet <jean.pihet@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of
 dwarf parsing feature
Message-ID: <20131008143131.GA21189@mudshark.cambridge.arm.com>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
 <1380195398-4402-4-git-send-email-jean.pihet@linaro.org>
 <20130926124829.GA3284@krava.brq.redhat.com>
 <CAFrcx1nDe6mhxEuU4ROJGOmGFaYtVnnhXYirkmhRb1NEecNhtw@mail.gmail.com>
 <20131008104740.GU3081@twins.programming.kicks-ass.net>
 <CAFrcx1kNONpBcsEHX1PN0kNUCOAkBCid+bgbv3mc0TPu=F+MYg@mail.gmail.com>
 <20131008142830.GI4018@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008142830.GI4018@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 03:28:30PM +0100, Arnaldo Carvalho de Melo wrote:
> Em Tue, Oct 08, 2013 at 04:15:40PM +0200, Jean Pihet escreveu:
> > >> On 26 September 2013 14:48, Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > >> > Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> > -- adding Arnaldo in the loop --
> > Arnaldo, are you OK with the changes [1]? Jiri acked the patches
> > already; Will is willing (no pun intended) to take the ARM specific
> > patches [2] in his tree.
> 
> As Jiri acked, go ahead and pick as much as you can via Will's tree, I'd
> say. :-)

Cheers guys, that suits me!

Will
