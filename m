Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaIQXkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 19:40:43 -0400
Received: from www.xora.org.uk ([80.68.91.202]:58877 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaIQXkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 19:40:42 -0400
Date: Wed, 17 Sep 2014 16:40:36 -0700
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Graeme Gregory <graeme.gregory@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
Message-ID: <20140917234036.GC2464@xora-yoga-13>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <20140917014410.GC31214@srcf.ucam.org>
 <20140917160508.GA2464@xora-yoga-13>
 <201409180122.10631.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409180122.10631.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 01:22:10AM +0200, Arnd Bergmann wrote:
> On Wednesday 17 September 2014, Graeme Gregory wrote:
> > It sounds like from the discussions in other threads that ARM64 should
> > be following x86 and re-using DT bindings here. In which case there is
> > not need to submit things to UEFI organisation.
> > 
> > What I got a little lost in has there been a formal decision about DT
> > bindings in _DSD?
> 
> I think this is a discussion that still needs to happen: either we should
> recommend everyone to use _DSD in favor of the alternatives, or we
> should prohibit the use of _DSD. I have heard arguments both ways, but
> hopefully we can find an easy answer.
> 

This discussion is just not going to happen until people at @redhat.com
and people who have currently announced/released hardware are actually
willing to start talking about it.

Id love to be able to put my foot down and ban the use of _DSD for
servers but I suspect that will not happen.

Graeme

