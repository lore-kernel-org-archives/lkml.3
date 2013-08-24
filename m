Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3HXFau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 01:30:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61031 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab3HXFas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 01:30:48 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52184504.4070001@roeck-us.net>
Date: Fri, 23 Aug 2013 22:30:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Darren Hart <dvhart@linux.intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
References: <1377300343.5259.84.camel@dvhart-mobl4.amr.corp.intel.com> <20130823233805.GA1801@srcf.ucam.org> <1377301548.5259.91.camel@dvhart-mobl4.amr.corp.intel.com> <20130824001345.GD14810@roeck-us.net> <20130824011036.GA2827@srcf.ucam.org> <20130824014723.GA17488@roeck-us.net> <20130824023806.GA3388@srcf.ucam.org> <521820A3.2010501@roeck-us.net> <20130824030628.GA3668@srcf.ucam.org> <52183A56.5020707@roeck-us.net> <20130824045139.GA4840@srcf.ucam.org>
In-Reply-To: <20130824045139.GA4840@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 09:51 PM, Matthew Garrett wrote:
> On Fri, Aug 23, 2013 at 09:45:10PM -0700, Guenter Roeck wrote:
>
>> "What happens when you have an ACPI device that contains an interrupt in
>>   _CRS and contains a different interrupt in an embedded FDT block?"
>>
>> Does the situation occur today, ie does it ever happen that one interrupt
>> for a device is specified (if that is the correct term) in _CRS and
>> another by some other means ?
>
> The only case I can think of is PCI, where we ignored the ACPI-provided
> resources until fairly recently. That was a somewhat reasonable thing to
> do, since the hardware still had to support pre-ACPI operating systems
> and so the non-ACPI information sources were typically correct.
>
> Other than that, I think we always trust the ACPI data.
>
Seems to me you answered your question. It should be possible
to do the same if you replace (ACPI, BIOS) with (ACPI, FDT).
Plus, hopefully there should be no reason to specify data in FDT
that is already provided through ACPI. If it is specified anyway,
its handling is a matter of policy.

Guenter

