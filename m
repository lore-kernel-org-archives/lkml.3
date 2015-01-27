Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbbA0ByX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:54:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23861 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbbA0ByU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:54:20 -0500
X-AuditID: cbfee68f-f791c6d000004834-f8-54c6efc99254
Message-id: <54C6EFC8.1090601@samsung.com>
Date: Tue, 27 Jan 2015 10:54:16 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Roger Quadros <rogerq@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, tony@atomide.com,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        george.cherian@ti.com, nsekhar@ti.com,
        devicetree <devicetree@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] extcon: usb-gpio: Introduce gpio usb extcon driver
References: <1422274532-9488-1-git-send-email-rogerq@ti.com>
 <1422274532-9488-2-git-send-email-rogerq@ti.com>
 <CAGTfZH3nmpUGgFJ6RU+xH8tuDkGBFA-NbXWa0CSXZXR+DXrbkQ@mail.gmail.com>
 <54C66B0D.9040109@ti.com>
In-reply-to: <54C66B0D.9040109@ti.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkRPfk+2MhBi0beCwO3q+3mH/kHKvF
	qYPLWS0u75rDZjF7ST+LxaJlrcwWtxtXsFns793AZNHzSMti/xUvBy6Pb18nsXj0bVnF6HH8
	xnYmj8+b5AJYorhsUlJzMstSi/TtErgymuf1sBacNqk4dHUZawPjMbUuRk4OCQETia9rN7ND
	2GISF+6tZ+ti5OIQEljKKHG6dz8rTNHinqnsEInpjBJHN9yFcl4zSlz7eRisnVdAS2JBx1wm
	EJtFQFXi/P13YDYbUHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosIKErcWwmxmllgCZPEzTnL
	GEESwgJ+Evdb/0HddIlRYsv0G0A3cXBwCqhJdDaAnccsoC4xad4iZghbXmLzmrfMIPUSAtfY
	Jebf2McCcZGAxLfJh1hAeiUEZCU2HWCGeE1S4uCKGywTGMVmIblpFpKxs5CMXcDIvIpRNLUg
	uaA4Kb3IWK84Mbe4NC9dLzk/dxMjMBJP/3vWv4Px7gHrQ4wCHIxKPLwbbx4LEWJNLCuuzD3E
	aAp0xURmKdHkfGC855XEGxqbGVmYmpgaG5lbmimJ8y6U+hksJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgZHp+UWp22sm//1SHOe96eDDxunvekq3hPiJL4qbNyksdv/WT9o1xTKX2ouXbNB9
	cDTK/kvy1MuOX+6/vpjuki03mW/Tub0TJEozLFR9P9zsFGzyutWZ9fx939Tvys3fYz59nV+T
	eCu+RMemh+syn9xhr4eWzUsmRcbdylmuPdMlfyYn+/KNm68qsRRnJBpqMRcVJwIA7dAiQr8C	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jQd2T74+FGHw5x2px8H69xfwjQMap
	g8tZLS7vmsNmMXtJP4vFomWtzBa3G1ewWezv3cBk0fNIy2L/FS8HLo9vXyexePRtWcXocfzG
	diaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4DOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmNM/rYS04bVJx
	6Ooy1gbGY2pdjJwcEgImEot7prJD2GISF+6tZ+ti5OIQEpjOKHF0w112COc1o8S1n4fBqngF
	tCQWdMxlArFZBFQlzt9/B2azAcX3v7jBBmKLCoRJrJx+hQWiXlDix+R7YLaIgKLEvZUQG5gF
	ljBJ3JyzjBEkISzgJ3G/9R/U6kuMElum32DtYuTg4BRQk+hsYAWpYRZQl5g0bxEzhC0vsXnN
	W+YJjAKzkOyYhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4/yZ9A7GVQ0W
	hxgFOBiVeHg33DwWIsSaWFZcmXuIUYKDWUmEd/IJoBBvSmJlVWpRfnxRaU5q8SFGU2AQTGSW
	Ek3OB6agvJJ4Q2MTMyNLI3NDCyNjcyVxXiX7thAhgfTEktTs1NSC1CKYPiYOTqkGRuO4n1e8
	gj6lZHn0BzRs3Poz89GZ5IdLHR45GeZWXL/SYutwSib11IzWs8KWT8XuvnPNP3nga9EG0bbX
	lfVvLxTzXQqPPhR//pf59Y8SO1V+N59wEudkn+svFLh+61HGC/cqWboe7Dmzm2PhbZcim1N/
	DfRuHbOd9+nh59aoFe0NSzdMOrUkWl6JpTgj0VCLuag4EQCOwZRuCQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On 01/27/2015 01:27 AM, Roger Quadros wrote:
