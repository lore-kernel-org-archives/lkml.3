Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaAXPfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:35:39 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38032 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaAXPfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:35:37 -0500
Message-ID: <52E2883F.1070007@linaro.org>
Date: Fri, 24 Jan 2014 23:35:27 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Al Stone <al.stone@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>
Subject: Re: [PATCH 03/20] ARM64 / ACPI: Introduce the skeleton of _PDC related
 for ARM64
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-4-git-send-email-hanjun.guo@linaro.org> <20140123180335.GK27520@arm.com>
In-Reply-To: <20140123180335.GK27520@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 2014年01月24日 02:03, Catalin Marinas wrote:
> On Fri, Jan 17, 2014 at 12:24:57PM +0000, Hanjun Guo wrote:
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/acpi.h
>> @@ -0,0 +1,32 @@
>> +/*
>> + *  Copyright (C) 2013, Al Stone <al.stone@linaro.org>
>> + *
>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> + *
>> + *  This program is free software; you can redistribute it and/or modify
>> + *  it under the terms of the GNU General Public License as published by
>> + *  the Free Software Foundation; either version 2 of the License, or
>> + *  (at your option) any later version.
>> + *
>> + *  This program is distributed in the hope that it will be useful,
>> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *  GNU General Public License for more details.
>> + *
>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> + */
>> +
>> +#ifndef _ASM_ARM64_ACPI_H
>> +#define _ASM_ARM64_ACPI_H
> Nitpick: please use __ASM_ACPI_H as a guard for consistency (the same
> for all the other patches introducing new header files).

ok, will update this patch.

Hanjun
>

