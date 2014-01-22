Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaAVLqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:46:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52390 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450AbaAVLqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:46:18 -0500
Date: Wed, 22 Jan 2014 11:46:16 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro
 CLOCKSOURCE_ACPI_DECLARE
Message-ID: <20140122114616.GB15591@e106331-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
 <1389961514-13562-19-git-send-email-hanjun.guo@linaro.org>
 <201401171521.35940.arnd@arndb.de>
 <52DCE790.6080809@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DCE790.6080809@linaro.org>
Thread-Topic: [PATCH 18/20] clocksource / acpi: Add macro
 CLOCKSOURCE_ACPI_DECLARE
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 09:08:32AM +0000, Hanjun Guo wrote:
> On 2014-1-17 22:21, Arnd Bergmann wrote:
> > On Friday 17 January 2014, Hanjun Guo wrote:
> >>
> >> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
> >>
> >> This macro does the same job as CLOCKSOURCE_OF_DECLARE. The device
> >> name from the ACPI timer table is matched with all the registered
> >> timer controllers and matching initialisation routine is invoked.
> > 
> > I wouldn't anticipate this infrastructure to be required. Shouldn't all
> > ARMv8 machines have an architected timer?
> 
> I not sure of this, could anyone can give some guidance? if only arch
> timer is available for ARM64, this will make thing very simple.

All ARMv8 systems should have an architected timer.

However, they may also have other timers (e.g. global timers for use
when CPUs are in low power states and their local architected timers
aren't active).

Thanks,
Mark.
