Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaJ1AZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:25:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36252 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJ1AZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:25:09 -0400
X-AuditID: cbfee691-f79b86d000004a5a-74-544ee2635b40
Message-id: <544EE263.8080109@samsung.com>
Date: Tue, 28 Oct 2014 09:25:07 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 0/3] ARM: dts: Add new board dts file for
 Exynos3250-based Rinato board
References: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
 <544ED8B5.3090607@samsung.com> <01b401cff244$d0052610$700f7230$@samsung.com>
In-reply-to: <01b401cff244$d0052610$700f7230$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkWDf5kV+IwZS9ChZ/Jx1jt/gzoZXN
	YtL9CSwWr18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi6XXLzJZnLr+Gcid/JLNYtWu
	P4wOvB5r5q1h9Pj9axKjx85Zd9k9Ni+p97hyoonVo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0S
	uDLO7mQr+CVUsXxeB1sD4wT+LkZODgkBE4lNb8+xQdhiEhfurQeyuTiEBJYySkxY0MMMU9R7
	oZ0dIjGdUWJ171QWCOc1o0T3j4ssIFW8AloSx98+AetgEVCVePf7GDuIzQYU3//iBtgKUYEw
	iZXTr0DVC0r8mHwPzBYRUJPoWbyVEWQos8AOJolfZzeDJYQF4iWWfZsIddNkRomLi2eATeUU
	sJKY2fsIrIhZQEdif+s0NghbXmLzmrfMIA0SAo0cEusPnGGHOElA4tvkQ0ANHEAJWYlNB6B+
	k5Q4uOIGywRGsVlIjpqFZOwsJGMXMDKvYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiM49P/
	nk3cwXj/gPUhRgEORiUeXoOHfiFCrIllxZW5hxhNga6YyCwlmpwPTBZ5JfGGxmZGFqYmpsZG
	5pZmSuK8OtI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw1oRHry221Xl4kV8zq6iKc7fa
	EV0/ozXBQVl3BavuyCyZrr/vablu3fcHTlK/SnYdYjNbcUdXze7mnXn6mr9q9WoPMhQu37T1
	paCY3MxdP6Xq5y7ymP2p+ID2m6QWj1lrmAs4W0xX7kiaULdom49HLYtn13v3b3LBCqbaM/Vl
	z6mu5Nt62PODEktxRqKhFnNRcSIAYZ8jZd4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd3kR34hBh8viFv8nXSM3eLPhFY2
	i0n3J7BYvH5haNG74CqbxdmmN+wWmx5fY7W4vGsOm8WM8/uYLJZev8hkcer6ZyB38ks2i1W7
	/jA68HqsmbeG0eP3r0mMHjtn3WX32Lyk3uPKiSZWj74tqxg9Pm+SC2CPamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMOYcXYnW8EvoYrl8zrYGhgn8HcxcnJICJhI9F5oZ4ew
	xSQu3FvP1sXIxSEkMJ1RYnXvVBYI5zWjRPePiywgVbwCWhLH3z5hBrFZBFQl3v0+BtbNBhTf
	/+IGG4gtKhAmsXL6Fah6QYkfk++B2SICahI9i7cyggxlFtjBJPHr7GawhLBAvMSybxOhVk9m
	lLi4eAbYVE4BK4mZvY/AipgFdCT2t05jg7DlJTavecs8gVFgFpIls5CUzUJStoCReRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcJJ4JrWDcWWDxSFGAQ5GJR5eg4d+IUKsiWXFlbmHGCU4
	mJVEeL12AIV4UxIrq1KL8uOLSnNSiw8xmgLDYCKzlGhyPjCB5ZXEGxqbmBlZGpkbWhgZmyuJ
	8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYDzhV3D4J6vg1D2LPx44K/bdbeIiC+5LD6J2quq+
	WB21yrdbjaE0sem3+q8ftxK+cQbNcwmuumycGRPlZnmn3WPnDqe3M8u+ckwU5VWNOdEbvCRv
	4olz1yev+FgR1lp1ZOkcU5Vf01yD0mo2PInP9Ze6UfK5nXd7YGZMfTb/m2sNHxVrTl85b6TE
	UpyRaKjFXFScCABzThClKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

On 10/28/2014 09:19 AM, Kukjin Kim wrote:
> Chanwoo Choi wrote:
>>
>> Dear Kukjin,
>>
> Hi,
> 
>> Did you please pick up this patchset on 3.19 queue?
>>
> I'll apply this series once my previous pull-request which has been sent out
> last week is merged into arm-soc tree.
> 
> If any comments on this series, I'll let you know.
> 

Thanks for applied it.

Best Regards,
Chanwoo Choi

> 
> 
>> Best Regards,
>> Chanwoo Choi
>>
>> On 10/24/2014 10:12 PM, Chanwoo Choi wrote:
>>> This patchset adds new board dts file for Samsung Rinato board (Gear 2) which
>>> is based on Exynos3250 SoC and adds sleep mode pin configuration using pinctrl
>>> subsystem to reduce leakage power-consumption in sleep state.
>>>
>>> This patchset is based on linux-samsung.git (for-next branch).
>>>
>>> Changes from v3:
>>> - Fix wrong email address
>>> - Remove 'vemmc_reg' fixed regulator and then use 'ldo12_reg' for mshc_0
>>>
>>> Changes from v2:
>>> - Separate patch3 from patchset[1] and then this patchset includes patch3.
>>>   After applied patch3, the power-consumption of Rinato board is 0.6mA in suspend state.
>>>   [1] [PATCHv5 0/3] regulator: of: Add support for parsing regulator suspend state
>>>   : https://lkml.org/lkml/2014/10/10/161
>>> - Change PDN (Power-down mode) state for GPE0-3 (BT_UART_RTS) because Rinato
>>>   board uses UART1 for bluetooth device. BT_UART_RTS pin should be disabled in
>>>   suspend state by setting high state of GPE0-3
>>> - Turn on always the regulator state of VAP_VMIPI_1.0V because if VAP_VMIPI_1.0V
>>>   is off state or would be not controlled by DRM driver, happen imprecise external abort.
>>>
>>> Changes from v1:
>>> - Remove useless brace
>>> - Remove unneeded 'regulators' keyword
>>> - Consolidate memory information in one entry
>>>
>>> Chanwoo Choi (3):
>>>   ARM: dts: Add board dts file for Exynos3250-based Rinato board
>>>   ARM: dts: Add sleep mode pin configuration for exynos3250-rinato
>>>   ARM: dts: Add sleep mode of regulator for exynos3250-rinato board
>>>
>>>  arch/arm/boot/dts/Makefile                |   3 +-
>>>  arch/arm/boot/dts/exynos3250-pinctrl.dtsi |  16 +
>>>  arch/arm/boot/dts/exynos3250-rinato.dts   | 686 ++++++++++++++++++++++++++++++
>>>  3 files changed, 704 insertions(+), 1 deletion(-)
>>>  create mode 100644 arch/arm/boot/dts/exynos3250-rinato.dts
>>>
> 
> 

