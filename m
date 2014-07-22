Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaGVQ3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:29:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35907 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752896AbaGVQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:29:30 -0400
Message-ID: <1406046564.25343.74.camel@hornet>
Subject: Re: [PATCH v2] bus: ARM CCN PMU driver
From: Pawel Moll <pawel.moll@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        "arm@kernel.org" <arm@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Kumar Gala <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 22 Jul 2014 17:29:24 +0100
In-Reply-To: <CAOesGMijrD6SxAyjvQptmAB8swqcvXNkiVS_nRCtUVtX2vYUFQ@mail.gmail.com>
References: <1405091188-31754-1-git-send-email-pawel.moll@arm.com>
	 <1406023886.25343.48.camel@hornet>
	 <CAOesGMijrD6SxAyjvQptmAB8swqcvXNkiVS_nRCtUVtX2vYUFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 09:08 -0700, Olof Johansson wrote:
> On Tue, Jul 22, 2014 at 3:11 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> > Hi Arnd, Kevin, Olof,
> >
> > On Fri, 2014-07-11 at 16:06 +0100, Pawel Moll wrote:
> >> Driver providing perf backend for ARM Cache Coherent Network
> >> interconnect. Supports counting all hardware events and crosspoint
> >> watchpoints.
> >>
> >> Currently works with CCN-504 only, although there should be
> >> no changes required for CCN-508 (just impossible to test it now).
> >>
> >> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> >
> > Would you consider taking this through arm-soc tree? There isn't
> > anything in MAINTAINERS, but I vaguely remember Arnd proposing this
> > directory in the first place...
> 
> Yeah, drivers/bus lacks an owner and we've normally been the ones
> merging them. Please send a fresh version of the patch over.

I've just rebased in on top of v3.16-rc6 and there's no change
whatsoever (which is a good thing, I guess), so I can send v3, but the
"changes since v2" will say "nothing" :-)

Thanks!

Pawel

