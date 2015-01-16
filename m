Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbbAPM3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:29:31 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35916 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbAPM33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:29:29 -0500
Date: Fri, 16 Jan 2015 12:29:22 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
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
Message-ID: <20150116122922.GO7091@arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <20150115190220.GF3043@sirena.org.uk>
 <20150115200437.GF24989@titan.lakedaemon.net>
 <20150116101034.GC13634@e104818-lin.cambridge.arm.com>
 <20150116120518.GK3043@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116120518.GK3043@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 12:05:18PM +0000, Mark Brown wrote:
> On Fri, Jan 16, 2015 at 10:10:34AM +0000, Catalin Marinas wrote:
> 
> > Indeed, keeping the series as one thread is better. Apart from a
> > slightly less misleading subject, I suggest Hanjun that he passes each
> > patch via get_maintainer.pl and adds the corresponding Cc: lines to the
> > commit log. I think that's a clearer way keep track of who needs to
> > ack/review the patches.
> 
> I'm not saying stop sending them as part of this series, I'm saying it
> might help to get people to look at them if they were also sent
> disassociated from it - in the situations where I end up ignoring things
> that look controversial but unexciting for my bit of it I know I won't
> even bother opening the e-mails since I know it's just going to get
> resent anyway quite often with revisions from whatever makes the rest of
> the series controversial, I expect others will do the same.
> 
> Actually, another thing that might help would be if you and/or Will were
> to prod the relevant people for review, letting them know that the
> controversy isn't likely to affect their bits.

Hmm, we *could*, but having maintainers go round poking other people to
review patches feels like the wrong way round to me. The authors should
be taking ownership of this series and that's half of the problem we
had in previous versions.

It needs to be clear that Hanjun/Al/Graeme are the ones running the show,
not just now, but (even more importantly) when people start building on
top of the base support. If Catalin and I have to go around asking for
review, it sets us off on the wrong foot imo.

Will
