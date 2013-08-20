Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab3HTK3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:29:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44791 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3HTK3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:29:40 -0400
X-AuditID: cbfee68f-b7f436d000000f81-73-5213451295e4
Message-id: <52134513.1060304@samsung.com>
Date: Tue, 20 Aug 2013 19:29:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: balbi@ti.com, myungjoo.ham@samsung.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob@landley.net, ian.campbell@citrix.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, bcousson@baylibre.com
Subject: Re: [PATCH 1/2] extcon: extcon-dra7xx: Add extcon driver for USB ID
 detection
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com>
 <1376648029-30659-2-git-send-email-george.cherian@ti.com>
 <5212B740.2000000@samsung.com> <521338B7.7040208@ti.com>
In-reply-to: <521338B7.7040208@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42JZI2JSoivsKhxk8PMPs8XB+/UWd+b/ZbWY
	f+Qcq8Wpg8tZLQ782cFo8aa3g8ViYdsSFovLu+awWcxe0s9isWhZK7PF0usXmSxuN65gs5gw
	fS2LxeEVB5gs1r2czmLx6mAbi4OAx5p5axg93t9oZfdY8PkKu8fryRMYPV6tnsnqcefaHjaP
	vi2rGD2O39jO5PF5k5zHxrmhAVxRXDYpqTmZZalF+nYJXBnNG7azFPwzrNh9eR5jA+N8tS5G
	Tg4JAROJ8wsesEPYYhIX7q1n62Lk4hASWMoo8XptJyNM0YnLu1kgEtMZJX7f/w3lvGKUONG0
	gBWkildAS2JTx1EWEJtFQFViz429YGPZgOL7X9xgA7FFBcIkVk6/wgJRLyjxY/I9MFsEqKb/
	UjcTyFBmgS9MErNWzQZq5uAQFoiQuLBCAWLZHkaJ5rt9zCANnAJqEvN/LwdbzCygI7G/dRob
	hC0vsXnNW2aQBgmBHRwSi45+Y4S4SEDi2+RDLCBDJQRkJTYdYIZ4TVLi4IobLBMYxWYhuWkW
	krGzkIxdwMi8ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwBZz+96x/B+PdA9aHGJOBVk5k
	lhJNzgemkLySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MKaUqF8Xvr/owIq9ueXnb0TkhClyW861nPz81vZQFd1FNs7ML1ktD5T6K+7K+3ej+qd5
	vU5NWX/8nbo37k/mL5QzXffbt7nnRsL1RWuL/lTt/K8jECpYu1Lodpu70i698kfHj1k8ZFa9
	83l1sevVm7rTWxQCbFQUd+VKRF1ebayzVuxfwq0Fm5RYijMSDbWYi4oTAUOPVq8XAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jQV0hV+Egg8+bzCwO3q+3uDP/L6vF
	/CPnWC1OHVzOanHgzw5Gize9HSwWC9uWsFhc3jWHzWL2kn4Wi0XLWpktll6/yGRxu3EFm8WE
	6WtZLA6vOMBkse7ldBaLVwfbWBwEPNbMW8Po8f5GK7vHgs9X2D1eT57A6PFq9UxWjzvX9rB5
	9G1Zxehx/MZ2Jo/Pm+Q8Ns4NDeCKamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAH6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMOY0bxhO0vBP8OK3ZfnMTYwzlfrYuTkkBAwkThxeTcLhC0mceHeerYuRi4OIYHpjBK/7/9m
	gXBeMUqcaFrAClLFK6AlsanjKFgHi4CqxJ4be9lBbDag+P4XN9hAbFGBMImV06+wQNQLSvyY
	fA/MFgGq6b/UzQQylFngC5PErFWzgZo5OIQFIiQurFCAWLaHUaL5bh8zSAOngJrE/N/LwRYz
	C+hI7G+dxgZhy0tsXvOWeQKjwCwkO2YhKZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOAE80x6B+OqBotDjAIcjEo8vB1KQkFCrIllxZW5hxglOJiVRHhfOwoHCfGmJFZWpRbl
	xxeV5qQWH2JMBgbBRGYp0eR8YPLLK4k3NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZq
	akFqEcwWJg5OqQbG3NqozjvWwiLsEh/Ln3Kfy2ewO7CL+a3Tk57HN0+lb0zPc8m2abz8uS5F
	L7/QeFPUvsd/Dezsrm/213K7lRa88Sab5ozzcn/Y52SWx/81uLbmXGl17X7Gv2tOSRguMT85
	w3Tirm/Na200DGSLZ4Z/PiuaGH6GZ1LozB3PGkVTm85ZT8mtnN+pxFKckWioxVxUnAgAwm4E
	snQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

