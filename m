Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaH2Gge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:36:34 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50832 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaH2Ggc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:36:32 -0400
MIME-Version: 1.0
In-Reply-To: <1408172039-32513-8-git-send-email-mika.westerberg@linux.intel.com>
References: <1408172039-32513-1-git-send-email-mika.westerberg@linux.intel.com>
	<1408172039-32513-8-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 29 Aug 2014 08:36:31 +0200
Message-ID: <CACRpkdZr3aLfiD24cpXjtrczvkuCvpfsSv6zadawkQf+v8vsfQ@mail.gmail.com>
Subject: Re: [RFC PATCH 7/9] gpio: sch: Consolidate core and resume banks
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Al Stone <al.stone@linaro.org>, Olof Johansson <olof@lixom.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>,
        Robert Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>, Mark Brown <broonie@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 8:53 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> This is actually a single device with two sets of identical registers,
> which just happen to start from a different offset. Instead of having
> separate GPIO chips created we consolidate them to be single GPIO chip.
>
> In addition having a single GPIO chip allows us to handle ACPI GPIO
> translation in the core in a more generic way, since the two GPIO chips
> share the same parent ACPI device.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Tested-by: Max Eliaser <max.eliaser@intel.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess this needs to be merged with the rest of the stuff in this series
so for the GPIO sch part go ahead.

Yours,
Linus Walleij
