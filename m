Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaF3RVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:21:09 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45354 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaF3RVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:21:07 -0400
Message-ID: <53B19C80.8060306@linaro.org>
Date: Mon, 30 Jun 2014 18:21:04 +0100
From: Graeme Gregory <graeme.gregory@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "rric@kernel.org" <rric@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 05/13] ARM64 / ACPI: Introduce arm-core.c and its related
 head file
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org> <1403840976-7456-6-git-send-email-hanjun.guo@linaro.org> <20140630162406.GR28951@arm.com>
In-Reply-To: <20140630162406.GR28951@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30/06/2014 17:24, Catalin Marinas wrote:
> On Fri, Jun 27, 2014 at 04:49:28AM +0100, Hanjun Guo wrote:
>>   drivers/acpi/Makefile          |    2 +
>>   drivers/acpi/plat/Makefile     |    1 +
>>   drivers/acpi/plat/arm-core.c   |  110 ++++++++++++++++++++++++++++++++++++++++
> Do you ever plan to add ACPI support for 32-bit ARM? If not, this part
> could be placed under arch/arm64 (similar to x86).
>
Originally the plan was to support both platforms, but it seems people 
have stopped talking to Linaro about 32bit support now so unless anyone 
else has some actual info I guess it would be safe to move it into arm64.

Graeme

