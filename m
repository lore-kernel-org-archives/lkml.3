Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbbAPKFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:05:04 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35519 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbbAPKFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:05:00 -0500
Date: Fri, 16 Jan 2015 10:04:48 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
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
Message-ID: <20150116100447.GB13634@e104818-lin.cambridge.arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <54B8BB24.2020408@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B8BB24.2020408@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 07:17:56AM +0000, Hanjun Guo wrote:
> On 2015年01月16日 02:23, Catalin Marinas wrote:
> > On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
> >> On Wed, Jan 14, 2015 at 3:04 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> >>> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
> >>
> >> I'll get right to the point: Can we please have this series queued up
> >> for v3.20?
> >
> > Before you even ask for this, please look at the patches and realise
> > that there is a complete lack of Reviewed-by tags on the code (well,
> > apart from trivial Kconfig changes). In addition, the series touches on
> > other subsystems like clocksource, irqchip, acpi and I don't see any
> > acks from the corresponding maintainers. So even if I wanted to merge
> 
> For the ACPI part, Rafael already said that "Having looked at the
> patches recently, I don't see any major problems in them from the ACPI
> core perspective, so to me they are good to go." [1]
> Is that kind of ack for this ?

I guess we can call this an "ack" from the ACPI core perspective. But
it's not just ACPI core that this series touches. You should probably
get a renewed ack for the latest series as the message you quoted is 4
months old.

A question that Rafael asked was how you plan to get these merged. You
(or Grant) chose the arm64 maintainers and that's fine by me but it
doesn't mean you don't need acks/reviews for the patches in this series.

-- 
Catalin