>>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt b/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
>>> new file mode 100644
>>> index 0000000..37e4c22
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
>>> @@ -0,0 +1,19 @@
>>> +EXTCON FOR DRA7xx
>>> +
>>> +Required Properties:
>>> + - compatible : Should be "ti,dra7xx-usb"
>>> + - gpios : phandle to ID pin and interrupt gpio.
>>> +
>>> +Optional Properties:
>>> +  - interrupt-parent : interrupt controller phandle
>>> +  - interrupts : interrupt number
>>> +
>>> +
>>> +dra7x_extcon1 {
>> You used 'dra7xx-usb' device name. Why did you use 'dra7x_extcon1' name?
>> What is meaning 'dra7x_extcon1'?
> 
> I will rename it to  dra7xx_extcon.

extcon naming means various external connector device. e.g., usb, jack, etc...
So, I prefer 'dra7xx_usb' instead of 'dra7xx_extcon'. I have plan to divide
extcon device driver according to the kind of device.


>>> +static int id_poll_func(void *data)
>>> +{
>>> +    struct dra7xx_usb *dra7xx_usb = (struct dra7xx_usb *) data;
>>> +
>>> +    allow_signal(SIGINT);
>>> +    allow_signal(SIGTERM);
>>> +    allow_signal(SIGKILL);
>>> +    allow_signal(SIGUSR1);
>>> +
>>> +    set_freezable();
>>> +
>>> +    while (!kthread_should_stop()) {
>>> +        dra7xx_usb->id_current = gpio_get_value_cansleep
>>> +                        (dra7xx_usb->id_gpio);
>>> +        if (dra7xx_usb->id_current == dra7xx_usb->id_prev) {
>>> +            schedule_timeout_interruptible
>>> +                        (msecs_to_jiffies(2*1000));
>>> +            continue;
>>> +        } else if (dra7xx_usb->id_current == 0) {
>>> +            extcon_set_cable_state(&dra7xx_usb->edev, "USB", false);
>>> +            extcon_set_cable_state(&dra7xx_usb->edev,
>>> +                        "USB-HOST", true);
>>> +        } else {
>>> +            extcon_set_cable_state(&dra7xx_usb->edev,
>>> +                        "USB-HOST", false);
>>> +            extcon_set_cable_state(&dra7xx_usb->edev, "USB", true);
>>> +        }
>> Should dra7xx_usb keep always connected state with either USB or USB-HOST cable?
>> I don't understand. So please explain detailed operation method of dra7xx_usb device.
> 
> In dra7xx only ID pin is connected to the SoC gpio. There is no way, currently to detect the VBUS on/off.
> So I always default to either HOST/DEVICE mode solely depending on the ID pin value.
OK.

But I don't want to use kthread with polling method.
I recommend that you use interrupt method for cable detection.
All of extcon device driver have only used interrupt method without polling.

> 
>>
>>> +        dra7xx_usb->id_prev = dra7xx_usb->id_current;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static irqreturn_t id_irq_handler(int irq, void *data)
>>> +{
>>> +    struct dra7xx_usb *dra7xx_usb = (struct dra7xx_usb *) data;
>>> +
>>> +    dra7xx_usb->id_current = gpio_get_value_cansleep(dra7xx_usb->id_gpio);
>>> +
>>> +    if (dra7xx_usb->id_current == dra7xx_usb->id_prev) {
>>> +        return IRQ_NONE;
>>> +    } else if (dra7xx_usb->id_current == 0) {

You should define some constant variable to clarify '0' meaning instead of using '0' directly.


>>> +    dra7xx_usb = devm_kzalloc(&pdev->dev, sizeof(*dra7xx_usb), GFP_KERNEL);
>>> +    if (!dra7xx_usb)
>>> +        return -ENOMEM;
>> You have to add error message with dev_err().
> 
> devm_kzalloc itself should give some message.

ok.


>>> +    status = extcon_dev_register(&dra7xx_usb->edev, dra7xx_usb->dev);
>>> +    if (status) {
>>> +        dev_err(&pdev->dev, "failed to register extcon device\n");
>>> +        return status;
>> You should restore previous operation about dra7xx_usb->irq_gpio.
> 
> okay
>>
>>> +    }
>>> +
>>> +    dra7xx_usb->id_prev = gpio_get_value_cansleep(dra7xx_usb->id_gpio);
>>> +    if (dra7xx_usb->id_prev) {

ditto.
You should define some constant variable to clarify 'dra7xx_usb->id_prev' meaning.

>>> +        extcon_set_cable_state(&dra7xx_usb->edev, "USB-HOST", false);
>>> +        extcon_set_cable_state(&dra7xx_usb->edev, "USB", true);
>>> +    } else {
>>> +        extcon_set_cable_state(&dra7xx_usb->edev, "USB", false);
>>> +        extcon_set_cable_state(&dra7xx_usb->edev, "USB-HOST", true);
>>> +    }
>> why did you do keep always connected state?
> 
> There is no way, currently to detect the VBUS on/off.
> So I always default to either HOST/DEVICE mode solely depending on the ID pin value.
> 
>>> +
>>> +    if (dra7xx_usb->irq_gpio) {
>>> +        status = devm_request_threaded_irq(dra7xx_usb->dev, irq_num,
>>> +                NULL, id_irq_handler, IRQF_SHARED |
>>> +                IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
>>> +                dev_name(&pdev->dev), (void *) dra7xx_usb);
>>> +        if (status)
>>> +            dev_err(dra7xx_usb->dev, "failed to request irq #%d\n",
>>> +                        irq_num);
>> If devm_request_threaded_irq() return fail state, why did not you do add error exception?
> 
> If interrupt fails I fallback to polling thread.
>>> +        else
>>> +            return 0;
>> If devm_request_threaded_irq() return success state, why did you directly call 'return'?
>> kthread_create operation isn't necessary?
> 
> Yes kthread is optional. Some boards doenot have the ID pin hooked onto the GPIO.
> In such cases we will run the kthread and poll on the ID pin values.
>>
>>> +    }
>>> +
>>> +    dra7xx_usb->thread_task = kthread_create(id_poll_func, dra7xx_usb,
>>> +                         dev_name(&pdev->dev));
>> Should you use polling method with kthread? I think it isn't proper method.
>> You did get the irq number by using DT helper function and register irq handler
>> with devm_request_threaded_irq(). I prefer interrupt method for detection of cable state.
> 
> I also prefer interrupt method. If any implementation does not have ID pin connected to GPIOs then still
> it could use the driver in polling mode.

As I mentioned above, I don't prefer interrupt method for cable detection.
Polling method for detection isn't appropriate for extcon device driver.

Instead, I will consider whether to support polling method or not on extcon core.

Thanks,
Chanwoo Choi


