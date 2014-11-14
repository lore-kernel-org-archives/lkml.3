Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160AbaKNI6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:58:45 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:61832 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965140AbaKNI6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:58:42 -0500
MIME-Version: 1.0
In-Reply-To: <1433051.htaUTMPMBY@vostro.rjw.lan>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
	<2758495.RYBbleVHkC@vostro.rjw.lan>
	<CACRpkdanUC4QYbMXgMOkiGS+6oVyD1Opg_sFo95TEsyHJTM6_w@mail.gmail.com>
	<1433051.htaUTMPMBY@vostro.rjw.lan>
Date: Fri, 14 Nov 2014 09:58:41 +0100
Message-ID: <CACRpkdb-T42Bqtf7zvc+2om03hgu4j8twDUqmsE4dcKaPXB9Wg@mail.gmail.com>
Subject: Re: [PATCH] ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 11:56 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, November 03, 2014 02:22:10 PM Linus Walleij wrote:

>> With that change:
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
> OK, made the changes and added your Reviewed-by.
>
> One semi-related question though.  Alexandre ACKed the patch before, so
> what did that mean from the GPIO subsystem's perspective?  Was the patch
> approved, not approved, semi-approved?

It just means we are not always entirely aligned, it's not like
Alexandre and I have meetings on the side and decide what to
say, it's just these mails. I do trust him, I wouldn't get mad if it
had been merged just wanted some polishing when I could get
it...

Yours,
Linus Walleij
