Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaCNWOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:14:14 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:63444 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaCNWOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140314221143.GA26621@amd.pavel.ucw.cz>
References: <20140314211456.GA23213@amd.pavel.ucw.cz>
	<CAKb7Uvi-GfOu3_3BMU_Cu4qYS8PQRWzxVm1XETY7y_TJjGPs_A@mail.gmail.com>
	<20140314221143.GA26621@amd.pavel.ucw.cz>
Date: Fri, 14 Mar 2014 18:14:12 -0400
X-Google-Sender-Auth: mjDwhwmjaZ5Q0h29FdEIOY-t5rk
Message-ID: <CAKb7Uvh1TaNLmi0YVBPmCD571ZU_sM1DpbYUSA8xQZnS5xUbCA@mail.gmail.com>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 6:11 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2014-03-14 17:29:41, Ilia Mirkin wrote:
>> On Fri, Mar 14, 2014 at 5:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> > It seems /proc/acpi/battery interface is gone, and I don't see any
>> > option to reintroduce it... what is going on?
>>
>> The interface went away in a semi-recent kernel release (3.13 or
>> 3.12), breaking pretty much every battery app. (Admittedly the
>> interface was marked as deprecated for quite some time, but that
>> didn't stop everyone from using it and not caring about the new
>> thing.) I've yet to find a windowmaker dock app that works with the
>> current sysfs API :(
>
> Name one application it broke, and we'll get it reverted. It broke my
> by-hand journalling, at the very least.

wmbattery

They have attempted to use the sysfs api, but apparently that
integration was done with an older version of that API. There's also
some attempt to get it to work with upower, but I couldn't figure out
how to make that work either on my (up-to-date gentoo) box. (TBH I
didn't spend more than an hour or two on it, so it may not be
impossible.)

  -ilia
