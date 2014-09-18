Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaIRPy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:54:56 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34270 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaIRPyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:54:54 -0400
Date: Thu, 18 Sep 2014 16:54:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
Message-ID: <20140918155439.GA25330@e104818-lin.cambridge.arm.com>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <20140917014410.GC31214@srcf.ucam.org>
 <20140917160508.GA2464@xora-yoga-13>
 <201409180122.10631.arnd@arndb.de>
 <20140917234036.GC2464@xora-yoga-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917234036.GC2464@xora-yoga-13>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:40:36AM +0100, Graeme Gregory wrote:
> On Thu, Sep 18, 2014 at 01:22:10AM +0200, Arnd Bergmann wrote:
> > On Wednesday 17 September 2014, Graeme Gregory wrote:
> > > It sounds like from the discussions in other threads that ARM64 should
> > > be following x86 and re-using DT bindings here. In which case there is
> > > not need to submit things to UEFI organisation.
> > > 
> > > What I got a little lost in has there been a formal decision about DT
> > > bindings in _DSD?
> > 
> > I think this is a discussion that still needs to happen: either we should
> > recommend everyone to use _DSD in favor of the alternatives, or we
> > should prohibit the use of _DSD. I have heard arguments both ways, but
> > hopefully we can find an easy answer.
> 
> This discussion is just not going to happen until people at @redhat.com
> and people who have currently announced/released hardware are actually
> willing to start talking about it.

OTOH, there doesn't seem to be any urgency for merging arm64 ACPI
support, so this discussion can wait ;).

> Id love to be able to put my foot down and ban the use of _DSD for
> servers but I suspect that will not happen.

And the alternative would be hard-coded platform specific configuration
(or we assume that such configuration isn't needed)?

-- 
Catalin
