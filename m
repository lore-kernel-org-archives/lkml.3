Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3LWI0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:26:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:17991 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab3LWI03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:26:29 -0500
X-AuditID: cbfee690-b7f266d00000287c-07-52b7f3af98e6
Message-id: <52B7F3B2.7070709@samsung.com>
Date: Mon, 23 Dec 2013 17:26:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Barry Song <21cnbao@gmail.com>
Cc: rjying <rjying@gmail.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RongJun Ying <Rongjun.Ying@csr.com>,
        Binghua Duan <Binghua.Duan@csr.com>
Subject: Re: [PATCH 1/1] extcon: gpio: Add power resume support
References: <1387526987-12455-1-git-send-email-rongjun.ying@csr.com>
 <52B7B9F0.1020801@samsung.com>
 <CAGsJ_4xwc63kEBgmMk+E3JpYLhX0Vt1qQPcBXNtOGC2Gmo=MOw@mail.gmail.com>
 <52B7D990.2020206@samsung.com>
 <CAGsJ_4wbYkadoM5HHwbGUcwuimxiq-u9FMaWMs7wD-SXU4ybcQ@mail.gmail.com>
 <52B7ECC7.8020508@samsung.com>
 <CAGsJ_4wUszpPNxkpDZfbgC7DSAPtxYDmmRsFAih9Lmd-wxL1Fw@mail.gmail.com>
In-reply-to: <CAGsJ_4wUszpPNxkpDZfbgC7DSAPtxYDmmRsFAih9Lmd-wxL1Fw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWyRsSkRHf95+1BBm2T+S0+3xWyaGjYwWhx
	edccNovbjSvYLG71HmC22HfhD6sDm8eunXNYPXbOusvu0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBknbr1nKlgqVjH1bW0D43fBLkZODgkBE4l1u/ewQNhiEhfurWfrYuTiEBJYyihx9s1N
	Zpii349nM0MkFjFKLFj7iRXCecUocaF9NSNIFa+AlsTxpevYuxg5OFgEVCWaV3mChNmAwvtf
	3GADsUUFwiRWTr/CAlEuKPFj8j0wW0RASWLy1G8sIDOZBXYySuy/u5UVJCEsYC+x8uMiRohl
	f5gk9n2/AjaJUyBY4vfpS2DnMQuoS0yatwjKlpfYvOYt2KkSAsfYJfYvOgXWwCIgIPFt8iEW
	kOskBGQlNh2Aek1S4uCKGywTGMVmITlqFpKxs5CMXcDIvIpRNLUguaA4Kb3IRK84Mbe4NC9d
	Lzk/dxMjMMZO/3s2YQfjvQPWhxiTgVZOZJYSTc4HxmheSbyhsZmRhamJqbGRuaUZacJK4rxq
	j5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBOt4+RcD4ZY2DdvMfkTvSB4l091hPO61/O
	fJdx+diUWydrBLcmL1rSEpLfeKy7KbrIZ22euZuXUZVUR5NczPemtqlCkgZMR+oj41sm3djS
	XD1l1bUjyebxUz8+0Z6gXhHau7fhfsXNgpuzvHIMOOt6eZd8Zel21s2rCNzn5ZEvIyLBdI71
	qRJLcUaioRZzUXEiAMCIDX7HAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd31n7cHGaw7yWHx+a6QRUPDDkaL
	y7vmsFncblzBZnGr9wCzxb4Lf1gd2Dx27ZzD6rFz1l12j74tqxg9Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMOHHrPVPBUrGKqW9rGxi/C3YxcnJICJhI/H48
	mxnCFpO4cG89WxcjF4eQwCJGiQVrP7FCOK8YJS60r2YEqeIV0JI4vnQdexcjBweLgKpE8ypP
	kDAbUHj/ixtsILaoQJjEyulXWCDKBSV+TL4HZosIKElMnvqNBWQms8BORon9d7eygiSEBewl
	Vn5cxAix7A+TxL7vV8AmcQoES/w+fQnsPGYBdYlJ8xZB2fISm9e8ZZ7AKDALyZJZSMpmISlb
	wMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4gp9J7WBc2WBxiFGAg1GJh5ejZXuQEGti
	WXFl7iFGCQ5mJRHe6B/bgoR4UxIrq1KL8uOLSnNSiw8xJgODYCKzlGhyPjC55JXEGxqbmBlZ
	GpkbWhgZm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo6nST9+FmvX3rZIObM+dK7dw
	3W81+yWb4x8nvtb/qi1gzq7wZGr/i7rI5xNDlt7hjXVJmcvQWrcv7h3Ldyfxd8yJ2XGPq48t
	3h6lVz435fkt7rcLT+pxS7VGfHvmPveh2b9OB/u7r268jGZjz0n5+cTqwt7MbRt3v7l68yfv
	vNydJg++z2GcbarEUpyRaKjFXFScCACmWYHNJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 05:13 PM, Barry Song wrote:
> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>> On 12/23/2013 04:36 PM, Barry Song wrote:
>>> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>>>> On 12/23/2013 03:10 PM, Barry Song wrote:
>>>>> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>>>>>> On 12/20/2013 05:09 PM, rjying wrote:
>>>>>>> From: Rongjun Ying <rongjun.ying@csr.com>
>>>>>>>
>>>>>>> After system resume, need send extcon uevent to userspace
>>>>>>
>>>>>> Why did extcon send uevent after wakeup from suspend?
>>>>>>
>>>>>> If extcon cable is attatched or detached on suspend state,
>>>>>> Kernel can detect the interrupt about changed state of extcon.
>>>>>
>>>>> irq controller has lost power in suspend, so there is no pending interrupt.
>>>>> and HW will not pend any interrupt when we hotplug cable during sleep.
>>>>
>>>> No, SoC in suspend state must maintain the minimum power under 1mA
>>>> if completed the power-optimization on suspend state.
>>>>
>>>> If user insert USB cable to target, the external interrupt connected to
>>>> USB port is happened. And kernel would be waked up from suspend state
>>>> to operate proper interrupt handler of external interrupt.
>>>
>>> no. not every USB supports that. that depends on the power domain design of SoC.
>>
>> USB is only example for gpio control in suspend state.
>>
>>>
>>>>
>>>> Also,
>>>> Input subsystem used gpio-keys driver for power button..
>>>> If user press power button in suspend state, target would be waked up from suspend state.
>>>> It is same case both extcon gpio and gpio-keys of input subsystem.
>>>
>>> no. it depends on the SoC design. many SoC only support 1 special key
>>> which can work as ON-KEY as wakeup source. and this kind of keys might
>>> not be GPIO at all.
>>> there is a special power domain which is still open for it.
>>
>> many SoC?
>>
>> As I knew, most SoC has supported various wakeup source.
>> As you comment, if specific SoC support only one special key
>> for wakeup from suspend state, I think it isn't common.
>>
>> Also,
>> This patch isn't necessary on SoCs which support various wakeup source (e.g., external interrupt).
>> As you comment, this issue has dependecy on specific SoC. Why did you think this common code?
> 
> i am not thinking this patch must be common codes but i think the
> extcon should provide common codes to support all chips. that is what
> a framework should consider.
> 
> if there is no this or things similar with this, how could extcon
> support the chips which don't support receiving sleep gpio interrupts?

Sure, subsystem should support all cases related to this issue.

I'd like to send common patch to support all cases as we discussed.
If some patch support all case, I would review and apply it.

Chanwoo Choi





