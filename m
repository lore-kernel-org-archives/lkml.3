Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab3FVNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 09:16:59 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43411 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756024Ab3FVNQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 09:16:57 -0400
Message-ID: <51C5A499.5050509@metafoo.de>
Date: Sat, 22 Jun 2013 15:20:25 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, jimwall@q.com,
        brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCHv2 1/3] iio: Add Nuvoton NAU7802 ADC driver
References: <1371754675-12242-1-git-send-email-alexandre.belloni@free-electrons.com> <1371754675-12242-2-git-send-email-alexandre.belloni@free-electrons.com> <51C590B5.2060308@kernel.org> <51C5923D.6030609@metafoo.de> <51C5A1AF.3070404@free-electrons.com>
In-Reply-To: <51C5A1AF.3070404@free-electrons.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2013 03:07 PM, Alexandre Belloni wrote:
> On 22/06/2013 14:02, Lars-Peter Clausen wrote:
>> On 06/22/2013 01:55 PM, Jonathan Cameron wrote:
>>> On 06/20/2013 07:57 PM, Alexandre Belloni wrote:
>>>> The Nuvoton NAU7802 ADC is a 24-bit 2-channels I2C ADC, with adjustable
>>>> gain and sampling rates.
>>>>
>>> Sorry, somewhat low on time today so only a quick review.
>>>
>>> 1) Missing userspace ABI documentation.  Also, perhaps min_conversions is
>>>    a little vague?  Not that I have a better idea!
>> I really don't like the name min_conversions either. Isn't this effectively
>> a decimation filter?
> 
> Yeah, it could be seen like that but it is only relevant and only
> happens when switching between channels. I'm open to any ideas.
> 

I see. Is there anything about this in the datasheet on how many conversions
you usually need? Is this really something you need to change at runtime or
does moving this to platform data work?

- Lars
