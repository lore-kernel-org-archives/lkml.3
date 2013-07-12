Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab3GLAs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:48:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33693 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3GLAs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:48:56 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-76-51df5277bccd
From: Jingoo Han <jg1.han@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>, "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Julius Werner'" <jwerner@chromium.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Felipe Balbi'" <balbi@ti.com>, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Tushar Behera'" <tushar.behera@linaro.org>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Olof Johansson'" <olofj@chromium.org>,
        "'Vincent Palatin'" <vpalatin@chromium.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Fabio Estevam'" <festevam@gmail.com>,
        "'Philipp Zabel'" <p.zabel@pengutronix.de>,
        Yulgon Kim <yulgon.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
 <000901ce7dc8$90a819b0$b1f84d10$@samsung.com>
 <CAODwPW-=bo2BqcHopY32N76p6DDGNDmCrKFo1R4gEEZhsG-DYg@mail.gmail.com>
In-reply-to: <CAODwPW-=bo2BqcHopY32N76p6DDGNDmCrKFo1R4gEEZhsG-DYg@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
Date: Fri, 12 Jul 2013 09:48:54 +0900
Message-id: <001701ce7e99$95b2c460$c1184d20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIqj1FUEYrwpGpRm2gJpEuTVlJQ6gHLDLVbAwQrQ7OYgZI8kA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSW0hTcRzH+Z9zdtwGxtFm/TWyGGSheN20vy4iguI8RGVBRS8218GZc45N
	rSB0mLekqWnamAUqamaWMcU0L7kJcyFiXjObmgwvMZTIpRFe2nYKfO3tw4/v7eHHxX1fcwK4
	ycp0Rq2UKoQknxjcXhSF3r40Fx+xUkog01w26qua56ChBhOJ5icuoPxxkxcaqxnloEKzHUO6
	6gkSjb17SiL9cC+GahvycPSzrQug4bYHGJqZtRKoRe8gkEVfB1CvvRlHBVs9JGpftxGocMjk
	dUpAV2lHCLrTMONF2ya7SXpYXwPokq0IuritCdADU28xes0YeJF7nX/iJqNIzmTU4Sdv8OV1
	nZukKk9w5+XyFS0oo4oAjwspMfxWVeXF8j74cbaFdLMv1QBgT/7Zf5q10U6CvdcCuNMdUgT4
	Lv4N4P1n3R4DSQVBp7PfEySgaPjeWUu4RTg1woHj+iUO6+gCcLoy3xPFoy5Da9E2cPNe6jzs
	t014mKCOQONDHeZmbyoWfrdMA5Z94K/yWY8Xp4JhS+cAxvIh2Nq8grNTD8OOIYdLz3WtOA21
	S7GsRAB7l1eBewOkbFy4ZndgbBcF18vNhFsPqYPQ2Pc3xh+aGqeIUgANu5oNu5oNu5oNuyqq
	AdEE/BiVTKVJTFJHhmmkqZoMZVKYLC3VCNhf0XWAL30SM5C56h/hAX6yNNcvKdMTIkUxUSha
	HC2KOh4b839n4X7voFxJvC+VJE1nUhhGxagT1BkKRmMGGJcXoAWBn41L1RUbKWeuTWY5xT6B
	mz8WHJljpgNvcluLn9+T4/4hdZMlcXROPfA32aY/tEvidviPfVstL5olQt3gV+7OYKOCV+Cw
	hOuMHbeOjW8E2b11d3esVmmC6Mms8NPVc9FbfLI/Kyd0tX5PYipWv5A89yq7onJR3mU4WjFY
	JhYSGrk0MhhXa6R/AFq15FtBAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42I5/e+xgG5Z0P1Ag3lHrCwO3q+3ODD7IavF
	2WUH2SweXvW3aLtykN3i8sJLrBYdhx4zWfQuuMpmcXnXHDaLGef3MVksWtbKbPF1y25Gi/Nb
	Opks7t47wWKxfsZrFotjM5YwWux7vIbZov3vXjaLbd/usFh0nD3I7iDiMbvhIovHzll32T3u
	XNvD5nF+xkJGj/6/Bh59W1Yxehy/sZ3J4/MmuQCOqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B4
	53hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygp5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo
	+oYEwfUYGaCBhHWMGUt2/mEraBWpWP0irIFxkkAXIyeHhICJxOdLO1kgbDGJC/fWs4HYQgKL
	GCX+79HuYuQCsn8xSjTP3QOWYBNQk/jy5TA7iC0i4CGx/8siFpAiZoGLrBJXZjxnhejYzShx
	a1ob2FhOgWCJE13/GEFsYQE/icN3roLZLAKqEpt6eplAbF4BS4kPx24xQtiCEj8m3wPrZRbQ
	kli/8zgThC0vsXnNW2aIUxUkdpx9DVTPAXSFk0TDc0uIEhGJfS/eMU5gFJqFZNIsJJNmIZk0
	C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBaeuZ1A7GlQ0WhxgFOBiVeHgLTtwL
	FGJNLCuuzD3EKMHBrCTCe9PsfqAQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wNTal5JvKGx
	iZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MNYfEP1RXtzQvau1I72y
	9ablAdtG52nSVbkyExpcaivPfn/+2rRy13+ntKDznCu2LLUXtVh57fSEvm9Rb2/FHL+5Q3Fh
	Qmfy+za/H2UpJU5aa9JKr3b3V844M+3s3uyGssdvfabEGtl0WZ183hDwM1TYJ4bld8q8CTyf
	qpp8Qv1/3a/6W8rEo8RSnJFoqMVcVJwIAGpquiifAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 12, 2013 6:46 AM, Julius Werner wrote:
