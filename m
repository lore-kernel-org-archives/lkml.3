Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaILUED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:04:03 -0400
Received: from www.xora.org.uk ([80.68.91.202]:46887 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaILUEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:04:00 -0400
Date: Fri, 12 Sep 2014 21:03:55 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Jon Masters <jcm@redhat.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, linaro-acpi@lists.linaro.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Lv Zheng <lv.zheng@intel.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Charles.Garcia-Tobin@arm.com
Subject: Re: [PATCH v4 05/18] ARM64 / ACPI: Introduce sleep-arm.c
Message-ID: <20140912200355.GD9234@xora-haswell.xora.org.uk>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-6-git-send-email-hanjun.guo@linaro.org>
 <54134CE8.8070506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54134CE8.8070506@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 03:43:36PM -0400, Jon Masters wrote:
> On 09/12/2014 10:00 AM, Hanjun Guo wrote:
> > From: Graeme Gregory <graeme.gregory@linaro.org>
> > 
> > ACPI 5.1 does not currently support S states for ARM64 hardware but
> > ACPI code will call acpi_target_system_state() for device power
> > managment, so introduce sleep-arm.c to allow other drivers to function
> > until S states are defined.
> 
> Aside: ACPI5.1 does define the Platform Communication Channel and CPC
> (Collaborative Processor Performance Control). Some details need to be
> fleshed out there for practical 64-bit ARMv8 server systems, but the
> underpinnings and mechanisms are in place in the 5.1 specification that
> can be built upon over time to achieve practical S-State equivalence.
> 
Disagree, S-States are about going to sleep or hibernating, that is
nothing to do with CPU Performance.

Graeme

