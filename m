Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaHRSLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:11:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46728 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaHRSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:11:52 -0400
Date: Mon, 18 Aug 2014 19:11:49 +0100
From: Graeme Gregory <graeme.gregory@linaro.org>
To: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v2 00/18] Introduce ACPI for ARM64 based on
 ACPI 5.1
Message-ID: <20140818181149.GG2094@xora-yoga-deb.xora.org.uk>
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>
 <CAJRNFK+UfJhGR65tOecy=X+YdHQHiNPZ4p_p8LUxhRL3GW5gFw@mail.gmail.com>
 <53E050B2.2080609@linaro.org>
 <CAJRNFKJtbfYEkYWcyXPOfRU9D4MVhabn5X1ZumZMSQFQ=S=j5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJRNFKJtbfYEkYWcyXPOfRU9D4MVhabn5X1ZumZMSQFQ=S=j5g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 07:08:59PM +0200, Alexander Spyridakis wrote:
> > Yes, I think so. If you meet any problem , please let us know, and we will
> > update the wiki.
> >
> >>
> >> Should I assume that UEFI is mandatory (alternative being the aarch64
> >> bootwrapper), as described in Documentation/arm64/arm-acpi.txt?
> >
> > Yes, UEFI is mandatory if you want to use ACPI.
> 
> Hello Hanjun,
> 
> What tables do you use for the foundation model (or AEMv8)?
> 
> The ones found in this repository:
> git://git.linaro.org/leg/acpi/acpi-asl.git are ACPIv5.0, and when the
> kernel gets pointed to them acpi is disabled because it expects an
> FADT v5.1 or later. Of course building these tables with latest ACPICA
> also fails.
> 
I updated that repository to ACPI 5.1 approximately 4 hours ago.

If you re-fetch you should see 5.1 tables for foundation model.

Graeme

