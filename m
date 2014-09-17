Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbaIQT7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:59:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52889 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbaIQT7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:59:48 -0400
Date: Wed, 17 Sep 2014 20:59:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
Message-ID: <20140917195932.GA21910@srcf.ucam.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <4416582.iOjLNrLDZE@vostro.rjw.lan>
 <20140917192259.GA18980@srcf.ucam.org>
 <1628662.T2ReQ4irMm@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628662.T2ReQ4irMm@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:11:13PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, September 17, 2014 08:22:59 PM Matthew Garrett wrote:
> > Using the information should be fine, but my understanding of the UEFI 
> > forum rules is that any submissions to UEFI specs must be from UEFI 
> > forum members - there are concerns around accidentally including 
> > patented material.
> 
> The documents in question are not regarded as UEFI specs, however.  They
> are just hosted by UEFI.

There's arguably some precedent for that - the ACPI vendor IDs and EFI 
System Partition name repositories are hosted rather than specs. But it 
seems like there's some qualitative difference between that kind of raw 
data and something that actually defines behaviour. But if the UEFI 
people feel comfortable with this, it's not a problem.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
