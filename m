Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3JKQmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:42:53 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34282 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3JKQmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:42:50 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZgP9VnVSpBN2Wg4ihL4ryZXeP=ASwr6BCP=u79eg6s6g@mail.gmail.com>
References: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
 <1381392071-21407-2-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdZgP9VnVSpBN2Wg4ihL4ryZXeP=ASwr6BCP=u79eg6s6g@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 11 Oct 2013 09:42:29 -0700
Message-ID: <CAAVeFu+K6HvQTMOQqMbZPUD_C3nQ1MvYju1BGUOWPYJjQEpTjg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] gpiolib / ACPI: move acpi_gpiochip_free_interrupts
 next to the request function
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 4:00 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Oct 10, 2013 at 10:01 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
>
>> It makes more sense to have these functions close to each other. No
>> functional changes.
>>
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> So I've applied this first patch, and I'm just waiting for Alexandre's
> ACK on the remaining patches concerning gpiod so we get this
> 100% right.

I think I'm ok with Mika's patches, however I need to send you a new
version of gpiod. I wanted to finish documentation first, but maybe
that can come slightly after so you can at least go ahead with both
series?
