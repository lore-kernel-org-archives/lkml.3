Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaKDRB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:01:28 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:51834 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaKDRBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:01:25 -0500
MIME-Version: 1.0
In-Reply-To: <3645687.BsyGDrJDrU@vostro.rjw.lan>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan> <2127128.VT1Iq03xz1@vostro.rjw.lan>
 <CACxGe6tvz8MiXnNGJ3XtrofxFr=o87yOB6kUKm57fXvQ0fL8jw@mail.gmail.com> <3645687.BsyGDrJDrU@vostro.rjw.lan>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 4 Nov 2014 17:01:04 +0000
X-Google-Sender-Auth: -F5YKZYifk7oj-24Gvzwxwt3ANg
Message-ID: <CACxGe6uv0TmoZivL3ESw+oRW-OjqakLP4KBnDrwJXzQ2ku8ZLA@mail.gmail.com>
Subject: Re: [PATCH v6 02/12] Driver core: Unified device properties interface
 for platform firmware
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 10:04 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> I also found that this parser code doesn't correctly handle malformed
>> (unterminated) string properties. It will overflow. The existing
>> functions have the same problem, so it isn't something that you've
>> added. I've got a fix, and as a side effect the fix creates the _array
>> version basically for free as part of reworking
>> of_property_count_strings() and of_property_read_string_index()
>
> OK
>
> So can you please point me to a git branch containing the fix?  I'll rebase the
> patch on top of that then and everything should merge just fine.

git://git.kernel.org/pub/scm/linux/kernel/git/glikely/linux.git devicetree/merge

I'm going to let the patch sit in there for a few days to get
linux-next exposure before I ask Linus to pull. The pull req will go
out before the end of the week.

g.
