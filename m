Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaGVQbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:31:04 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:40877 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaGVQbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:31:03 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1406046564.25343.74.camel@hornet>
References: <1405091188-31754-1-git-send-email-pawel.moll@arm.com>
	<1406023886.25343.48.camel@hornet>
	<CAOesGMijrD6SxAyjvQptmAB8swqcvXNkiVS_nRCtUVtX2vYUFQ@mail.gmail.com>
	<1406046564.25343.74.camel@hornet>
Date: Tue, 22 Jul 2014 09:30:57 -0700
Message-ID: <CAOesGMjdB=--6xfB4JKLiCSX2Hc-zLyAd6isNwMa2GwURJGAzg@mail.gmail.com>
Subject: Re: [PATCH v2] bus: ARM CCN PMU driver
From: Olof Johansson <olof@lixom.net>
To: Pawel Moll <pawel.moll@arm.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 9:29 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> On Tue, 2014-07-22 at 09:08 -0700, Olof Johansson wrote:
>> On Tue, Jul 22, 2014 at 3:11 AM, Pawel Moll <pawel.moll@arm.com> wrote:
>> > Hi Arnd, Kevin, Olof,
>> >
>> > On Fri, 2014-07-11 at 16:06 +0100, Pawel Moll wrote:
>> >> Driver providing perf backend for ARM Cache Coherent Network
>> >> interconnect. Supports counting all hardware events and crosspoint
>> >> watchpoints.
>> >>
>> >> Currently works with CCN-504 only, although there should be
>> >> no changes required for CCN-508 (just impossible to test it now).
>> >>
>> >> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
>> >
>> > Would you consider taking this through arm-soc tree? There isn't
>> > anything in MAINTAINERS, but I vaguely remember Arnd proposing this
>> > directory in the first place...
>>
>> Yeah, drivers/bus lacks an owner and we've normally been the ones
>> merging them. Please send a fresh version of the patch over.
>
> I've just rebased in on top of v3.16-rc6 and there's no change
> whatsoever (which is a good thing, I guess), so I can send v3, but the
> "changes since v2" will say "nothing" :-)

[PATCH RESEND v2] is the normal way to do it, but sure you can post a v3 too. ;)


-Olof
