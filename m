Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3GIRna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:43:30 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43299 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3GIRn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:43:28 -0400
Message-ID: <51DC4BB4.6060506@kernel.org>
Date: Tue, 09 Jul 2013 18:43:16 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Shawn Guo <shawn.guo@linaro.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, jimwall@q.com,
        brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv3 1/3] iio: Add Nuvoton NAU7802 ADC driver
References: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com> <1372094699-3832-2-git-send-email-alexandre.belloni@free-electrons.com> <51D53B72.6020309@metafoo.de> <51D7F044.9040205@kernel.org> <51DC1858.8010008@free-electrons.com>
In-Reply-To: <51DC1858.8010008@free-electrons.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, looks like I forgot to push the tree out.
Anyhow should be there shortly.

On 07/09/2013 03:04 PM, Alexandre Belloni wrote:
> Hi Jonathan,
> 
> I don't actually see it in iio.git on kernel.org, am I doing something
> wrong ?
> 
> On 06/07/2013 12:24, Jonathan Cameron wrote:
>> On 07/04/2013 10:08 AM, Lars-Peter Clausen wrote:
>>> On 06/24/2013 07:24 PM, Alexandre Belloni wrote:
>>>> The Nuvoton NAU7802 ADC is a 24-bit 2-channels I2C ADC, with adjustable
>>>> gain and sampling rates.
>>>>
>>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>> Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
>>>
>> Applied to the togreg branch of iio.git (with a few little tweaks).
>>
>> There was some fuzz that required manual fixing because of another driver merge so
>> please check I didn't foul anything up with this or the other bits below.
>>
>> There were two trivial missing unlocks on error paths in the read_raw function that
>> I've fixed up (Coccinelle found these for me - if you can I would always advise
>> running sparse, coccicheck and ideally smatch before submitting patches).
>>
>> I fixed up the comments because if there is one thing I hate bothering
>> with it is delightful patches that just fix this stuff. Much better
>> to do it now given it took 20 secs ;)
>>
>>> One remark though. Multiline comments should be like
>>>
>>> /*
>>>  * foo
>>>  * bar
>>>  */
>>>
>>> not
>>>
>>> /* foo
>>>  * bar
>>>  */
>>>
>>> But not need to resend the patch just for this
>>>
>>> - Lars
>>>
> 
> 
