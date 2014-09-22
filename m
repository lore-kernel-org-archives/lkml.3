Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaIVXIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:08:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43126 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbaIVXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:08:12 -0400
Date: Tue, 23 Sep 2014 00:07:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Al Stone <ahs3@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, linaro-acpi@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Jon Masters <jcm@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
Message-ID: <20140922230758.GA11987@srcf.ucam.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <20140922194841.GA9868@amd>
 <20140922203136.GA32156@srcf.ucam.org>
 <2486199.jzqMgLksH8@vostro.rjw.lan>
 <5420A8F4.20909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5420A8F4.20909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 04:55:48PM -0600, Al Stone wrote:

> Exactly so.  Or, collaborate with the hardware vendor, or a distro
> or anyone else that is a Promoter or Contributor as defined by UEFI
> [0].  The only thing to keep clear when doing so is who owns the
> intellectual property for any proposed change; this is one of the
> reasons the UEFI Forum has paid membership levels -- to pay for the
> legal assistance to make sure that the specs can be freely used.  As
> someone who is part of the ASWG, I'd personally be glad to help out
> however I can in this regard.

No, it's not about IP ownership, it's about whether those contributing 
the IP have waived patent rights. All contributors to a UEFI spec must 
be members - it's not acceptable for a member to contribute material on 
behalf of a non-member.

> I'm also curious as to what's being referred to as ACPI support
> code for large x86 vendors which is not part of the spec; I *think*
> I know what's being described but a specific example would really
> help me understand better.

Almost everything in drivers/platform/x86, the ACPI support code under 
drivers/gpu, the PCC code for HP servers, some of the USB-ACPI glue 
(defined by a Microsoft spec), some of the ACPI/TPM integration (defined 
by TCG), some hwmon code, probably a few other bits and pieces.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
