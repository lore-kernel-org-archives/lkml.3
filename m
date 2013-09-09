Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab3IICoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:44:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14942 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3IICoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:44:14 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-69-522d35fbaeed
Message-id: <522D35FB.6060106@samsung.com>
Date: Mon, 09 Sep 2013 11:44:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 3/3] extcon: Simplify extcon_dev_register() prototype by
 removing unnecessary parameter
References: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
 <1378081208-20274-4-git-send-email-cw00.choi@samsung.com>
 <20130902004024.GB10709@kroah.com> <5223E648.7020207@samsung.com>
 <20130903155744.GA21846@kroah.com> <52267BFE.3030106@samsung.com>
 <20130904011640.GA24275@kroah.com> <5226C2A6.9000805@samsung.com>
 <20130908215100.GA29783@kroah.com>
In-reply-to: <20130908215100.GA29783@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkQPe3qW6QwYUzJhZTHz5hs/g35Qa7
	Rf8WF4vmxevZLC487WGzONv0ht3i8q45bBa3G1ewOXB4bFrVyeaxf+4ado+XE3+zefRtWcXo
	MXXKX0aP4ze2M3l83iQXwB7FZZOSmpNZllqkb5fAlXFnVVjBF7mKWcfzGhivSXYxcnJICJhI
	/P6+hR3CFpO4cG89WxcjF4eQwFJGiY8P7zHDFF3adJoVIjGdUWLlg1VQzitGiTd/N7GBVPEK
	aEmsuLeLBcRmEVCV6D95FqybDSi+/8UNsBpRgTCJldOvsEDUC0r8mHwPzBYR0JB4efQWC8hQ
	ZoFGJomLi+cDORwcwgK5EkuOhkMs+8Qk8W5+D9itnAL6EnOmbQcbyiygI7G/dRqULS+xec1b
	ZpAGCYFH7BKnl89hhbhIQOLb5ENgQyUEZCU2HYB6TVLi4IobLBMYxWYhuWkWkrGzkIxdwMi8
	ilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMwJk//e9a7g/H2AetDjMlAKycyS4km5wNjOq8k
	3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjHccAtYb
	pDFJnghQL8mfv1FWdv09H41FZzWXeSxR+brnlO+pmW8nrGXIZrz3qM5bMP9E767sbiHnY5/v
	ZUmqx+Yfd2oP+cc97fLvdWuMhOR+XLuzTfZjXX2Xy7QHU/u4InZk+pUKfTx38+CUp5MDBGq/
	1FlpWkyasWrL6nNtc5dunGl8ctJtVz0lluKMREMt5qLiRADrJyJw3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd3fprpBBrMn6VhMffiEzeLflBvs
	Fv1bXCyaF69ns7jwtIfN4mzTG3aLy7vmsFncblzB5sDhsWlVJ5vH/rlr2D1eTvzN5tG3ZRWj
	x9Qpfxk9jt/YzuTxeZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBVSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM
	O6vCCr7IVcw6ntfAeE2yi5GTQ0LAROLSptOsELaYxIV769m6GLk4hASmM0qsfLCKFcJ5xSjx
	5u8mNpAqXgEtiRX3drGA2CwCqhL9J88yg9hsQPH9L26A1YgKhEmsnH6FBaJeUOLH5HtgtoiA
	hsTLo7dYQIYyCzQySVxcPB/I4eAQFsiVWHI0HGLZJyaJd/N72EEaOAX0JeZM2w42lFlAR2J/
	6zQoW15i85q3zBMYBWYh2TELSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH
	/DOpHYwrGywOMQpwMCrx8Er81wkSYk0sK67MPcQowcGsJMJ7/jlQiDclsbIqtSg/vqg0J7X4
	EGMyMAgmMkuJJucDk1FeSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYw
	cXBKNTAG/pvu5bXpY802pUohB2mv7L0Gyfpi4Wt2zbnK5T6H30BZfdUO6+5QkVXvkgIUrwW2
	Gs5+V8uicSZoyyyHwgPLGnYou2xvsy8puvfj45Qz4u7S38+6evapuT9aVK9aohtSqNqbdTKq
	cqex4GLm9/u1tFa3qgpUaK74J817aUP8z6zJ57X5niuxFGckGmoxFxUnAgDs2VLuPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, 
