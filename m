Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaGVKL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:11:29 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35615 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752391AbaGVKL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:11:27 -0400
Message-ID: <1406023886.25343.48.camel@hornet>
Subject: Re: [PATCH v2] bus: ARM CCN PMU driver
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org
Cc: Mark Rutland <Mark.Rutland@arm.com>,
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
Date: Tue, 22 Jul 2014 11:11:26 +0100
In-Reply-To: <1405091188-31754-1-git-send-email-pawel.moll@arm.com>
References: <1405091188-31754-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, Kevin, Olof, 

On Fri, 2014-07-11 at 16:06 +0100, Pawel Moll wrote:
> Driver providing perf backend for ARM Cache Coherent Network
> interconnect. Supports counting all hardware events and crosspoint
> watchpoints.
> 
> Currently works with CCN-504 only, although there should be
> no changes required for CCN-508 (just impossible to test it now).
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Would you consider taking this through arm-soc tree? There isn't
anything in MAINTAINERS, but I vaguely remember Arnd proposing this
directory in the first place...

Cheers!

Pawel

