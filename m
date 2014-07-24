Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbaGXOpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:45:50 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20303 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759007AbaGXOpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:45:49 -0400
Message-ID: <1406213141.25343.175.camel@hornet>
Subject: Re: [PATCH RESEND v2] bus: ARM CCN PMU driver
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        arm@kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 24 Jul 2014 15:45:41 +0100
In-Reply-To: <39594081.3C5fmmXpMJ@wuerfel>
References: <1406050379-15199-1-git-send-email-pawel.moll@arm.com>
	 <201407232223.39341.arnd@arndb.de> <39594081.3C5fmmXpMJ@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 23:29 +0200, Arnd Bergmann wrote:
> On Wednesday 23 July 2014 22:23:38 Arnd Bergmann wrote:
> > On Tuesday 22 July 2014, Pawel Moll wrote:
> > > Driver providing perf backend for ARM Cache Coherent Network
> > > interconnect. Supports counting all hardware events and crosspoint
> > > watchpoints.
> > > 
> > > Currently works with CCN-504 only, although there should be
> > > no changes required for CCN-508 (just impossible to test it now).
> > > 
> > > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > 
> > Applied to next/drivers, thanks!
> 
> I'm getting build errors with CONFIG_PERF_EVENTS disabled. 
> Is the patch below the right answer, or should we still load
> the driver and #ifdef the perf-events code?
> 
> It seems to me that the driver doesn't do anything besides
> perf events, but I could be missing something.

No, you're right. At the moment this is only a PMU driver, and I don't
expect this would change any time soon, so your change will do the job,
thanks!

Pawel

