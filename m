Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776Ab3IDFSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:18:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11448 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383Ab3IDFSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:18:37 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-e7-5226c2a6cfad
Message-id: <5226C2A6.9000805@samsung.com>
Date: Wed, 04 Sep 2013 14:18:30 +0900
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
 <20130904011640.GA24275@kroah.com>
In-reply-to: <20130904011640.GA24275@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkQHfZIbUgg3drTS2mPnzCZvFvyg12
	i/4tLhbNi9ezWVx42sNmcbbpDbvF5V1z2CxuN65gc+Dw2LSqk81j/9w17B4vJ/5m8+jbsorR
	Y+qUv4wex29sZ/L4vEkugD2KyyYlNSezLLVI3y6BK+P4VraCddIVs692sjcwPhPrYuTkkBAw
	kWhf/ZsRwhaTuHBvPVsXIxeHkMBSRomTOxYxdzFygBVN7DaFiE9nlJix8goThPOKUeL1y0fM
	IN28AloSH7Z1gE1iEVCV+Hx2LxOIzQYU3//iBhuILSoQJrFy+hUWiHpBiR+T74HZIgIaEi+P
	3mIBGcos0MgkcXHxfBaQzcICuRJLjoZDLFvHJDGpYy/YMk4BfYm3i++xgtjMAjoS+1unsUHY
	8hKb17xlBmmQEHjJLrGms4kF4iIBiW+TD7FAvCMrsekAM8TLkhIHV9xgmcAoNgvJTbOQjJ2F
	ZOwCRuZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIExefrfswk7GO8dsD7EmAy0ciKzlGhy
	PjCm80riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	aGgUm+o/P+lLbWewOcuhOKYYrlUvt/5x64tlsElLSrQ4/3xZe11BK4enipG2VNGmFlYdpj3G
	soJHih9/T7rwYGKd4iEl1l9FXzV/bRGTVZxVwWDmf2T+hLjdKxgP/zyUvjOtVjhoy5nZlp8v
	beLw2rhWY7Vj3IKdf5cfaH1d+k7qemWXRqy9EktxRqKhFnNRcSIAlMr3oN8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd1lh9SCDB7/1LGY+vAJm8W/KTfY
	Lfq3uFg0L17PZnHhaQ+bxdmmN+wWl3fNYbO43biCzYHDY9OqTjaP/XPXsHu8nPibzaNvyypG
	j6lT/jJ6HL+xncnj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	x7eyFayTrph9tZO9gfGZWBcjB4eEgInExG7TLkZOIFNM4sK99WxdjFwcQgLTGSVmrLzCBOG8
	YpR4/fIRM0gVr4CWxIdtHYwgNouAqsTns3uZQGw2oPj+FzfYQGxRgTCJldOvsEDUC0r8mHwP
	zBYR0JB4efQWC8hQZoFGJomLi+ezgFwhLJArseRoOMSydUwSkzr2gi3jFNCXeLv4HiuIzSyg
	I7G/dRobhC0vsXnNW+YJjAKzkOyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGCI/6Z1A7GlQ0WhxgFOBiVeHg3PFMNEmJNLCuuzD3EKMHBrCTCm+CjFiTEm5JYWZValB9f
	VJqTWnyIMRkYBBOZpUST84HJKK8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJJanZqakF
	qUUwW5g4OKUaGHVVJqhE3PyyU3GCv02Ctv7r+skZuxTj7HycA5WjjMpUgvtN9bbsmSl5td3s
	k9ZT7Qalb3MfLm1pMTowb2W8iteH73IKln/vGBu/nnu+/nJdgGG2/rIVEfMX3BMUby5ZVrzR
	+J1Qt87O3O3x++IPiB36N+3d3gtTY3o/Z8wRfvBIe3bHrJqjnkosxRmJhlrMRcWJAHtJ5yg8	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 10:16 AM, Greg KH wrote:
> On Wed, Sep 04, 2013 at 09:17:02AM +0900, Chanwoo Choi wrote:
>> On 09/04/2013 12:57 AM, Greg KH wrote:
>>> On Mon, Sep 02, 2013 at 10:13:44AM +0900, Chanwoo Choi wrote:
>>>> Hi Greg,
>>>>
>>>> On 09/02/2013 09:40 AM, Greg KH wrote:
>>>>> On Mon, Sep 02, 2013 at 09:20:08AM +0900, Chanwoo Choi wrote:
>>>>>> This patch remove extcon_dev_register()'s second parameter which means
>>>>>> the pointer of parent device to simplify prototype of this function.
>>>>>
>>>>> No, please don't.  You want the parent to be passed in, as the core
>>>>> needs it when it is registered with the system, otherwise it will not
>>>>> show up in sysfs properly (i.e. you can't set it afterwards.)
>>>>
>>>> Currently, each extcon driver have allocated memory for extcon device
>>>> by using devm_kzalloc() in each extcon device driver.
>>>
>>> That seems backwards, the extcon core should be the one doing the
>>> allocation, and ownership of the device, like all other subsystem cores
>>> do.  That makes the driver logic much simpler, and the lifetime
>>> ownership correct (i.e. what happens when a device is unbound from a
>>> driver by userspace?  The driver can't control the device memory
>>> anymore...)
>>>
>>
>> OK,
>> The extcon core will control memory allocation instead of extcon device driver
>> as following.
>> - devm_extcon_allocate_device(struct device *dev)
> 
> Huh?  Why do you need a devm allocator?  This is a "real" child device,
> just create it with a "extcon_create_device()" or some such call, like
> all other busses do?

I refer Input/IIO subsystem to check the process of device registration.
Input subsystem has following functions for memory allocation of input device
and input device registration.

Input subsystem
- struct input_dev *devm_input_allocate_device(struct device *device)
- struct input_dev *input_allocate_device(void)
- int input_register_device(struct input_dev *dev)
drivers/input/input.c

devm_input_allocate_device()/input_allocate_device() can allocate
memory for input device in input core. And then created input device
pass input_register_device() as parameter.

So, input device driver haven't executed kmalloc() or devm_kmalloc()
to allocate memory of input device by using input_allocate_device()/
devm_input_allocate_device().


Also,IIO subsystem has separate iio_device_alloc() function
to allocate memory for iio device. But IIO subsystem hasn't
"devm_" allocator. So, If iio device driver fail initialization
in *_probe, should execute iio_device_free() to free allocated memory.

IIO Subsystem
- iio_device_alloc(int sizeof_priv)
- iio_device_register(struct iio_dev *indio_dev);
drivers/iio/industrialio-core.c


So, I think extcon subsystem need extcon_allocate_device()/devm_extcon_allocate_device()
to allocate for memory extcon device. To implement devm_extcon_allocate_device() function
, extcon subsystem need extcon_allocate_device() because devm_extcon_allocate_device()
must call extcon_allocate_device for memory allocation.

If extcon_allocate_device()/devm_extcon_allocate_device() is implemented to extcon core,
I think extcon core can control the memory operation of extcon device.

EXTCON Subsystem
- devm_extcon_allocate_device(struct device *dev)
- extcon_allocate_device(void)
- extcon_dev_register(struct extcon_dev *edev)

If I'm wrong, please correct me. Thanks.

Best Regards,
Chanwoo Choi








