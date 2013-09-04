Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642Ab3IDARS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:17:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65044 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761544Ab3IDARQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:17:16 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-a3-52267bfe5979
Message-id: <52267BFE.3030106@samsung.com>
Date: Wed, 04 Sep 2013 09:17:02 +0900
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
 <20130903155744.GA21846@kroah.com>
In-reply-to: <20130903155744.GA21846@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkQPdftVqQwZ1+IYupD5+wWfybcoPd
	on+Li0Xz4vVsFhee9rBZnG16w25xedccNovbjSvYHDg8Nq3qZPPYP3cNu8fLib/ZPPq2rGL0
	mDrlL6PH8RvbmTw+b5ILYI/isklJzcksSy3St0vgyjh04z5rwS+uinkzzjE1ML7g6GLk5JAQ
	MJG4e3wmM4QtJnHh3nq2LkYuDiGBpYwShz48Y4cp+nj4NxNEYjqjxPY1T6GcV4wSu+9uYAWp
	4hXQknh95yZYB4uAqsTLvmYmEJsNKL7/xQ02EFtUIExi5fQrLBD1ghI/Jt8Ds0UENCReHr3F
	AjKUWaCRSeLi4vlADgeHsECuxJKj4SA1YMvm35EGsTkF9CUOXH8PtotZQEdif+s0NghbXmLz
	mrfMIHMkBB6xS+xbtJoF4iABiW+TD4HNlBCQldh0AOplSYmDK26wTGAUm4XkpFlIxs5CMnYB
	I/MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMCoPP3v2YQdjPcOWB9iTAZaOZFZSjQ5HxjV
	eSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgNBVp
	6P73iGf9j/qj2+ctrCg1V06UVjnx+bZs5sTsWMG3ZWycz5erHmR/0mMxzeH88WMRcjGLF1au
	Sc6+9HuZWsaRYzdlp9YaT3+iezimu37G8bdtIbGKpgqLhO/ZbM3OkZtuejcvucjP4U3IlYmt
	S+ZXnTC6nvepckugr4Nm/O9V4Zfd9skUK7EUZyQaajEXFScCAN5ujzjgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd1/1WpBBnMncVlMffiEzeLflBvs
	Fv1bXCyaF69ns7jwtIfN4mzTG3aLy7vmsFncblzB5sDhsWlVJ5vH/rlr2D1eTvzN5tG3ZRWj
	x9Qpfxk9jt/YzuTxeZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBVSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM
	Qzfusxb84qqYN+McUwPjC44uRk4OCQETiY+HfzNB2GISF+6tZ+ti5OIQEpjOKLF9zVMmCOcV
	o8TuuxtYQap4BbQkXt+5yQ5iswioSrzsawbrZgOK739xgw3EFhUIk1g5/QoLRL2gxI/J98Bs
	EQENiZdHb7GADGUWaGSSuLh4PpDDwSEskCux5Gg4SA3Ysvl3pEFsTgF9iQPX34PtYhbQkdjf
	Oo0NwpaX2LzmLfMERoFZSFbMQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB
	Mf9MegfjqgaLQ4wCHIxKPLwH7dWChFgTy4orcw8xSnAwK4nwJvgAhXhTEiurUovy44tKc1KL
	DzEmA0NgIrOUaHI+MB3llcQbGpuYGVkamRtaGBmbkyasJM57sNU6UEggPbEkNTs1tSC1CGYL
	EwenVAOjhtQ6BnEB3wwvlecqyY47IqzqaxO6WH8l5tVeEXZeeHHJw53G3LwnXaZdPLv5kmJE
	ip+F427bxU94Vmo8FuhZsF1/sfzdm8wtm3ZvTfio/rXsRHPxMlWFeqe5od3HpDtn5erWtW+b
	yNOWcr0kVfp8AV9K3f65Pm5FfKcz6mZ+Cox8f7CYaa0SS3FGoqEWc1FxIgBv7bhnPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 12:57 AM, Greg KH wrote:
> On Mon, Sep 02, 2013 at 10:13:44AM +0900, Chanwoo Choi wrote:
>> Hi Greg,
>>
>> On 09/02/2013 09:40 AM, Greg KH wrote:
>>> On Mon, Sep 02, 2013 at 09:20:08AM +0900, Chanwoo Choi wrote:
>>>> This patch remove extcon_dev_register()'s second parameter which means
>>>> the pointer of parent device to simplify prototype of this function.
>>>
>>> No, please don't.  You want the parent to be passed in, as the core
>>> needs it when it is registered with the system, otherwise it will not
>>> show up in sysfs properly (i.e. you can't set it afterwards.)
>>
>> Currently, each extcon driver have allocated memory for extcon device
>> by using devm_kzalloc() in each extcon device driver.
> 
> That seems backwards, the extcon core should be the one doing the
> allocation, and ownership of the device, like all other subsystem cores
> do.  That makes the driver logic much simpler, and the lifetime
> ownership correct (i.e. what happens when a device is unbound from a
> driver by userspace?  The driver can't control the device memory
> anymore...)
> 

OK,
The extcon core will control memory allocation instead of extcon device driver
as following.
- devm_extcon_allocate_device(struct device *dev)

I'll complete this feature about memory allocation for extcon device
and resend it again. Thanks.

Best Regards,
Chanwoo Choi

