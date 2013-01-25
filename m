Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab3AYB1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:27:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9262 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3AYB1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:27:08 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-cf-5101df690aac
Message-id: <5101DF68.9020805@samsung.com>
Date: Fri, 25 Jan 2013 10:27:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 24 (extcon-max77693)
References: <20130124171309.9742ea16b3cb15cc9e5ca3a4@canb.auug.org.au>
 <5101C386.4050802@infradead.org>
In-reply-to: <5101C386.4050802@infradead.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zPd3M+4yBButXillc3jWHzeLgwjZG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDImXPzNXrCGu2LZes0GxqecXYycHBICJhK7/v9lhrDF
	JC7cW8/WxcjFISSwjFFi7q4WZpiiziMnmSAS0xkl5s27yQjhvGCUmLLzDztIFa+AlsShV59Z
	QWwWAVWJVT/6WEBsNqD4/hc3gMZycIgKREj86ueAKBeU+DH5HliJiICGxO8rV8BamQXSJe4/
	egi2WFjASqLt4z5GEFtIIFNi86YZTCA2p4CuRMv2PiaIeh2J/a3T2CBseYnNa94yg9wmIdDN
	LnHycTcLxD0CEt8mH2IBuUFCQFZi0wGoxyQlDq64wTKBUWwWkpNmIRk7C8nYBYzMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzFCYkNqB+PKBotDjAIcjEo8vBZpjIFCrIllxZW5hxglOJiV
	RHhdIoBCvCmJlVWpRfnxRaU5qcWHGJOBDpzILCWanA+M27ySeENjA2NDQ0tDM1NLUwPShJXE
	eRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnVwHhBS/NtMV+of8ezX9FsYgfPBxj7CmiUWbxTj2tb
	n8m7aHXQZS72Q+KZq44d0v1T+ONLpeROxuM7De+cWxfGuaP93VG5q7M6Su8/2fOuprZuLpNQ
	BP/2f4+LW8yVA3Rs767PjN7gHnP/3pacyCSx5KITnyXM7srMW6xZt4Xv5tebYc4zPSZo7FFi
	Kc5INNRiLipOBACTjNJw0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t9jQd3M+4yBBotu8Vlc3jWHzeLgwjZG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzJlz8zV6whrti
	2XrNBsannF2MnBwSAiYSnUdOMkHYYhIX7q1n62Lk4hASmM4oMW/eTUYI5wWjxJSdf9hBqngF
	tCQOvfrMCmKzCKhKrPrRxwJiswHF97+4AdTNwSEqECHxq58DolxQ4sfke2AlIgIaEr+vXAFr
	ZRZIl7j/6CEziC0sYCXR9nEfI4gtJJApsXnTDLCDOAV0JVq29zFB1OtI7G+dxgZhy0tsXvOW
	eQKjwCwkK2YhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODIeya1g3Flg8Uh
	RgEORiUeXos0xkAh1sSy4srcQ4wSHMxKIrwuEUAh3pTEyqrUovz4otKc1OJDjMnAAJjILCWa
	nA9MCnkl8YbGJmZGlkZmxibmxsakCSuJ8zKeehIgJJCeWJKanZpakFoEs4WJg1OqgbGodUnB
	EY+CL4Hht1+3GbeZqa96rvJc6YmQ+vRtGhnrPvZejhcy5z5n//jelZs2X52esKxscbp1zVit
	WPPRx08Xf6eUlJn3tXi4zm5aretzu+/qvz0Xr+07KjfZu3BmV7nC8ZziKiH+mPzccyYrTjn/
	ZV5c9v7U0bKte73FY+8dCoj+wZPecUCJpTgj0VCLuag4EQDENTB+AAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 08:28 AM, Randy Dunlap wrote:
> On 01/23/13 22:13, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130123:
>>
> 
> 
> on i386, when CONFIG_INPUT is not enabled:
> 
> 
>  drivers/built-in.o: In function `max77693_muic_remove':
> extcon-max77693.c:(.text+0x664853): undefined reference to `input_unregister_device'
> drivers/built-in.o: In function `max77693_muic_probe':
> extcon-max77693.c:(.text+0x664971): undefined reference to `input_allocate_device'
> extcon-max77693.c:(.text+0x6649c1): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x6649d6): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x6649eb): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x664a00): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x664a15): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x664a20): undefined reference to `input_register_device'
> drivers/built-in.o: In function `max77693_muic_adc_handler':
> extcon-max77693.c:(.text+0x665318): undefined reference to `input_event'
> extcon-max77693.c:(.text+0x66532a): undefined reference to `input_event'
> make[1]: *** [vmlinux] Error 1
> 
> 
> 
> Needs
> 	depends on INPUT
> ??

You are right. I miss to add CONFIG_INPUT driver/extcon/Kconfig.
I will send fix patch of this build error right now.

Thank you,
Chanwoo Choi
