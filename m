Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab3AYSB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:01:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25889 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab3AYSB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:01:56 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-6e-5102c893eb3a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, dianders@chromium.org,
        jg1.han@samsung.com, cpgs@samsung.com
References: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v2 0/2] usb: exynos: Fix compatible strings used for device
Date: Fri, 25 Jan 2013 10:01:32 -0800
Message-id: <010e01cdfb26$04adcb00$0e096100$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJDuRtN8z1cah/7gtvl8MOZA67cM5du2Qlw
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zQ93JJ5gCDXY0S1hc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlXF59jX2giUcFQ/nnGduYDzA1sXIySEhYCJx
	8ccaJghbTOLCvfVgcSGBZYwSN57YwtQ0bLwNFOcCii9ilFizazozhPOXUWJjyy+wbjYBDYnD
	75+xg9giAh4Sd48tZwcpYhZ4wCRx5sx5doixHhLN7f0sIDangKfEnFnNYOuEBfwl9r2ayQxi
	swioSsx/2wpWwytgKXFq51R2CFtQ4sfke2BxZgEtifU7jzNB2PISm9e8ZYY4VUFix9nXjBBH
	GEncbb0HVSMuMenBQ7CDJARWsUs8m3qMDWKZgMS3yYeAhnIAJWQlNh2AmiMpcXDFDZYJjBKz
	kKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGSMRJ72Bc1WBxiFGA
	g1GJh/fDXKZAIdbEsuLK3EOMEhzMSiK8MiZAId6UxMqq1KL8+KLSnNTiQ4zJQMdOZJYSTc4H
	JoO8knhDY2MTMxNTE3NLU3NT0oSVxHkZTz0JEBJITyxJzU5NLUgtgtnCxMEp1cCY3GrbkDSx
	II053NBrvpzh/7wmK5sLm4M3B4de/CP3tXRbXHL9yp2ndpQzVJy5eGT7x7J6x6eSHwsSlx/7
	n/PD9Po8Lu7AYsmHz65f1HoSazNrzd12/oIphvnn7PYxn12wYdXc/zGaLzdX76no2sL24PUp
	ca+u8D851iUBJXsPXHXsWJAV8rVfiaU4I9FQi7moOBEAN3jkRfwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAd3JJ5gCDU6uFrK4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj8uxr
	7AVLOCoezjnP3MB4gK2LkZNDQsBEomHjbShbTOLCvfVANheHkMAiRok1u6YzQzh/GSU2tvxi
	AqliE9CQOPz+GTuILSLgIXH32HJ2kCJmgQdMEmfOnAdLCAElmtv7WUBsTgFPiTmzmsFWCAv4
	S+x7NZMZxGYRUJWY/7YVrIZXwFLi1M6p7BC2oMSPyffA4swCWhLrdx5ngrDlJTavecsMcaqC
	xI6zrxkhjjCSuNt6D6pGXGLSg4fsExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rpFe
	cWJucWleul5yfu4mRnBEP5PewbiqweIQowAHoxIP74e5TIFCrIllxZW5hxglOJiVRHhlTIBC
	vCmJlVWpRfnxRaU5qcWHGJOBPp3ILCWanA9MNnkl8YbGJmZGlkZmFkYm5uakCSuJ8zKeehIg
	JJCeWJKanZpakFoEs4WJg1OqgVHZo/H62YeujZvUbeqs6tYnWCTbFX6ZUvr014XzQabipkcL
	9ga+F45imdHIrxGpZfkgdNbd23nfXL03nxM5Z/XVL62Y8zB/x7trng/tjNseSjCuWL48yVSw
	p99a6NGXNZfO18+b+kcsxUJ6t16h74KX5j/87sRqZk3STqx/ZflZzvbqwn0lpkosxRmJhlrM
	RcWJANMEeM4sAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Using chip specific compatible string as it should be.
> So fixing this for ehci-s5p, ohci-exynos and dwc3-exynos
> which till now used a generic 'exynos' in their compatible strings.
> 
> Changes from v1:
> 	- Changing compatible string from "samsung,exynos5250-dwc3" to
> 	  "samsung,exynos5250-dwusb3" as per discussion happened in
> thread:
> 	  [PATCH 0/2] usb: exynos: Fix compatible strings used for device.
> 
> Vivek Gautam (2):
>   usb: ehci-s5p/ohci-exynos: Fix compatible strings for the device
>   usb: dwc3-exynos: Fix compatible strings for the device
> 
>  drivers/usb/dwc3/dwc3-exynos.c |    2 +-
>  drivers/usb/host/ehci-s5p.c    |    2 +-
>  drivers/usb/host/ohci-exynos.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
For now, I'm fine on this series, I'm still thinking we need to sort out the
chip name in compatible for IP though.

Felipe, please go ahead, if you want my ack, feel free to add:

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

