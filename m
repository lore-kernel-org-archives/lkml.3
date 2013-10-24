Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3JXOMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:12:25 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37003 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3JXOMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:12:23 -0400
Message-ID: <526938FE.4080309@kernel.org>
Date: Thu, 24 Oct 2013 16:13:02 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jon Brenner <Jon.Brenner@ams.com>, Sebastian Reichel <sre@debian.org>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio:light:tsl2563: Add DT support
References: <1382565063-17083-1-git-send-email-sre@debian.org> <5268DA76.6060503@kernel.org> <20131024134259.GB3681@earth.universe> <3C879D35B299F147B1DEDFBEE12F2E06012E5631C1@SUX2182.office.amsiag.com>
In-Reply-To: <3C879D35B299F147B1DEDFBEE12F2E06012E5631C1@SUX2182.office.amsiag.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/24/13 14:58, Jon Brenner wrote:
> AMS-TAOS

amstaos

so lowercase, and based on their being no other hyphenated
names (ST-Ericson is ste for example)


> 
> -----Original Message-----
> From: Sebastian Reichel [mailto:sre@debian.org] 
> Sent: Thursday, October 24, 2013 8:43 AM
> To: Jonathan Cameron
> Cc: linux-iio@vger.kernel.org; Rob Herring; Pawel Moll; Mark Rutland; Stephen Warren; Ian Campbell; Rob Landley; Jonathan Cameron; Peter Meerwald; Greg Kroah-Hartman; Bill Pemberton; Sachin Kamat; devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org; Jon Brenner
> Subject: Re: [PATCH] iio:light:tsl2563: Add DT support
> 
> On Thu, Oct 24, 2013 at 09:29:42AM +0100, Jonathan Cameron wrote:
>> On 10/23/13 22:51, Sebastian Reichel wrote:
>>> Add Device Tree support for the TSL2563 driver and document the 
>>> binding.
>>>
>>> Signed-off-by: Sebastian Reichel <sre@debian.org>
>>> ---
>>>  .../devicetree/bindings/iio/light/tsl2563.txt         | 19 +++++++++++++++++++
>>>  drivers/iio/light/tsl2563.c                           |  4 ++++
>>>  2 files changed, 23 insertions(+)
>>>  create mode 100644 
>>> Documentation/devicetree/bindings/iio/light/tsl2563.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/iio/light/tsl2563.txt 
>>> b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
>>> new file mode 100644
>>> index 0000000..b52cf4b
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
>>> @@ -0,0 +1,19 @@
>>> +* TAOS TSL2563 ambient light sensor
>>> +
>>> +Required properties:
>>> +
>>> +  - compatible : should be "taos,tsl2563"
>>> +  - reg : the I2C address of the sensor
>>> +
>>> +Optional properties:
>>> +
>> So two options for this one.  Either pitch it as a possible general 
>> parameter, or mark it with a vendor prefix.  It seems like something 
>> fairly general, but in that case it probably needs a more detailed proposal and explanation of exactly what it is.
> 
> OK, I will add a vendor prefix in a PATCHv2. When I converted the driver to DT I had a look how this is used and I don't think it's "fairly general".
> 
>> Also, is taos listed in vendor-prefixes.txt?  Jon, is that the right vendor prefix to use?
>> I'm guessing you have some non mainline bindings out there already so 
>> it would be good to match those...
> 
> taos is currently not listed in the vendor-prefixes.txt file. Also it seems that "TAOS Inc." has been absorbed by "ams AG" in 2011.
> So how to proceed with the patch?
> 
> -- Sebastian
> 
