Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273Ab3GSLz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:55:58 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39105 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974Ab3GSLz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:55:57 -0400
MIME-Version: 1.0
In-Reply-To: <51CD4233.3040209@iki.fi>
References: <1372159970-6361-1-git-send-email-ruslan.bilovol@ti.com>
	<51CD4233.3040209@iki.fi>
Date: Fri, 19 Jul 2013 14:55:55 +0300
X-Google-Sender-Auth: tb4XXzjBpiDbNQ7-LyCiB3HGweE
Message-ID: <CAB=otbTmhGSd5TJWODroZDYjPXUk_C8vFwmWeXnKfwW_eUAxDg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: DTS: OMAP4: Add OMAP4 Blaze Tablet support
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@iki.fi>
Cc: b-cousson@ti.com, tony@atomide.com, benoit.cousson@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi

On Fri, Jun 28, 2013 at 10:58 AM, Tomi Valkeinen <tomi.valkeinen@iki.fi> wrote:
> On 25/06/13 14:32, Ruslan Bilovol wrote:
>> The OMAP4 Blaze Tablet is TI OMAP4 processor-based
>> development platform in a tablet formfactor.
>> The platform contains many of the features found in
>> present-day handsets (such as audio, video, wireless
>> functions and user interfaces) and in addition
>> contains features for software development and test.
>>
>> This patch adds initial support for the OMAP4 Blaze
>> Tablet development platform. Additional functionality
>> depends on different drivers and code modifications that
>> are not upstreamed yet or do not support DT yet, so will
>> be added later.
>
> I think there are (at least) two revisions of the blaze tablet, the
> newer one has a higher resolution LCD. I don't know what the other
> differences are.
>
> I think you have the newer revision. I have the older. Do you know about
> the diff of those revisions, or more importantly, will the same blaze
> tablet support work for the older revision also?

Yes, it was manufacturing some first revision of BlazeTablet but now
it is out of production.
On Svtronics there is ability to buy only BlazeTablet2 and we use only
it last year as
development platform.

The difference is known - another display, sensors, diffs in routing
gpio to leds etc..
The same DTS will allow to boot BlazeTablet and BlazeTablet2 but
number of supported features
of course will be less in case of first revision of BlazeTablet

Since first revision of Blazetablet is not available to buy and we do
not use it for some time
I think there is no needs in doing support of it upstream.

Regards,
Ruslan

>
>  Tomi
>
>
