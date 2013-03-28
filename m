Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3C1GgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:36:25 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:33455 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3C1GgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:36:23 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAD=FV=XVWe+GNzEuYkXL3n85t2zRCHJkz5ry_uVXY62rp61qKQ@mail.gmail.com>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org> <1363207202-10858-1-git-send-email-dianders@chromium.org> <1363207202-10858-2-git-send-email-dianders@chromium.org> <CAHfPSqDLXD-T6__eF=d+U7Me953DqTgMXi=Jmx7LnHL+W-FLhQ@mail.gmail.com> <51533D34.7020406@metafoo.de> <CAD=FV=XVWe+GNzEuYkXL3n85t2zRCHJkz5ry_uVXY62rp61qKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/4] iio: adc: Document the regulator/clocks for exynos-adc
From: Jonathan Cameron <jic23@kernel.org>
Date: Thu, 28 Mar 2013 06:31:06 +0000
To: Doug Anderson <dianders@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20b79acf-6799-4aad-b2fc-8300d04f5faa@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Doug Anderson <dianders@chromium.org> wrote:

>Hi,
>
>On Wed, Mar 27, 2013 at 11:40 AM, Lars-Peter Clausen <lars@metafoo.de>
>wrote:
>> On 03/27/2013 07:35 PM, Naveen Krishna Ch wrote:
>>> On 13 March 2013 13:39, Doug Anderson <dianders@chromium.org> wrote:
>>>> The exynos ADC won't work without a regulator called "vdd" and a
>clock
>>>> called "adc".  Document this fact in the device tree bindings.
>>>>
>>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>> Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>>
>>> Lars, any update on this patch set. This change is required.
>>
>> Uhm, looks fine to me. I'm sure Jonathan will pick it up :)
>
>Part 2 made it in, but not the documentation patch.  Now that it has a
>Reviewed-by it can probably go in...  :)
>
>-Doug
I'll take it sometime over the weekend. 

Thanks. 
Jonathan

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
