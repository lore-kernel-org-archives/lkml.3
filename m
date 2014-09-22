Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaIVXCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:02:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63934 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754754AbaIVXCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:02:39 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
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
Date: Tue, 23 Sep 2014 01:22:25 +0200
Message-ID: <3015103.TVl3N7ml2X@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5420A402.2060809@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <20140922222810.GA9421@srcf.ucam.org> <5420A402.2060809@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 23, 2014 06:34:42 AM Hanjun Guo wrote:
> On Sep 23, 2014, 06:28AM, Matthew Garrett wrote:
> > On Tue, Sep 23, 2014 at 12:46:24AM +0200, Rafael J. Wysocki wrote:
> >> On Monday, September 22, 2014 09:31:36 PM Matthew Garrett wrote:
> >>> Explicit Change Request. These can only be filed by paid-up members of 
> >>> the UEFI Forum, so I suspect this requirement is going to be unworkable 
> >>> (there's plenty of ACPI support code for large x86 vendors which isn't 
> >>> part of any ACPI spec).
> >> Why do you think so?
> > The IP rules in the membership agreements.
> 
> If I'm not mistaken, I think there is no IP issues for the _DSD bindings,
> it just some key value pairs.

Well, if we are talking about the bindings themselves only, then as I said
previously that would be a hosted document rather than a UEFI specification
anyway, so I don't see how the "IP rules in the membership agreements" would
apply to that in any case.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
