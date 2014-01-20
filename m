Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaATJIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:08:50 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58404 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaATJIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:08:48 -0500
Message-ID: <52DCE790.6080809@linaro.org>
Date: Mon, 20 Jan 2014 17:08:32 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Charles.Garcia-Tobin@arm.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro CLOCKSOURCE_ACPI_DECLARE
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-19-git-send-email-hanjun.guo@linaro.org> <201401171521.35940.arnd@arndb.de>
In-Reply-To: <201401171521.35940.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-1-17 22:21, Arnd Bergmann wrote:
> On Friday 17 January 2014, Hanjun Guo wrote:
>>
>> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>
>> This macro does the same job as CLOCKSOURCE_OF_DECLARE. The device
>> name from the ACPI timer table is matched with all the registered
>> timer controllers and matching initialisation routine is invoked.
> 
> I wouldn't anticipate this infrastructure to be required. Shouldn't all
> ARMv8 machines have an architected timer?

I not sure of this, could anyone can give some guidance? if only arch
timer is available for ARM64, this will make thing very simple.

Thanks
Hanjun
