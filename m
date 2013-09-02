Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab3IBBNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 21:13:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24030 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3IBBNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 21:13:46 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-7f-5223e6480982
Message-id: <5223E648.7020207@samsung.com>
Date: Mon, 02 Sep 2013 10:13:44 +0900
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
 <20130902004024.GB10709@kroah.com>
In-reply-to: <20130902004024.GB10709@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkRNfjmXKQweGLxhZTHz5hs/g35Qa7
	Rf8WF4vmxevZLC487WGzONv0ht3i8q45bBa3G1ewOXB4bFrVyeaxf+4ado+XE3+zefRtWcXo
	MXXKX0aP4ze2M3l83iQXwB7FZZOSmpNZllqkb5fAlXFjdi9TwVTeisOff7A3MD7h6mLk5JAQ
	MJGYevUVO4QtJnHh3nq2LkYuDiGBpYwSV59MZYIp+rrwADtEYhGjxPuvm8E6hAReMUp8vxUE
	YvMKaEnsej6VsYuRg4NFQFWia18YSJgNKLz/xQ02EFtUIExi5fQrLBDlghI/Jt8Ds0UENCRe
	Hr3FAjKfWaCRSeLi4vksIHOEBXIllhwNh9i7jFHixYPFYA2cAvoSy69dYgaxmQV0JPa3TmOD
	sOUlNq95ywzSICHwkl1i62GIBhYBAYlvkw+BDZUQkJXYdIAZ4jFJiYMrbrBMYBSbheSmWUjG
	zkIydgEj8ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwJg8/e9Z7w7G2wesDzEmA62cyCwl
	mpwPjOm8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTC29uVw+W5y9OIXdLpxfsLEl/Gp6+03CDjNv+RTwG76fv+X/f85b4Uvzlnmdsowtf6MmtOW
	L2vO9DdWuRvOqBDbYX4x61XZtQgzAduDhyY8mDJR1KixNkZy8i6bA/lhNc5P333cJlC9QNbo
	f6bwxV/dWzhebd2Vte362oTUlRe3XjTav7C8/66BEktxRqKhFnNRcSIAACOZWd8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV2PZ8pBBmfealtMffiEzeLflBvs
	Fv1bXCyaF69ns7jwtIfN4mzTG3aLy7vmsFncblzB5sDhsWlVJ5vH/rlr2D1eTvzN5tG3ZRWj
	x9Qpfxk9jt/YzuTxeZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBVSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM
	G7N7mQqm8lYc/vyDvYHxCVcXIyeHhICJxNeFB9ghbDGJC/fWs3UxcnEICSxilHj/dTNYQkjg
	FaPE91tBIDavgJbErudTGbsYOThYBFQluvaFgYTZgML7X9xgA7FFBcIkVk6/wgJRLijxY/I9
	MFtEQEPi5dFbLCDzmQUamSQuLp7PAjJHWCBXYsnRcIi9yxglXjxYDNbAKaAvsfzaJWYQm1lA
	R2J/6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefn
	bmIER/wzqR2MKxssDjEKcDAq8fBWrFAOEmJNLCuuzD3EKMHBrCTCa/wEKMSbklhZlVqUH19U
	mpNafIgxGRgCE5mlRJPzgckoryTe0NjEzMjSyNzQwsjYnDRhJXHeA63WgUIC6YklqdmpqQWp
	RTBbmDg4pRoYp6vejM9acU5sXdUHS4s60asccpdm+8ZvjriV/XzfQkG9DQV+PtFXg2dezEl/
	bWpc0vFrjav/xtLnf9dUd0Uv1ZVcrlfaG2irbzDVMPFYR1LMyRnfs2VLt3Hvb6yMf6twSePO
	bMPKd4d1TRVsrTqDrq5ddnzmrHTHv9VmF4658ly8JWbde+aGEktxRqKhFnNRcSIAnlIyeDwD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 09/02/2013 09:40 AM, Greg KH wrote:
> On Mon, Sep 02, 2013 at 09:20:08AM +0900, Chanwoo Choi wrote:
>> This patch remove extcon_dev_register()'s second parameter which means
>> the pointer of parent device to simplify prototype of this function.
> 
> No, please don't.  You want the parent to be passed in, as the core
> needs it when it is registered with the system, otherwise it will not
> show up in sysfs properly (i.e. you can't set it afterwards.)

Currently, each extcon driver have allocated memory for extcon device
by using devm_kzalloc() in each extcon device driver.So,I have plan to
implement "devm_extcon_allocate_device()" which allocate managed extcon device
and connect with parent device(->dev.parent = dev).
(I refer to devm_input_allocate_device() in drivers/input/input.c)

So, This patch is precedence work before implementing devm_extcon_allocate_device()
because the pointer of parent device have to pass devm_extcon_allocate_device()
instead of extcon_dev_register().

I'm going to change registration prcedure for extcon device as following:
Before:
	ret = extcon_dev_register(edev, dev);

After:
	edev = devm_extcon_allocate_device(dev);
	...
	ret = extcon_dev_register(edev);
	...


If you want me to send this feature including in 'devm_extcon_allocate_device()'
at the same time, I'll complete this feature and then post this patchset again.

> 
>> So, if extcon device has the parent device, it should set the pointer of
>> parent device to edev.dev.parent in extcon device driver instead of in
>> extcon_dev_register().
> 
> No it will break things if you do that :(

Best Regards,
Chanwoo Choi
