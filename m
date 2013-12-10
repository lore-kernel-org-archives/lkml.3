Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3LJByW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:54:22 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35047 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3LJByT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:54:19 -0500
Message-ID: <52A673CD.6010405@linaro.org>
Date: Tue, 10 Dec 2013 09:52:13 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>, Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running
 without PCI on ARM64
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <20131209115050.GA19163@arm.com> <52A5C024.5050702@linaro.org> <201312091735.05014.arnd@arndb.de> <20131209170617.GC30717@srcf.ucam.org>
In-Reply-To: <20131209170617.GC30717@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-10 1:06, Matthew Garrett wrote:
> On Mon, Dec 09, 2013 at 05:35:04PM +0100, Arnd Bergmann wrote:
> 
>> Exactly. In particular we don't want people to get the wrong idea about
>> where we are heading, so making it possible to use this code on embedded
>> systems for me is a reason *not* to take the patch.
> 
> People are trying to deploy ACPI-based embedded x86, and most of the 
> ACPI/DT integration discussion seems to have been based on the idea that 
> this is a worthwhile thing to support. If we're not interested in doing 
> so then we should probably make that a whole kernel decision rather than 
> a per architecture one.

I agree, thanks for this information.

