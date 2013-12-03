Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3LCQau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:30:50 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48135 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3LCQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:30:46 -0500
Message-ID: <529E072B.3060901@linaro.org>
Date: Wed, 04 Dec 2013 00:30:35 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Jon Masters <jonathan@jonmasters.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC part3 PATCH 2/2] ARM64 / clocksource: Use arch_timer_acpi_init()
References: <1386069328-22502-1-git-send-email-hanjun.guo@linaro.org> <1386069328-22502-3-git-send-email-hanjun.guo@linaro.org> <CACRpkdYeMOMQzDn5=XpDg7X9L_zMZczGg-5SBA8q_WvwFPnH7A@mail.gmail.com> <529DE21E.4080707@linaro.org> <CACRpkdZWELp1u=O=gSGZhaxQ2oTMu_jXuJb43snrr-tdYW9XAA@mail.gmail.com> <20131203144309.GC7552@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131203144309.GC7552@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月03日 22:43, Mark Rutland wrote:
> On Tue, Dec 03, 2013 at 02:13:49PM +0000, Linus Walleij wrote:
>> On Tue, Dec 3, 2013 at 2:52 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>
>>> I will introduce has_arch_timer_node() as you said and use
>>> it as follows:
>>>
>>> if (has_arch_timer_node())
>>> clocksource_of_init();
>>> esle
>>> arch_timer_acpi_init(); /* try ACPI way */
>>>
>>> Is this make sense to you?
> What does arch_timer_acpi_init() do? Is it just detecting the presence
> of the timer, or grabbing the rate from a property in an ACPI table?

It seems that you didn't get the PATCH 1/2, and my part1/part2 patch set
is also missing, I will resend all the patch set, sorry for the noise.

Thanks
Hanjun
