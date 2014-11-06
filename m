Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaKFT2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:28:15 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56379 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKFT2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:28:14 -0500
MIME-Version: 1.0
In-Reply-To: <545912D2.5090708@codeaurora.org>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
	<CAOZdJXXAQtmR_Wq194nbiEpg2TYS7_5tXhLtDWckD4xMHGkdZg@mail.gmail.com>
	<20141104082056.GG1618@lahna.fi.intel.com>
	<545912D2.5090708@codeaurora.org>
Date: Thu, 6 Nov 2014 20:28:13 +0100
Message-ID: <CACRpkdarQBFWWgJ2VKJxXa7EZrXsDMgmm5jzc_ORhZSBm=LJuQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
From: Linus Walleij <linus.walleij@linaro.org>
To: Timur Tabi <timur@codeaurora.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 6:54 PM, Timur Tabi <timur@codeaurora.org> wrote:
> On 11/04/2014 02:20 AM, Mika Westerberg wrote:
>>
>> There is nothing like that yet in ACPI world but with the ACPI _DSD
>> patches we are getting properties similar to DT which means that we can
>> provide pinctrl bindings from ACPI systems as well.
>
>
> Do you know if anyone has signed up to actually do the work of defining how
> pinctrl will look in ACPI?

We don't even have a good standard for device tree yet, we're
rehashing the set-up for pin controllers with per-pin granularity
as we speak. For controllers combining groups with functions
identified with strings, and for pin config we have a sort of generic
solution.

Yours,
Linus Walleij
