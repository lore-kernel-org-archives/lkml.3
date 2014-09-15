Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaIOO45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:56:57 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:32996 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaIOO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:56:55 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 10:56:55 EDT
Date: Mon, 15 Sep 2014 15:56:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jon Masters <jcm@redhat.com>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
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
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 11/18] ARM64 / ACPI: Parse MADT for SMP initialization
Message-ID: <20140915145630.GE5415@arm.com>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-12-git-send-email-hanjun.guo@linaro.org>
 <54134DB4.6010705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54134DB4.6010705@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 08:47:00PM +0100, Jon Masters wrote:
> On 09/12/2014 10:00 AM, Hanjun Guo wrote:
> > MADT contains the information for MPIDR which is essential for
> > SMP initialization, parse the GIC cpu interface structures to
> > get the MPIDR value and map it to cpu_logical_map(), and add
> > enabled cpu with valid MPIDR into cpu_possible_map.
> > 
> > ACPI 5.1 only has two explicit methods to boot up SMP, PSCI and
> > Parking protocol, but the Parking protocol is only specified for
> > ARMv7 now, so make PSCI as the only way for the SMP boot protocol
> > before some updates for the ACPI spec or the Parking protocol spec.
> 
> As an aside, initial support for the Parking Protocol is working on test
> systems within Red Hat at this time.

BTW, have the details of the parking protocol been updated for ARMv8
yet?

-- 
Catalin
