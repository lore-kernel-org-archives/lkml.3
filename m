Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3C2JgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 05:36:09 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:46699 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3C2JgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 05:36:06 -0400
Message-ID: <51556084.2040307@kernel.org>
Date: Fri, 29 Mar 2013 09:36:04 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Ch <naveenkrishna.ch@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] iio: adc: Document the regulator/clocks for exynos-adc
References: <1363129994-10438-1-git-send-email-dianders@chromium.org> <1363207202-10858-1-git-send-email-dianders@chromium.org> <1363207202-10858-2-git-send-email-dianders@chromium.org> <CAHfPSqDLXD-T6__eF=d+U7Me953DqTgMXi=Jmx7LnHL+W-FLhQ@mail.gmail.com> <51533D34.7020406@metafoo.de> <CAD=FV=XVWe+GNzEuYkXL3n85t2zRCHJkz5ry_uVXY62rp61qKQ@mail.gmail.com>
In-Reply-To: <CAD=FV=XVWe+GNzEuYkXL3n85t2zRCHJkz5ry_uVXY62rp61qKQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 06:46 PM, Doug Anderson wrote:
> Hi,
> 
> On Wed, Mar 27, 2013 at 11:40 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 03/27/2013 07:35 PM, Naveen Krishna Ch wrote:
>>> On 13 March 2013 13:39, Doug Anderson <dianders@chromium.org> wrote:
>>>> The exynos ADC won't work without a regulator called "vdd" and a clock
>>>> called "adc".  Document this fact in the device tree bindings.
>>>>
>>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>> Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>>
>>> Lars, any update on this patch set. This change is required.
>>
>> Uhm, looks fine to me. I'm sure Jonathan will pick it up :)
> 
> Part 2 made it in, but not the documentation patch.  Now that it has a
> Reviewed-by it can probably go in...  :)
> 
And indeed it has now done so. Well into the togreg branch of iio.git

Jonathan
> -Doug
> 
