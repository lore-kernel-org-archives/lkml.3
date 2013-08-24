Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3HXCze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 22:55:34 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56235 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3HXCzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 22:55:33 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <521820A3.2010501@roeck-us.net>
Date: Fri, 23 Aug 2013 19:55:31 -0700
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
References: <6438184.2yT2NMB1CE@vostro.rjw.lan> <20130821233942.GA21502@srcf.ucam.org> <1810269.JOHnJ0H7P9@vostro.rjw.lan> <20130822000306.GA21785@srcf.ucam.org> <1377300343.5259.84.camel@dvhart-mobl4.amr.corp.intel.com> <20130823233805.GA1801@srcf.ucam.org> <1377301548.5259.91.camel@dvhart-mobl4.amr.corp.intel.com> <20130824001345.GD14810@roeck-us.net> <20130824011036.GA2827@srcf.ucam.org> <20130824014723.GA17488@roeck-us.net> <20130824023806.GA3388@srcf.ucam.org>
In-Reply-To: <20130824023806.GA3388@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 07:38 PM, Matthew Garrett wrote:
> On Fri, Aug 23, 2013 at 06:47:23PM -0700, Guenter Roeck wrote:
>> On Sat, Aug 24, 2013 at 02:10:36AM +0100, Matthew Garrett wrote:
>>> On Fri, Aug 23, 2013 at 05:13:45PM -0700, Guenter Roeck wrote:
>>>
>>>> Did the group conclude that the idea of FDT augmenting ACPI is not feasible ?
>>>
>>> I think expressing FDT in ACPI is feasible, I'm just not sure it's
>>> desirable. We'd still end up with duplicate information and no mechanism
>>> for drivers to handle both.
>>>
>> Not sure I understand what you are saying. My understanding of "augment"
>> would be that there is ACPI information, and there is a separate FDT
>> (or an FDT overlay) providing additional information. There should be
>> no duplicate information in this model.
>
> What happens when you have an ACPI device that contains an interrupt in
> _CRS and contains a different interrupt in an embedded FDT block?
>

Question is: Does this work _today_ with any existing driver, where
one interrupt is served through ACPI and another as 'standard' Linux
interrupt ? If yes, it must be working, and using fdt to describe
the interrupt mapping for the non-ACPI interrupt should not make
a difference. If no, the problem does not really have anything
to do with fdt.

Guenter

