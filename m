Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaAYQcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 11:32:22 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41839 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaAYQcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 11:32:20 -0500
MIME-Version: 1.0
In-Reply-To: <9739501.rBu7tJQIYj@vostro.rjw.lan>
References: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com>
	<9739501.rBu7tJQIYj@vostro.rjw.lan>
Date: Sat, 25 Jan 2014 17:32:19 +0100
Message-ID: <CADDKRnBFvfHcuEY8TA=nfyP-WSotkj9wkXxE2QS8h+22cyk_0w@mail.gmail.com>
Subject: Re: [kernel 3.13.0-06058-g2d08cd0] Strange ACPI error messages
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-25 Rafael J. Wysocki <rjw@rjwysocki.net>:
> On Saturday, January 25, 2014 11:03:09 AM Jörg Otte wrote:
>> Kernel 3.13.0-06058-g2d08cd0 displays following errors on the console:
>>
>> ACPI: \_PR_.CPU4: failed to get CPU APIC ID.
>> ACPI: \_PR_.CPU5: failed to get CPU APIC ID.
>> ACPI: \_PR_.CPU6: failed to get CPU APIC ID.
>> ACPI: \_PR_.CPU7: failed to get CPU APIC ID.
>>
>> I don't have CPUs 4..7! Error messages regarding not existing
>> CPUs should not be displayed.
>> kernel 3.13.0-05617-g3aacd62 and before did'nt show this messages.
>>
>> This is a regression. I never saw this messages before.
>
> Does your system show any other suspicious symptoms or are you worried about
> those messages only?
>
> Rafael
>

what's looking badly is this:

ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_]
(20131218/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_]
(20131218/hwxface-580)

and this:

acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
 \_SB_.PCI0:_OSC invalid UUID
 _OSC request data:1 1e 0
acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM

but these messages are not new.

Jörg
