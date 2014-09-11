Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbaIKQON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:14:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34239 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbaIKQOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:14:10 -0400
Message-ID: <5411CA4D.30202@arm.com>
Date: Thu, 11 Sep 2014 17:14:05 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Graeme Gregory <gg@slimlogic.co.uk>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <20140911132935.068DCC408F6@trevor.secretlab.ca> <20140911153739.GA24416@localhost> <5411C664.4060007@arm.com> <20140911160627.GU6558@xora-haswell.xora.org.uk>
In-Reply-To: <20140911160627.GU6558@xora-haswell.xora.org.uk>
X-OriginalArrivalTime: 11 Sep 2014 16:14:03.0661 (UTC) FILETIME=[679873D0:01CFCDDB]
X-MC-Unique: 114091117140609201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/09/14 17:06, Graeme Gregory wrote:
> On Thu, Sep 11, 2014 at 04:57:24PM +0100, Sudeep Holla wrote:
>>
>>

[...]
>> This what we have suggested in past especially for this S-state support.
>> Currently the core acpi code compiles in sleep support unconditionally.
>> That doesn't mean we need to do the same on ARM64, we can easily make
>> sure that's not enabled for ARM64 until we have clarification on how to
>> support them on ARM in ACPI specification.
>>
>> I just pointed out at one "out of spec" workaround done for x86
>> "unconditionally" in the code just to tell that it won't work on ARM.
>> That shouldn't be misunderstood as demand for refactoring as we have no
>> clue how S-state would look on ARM to take up any such task.
>>
> For the sleep.c case I worked on this and sent some updates to Hanjun so
> it should be compiled out in the next version of the patches.
>

Thanks Graeme, that's much better than any hooks/stubs which might fail
depending on ACPI table contents.

Regards,
Sudeep


