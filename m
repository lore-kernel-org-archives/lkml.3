Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaHRRJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:09:05 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:60242 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaHRRJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:09:01 -0400
MIME-Version: 1.0
In-Reply-To: <53E050B2.2080609@linaro.org>
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>
	<CAJRNFK+UfJhGR65tOecy=X+YdHQHiNPZ4p_p8LUxhRL3GW5gFw@mail.gmail.com>
	<53E050B2.2080609@linaro.org>
Date: Mon, 18 Aug 2014 19:08:59 +0200
Message-ID: <CAJRNFKJtbfYEkYWcyXPOfRU9D4MVhabn5X1ZumZMSQFQ=S=j5g@mail.gmail.com>
Subject: Re: [Linaro-acpi] [PATCH v2 00/18] Introduce ACPI for ARM64 based on
 ACPI 5.1
From: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I think so. If you meet any problem , please let us know, and we will
> update the wiki.
>
>>
>> Should I assume that UEFI is mandatory (alternative being the aarch64
>> bootwrapper), as described in Documentation/arm64/arm-acpi.txt?
>
> Yes, UEFI is mandatory if you want to use ACPI.

Hello Hanjun,

What tables do you use for the foundation model (or AEMv8)?

The ones found in this repository:
git://git.linaro.org/leg/acpi/acpi-asl.git are ACPIv5.0, and when the
kernel gets pointed to them acpi is disabled because it expects an
FADT v5.1 or later. Of course building these tables with latest ACPICA
also fails.

Regards.
