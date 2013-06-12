Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab3FLAzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:55:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60397 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3FLAzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:55:00 -0400
X-AuditID: cbfee68e-b7f276d000002279-56-51b7c6e0e6f8
Message-id: <51B7C6E0.3000603@samsung.com>
Date: Wed, 12 Jun 2013 09:54:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org, anish198519851985@gmail.com,
        pmeerw@pmeerw.net
Subject: Re: [PATCH 0/5] dwc3: omap: adapt dwc3 to use extcon framework
References: <1370276020-17446-1-git-send-email-kishon@ti.com>
In-reply-to: <1370276020-17446-1-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWyRsSkQPfBse2BBhNauCwu3+hitjh4v95i
	5qebbBYHZj9ktTjwZwejRfPi9WwWF572sFksbFvCYnF51xw2i9lL+lksFi1rZba43biCzeL3
	rmPsFodXHGCyWPdyOosDv8eCz1fYPXbOusvu8Wr1TFaPO9f2sHnsn7uG3eP8jIWMHuebjzB6
	9G1Zxehx/MZ2Jo/Pm+QCuKK4bFJSczLLUov07RK4Mpa8es1W8IC/Ysvxe6wNjF+5uxg5OSQE
	TCRO79nIDmGLSVy4t56ti5GLQ0hgKaPEvD8/mGCK1t36zwSRmM4ocffeDRaQhJDAC0aJdR1m
	IDavgJbE8YUP2UBsFgFVidbXb8Fq2IDi+1/cAIuLCoRJrJx+hQWiXlDix+R7YLYIUM3pnT+Y
	QRYwC3xmkvjavIaxi5GDQ1jAXaKrlw1il63EnUdtYJdyCthJfNx6khnEZhbQkdjfOo0NwpaX
	2LzmLdgcCYG1HBIvVi5ghDhIQOLb5EMsIDMlBGQlNh1ghnhMUuLgihssExjFZiE5aRaSsbOQ
	jF3AyLyKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzDuT/971reD8eYB60OMyUArJzJLiSbn
	A9NGXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	Re+E152sqFRPyHw8c/6PnWGntQqDpZrDrPWZjgnOWqqkvTBCSnvJ51WTL1Z85km5/erCymyn
	B+FuLgd5GNJP3/rovfeSa5tX11+L/zPOdl9ckzzzURaT+FOBZBtDIwfGPL1Jwa+WsYVfNal4
	t6Yv6Qrz52K1cz6+ljkVLmxyGUaL30R8PqakxFKckWioxVxUnAgAzV296REDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jQd0Hx7YHGkz2trh8o4vZ4uD9eouZ
	n26yWRyY/ZDV4sCfHYwWzYvXs1lceNrDZrGwbQmLxeVdc9gsZi/pZ7FYtKyV2eJ24wo2i9+7
	jrFbHF5xgMli3cvpLA78Hgs+X2H32DnrLrvHq9UzWT3uXNvD5rF/7hp2j/MzFjJ6nG8+wujR
	t2UVo8fxG9uZPD5vkgvgimpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshL
	zE21VXLxCdB1y8wBekNJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLHk
	1Wu2ggf8FVuO32NtYPzK3cXIySEhYCKx7tZ/JghbTOLCvfVsXYxcHEIC0xkl7t67wQKSEBJ4
	wSixrsMMxOYV0JI4vvAhG4jNIqAq0fr6LVgNG1B8/4sbYHFRgTCJldOvsEDUC0r8mHwPzBYB
	qjm98wczyAJmgc9MEl+b1zB2MXJwCAu4S3T1skHsspW486iNHcTmFLCT+Lj1JDOIzSygI7G/
	dRobhC0vsXnNW+YJjAKzkKyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC
	U8ozqR2MKxssDjEKcDAq8fAeMNseKMSaWFZcmXuIUYKDWUmEVzcXKMSbklhZlVqUH19UmpNa
	fIgxGRgCE5mlRJPzgekuryTe0NjEzMjSyNzQwsjYnDRhJXHeA63WgUIC6YklqdmpqQWpRTBb
	mDg4pRoY8zdplbSs+2NjtTqFXWnyqv/PFvjX5j+PLbHMLlvxo8yb8cuCFD2FrvD798UWBvyv
	Xl2/6NIjI/0l39e5a7RqBRwxm1H7LX11zeIjR2r/Ta763naNy+TD38Vij9ffXPPdMaiSN6DJ
	d8mlFdKdb1MuHWjzzNmU+ZVJpUvrMM/LpWdNhOUOmvxQVGIpzkg01GIuKk4EAHeFXLdtAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

Sorry for late reply.

I applied patch1,2 on extcon-linus branch.
- http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/log/?h=extcon-linus

But, I have comment of patch 3 about dt API. I send comment on patch 3 mailing thread.

Thanks,
Chanwoo Choi

On 06/04/2013 01:13 AM, Kishon Vijay Abraham I wrote:
> The first three patches deals with cleanup of extcon inorder to get
> through compilation without any issues. It also adds an API to get
> extcon device from dt node which I felt was missing.
>
> The next two patches deals with adapt dwc3 to use extcon framework.
> The 4th patch (usb: dwc3: omap: improve error handling of dwc3_omap_probe)
> should have ideally been sent to Felipe, however since
> there will be merge conflicts with the 5th patch
> (usb: dwc3: use extcon fwrk to receive connect/disconnect)
> in this series, I've sent in the same series.
>
> Once this patch series get merged, dwc3 in omap would be functional
> in device mode. However there is still some discussion on modelling
> SMPS10 regulator. Once that gets finalized, dwc3 should be functional
> in host mode as well.
>
> Kishon Vijay Abraham I (5):
>   extcon: Add an API to get extcon device from dt node
>   extcon: Kconfig: Make extcon config type as bool
>   extcon: add EXPORT_SYMBOL_GPL for exported functions
>   usb: dwc3: omap: improve error handling of dwc3_omap_probe
>   usb: dwc3: use extcon fwrk to receive connect/disconnect
>
>  Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
>  drivers/extcon/Kconfig                             |    2 +-
>  drivers/extcon/extcon-class.c                      |   42 +++++++
>  drivers/usb/dwc3/dwc3-omap.c                       |  133 ++++++++++++++++----
>  include/linux/extcon.h                             |    8 ++
>  include/linux/usb/dwc3-omap.h                      |   30 -----
>  6 files changed, 168 insertions(+), 52 deletions(-)
>  delete mode 100644 include/linux/usb/dwc3-omap.h
>

