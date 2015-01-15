Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbbAOUFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:05:20 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22012 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751959AbbAOUFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:05:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19r9oW+VR96Iz5fAROS2qOCbpalpe0HeuQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 318FA64751A
Date: Thu, 15 Jan 2015 15:04:37 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Message-ID: <20150115200437.GF24989@titan.lakedaemon.net>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <20150115190220.GF3043@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115190220.GF3043@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 07:02:20PM +0000, Mark Brown wrote:
> On Thu, Jan 15, 2015 at 06:23:47PM +0000, Catalin Marinas wrote:
> > On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
> 
> > > I'll get right to the point: Can we please have this series queued up
> > > for v3.20?
> 
> > Before you even ask for this, please look at the patches and realise
> > that there is a complete lack of Reviewed-by tags on the code (well,
> > apart from trivial Kconfig changes). In addition, the series touches on
> > other subsystems like clocksource, irqchip, acpi and I don't see any
> > acks from the corresponding maintainers. So even if I wanted to merge
> > the series, there is no way it can be done without additional
> > reviews/acks. On the document (last patch), I'd like to see a statement
> 
> There's probably a bit of a process problem here - these patches are all
> being posted as part of big and apparently controversial threads with
> subject lines in the form "ARM / ACPI:" so people could be forgiven for
> just not even reading the e-mails enough to notice changes to their
> subsystems.  Is it worth posting those patches separately more directly
> to the relevant maintainers?

I think it's beneficial to post the entire series as one thread, but to
change the subject line of each patch to adequately reflect the affected
subsystem.

thx,

Jason.