> 
> Hi Jingoo,
> 
> Yeah, I followed that discussion back then, but it seems to have
> stalled a little (at least the HSIC patches haven't been picked up in
> any kernel.org repo yet to my knowledge).
> 
> The problem is that I think these approaches cannot work reliably. I
> agree that it would be nice to control the HSIC device from its own
> driver, and have spent quite some time playing around with the
> usb/misc/usb3503.c driver to try to make this work... but there's a
> timing dependency here that you just can't model correctly with
> independent drivers.
> 
> If the HSIC device is already active during boot (e.g. because it was
> used by firmware), there's always a chance that the USB stack will
> come up before the driver that resets it does. The device will be
> enumerated as normal, and when the other driver later pulls the reset
> signal the USB stack will not notice because there is no real
> disconnect detection on HSIC. Only when you eventually try to send
> another transfer to the device will you start to get timeouts, and the
> newly reset device will not be able to reenumerate because the host
> never asks it to.
> 
> I really don't see how you could solve this without putting some kind
> of synchronization mechanism in the USB drivers. So this leaves
> ehci-s5p and phy-samsung-usb2 as the only possible places, and I chose
> the latter since all the host-side HSIC initialization is also there
> already. I think if you think of it as "reset whatever is on the other
> side of this PHY", it's okay to put it as an optional feature into the
> PHY driver.

CC'ed Tomasz Figa, Dongjin Kim, Yulgon Kim


Hi Tomasz, Dongjin,

Julius Werner wants to put 'SMSC 3503 hub reset on Arndale board'
to 'phy-samsung-usb*.c' files, because there is a timing dependency
above mentioned.
The following is the original patch sent by Julius Werner two day ago.
(http://www.spinics.net/lists/linux-samsung-soc/msg20250.html)

Previously, Olof mentioned that 'drivers/platform/arm/' would be used.
(http://patches.linaro.org/16856/)

Also, another way was mentioned by Fabio Estevam, using 
'drivers/reset/gpio-reset.c' which is not merged yet.
(http://permalink.gmane.org/gmane.linux.drivers.devicetree/36830)

I think that 'phy-samsung-usb*.c' files are not a good place.
However, Julius Werner's comment looks reasonable enough.

If you have a comment, please feel free to share it. :)
Thank you.

Best regards,
Jingoo Han


