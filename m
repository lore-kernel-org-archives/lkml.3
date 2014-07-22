Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaGVQIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:08:50 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:44303 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaGVQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:08:49 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1406023886.25343.48.camel@hornet>
References: <1405091188-31754-1-git-send-email-pawel.moll@arm.com>
	<1406023886.25343.48.camel@hornet>
Date: Tue, 22 Jul 2014 09:08:44 -0700
Message-ID: <CAOesGMijrD6SxAyjvQptmAB8swqcvXNkiVS_nRCtUVtX2vYUFQ@mail.gmail.com>
Subject: Re: [PATCH v2] bus: ARM CCN PMU driver
From: Olof Johansson <olof@lixom.net>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 3:11 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> Hi Arnd, Kevin, Olof,
>
> On Fri, 2014-07-11 at 16:06 +0100, Pawel Moll wrote:
>> Driver providing perf backend for ARM Cache Coherent Network
>> interconnect. Supports counting all hardware events and crosspoint
>> watchpoints.
>>
>> Currently works with CCN-504 only, although there should be
>> no changes required for CCN-508 (just impossible to test it now).
>>
>> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
>
> Would you consider taking this through arm-soc tree? There isn't
> anything in MAINTAINERS, but I vaguely remember Arnd proposing this
> directory in the first place...

Yeah, drivers/bus lacks an owner and we've normally been the ones
merging them. Please send a fresh version of the patch over.


-Olof
