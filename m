Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaIQB5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:57:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43812 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaIQB5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:57:43 -0400
Date: Wed, 17 Sep 2014 02:57:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linaro-acpi@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Charles.Garcia-Tobin@arm.com,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Jon Masters <jcm@redhat.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
Message-ID: <20140917015734.GD31214@srcf.ucam.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-19-git-send-email-hanjun.guo@linaro.org>
 <20140917014410.GC31214@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917014410.GC31214@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 02:44:10AM +0100, Matthew Garrett wrote:
> On Fri, Sep 12, 2014 at 10:00:16PM +0800, Hanjun Guo wrote:
> > +No code shall be accepted into the kernel unless it complies with the released
> > +standards from UEFI ASWG. If there are features missing from ACPI to make it
> > +function on a platform, ECRs should be submitted to ASWG and go through the
> > +approval process.
> 
> Similar question here. Is the expectation that all ARM vendors will 
> become UEFI contributors?

I should also add that this is inconsistent with how we've managed 
things in the x86 world - there's a great deal of ACPI functionality 
implemented that's not covered in the spec.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
