Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3H1SQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:16:34 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58721 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3H1SQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:16:32 -0400
Message-ID: <521E4C90.5080608@kernel.org>
Date: Wed, 28 Aug 2013 20:16:32 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        jic23@cam.ac.uk, denis.ciocca@st.com, lars@metafoo.de
Subject: Re: [PATCH v5 1/2] staging: iio: Documentation sysfs-bus-iio add
 power_mode
References: <1377687678-5761-1-git-send-email-o.v.kravchenko@globallogic.com> <521E1255.2090201@linux.intel.com> <521E12FF.4030709@kernel.org>
In-Reply-To: <521E12FF.4030709@kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/13 16:10, Jonathan Cameron wrote:
> On 28/08/13 16:08, Srinivas Pandruvada wrote:
>> On 08/28/2013 04:01 AM, Oleksandr Kravchenko wrote:
>>> Add description about in_accelX_power_mode and
>>> in_accel_power_mode_available.
>>>
>>> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Applied.  Note that neither this nor the next patch applied cleanly. In both
cases some of the context was missing.  Could you check the resulting
merge.  Seems fine to me, but I have messed these up before!

Jonathan
>>> ---
>>>   Documentation/ABI/testing/sysfs-bus-iio |   10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio
>>> b/Documentation/ABI/testing/sysfs-bus-iio
>>> index dda81ff..1a333f3 100644
>>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>>> @@ -792,3 +792,13 @@ Contact:    linux-iio@vger.kernel.org
>>>   Description:
>>>           This attribute is used to read the amount of quadrature error
>>>           present in the device at a given time.
>>> +
>>> +What:        /sys/.../iio:deviceX/in_accelX_power_mode
>> Shall we add power_mode to all sensors not just accelerometer? HID
>> sensor hub spec allows every sensor in it to go low power mode.
>> This is not same as OFF.
> Feel free to add the relevant lines in the patch that adds the attribute.  We should not add stuff here that is not used.
> 
>>> +KernelVersion:    3.11
>>> +Contact:    linux-iio@vger.kernel.org
>>> +Description:
>>> +        Specifies the chip power mode.
>>> +        low_noise: reduce noise level from ADC,
>>> +        low_power: enable low current consumption.
>>> +        For a list of available output power modes read
>>> +        in_accel_power_mode_available.
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
