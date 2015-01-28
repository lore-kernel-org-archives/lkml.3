Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbbA1CTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:19:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45268 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549AbbA1CT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:19:27 -0500
X-AuditID: cbfee68e-f79b46d000002b74-e7-54c8472c368a
Message-id: <54C8472B.6070302@samsung.com>
Date: Wed, 28 Jan 2015 11:19:23 +0900
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
 <54C66B0D.9040109@ti.com> <54C6EFC8.1090601@samsung.com>
 <54C7B0E5.20101@ti.com>
In-reply-to: <54C7B0E5.20101@ti.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkQFfH/USIweNVqhYH79dbzD9yjtXi
	1MHlrBaXd81hs5i9pJ/FYtGyVmaL240r2Cz2925gsuh5pGWx/4qXA5fHt6+TWDz6tqxi9Dh+
	YzuTx+dNcgEsUVw2Kak5mWWpRfp2CVwZu6cvYyl4a1ex7P4e5gbG1fpdjJwcEgImEncP97FD
	2GISF+6tZ+ti5OIQEljKKNG88iYrTNGTFxfYIRLTGSU23J3MCuG8ZpQ40tXKDFLFK6Al8X7G
	eTCbRUBV4uOya2DdbEDx/S9usIHYogJhEiunX2GBqBeU+DH5HpgtIqAocW8lxGpmgSVMEjfn
	LGMESQgL+Encb/0HdVM3k8Ta59vBNnAKqEj0fZwDNpVZQF1i0rxFzBC2vMTmNW+ZQRokBC6x
	S/zZNIsJ4iQBiW+TDwGt4wBKyEpsOsAM8ZukxMEVN1gmMIrNQnLULCRjZyEZu4CReRWjaGpB
	ckFxUnqRkV5xYm5xaV66XnJ+7iZGYCye/vesbwfjzQPWhxgFOBiVeHhfmJ0IEWJNLCuuzD3E
	aAp0xURmKdHkfGDE55XEGxqbGVmYmpgaG5lbmimJ8yZI/QwWEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwNjLJbelXrJDW5Llixvj3XdcrUv/M3Ca1uvs6/tiu+tZ7v/Yn++/nLiluOnrlZk8
	ydxHDkd1/ZzRXFp/fuXX5+0Zv/gq9PZsCJmvK9Ry4TBjXzG/gdMEMdsDUeVB+5q3X3/beLHy
	XsLJoKc/zSrDJeNefNzmE3ek+a+LJZvEnOV/Opw6nuw3+aXEUpyRaKjFXFScCAC7ZQqDwAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jQV0d9xMhBkcmy1gcvF9vMf/IOVaL
	UweXs1pc3jWHzWL2kn4Wi0XLWpktbjeuYLPY37uByaLnkZbF/iteDlwe375OYvHo27KK0eP4
	je1MHp83yQWwRDUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4
	BOi6ZeYAnaOkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzNg9fRlLwVu7
	imX39zA3MK7W72Lk5JAQMJF48uICO4QtJnHh3nq2LkYuDiGB6YwSG+5OZoVwXjNKHOlqZQap
	4hXQkng/4zyYzSKgKvFx2TVWEJsNKL7/xQ02EFtUIExi5fQrLBD1ghI/Jt8Ds0UEFCXurYTY
	wCywhEni5pxljCAJYQE/ifut/6BWdzNJrH2+HWwDp4CKRN/HOWBTmQXUJSbNW8QMYctLbF7z
	lnkCo8AsJEtmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgSH8mtYNxZYPF
	IUYBDkYlHt4XZidChFgTy4orcw8xSnAwK4nwvtUACvGmJFZWpRblxxeV5qQWH2I0BYbBRGYp
	0eR8YBLKK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpgXNF6tO+l
	55P+gE99uk9+3P+1eq+xavqHgx4XIoIXzvdXtNzvELA9ufxlg79i4YWwD51THRKEVObMKzcT
	/7e9QbEwzlMw6pPAe/dLNjyuYX1zVbaVrbPZnnb5QoXFBn6NFaxeU343lmq9edFiOlnp/tdV
	Hzhrsjq1Ha5IrM+WnC1zKT/67Y1aJZbijERDLeai4kQAPwS5OQoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On 01/28/2015 12:38 AM, Roger Quadros wrote:
