Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162667AbaDCIvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:51:49 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51558 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1162636AbaDCIvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:51:45 -0400
Date: Thu, 3 Apr 2014 09:51:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
Message-ID: <20140403085120.GB17022@arm.com>
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org>
 <5334078A.9010408@arm.com>
 <53341ADF.2050904@linaro.org>
 <2765234.k5FCzWzCDz@vostro.rjw.lan>
 <533D1D5E.20208@linaro.org>
 <CAOh2x=nYWjB+Org6eNjQAT93ZX2DRHNYSJWgWTo8vS2AmdrAbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x=nYWjB+Org6eNjQAT93ZX2DRHNYSJWgWTo8vS2AmdrAbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 09:41:57AM +0100, Viresh Kumar wrote:
> On Thu, Apr 3, 2014 at 2:05 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> > How about the following patch? if it is ok, I will resend it.
> 
> http://www.spinics.net/lists/arm-kernel/msg319545.html

I can see commit 62d1a3ba5adc5653d43f6cd3a90758bb6ad5d5bd (arm64: Fix
duplicated Kconfig entries again) already in mainline, so problem
solved.

Thanks Josh ;)

-- 
Catalin
