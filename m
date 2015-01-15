Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbbAOUwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:52:09 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26344 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752164AbbAOUwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:52:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+xgJqslCdhwphtGwPkhnmnOUDnIm+/R20=
X-DKIM: OpenDKIM Filter v2.0.1 titan 26CD864759F
Date: Thu, 15 Jan 2015 15:51:39 -0500
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
Message-ID: <20150115205139.GG24989@titan.lakedaemon.net>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <20150115190220.GF3043@sirena.org.uk>
 <20150115200437.GF24989@titan.lakedaemon.net>
 <20150115203159.GG3043@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115203159.GG3043@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 08:31:59PM +0000, Mark Brown wrote:
> On Thu, Jan 15, 2015 at 03:04:37PM -0500, Jason Cooper wrote:
> > On Thu, Jan 15, 2015 at 07:02:20PM +0000, Mark Brown wrote:
> 
> > > There's probably a bit of a process problem here - these patches are all
> > > being posted as part of big and apparently controversial threads with
> > > subject lines in the form "ARM / ACPI:" so people could be forgiven for
> > > just not even reading the e-mails enough to notice changes to their
> > > subsystems.  Is it worth posting those patches separately more directly
> > > to the relevant maintainers?
> 
> > I think it's beneficial to post the entire series as one thread, but to
> > change the subject line of each patch to adequately reflect the affected
> > subsystem.
> 
> Just changing the subject lines to be more suitable would help, but
> given the painful thread it's probably worth going the extra step if
> the lack of these reviews is a causing problems - I know that even with
> a suitable subject line if I'm busy then I'm fairly likely to zone out
> something in the middle a big series that doesn't seem to be going
> anywhere.

True, I was merely expressing a preference.  A lot of series containing
irqchip changes tend to have build dependencies outside of
drivers/irqchip. So I like to see the whole picture to decide how best
to handle the patches.

I suppose the ideal solution would be to have a "mute sub-thread" option
in the MUA.  But that doesn't help us today.  :)

Whichever way they do it is fine by me.

thx,

Jason.
