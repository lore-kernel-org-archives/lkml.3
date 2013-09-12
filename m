Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3ILM24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:28:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64496 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176Ab3ILM2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:28:54 -0400
Date: Thu, 12 Sep 2013 13:28:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 0/3] perf: parse the dwarf backtrace info from
 .debug_frame section
Message-ID: <20130912122805.GG15357@mudshark.cambridge.arm.com>
References: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1mQ-P7byYfqP-0bYabUzTDeSWyHFx2FJQ6wQLYEcV_Pxw@mail.gmail.com>
 <20130912121953.GX31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912121953.GX31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 01:19:53PM +0100, Peter Zijlstra wrote:
> On Thu, Sep 12, 2013 at 02:07:23PM +0200, Jean Pihet wrote:
> > Hi,
> > 
> > -- Adding more maintainers in the To: list --
> > 
> > Ping about the patch set, is this one acceptable for mainline?
> 
> The below looks to be mostly ARM bits and I would suspect Will to take
> care of them.

I wrote those bits too, so I'm happy to take them via my tree. I'd rather
wait for the last patch to have an ack from somebody like Acme (or for them
to take it in the tip/perf tree) before I push anything though.

Cheers,

Will
