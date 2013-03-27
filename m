Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3C0Sqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:46:51 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:34222 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3C0Sqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:46:47 -0400
MIME-Version: 1.0
In-Reply-To: <51533D34.7020406@metafoo.de>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
	<1363207202-10858-1-git-send-email-dianders@chromium.org>
	<1363207202-10858-2-git-send-email-dianders@chromium.org>
	<CAHfPSqDLXD-T6__eF=d+U7Me953DqTgMXi=Jmx7LnHL+W-FLhQ@mail.gmail.com>
	<51533D34.7020406@metafoo.de>
Date: Wed, 27 Mar 2013 11:46:43 -0700
X-Google-Sender-Auth: S5oO6apPJaZlJnEe8cpaQIdP6lc
Message-ID: <CAD=FV=XVWe+GNzEuYkXL3n85t2zRCHJkz5ry_uVXY62rp61qKQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] iio: adc: Document the regulator/clocks for exynos-adc
From: Doug Anderson <dianders@chromium.org>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 27, 2013 at 11:40 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 03/27/2013 07:35 PM, Naveen Krishna Ch wrote:
>> On 13 March 2013 13:39, Doug Anderson <dianders@chromium.org> wrote:
>>> The exynos ADC won't work without a regulator called "vdd" and a clock
>>> called "adc".  Document this fact in the device tree bindings.
>>>
>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>
>> Lars, any update on this patch set. This change is required.
>
> Uhm, looks fine to me. I'm sure Jonathan will pick it up :)

Part 2 made it in, but not the documentation patch.  Now that it has a
Reviewed-by it can probably go in...  :)

-Doug