> Chanwoo,
> 
> On 27/01/15 03:54, Chanwoo Choi wrote:
>> Hi Roger,
>>
>> On 01/27/2015 01:27 AM, Roger Quadros wrote:
>>> Hi Chanwoo,
>>>
>>> All your comments are valid. Need some clarification on one comment.
>>>
>>> On 26/01/15 15:56, Chanwoo Choi wrote:
>>>> Hi Roger,
>>>>
>>>> This patch looks good to me. But I add some comment.
>>>> If you modify some comment, I'll apply this patch on 3.21 queue.
>>>>
>>>> On Mon, Jan 26, 2015 at 9:15 PM, Roger Quadros <rogerq@ti.com> wrote:
>>>>> This driver observes the USB ID pin connected over a GPIO and
>>>>> updates the USB cable extcon states accordingly.
>>>>>
>>>>> The existing GPIO extcon driver is not suitable for this purpose
>>>>> as it needs to be taught to understand USB cable states and it
>>>>> can't handle more than one cable per instance.
>>>>>
>>>>> For the USB case we need to handle 2 cable states.
>>>>> 1) USB (attach/detach)
>>>>> 2) USB-Host (attach/detach)
>>>>>
>>>>> This driver can be easily updated in the future to handle VBUS
>>>>> events in case it happens to be available on GPIO for any platform.
>>>>>
>>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>>> ---
>>>>>  .../devicetree/bindings/extcon/extcon-usb-gpio.txt |  20 ++
>>>>>  drivers/extcon/Kconfig                             |   7 +
>>>>>  drivers/extcon/Makefile                            |   1 +
>>>>>  drivers/extcon/extcon-usb-gpio.c                   | 214 +++++++++++++++++++++
>>>>>  4 files changed, 242 insertions(+)
>>>>>  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
>>>>>  create mode 100644 drivers/extcon/extcon-usb-gpio.c
>>>>>
>>>
>>> <snip>
>>>
>>>>> +
>>>>> +static int usb_extcon_probe(struct platform_device *pdev)
>>>>> +{
>>>>> +       struct device *dev = &pdev->dev;
>>>>> +       struct device_node *np = dev->of_node;
>>>>> +       struct usb_extcon_info *info;
>>>>> +       int ret;
>>>>> +
>>>>> +       if (!np)
>>>>> +               return -EINVAL;
>>>>> +
>>>>> +       info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>>>>> +       if (!info)
>>>>> +               return -ENOMEM;
>>>>> +
>>>>> +       info->dev = dev;
>>>>> +       info->id_gpiod = devm_gpiod_get(&pdev->dev, "id");
>>>>> +       if (IS_ERR(info->id_gpiod)) {
>>>>> +               dev_err(dev, "failed to get ID GPIO\n");
>>>>> +               return PTR_ERR(info->id_gpiod);
>>>>> +       }
>>>>> +
>>>>> +       ret = gpiod_set_debounce(info->id_gpiod,
>>>>> +                                USB_GPIO_DEBOUNCE_MS * 1000);
>>>>> +       if (ret < 0)
>>>>> +               info->debounce_jiffies = msecs_to_jiffies(USB_GPIO_DEBOUNCE_MS);
>>>>> +
>>>>> +       INIT_DELAYED_WORK(&info->wq_detcable, usb_extcon_detect_cable);
>>>>> +
>>>>> +       info->id_irq = gpiod_to_irq(info->id_gpiod);
>>>>> +       if (info->id_irq < 0) {
>>>>> +               dev_err(dev, "failed to get ID IRQ\n");
>>>>> +               return info->id_irq;
>>>>> +       }
>>>>> +
>>>>> +       ret = devm_request_threaded_irq(dev, info->id_irq, NULL,
>>>>> +                                       usb_irq_handler,
>>>>> +                                       IRQF_SHARED | IRQF_ONESHOT |
>>>>> +                                       IRQF_NO_SUSPEND,
>>>>> +                                       pdev->name, info);
>>>
>>> use of IRQF_NO_SUSPEND is not recommended to be used together with IRQF_SHARED so
>>> I'll remove IRQF_SHARED from here if we decide to stick with IRQF_NO_SUSPEND.
>>> More on this below.
>>>
>>>>> +       if (ret < 0) {
>>>>> +               dev_err(dev, "failed to request handler for ID IRQ\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       info->edev = devm_extcon_dev_allocate(dev, usb_extcon_cable);
>>>>> +       if (IS_ERR(info->edev)) {
>>>>> +               dev_err(dev, "failed to allocate extcon device\n");
>>>>> +               return -ENOMEM;
>>>>> +       }
>>>>> +
>>>>> +       ret = devm_extcon_dev_register(dev, info->edev);
>>>>> +       if (ret < 0) {
>>>>> +               dev_err(dev, "failed to register extcon device\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       platform_set_drvdata(pdev, info);
>>>>
>>>> I prefer to execute the device_init_wakeup() function as following
>>>> for suspend/resume function:
>>>>             device_init_wakeup(&pdev->dev, 1);
>>>>
>>>>> +
>>>>> +       /* Perform initial detection */
>>>>> +       usb_extcon_detect_cable(&info->wq_detcable.work);
>>>>> +
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +static int usb_extcon_remove(struct platform_device *pdev)
>>>>> +{
>>>>> +       struct usb_extcon_info *info = platform_get_drvdata(pdev);
>>>>> +
>>>>> +       cancel_delayed_work_sync(&info->wq_detcable);
>>>>
>>>> Need to add blank line.
>>>>
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +#ifdef CONFIG_PM_SLEEP
>>>>> +static int usb_extcon_suspend(struct device *dev)
>>>>> +{
>>>>> +       struct usb_extcon_info *info = dev_get_drvdata(dev);
>>>>> +
>>>>> +       enable_irq_wake(info->id_irq);
>>>>
>>>> I prefer to use device_may_wakeup() function for whether
>>>> executing enable_irq_wake() or not. Also, The disable_irq()
>>>> in the suspend function would prevent us from discarding interrupt
>>>> before wakeup from suspend completely.
>>>>
>>>
>>> I need more clarification here.
>>>
>>> If we are going to use enable_irq_wake() here then what is the point of IRQF_NO_SUSPEND?
>>>
>>> >From Documentation/power/suspend-and-interrupts.txt I see that interrupts marked
>>> as IRQF_NO_SUSPEND should not be configured for system wakeup using enable_irq_wake().
>>>
>>> what is your preference?
>>>
>>> Is it good enough to not use IRQF_NO_SUSPEND but use enable_irq_wake() instead to
>>> enable system wakeup for that IRQ.
>>
>> I'm sorry for confusion about usage both IRQF_NO_SUSPEND and enable_irq_wake().
>> If suspend() function in device driver executes the enable_irq_wake(),
>> IRQF_NO_SUSPEND flag is not necessary.
>>
>> I think that we better use enable_irq_wake() instead of adding IRQF_NO_SUSPEND flag.
>> I'll expect to remove IRQF_NO_SUSPEND flag when requesting gpio interrupt.
>>
> OK.
> 
>>>
>>>>             if (device_may_wakeup(dev))
>>>>                      enable_irq_wake(info->id_irq);
>>>>             disable_irq(info->id_irq);
>>>
>>> why do we need to disable irq here? How will the system wakeup if IRQ is disabled?
>>
>> The disable_irq() may make the interrupt as masking state.
>> Although interrput is masking state(disable), interrup can happen.
>> but, the interrupt may remain the pending state without discarding it.
>>
>> And then,
>> When resume() function in extcon-usb-gpio.c executes enable_irq(info->id_irq),
>> pending interrupt will happen and executes the interrupt handler(usb_irq_handler).
>>
>> If we don't execute disable_irq() in suspend function,
>> info->id->irq interrupt might happen before completing the resume sequence
>> of extcon-gpio-usb driver.
> 
> How will that cause a problem? If an interrupt happens _before_ the system enters
> SUSPEND state then kernel should abort the suspend. This should be taken care by 
> kernel PM core and not the device driver.
> 
> I still fail to understand that we need to call disable_irq() in .suspend() and
> enable_irq() in .resume()
> 
> can you point me to any other drivers doing so?

You can refer the suspend function in drivers/mfd/max14577.c or drivers/mfd/max77693.c.
The max14577_suspend() includes the detailed comment for why using disable_irq() in suspend function.

In max14577 case, max14577_suspend() use disable_irq() function because of i2c dependency.
If max14577 device is wake-up from suspend state before completing the resume sequence
of i2c, max14577 may fail to read/write i2c communication.

Thanks,
Chanwoo Choi

