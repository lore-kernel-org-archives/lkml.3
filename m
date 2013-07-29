Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3G2B3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 21:29:01 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33414 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3G2B2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 21:28:41 -0400
Message-ID: <51F5C543.10103@opensuse.org>
Date: Sun, 28 Jul 2013 21:28:35 -0400
From: =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaron Lu <aaron.lwe@gmail.com>
CC: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: acpi_backlight=vendor no longer working around buggy laptop from
 hell
References: <51F40114.9060607@opensuse.org> <51F5BFF6.7080506@gmail.com>
In-Reply-To: <51F5BFF6.7080506@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 28/07/13 21:05, Aaron Lu escribió:

> So does adding nox2apic still work for you with latest Linus' tree?

Yes, nox2apic makes things work again, but has always puzzled me why 
acpi_backlight=vendor made it work previously with no apparent bad side 
effect..

>> The only possible hint in the logs I could ever find is:
>>
>> [    3.844586] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
>
> This is subtle, meaning the BIOS doesn't provide the required method.

Yeah, I wonder what Windows 7/8 is doing..does not seem to care about that..