> Hi Chanwoo,
> 
> All your comments are valid. Need some clarification on one comment.
> 
> On 26/01/15 15:56, Chanwoo Choi wrote:
>> Hi Roger,
>>
>> This patch looks good to me. But I add some comment.
>> If you modify some comment, I'll apply this patch on 3.21 queue.
>>
>> On Mon, Jan 26, 2015 at 9:15 PM, Roger Quadros <rogerq@ti.com> wrote:
>>> This driver observes the USB ID pin connected over a GPIO and
>>> updates the USB cable extcon states accordingly.
>>>
>>> The existing GPIO extcon driver is not suitable for this purpose
>>> as it needs to be taught to understand USB cable states and it
>>> can't handle more than one cable per instance.
>>>
>>> For the USB case we need to handle 2 cable states.
>>> 1) USB (attach/detach)
>>> 2) USB-Host (attach/detach)
>>>
>>> This driver can be easily updated in the future to handle VBUS
>>> events in case it happens to be available on GPIO for any platform.
>>>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>> ---
>>>  .../devicetree/bindings/extcon/extcon-usb-gpio.txt |  20 ++
>>>  drivers/extcon/Kconfig                             |   7 +
>>>  drivers/extcon/Makefile                            |   1 +
>>>  drivers/extcon/extcon-usb-gpio.c                   | 214 +++++++++++++++++++++
>>>  4 files changed, 242 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
>>>  create mode 100644 drivers/extcon/extcon-usb-gpio.c
>>>
> 
> <snip>
> 
>>> +
>>> +static int usb_extcon_probe(struct platform_device *pdev)
>>> +{
>>> +       struct device *dev = &pdev->dev;
>>> +       struct device_node *np = dev->of_node;
>>> +       struct usb_extcon_info *info;
>>> +       int ret;
>>> +
>>> +       if (!np)
>>> +               return -EINVAL;
>>> +
>>> +       info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>>> +       if (!info)
>>> +               return -ENOMEM;
>>> +
>>> +       info->dev = dev;
>>> +       info->id_gpiod = devm_gpiod_get(&pdev->dev, "id");
>>> +       if (IS_ERR(info->id_gpiod)) {
>>> +               dev_err(dev, "failed to get ID GPIO\n");
>>> +               return PTR_ERR(info->id_gpiod);
>>> +       }
>>> +
>>> +       ret = gpiod_set_debounce(info->id_gpiod,
>>> +                                USB_GPIO_DEBOUNCE_MS * 1000);
>>> +       if (ret < 0)
>>> +               info->debounce_jiffies = msecs_to_jiffies(USB_GPIO_DEBOUNCE_MS);
>>> +
>>> +       INIT_DELAYED_WORK(&info->wq_detcable, usb_extcon_detect_cable);
>>> +
>>> +       info->id_irq = gpiod_to_irq(info->id_gpiod);
>>> +       if (info->id_irq < 0) {
>>> +               dev_err(dev, "failed to get ID IRQ\n");
>>> +               return info->id_irq;
>>> +       }
>>> +
>>> +       ret = devm_request_threaded_irq(dev, info->id_irq, NULL,
>>> +                                       usb_irq_handler,
>>> +                                       IRQF_SHARED | IRQF_ONESHOT |
>>> +                                       IRQF_NO_SUSPEND,
>>> +                                       pdev->name, info);
> 
> use of IRQF_NO_SUSPEND is not recommended to be used together with IRQF_SHARED so
> I'll remove IRQF_SHARED from here if we decide to stick with IRQF_NO_SUSPEND.
> More on this below.
> 
>>> +       if (ret < 0) {
>>> +               dev_err(dev, "failed to request handler for ID IRQ\n");
>>> +               return ret;
>>> +       }
>>> +
>>> +       info->edev = devm_extcon_dev_allocate(dev, usb_extcon_cable);
>>> +       if (IS_ERR(info->edev)) {
>>> +               dev_err(dev, "failed to allocate extcon device\n");
>>> +               return -ENOMEM;
>>> +       }
>>> +
>>> +       ret = devm_extcon_dev_register(dev, info->edev);
>>> +       if (ret < 0) {
>>> +               dev_err(dev, "failed to register extcon device\n");
>>> +               return ret;
>>> +       }
>>> +
>>> +       platform_set_drvdata(pdev, info);
>>
>> I prefer to execute the device_init_wakeup() function as following
>> for suspend/resume function:
>>             device_init_wakeup(&pdev->dev, 1);
>>
>>> +
>>> +       /* Perform initial detection */
>>> +       usb_extcon_detect_cable(&info->wq_detcable.work);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int usb_extcon_remove(struct platform_device *pdev)
>>> +{
>>> +       struct usb_extcon_info *info = platform_get_drvdata(pdev);
>>> +
>>> +       cancel_delayed_work_sync(&info->wq_detcable);
>>
>> Need to add blank line.
>>
>>> +       return 0;
>>> +}
>>> +
>>> +#ifdef CONFIG_PM_SLEEP
>>> +static int usb_extcon_suspend(struct device *dev)
>>> +{
>>> +       struct usb_extcon_info *info = dev_get_drvdata(dev);
>>> +
>>> +       enable_irq_wake(info->id_irq);
>>
>> I prefer to use device_may_wakeup() function for whether
>> executing enable_irq_wake() or not. Also, The disable_irq()
>> in the suspend function would prevent us from discarding interrupt
>> before wakeup from suspend completely.
>>
> 
> I need more clarification here.
> 
> If we are going to use enable_irq_wake() here then what is the point of IRQF_NO_SUSPEND?
> 
>>From Documentation/power/suspend-and-interrupts.txt I see that interrupts marked
> as IRQF_NO_SUSPEND should not be configured for system wakeup using enable_irq_wake().
> 
> what is your preference?
> 
> Is it good enough to not use IRQF_NO_SUSPEND but use enable_irq_wake() instead to
> enable system wakeup for that IRQ.

I'm sorry for confusion about usage both IRQF_NO_SUSPEND and enable_irq_wake().
If suspend() function in device driver executes the enable_irq_wake(),
IRQF_NO_SUSPEND flag is not necessary.

I think that we better use enable_irq_wake() instead of adding IRQF_NO_SUSPEND flag.
I'll expect to remove IRQF_NO_SUSPEND flag when requesting gpio interrupt.

> 
>>             if (device_may_wakeup(dev))
>>                      enable_irq_wake(info->id_irq);
>>             disable_irq(info->id_irq);
> 
> why do we need to disable irq here? How will the system wakeup if IRQ is disabled?

The disable_irq() may make the interrupt as masking state.
Although interrput is masking state(disable), interrup can happen.
but, the interrupt may remain the pending state without discarding it.

And then,
When resume() function in extcon-usb-gpio.c executes enable_irq(info->id_irq),
pending interrupt will happen and executes the interrupt handler(usb_irq_handler).

If we don't execute disable_irq() in suspend function,
info->id->irq interrupt might happen before completing the resume sequence
of extcon-gpio-usb driver.

Thanks,
Chanwoo Choi
