Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbbATQJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:09:23 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49225 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbbATQJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:09:20 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-fd-54be7dad35eb
Message-id: <54BE7DAB.80702@samsung.com>
Date: Tue, 20 Jan 2015 17:09:15 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Rob Herring <robherring2@gmail.com>
Cc: linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, sakari.ailus@iki.fi,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com>
 <54B38682.5080605@samsung.com>
 <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com>
 <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <54B4DA81.7060900@samsung.com>
 <CAL_JsqLYxB5hzLAWXpU=uncM5DEMZU78mP673H9oSSNB-cgcYQ@mail.gmail.com>
 <54B8D4D0.3000904@samsung.com>
 <CAL_Jsq+EFWzs1HP1tVt6P=p=HZn2AtSPjp55YrmMQi_mE+kNfQ@mail.gmail.com>
 <54B933D0.1090004@samsung.com>
In-reply-to: <54B933D0.1090004@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xa7pra/eFGPxvFbDYOGM9q8XUh0/Y
	LI7unMhkMf/IOVaL/jcLWS3OvVrJaHG26Q27xbcrHUwWl3fNYbPY+mYdo0XPhq2sFkuvX2Sy
	uHvqKJvFhOlrWSxa9x5ht/j+7Rubxe5dT1ktDr9pZ7U4s38lm4Owx5p5axg9Lvf1MnnsnHWX
	3WPl8i9sHoe/LmTx2LSqk81jz/wfrB59W1YxeqxY/Z3d4/MmuQCuKC6blNSczLLUIn27BK6M
	jt2TWAva3SuaTmxjbGDcY9HFyMkhIWAi8W1OFzuELSZx4d56ti5GLg4hgaWMEg9P3maGcD4y
	Srz8Np0VpIpXQEPi2uEjYB0sAqoSZy/cYgax2QQMJX6+eM0EYosKREj8Ob0Pql5Q4sfkeywg
	toiAusS35cfBNjALvGeVmLx0KRtIQljAVWJ2+2Kobb2sEmu3LATr4BTQlji3YRfYVGYBM4lH
	LeuYIWx5ic1r3jJPYBSYhWTJLCRls5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kR
	EpVfdjAuPmZ1iFGAg1GJh1cjZ0+IEGtiWXFl7iFGCQ5mJRFegfJ9IUK8KYmVValF+fFFpTmp
	xYcYmTg4pRoYRU5V/KnI2yqe/n757mTuINeZ/xstxTZP8T6wrWWtf+q0nBY9dpmL85rZWF9M
	q73X9m+13fK3iyu/KHxUkX/ZuKLVa3//TZV3u4uVmYv4z4SreT2Wz18sVLrUZOtat4c+ye22
	K9u8t5Vmr1hpyNXrejZ6c/K2o5kNTMtrKxaUnrxYbHRBJvm1EktxRqKhFnNRcSIACzY73qgC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 04:52 PM, Jacek Anaszewski wrote:
