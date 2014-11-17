Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaKQE3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 23:29:18 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:65331 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaKQE3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 23:29:16 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdb-T42Bqtf7zvc+2om03hgu4j8twDUqmsE4dcKaPXB9Wg@mail.gmail.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <2758495.RYBbleVHkC@vostro.rjw.lan> <CACRpkdanUC4QYbMXgMOkiGS+6oVyD1Opg_sFo95TEsyHJTM6_w@mail.gmail.com>
 <1433051.htaUTMPMBY@vostro.rjw.lan> <CACRpkdb-T42Bqtf7zvc+2om03hgu4j8twDUqmsE4dcKaPXB9Wg@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 17 Nov 2014 13:28:54 +0900
Message-ID: <CAAVeFuLV2yR1tmxX-HicupqgwUYj5HzqvSoi0Bq3V7aVpvf9bg@mail.gmail.com>
Subject: Re: [PATCH] ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
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

On Fri, Nov 14, 2014 at 5:58 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Nov 3, 2014 at 11:56 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Monday, November 03, 2014 02:22:10 PM Linus Walleij wrote:
>
>>> With that change:
>>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> OK, made the changes and added your Reviewed-by.
>>
>> One semi-related question though.  Alexandre ACKed the patch before, so
>> what did that mean from the GPIO subsystem's perspective?  Was the patch
>> approved, not approved, semi-approved?
>
> It just means we are not always entirely aligned, it's not like
> Alexandre and I have meetings on the side and decide what to
> say, it's just these mails. I do trust him, I wouldn't get mad if it
> had been merged just wanted some polishing when I could get
> it...

In case of conflicting feedback between me and Linus, it goes without
saying that Linus' opinion should prevail. I am trying to help a bit
and take some of the burden off his shoulders, but have neither his
skill nor his experience (which shows when you compare our patch
reviews). So for important stuff it is a good idea to wait until both
of us give a ack - the most likely conflict scenario being that I give
a pass overlooking something that Linus will catch.
