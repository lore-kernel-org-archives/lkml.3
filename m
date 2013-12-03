Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3LCONx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:13:53 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:42473 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3LCONt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:13:49 -0500
MIME-Version: 1.0
In-Reply-To: <529DE21E.4080707@linaro.org>
References: <1386069328-22502-1-git-send-email-hanjun.guo@linaro.org>
	<1386069328-22502-3-git-send-email-hanjun.guo@linaro.org>
	<CACRpkdYeMOMQzDn5=XpDg7X9L_zMZczGg-5SBA8q_WvwFPnH7A@mail.gmail.com>
	<529DE21E.4080707@linaro.org>
Date: Tue, 3 Dec 2013 15:13:49 +0100
Message-ID: <CACRpkdZWELp1u=O=gSGZhaxQ2oTMu_jXuJb43snrr-tdYW9XAA@mail.gmail.com>
Subject: Re: [RFC part3 PATCH 2/2] ARM64 / clocksource: Use arch_timer_acpi_init()
From: Linus Walleij <linus.walleij@linaro.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 2:52 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:

> I will introduce has_arch_timer_node() as you said and use
> it as follows:
>
> if (has_arch_timer_node())
> clocksource_of_init();
> esle
> arch_timer_acpi_init(); /* try ACPI way */
>
> Is this make sense to you?

Sure, go head.

Thanks,
Linus Walleij