> On 01/16/2015 02:48 PM, Rob Herring wrote:
>> On Fri, Jan 16, 2015 at 3:07 AM, Jacek Anaszewski
>> <j.anaszewski@samsung.com> wrote:
>>> On 01/15/2015 03:24 PM, Rob Herring wrote:
>>>>
>>>> On Tue, Jan 13, 2015 at 2:42 AM, Jacek Anaszewski
>>>> <j.anaszewski@samsung.com> wrote:
>>>>>
>>>>> On 01/12/2015 05:55 PM, Rob Herring wrote:
>>>>>>
>>>>>>
>>>>>> Adding Mark B and Liam...
>>>>>>
>>>>>> On Mon, Jan 12, 2015 at 10:10 AM, Jacek Anaszewski
>>>>>> <j.anaszewski@samsung.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 01/12/2015 02:52 PM, Rob Herring wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On Mon, Jan 12, 2015 at 2:32 AM, Jacek Anaszewski
>>>>>>>> <j.anaszewski@samsung.com> wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 01/09/2015 07:33 PM, Rob Herring wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On Fri, Jan 9, 2015 at 9:22 AM, Jacek Anaszewski
>>>>>>>>>> <j.anaszewski@samsung.com> wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Add a property for defining the device outputs the LED
>>>>>>>>>>> represented by the DT child node is connected to.
>>>>>>
>>>>>>
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>>>>>> b/Documentation/devicetree/bindings/leds/common.txt
>>>>>>>>>>> index a2c3f7a..29295bf 100644
>>>>>>>>>>> --- a/Documentation/devicetree/bindings/leds/common.txt
>>>>>>>>>>> +++ b/Documentation/devicetree/bindings/leds/common.txt
>>>>>>>>>>> @@ -1,6 +1,10 @@
>>>>>>>>>>>       Common leds properties.
>>>>>>>>>>>
>>>>>>>>>>>       Optional properties for child nodes:
>>>>>>>>>>> +- led-sources : Array of bits signifying the LED current
>>>>>>>>>>> regulator
>>>>>>>>>>> outputs the
>>>>>>>>>>> +               LED represented by the child node is
>>>>>>>>>>> connected to
>>>>>>>>>>> (1
>>>>>>>>>>> -
>>>>>>>>>>> the LED
>>>>>>>>>>> +               is connected to the output, 0 - the LED isn't
>>>>>>>>>>> connected
>>>>>>>>>>> to the
>>>>>>>>>>> +               output).
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Sorry, I just don't understand this.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> In some Flash LED devices one LED can be connected to one or more
>>>>>>>>> electric current outputs, which allows for multiplying the maximum
>>>>>>>>> current allowed for the LED. Each sub-LED is represented by a
>>>>>>>>> child
>>>>>>>>> node in the DT binding of the Flash LED device and it needs to
>>>>>>>>> declare
>>>>>>>>> which outputs it is connected to. In the example below the
>>>>>>>>> led-sources
>>>>>>>>> property is a two element array, which means that the flash LED
>>>>>>>>> device
>>>>>>>>> has two current outputs, and the bits signify if the LED is
>>>>>>>>> connected
>>>>>>>>> to the output.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Sounds like a regulator for which we already have bindings for
>>>>>>>> and we
>>>>>>>> have a driver for regulator based LEDs (but no binding for it).
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Do you think of drivers/leds/leds-regulator.c driver? This driver
>>>>>>> just
>>>>>>> allows for registering an arbitrary regulator device as a LED
>>>>>>> subsystem
>>>>>>> device.
>>>>>>>
>>>>>>> There are however devices that don't fall into this category,
>>>>>>> i.e. they
>>>>>>> have many outputs, that can be connected to a single LED or to many
>>>>>>> LEDs
>>>>>>> and the driver has to know what is the actual arrangement.
>>>>>>
>>>>>>
>>>>>>
>>>>>> We may need to extend the regulator binding slightly and allow for
>>>>>> multiple phandles on a supply property, but wouldn't something like
>>>>>> this work:
>>>>>>
>>>>>> led-supply = <&led-reg0>, <&led-reg1>, <&led-reg2>, <&led-reg3>;
>>>>>>
>>>>>> The shared source is already supported by the regulator binding.
>>>>>
>>>>>
>>>>>
>>>>> I think that we shouldn't split the LED devices into power supply
>>>>> providers and consumers as in case of generic regulators. From this
>>>>> point of view a LED device current output is a provider and a discrete
>>>>> LED element is a consumer. In this approach each discrete LED element
>>>>> should have a related driver which is not how LED devices are being
>>>>> handled in the LED subsystem, where there is a single binding for a
>>>>> LED
>>>>> device and there is a single driver for it which creates separate LED
>>>>> class devices for each LED connected to the LED device output. Each
>>>>> discrete LED is represented by a child node in the LED device binding.
>>>>>
>>>>> I am aware that it may be tempting to treat LED devices as common
>>>>> regulators, but they have their specific features which gave a
>>>>> reason for introducing LED class for them. Besides, there is already
>>>>> drivers/leds/leds-regulator.c driver for LED devices which support
>>>>> only
>>>>> turning on/off and setting brightness level.
>>>>>
>>>>> In your proposition a separate regulator provider binding would have
>>>>> to be created for each current output and a separate binding for
>>>>> each discrete LED connected to the LED device. It would create
>>>>> unnecessary noise in a dts file.
>>>>>
>>>>> Moreover, using regulator binding implies that we want to treat it
>>>>> as a sheer power supply for our device (which would be a discrete LED
>>>>> element in this case), whereas LED devices provide more features like
>>>>> blinking pattern and for flash LED devices - flash timeout, external
>>>>> strobe and flash faults.
>>>>
>>>>
>>>> Okay, fair enough. Please include some of this explanation in the
>>>> binding description.
>>>>
>>>> I do still have some concerns about led-sources and whether it can
>>>> support other scenarios. It is very much tied to the parent node. Are
>>>> there any cases where we don't want the LEDs to be sub nodes? Perhaps
>>>> the LEDs are on a separate daughterboard from the driver/supply and we
>>>> can have different drivers. It's a stretch maybe.
>>>
>>>
>>> I think it is. Such arrangements would introduce problems also to the
>>> other existing bindings. Probably not only LED subsystem related ones.
>>>
>>>> Or are there cases
>>>> where you need more information than just the connection?
>>>
>>>
>>> Currently I can't think of any.
>>>
>>> Modified rough proposal of the description:
>>>
>>>
>>> -Optional properties for child nodes:
>>> +LED and flash LED devices provide the same basic functionality as
>>> +current regulators, but extended with LED and flash LED specific
>>> +features
>>> like blinking patterns, flash timeout, flash faults and
>>> +external flash strobe mode.
>>> +
>>> +Many LED devices expose more than one current output that can be
>>> +connected to one or more discrete LED component. Since the arrangement
>>> +of connections can influence the way of the LED device initialization,
>>> +the LED components have to be tightly coupled with the LED device
>>> +binding. They are represented in the form of its child nodes.
>>> +
>>> +Optional properties for child nodes (if a LED device exposes only one
>>> +current output the properties can be placed directly in the LED device
>>> +node):
>>
>> Why special case 1 output case? Just always require a child node.
>
> OK.
>
>>> +- led-sources : Array of connection states between all LED current
>>> +               sources exposed by the device and this LED (1 - this LED
>>> +               is connected to the current output with index N, 0 -
>>> +               this LED isn't connected to the current output with
>>> +               index N); the mapping of N-th element of the array to
>>> +               the physical device output should be defined in the LED
>>> +               driver binding.
>>
>> I think this should be a list of connected output numbers rather than
>> effectively a bitmask.
>>
>> You may want to add something like led-output-cnt or led-driver-cnt in
>> the parent so you know the max list size.
>
> Why should we need this? The number of current outputs exposed by the
> device is fixed and can be specified in a LED device bindings
> documentation.
>

OK. The led-output-cnt property should be put in each sub-node, as the
number of the current outputs each LED can be connected to is variable.

New version:

  Optional properties for child nodes:
+led-sources-cnt : Number of device current outputs the LED is connected to.
+- led-sources : List of device current outputs the LED is connected to. The
+               outputs are identified by the numbers that must be defined
+               in the LED device binding documentation.
  - label : The label for this LED.  If omitted, the label is
    taken from the node name (excluding the unit address).

@@ -33,7 +47,9 @@ system-status {

  camera-flash {
         label = "Flash";
+       led-sources-cnt = <2>;
+       led-sources = <0>, <1>;
         max-microamp = <50000>;
         flash-max-microamp = <320000>;
         flash-timeout-us = <500000>;
-}
+};

-- 
Best Regards,
Jacek Anaszewski