On 09/09/2013 06:51 AM, Greg KH wrote:
> On Wed, Sep 04, 2013 at 02:18:30PM +0900, Chanwoo Choi wrote:
>> On 09/04/2013 10:16 AM, Greg KH wrote:
>>> On Wed, Sep 04, 2013 at 09:17:02AM +0900, Chanwoo Choi wrote:
>>>> On 09/04/2013 12:57 AM, Greg KH wrote:
>>>>> On Mon, Sep 02, 2013 at 10:13:44AM +0900, Chanwoo Choi wrote:
>>>>>> Hi Greg,
>>>>>>
>>>>>> On 09/02/2013 09:40 AM, Greg KH wrote:
>>>>>>> On Mon, Sep 02, 2013 at 09:20:08AM +0900, Chanwoo Choi wrote:
>>>>>>>> This patch remove extcon_dev_register()'s second parameter which means
>>>>>>>> the pointer of parent device to simplify prototype of this function.
>>>>>>>
>>>>>>> No, please don't.  You want the parent to be passed in, as the core
>>>>>>> needs it when it is registered with the system, otherwise it will not
>>>>>>> show up in sysfs properly (i.e. you can't set it afterwards.)
>>>>>>
>>>>>> Currently, each extcon driver have allocated memory for extcon device
>>>>>> by using devm_kzalloc() in each extcon device driver.
>>>>>
>>>>> That seems backwards, the extcon core should be the one doing the
>>>>> allocation, and ownership of the device, like all other subsystem cores
>>>>> do.  That makes the driver logic much simpler, and the lifetime
>>>>> ownership correct (i.e. what happens when a device is unbound from a
>>>>> driver by userspace?  The driver can't control the device memory
>>>>> anymore...)
>>>>>
>>>>
>>>> OK,
>>>> The extcon core will control memory allocation instead of extcon device driver
>>>> as following.
>>>> - devm_extcon_allocate_device(struct device *dev)
>>>
>>> Huh?  Why do you need a devm allocator?  This is a "real" child device,
>>> just create it with a "extcon_create_device()" or some such call, like
>>> all other busses do?
>>
>> I refer Input/IIO subsystem to check the process of device registration.
>> Input subsystem has following functions for memory allocation of input device
>> and input device registration.
>>
>> Input subsystem
>> - struct input_dev *devm_input_allocate_device(struct device *device)
>> - struct input_dev *input_allocate_device(void)
>> - int input_register_device(struct input_dev *dev)
>> drivers/input/input.c
>>
>> devm_input_allocate_device()/input_allocate_device() can allocate
>> memory for input device in input core. And then created input device
>> pass input_register_device() as parameter.
>>
>> So, input device driver haven't executed kmalloc() or devm_kmalloc()
>> to allocate memory of input device by using input_allocate_device()/
>> devm_input_allocate_device().
>>
>>
>> Also,IIO subsystem has separate iio_device_alloc() function
>> to allocate memory for iio device. But IIO subsystem hasn't
>> "devm_" allocator. So, If iio device driver fail initialization
>> in *_probe, should execute iio_device_free() to free allocated memory.
>>
>> IIO Subsystem
>> - iio_device_alloc(int sizeof_priv)
>> - iio_device_register(struct iio_dev *indio_dev);
>> drivers/iio/industrialio-core.c
>>
>>
>> So, I think extcon subsystem need extcon_allocate_device()/devm_extcon_allocate_device()
>> to allocate for memory extcon device. To implement devm_extcon_allocate_device() function
>> , extcon subsystem need extcon_allocate_device() because devm_extcon_allocate_device()
>> must call extcon_allocate_device for memory allocation.
>>
>> If extcon_allocate_device()/devm_extcon_allocate_device() is implemented to extcon core,
>> I think extcon core can control the memory operation of extcon device.
>>
>> EXTCON Subsystem
>> - devm_extcon_allocate_device(struct device *dev)
>> - extcon_allocate_device(void)
>> - extcon_dev_register(struct extcon_dev *edev)
>>
>> If I'm wrong, please correct me. Thanks.
> 
> No, you are totally correct, I was wrong, nevermind, continue on doing a
> great job, my mistake :)
> 
> greg k-h

Thanks for your comment always.

Best Regards,
Chanwoo Choi


