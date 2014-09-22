Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaIVW0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:26:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59999 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754863AbaIVW0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:26:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Hanjun Guo <hanjun.guo@linaro.org>,
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
Date: Tue, 23 Sep 2014 00:46:24 +0200
Message-ID: <2486199.jzqMgLksH8@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140922203136.GA32156@srcf.ucam.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <20140922194841.GA9868@amd> <20140922203136.GA32156@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 22, 2014 09:31:36 PM Matthew Garrett wrote:
> On Mon, Sep 22, 2014 at 09:48:41PM +0200, Pavel Machek wrote:
> > On Fri 2014-09-12 22:00:16, Hanjun Guo wrote:
> > > +No code shall be accepted into the kernel unless it complies with the released
> > > +standards from UEFI ASWG. If there are features missing from ACPI to make it
> > > +function on a platform, ECRs should be submitted to ASWG and go through the
> > > +approval process.
> > 
> > Surely this should be narrowed down somehow? Or is reading all the
> > released standards from ASWG mandatory before patching the kernel now?
> > 
> > Spelling out wtf ECR is would be nice, too.
> 
> Explicit Change Request. These can only be filed by paid-up members of 
> the UEFI Forum, so I suspect this requirement is going to be unworkable 
> (there's plenty of ACPI support code for large x86 vendors which isn't 
> part of any ACPI spec).

Why do you think so?

Linux Foundation can do that on behalf of the community if no one else.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
