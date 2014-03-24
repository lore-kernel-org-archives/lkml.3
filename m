Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaCXBgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 21:36:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21708 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaCXBgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 21:36:05 -0400
X-AuditID: cbfee690-b7f266d00000287c-79-532f8c0142e8
Message-id: <532F8C04.7060204@samsung.com>
Date: Mon, 24 Mar 2014 10:36:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, Tomasz Figa <t.figa@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCHv4 0/5] devfreq: exynos: Fix minor issue and code clean to
 remove legacy method
References: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
 <532DA3BB.5090000@gmail.com>
In-reply-to: <532DA3BB.5090000@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkSJexRz/Y4Mo6RYuNM9azWpxtesNu
	cXnXHDaLGef3MVncblzBZvF4xVt2i/UzXrNYrNr1h9GBw2PnrLvsHov3vGTy6NuyitHj8ya5
	AJYoLpuU1JzMstQifbsEroxJ6z4xFewUqPjfcp25gXE6bxcjJ4eEgInE5CUb2CBsMYkL99YD
	2VwcQgJLGSVOztrJBFO0o/chVGI6o8S+U7uYIZxXjBJfem6CtfMKaEnsmdQN1sEioCpx50gP
	WJwNKL7/xQ0wW1QgTGLl9CssEPWCEj8m3wOzRQTUJb5N6WcHGcos8IlR4v6iPWCDhAVSJA4+
	fANWJARk/zn5lxXE5hTQlJizfhLYUGYBHYn9rdOgbHmJzWvegl0nIXCKXWLi3T3sEBcJSHyb
	fAhoEAdQQlZi0wFmiNckJQ6uuMEygVFsFpKbZiEZOwvJ2AWMzKsYRVMLkguKk9KLTPSKE3OL
	S/PS9ZLzczcxAmPv9L9nE3Yw3jtgfYgxGWjlRGYp0eR8YOzmlcQbGpsZWZiamBobmVuakSas
	JM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMjp9b2NCO260xC62vuJcodWal56fR2
	1qset+Z/3dy5vPRUfNEX/YdnzrouPWrawmq5clGcDNNiO3aB2GOnojs/LnBxnrb8w8xyyXXa
	ec+YJ7711bk4P35r3tl76xfuS53D+GPFDnPB65obb+38xcu3fWdf3JL77LPP1BRevtYb7ZLM
	MuVGqPnNFCWW4oxEQy3mouJEAGLTK5vTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV3GHv1ggz0fpCw2zljPanG26Q27
	xeVdc9gsZpzfx2Rxu3EFm8XjFW/ZLdbPeM1isWrXH0YHDo+ds+6yeyze85LJo2/LKkaPz5vk
	AliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmTFr3ialgp0DF/5brzA2M
	03m7GDk5JARMJHb0PmSDsMUkLtxbD2RzcQgJTGeU2HdqFzOE84pR4kvPTbAqXgEtiT2TuplA
	bBYBVYk7R3rA4mxA8f0vboDZogJhEiunX2GBqBeU+DH5HpgtIqAu8W1KPzvIUGaBT4wS9xft
	ARskLJAicfDhG7AiISD7z8m/rCA2p4CmxJz1k8CGMgvoSOxvnQZly0tsXvOWeQKjwCwkO2Yh
	KZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODIfia9g3FVg8UhRgEORiUe3oIP
	usFCrIllxZW5hxglOJiVRHiNO/WDhXhTEiurUovy44tKc1KLDzEmA4NgIrOUaHI+MOnklcQb
	GpuYGVkamRtaGBmbkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVANjvf4xhxSRT2+Zv788
	IHJdTnLZi3WTHJdpOHWn/b42fwqvK2dW+TTdL6qx4U02BcXHtznbXKh4U3ZyYrVTSfLDraJZ
	h/mkFlbKLppu8u9i57U7ijrvnV4m2/DJlnEWzbsstTfC5WZmy2Up86tqVvl3vU4KdBvdnHZk
	yYdGnePGk3RSXyXdyDZWYinOSDTUYi4qTgQAWAYbbjADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/22/2014 11:52 PM, Tomasz Figa wrote:
> Hi,
> 
> [fixing mistyped addresses of me and Bartlomiej]
> 
> On 20.03.2014 03:59, Chanwoo Choi wrote:
>> This patchset use SIMPLE_DEV_PM_OPS macro intead of legacy method and fix
>> probe fail if CONFIG_PM_OPP is disabled. Also, this patchset fix minor issue.
>>
>> Changes from v3:
>> - Discard patches related to DT support because DT support patch of patchset
>>    don't satisfy the basic of dt concept. So, I'm going to implement DT support
>>    patch regardless this patchset separately.
>> - Use SIMPLE_DEV_PM_OPS macro instead of SET_SYSTEM_SLEEP_PM_OPS macro
>> - Delete devfreq->profile->exit callback to improve readability when failure
>>    happen in probe().
>> - Add exynos5 patch to clean code
>>
>> Changes from v2:
>> - Add detailed description to Documentation/devicetree/bindings/exynos4_bus.txt
>>    and change patch description of patch#8
>> - Change the sequence of patchset in patch #1 ~ #4
>> - Fix minor issue
>>
>> Changes from v1:
>> - Add exynos4_bus.txt documentation for devicetree guide
>> - Fix probe failure if CONFIG_PM_OPP is disabled
>> - Fix typo and resource leak(regulator/clock/memory) when happening probe failure
>> - Add additionally comment for PPMU usage instead of previous PPC
>> - Split separate patch to remove ambiguous of patch
>>
>> Chanwoo Choi (5):
>>    devfreq: exynos4: Fix bug of resource leak and code clean on probe()
>>    devfreq: exynos4: Use SIMPLE_DEV_PM_OPS macro
>>    devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
>>    devfreq: exynos5: Use SIMPLE_DEV_PM_OPS macro
>>    devfreq: exynos5: Add CONFIG_PM_OPP dependency to fix probe fail
>>
>>   drivers/devfreq/Kconfig              |  2 ++
>>   drivers/devfreq/exynos/exynos4_bus.c | 43 ++++++++++++++++++++++--------------
>>   drivers/devfreq/exynos/exynos5_bus.c |  7 ++++--
>>   3 files changed, 34 insertions(+), 18 deletions(-)
>>
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 

Thanks for your review always.

Best Regards,
Chanwoo Choi

