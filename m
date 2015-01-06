Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbbAFUuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:50:18 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:60687 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbbAFUuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:50:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: liyi 00215672 <phoenix.liyi@huawei.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Charles.Garcia-Tobin@arm.com" <Charles.Garcia-Tobin@arm.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: =?UTF-8?B?562U5aSNOg==?= [PATCH v6 17/17] Documentation: ACPI for ARM64
Date: Tue, 06 Jan 2015 21:49:21 +0100
Message-ID: <9429675.LhiSR5rsOc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <D0F5605BA99F0B4594FB1EEC24E785CC654879C3@SZXEMA510-MBX.china.huawei.com>
References: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org> <1420368918-5086-18-git-send-email-hanjun.guo@linaro.org> <D0F5605BA99F0B4594FB1EEC24E785CC654879C3@SZXEMA510-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:8zuBfeOx7FSv+DTDwXsnLElOORJHdmSL0OUze1MciG6Xl8AsGaF
 TLEM98yrg10ehs+4yJiFDGzlb/pEU2Hrep5R/XDOzuSel2kFYkv6GuVxgLlFMmj/Ah0/BRh
 Zley7JeUBgdoEpkftJqMPoZEy0I2mqeoU6M8+8g/JZ3/lhuzclh3y4XTPxstf4ki7iRZB+N
 mJ+GgomVF1B3xqU0vO+NQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 09:52:05 liyi 00215672 wrote:
> In traditional telecom market, what confused us(Huawei) was our software
> and hardware coupling together oftentimes. So if we change some hardware
> then we MUST modify our software, which was not our customer’s
> expectation. In x86 world, we have UEFI and ACPI technologies, they are
> suitable to solve this problem very well, we just upgrade our hardware
> and don’t need to upgrade their software, in the meantime ACPI provides
> many methods on power management.

Can you give an example of how ACPI solves the problem of supporting a
particular piece of new hardware?

I assume that for a completely new SoC, it won't help because you
still need device drivers for all the major parts of the hardware
that have changed, so this is about parts of the system that can
be abstracted in AML but not fully described in DT without the need
for new device drivers. Which are the main ones you are interested in
here?

	Arnd
