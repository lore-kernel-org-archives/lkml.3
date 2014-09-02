Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaIBQea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:34:30 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11531 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754468AbaIBQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:34:28 -0400
Date: Tue, 2 Sep 2014 17:34:14 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot
 support
Message-ID: <20140902163414.GJ27056@arm.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
 <1409583475-6978-14-git-send-email-hanjun.guo@linaro.org>
 <5404AE56.80801@arm.com>
 <5405AE95.1020201@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5405AE95.1020201@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:48:37PM +0100, Tomasz Nowicki wrote:
> On 01.09.2014 19:35, Marc Zyngier wrote:
> > On 01/09/14 15:57, Hanjun Guo wrote:
> >> From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> >>
> >> ACPI kernel uses MADT table for proper GIC initialization. It needs to
> >> parse GIC related subtables, collect CPU interface and distributor
> >> addresses and call driver initialization function (which is hardware
> >> abstraction agnostic). In a similar way, FDT initialize GICv1/2.
> >>
> >> NOTE: This commit allow to initialize GICv1/2 only.
> >
> > I cannot help but notice that there is no support for KVM here. It'd be
> > good to add a note to that effect, so that people do not expect
> > virtualization support to be working when booting with ACPI.
> 
> yes, it is worth mentioning!

It's also worth mentioning if there are any plans to fix this ;).

-- 
Catalin
