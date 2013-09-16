Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3IPSOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:14:51 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:41973 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3IPSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:14:50 -0400
Message-ID: <523758B8.1050109@kernel.org>
Date: Mon, 16 Sep 2013 20:15:04 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Denis CIOCCA <denis.ciocca@st.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 14/38] iio: accel: st: Append _accel to accelerator sensor
 device names
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-15-git-send-email-lee.jones@linaro.org> <52345330.4050707@kernel.org> <5234562D.5050803@kernel.org> <5236C259.6050701@metafoo.de> <5236CD88.10809@st.com> <5236F378.9060906@metafoo.de>
In-Reply-To: <5236F378.9060906@metafoo.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/13 13:03, Lars-Peter Clausen wrote:
> On 09/16/2013 11:21 AM, Denis CIOCCA wrote:
>> Hi Lars,
>>> On 09/14/2013 02:27 PM, Jonathan Cameron wrote:
>>>> On 09/14/13 13:14, Jonathan Cameron wrote:
>>>>> On 09/10/13 13:49, Lee Jones wrote:
>>>>>> Some of ST's sensors are appended with their sensor type and some
>>>>>> are not. For consistency we're extending the same naming convention
>>>>>> throughout.
>>>>>>
>>>>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>>> Honestly I don't care either way on these, but consistency would definitely
>>>>> be good so applied to the togreg branch of iio.git
>>>>>
>>>>> Thanks,
>>>> Actually change of plan. I'm going to hold off on these as this an ABI change.
>>>> Iritating though having these as completely inconsistent is, changing this
>>>> will change device identification from userspace which is not a good idea.
>>>>
>>>> Sorry Lee, but we really shouldn't do this. I should have picked up on this
>>>> in the original driver reviews but that's hindsight for you.
>>> I think those with the suffix are the ones where you have accel and gyro in
>>> the same package, the ones without the suffix are pure accelerometers.
>> Yes You are right. I've used this kind of logic... What do you think about?
>>
>> Denis
> 
> Seems sensible to me.

How about a comment to this effect in the code so that we keep it like this?
