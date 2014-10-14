Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaJNB0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:26:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8569 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbaJNB0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:26:38 -0400
X-AuditID: cbfee68f-f791c6d000004834-b1-543c7bcbbcc3
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kishon@ti.com
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
 <1412677176-3850-2-git-send-email-gautam.vivek@samsung.com>
 <00f101cfe6a1$d772c5a0$865850e0$%tikhomirov@samsung.com>
 <543C575A.1030105@gmail.com>
In-reply-to: <543C575A.1030105@gmail.com>
Subject: RE: [PATCH v2 1/4] dwc3: exynos: Add support for SCLK present on
 Exynos7
Date: Tue, 14 Oct 2014 10:26:35 +0900
Message-id: <001801cfe74d$e4cb23d0$ae616b70$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/nOD6DpDW+hYe7R7OdFR1iLabxogAFHQCA
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zY93T1TYhBu2PtCwO3q+3mH/kHKtF
	25WD7BbNi9ezWfQuuMpmceFpD5vF5V1z2CxmL+lnsZhxfh+TxaJlrcwWS69fZLKYMH0ti0Xr
	3iPsFqt2/WF04PNYM28No8fOWXfZPTat6mTz2D93DbtH35ZVjB7Hb2xn8vi8SS6APYrLJiU1
	J7MstUjfLoErY/K0CUwFvzgqlr7exNTA2MTexcjBISFgInHhQ0EXIyeQKSZx4d56ti5GLg4h
	gWWMElf+b2eESJhIPGrZyA6RmM4o0bZoFyuE8w/IWbcNrIpNwEji5cGNzCC2iEChxJNp58A6
	mAX6mSQu717CBNFxn1Hi7vo2VpDdnAKaEjNvcYI0CAsES1zpXArWzCKgKnFtynIWkBJeAReJ
	rz80QcK8AoISPybfYwGxmQUMJN7P6mOFsOUlNq95ywzxjbrEo7+6ECcYSexb2AVVLi4x6cFD
	sHMkBFZySJyd94cVYpWAxLfJh1ggemUlNh1ghnhYUuLgihssExglZiHZPAvJ5llINs9CsmIB
	I8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJCk0L+D8e4B60OMAhyMSjy8BZE2IUKsiWXF
	lbmHGE2BLprILCWanA9MPXkl8YbGZkYWpiamxkbmlmZK4rwLpX4GCwmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamBc+cXPY855e13rQhdb5Zia7m5pg7N8EdrXUrbrTP90MLk+9fju2use30zS
	uPfV8+6pEv80d2nA30kT+Xh0N23LZn6YMNX4wdnjxcLnFqjdrI17JPhsr6/wpK8T/2n7C8x7
	YH3GkvPLtZqo53M0CnXDC3UubVAvnpIu9OPX7EkbV7DkfLLf8pFFiaU4I9FQi7moOBEA6+y+
	ggUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd3T1TYhBpcPqFocvF9vMf/IOVaL
	tisH2S2aF69ns+hdcJXN4sLTHjaLy7vmsFnMXtLPYjHj/D4mi0XLWpktll6/yGQxYfpaFovW
	vUfYLVbt+sPowOexZt4aRo+ds+6ye2xa1cnmsX/uGnaPvi2rGD2O39jO5PF5k1wAe1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0M1KCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xozJ0yYwFfziqFj6ehNTA2MTexcjJ4eE
	gInEo5aNULaYxIV769m6GLk4hASmM0q0LdrFCuH8A3LWbWMEqWITMJJ4eXAjM4gtIlAo8WTa
	OXaQImaBfiaJy7uXMEF03GeUuLu+Daidg4NTQFNi5i1OkAZhgWCJK51LwZpZBFQlrk1ZzgJS
	wivgIvH1hyZImFdAUOLH5HssIDazgIHE+1l9rBC2vMTmNW+ZQcolBNQlHv3VhTjBSGLfwi6o
	cnGJSQ8esk9gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB
	SeeZ9A7GVQ0WhxgFOBiVeHgLIm1ChFgTy4orcw8xSnAwK4nw2qcDhXhTEiurUovy44tKc1KL
	DzGaAv05kVlKNDkfmBDzSuINjU3MjCyNzCyMTMzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFw
	SjUwsj55cfl5bYdXoqPJ0pUptRf+pr6rzdA68rVvbvr6X1fu+jzyYZB3T5/C7ih9+RJHhMI/
	uS3ZjBJFFy9s2qG0w897zxXDsGuq/98uOuwn9qlw9sMwdskCDuPX3K6r9a+GPF4vaMUz3aXk
	X0/ISt7QyjuNrUvfK5uxHW+8eKeozf12NEfSc9npSizFGYmGWsxFxYkAA+c7S1ADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Hi Anton,
> 
> On 13.10.2014 06:54, Anton Tikhomirov wrote:
> > Hi Vivek,
> >
> >> Exynos7 also has a separate special gate clock going to the IP
> >> apart from the usual AHB clock. So add support for the same.
> >
> > As we discussed before, Exynos7 SoCs have 7 clocks to be controlled
> > by the driver. Adding only sclk is not enough.
> >
> 
> I'm quite interested in this discussion. Has it happened on mailing
> lists?

No, we used company messenger for the discussion.

> 
> In general, previous SoCs also gave the possibility of controlling all
> the bus clocks separately, in addition to bulk gates, but there was no

correct

> real advantage in using those, while burdening the clock tree with
> numerous clocks. Isn't Exynos7 similar in this aspect?

Exynos7 doesn't have "Gating all clocks for USBDRD30" bit. The clocks
should be controlled separately.

> 
> Best regards,
> Tomasz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

