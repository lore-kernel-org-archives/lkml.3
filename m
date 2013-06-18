Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3FRB70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:59:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42649 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3FRB7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:59:22 -0400
X-AuditID: cbfee68f-b7f436d000000f81-12-51bfbef72473
From: Jingoo Han <jg1.han@samsung.com>
To: "'Alexander Holler'" <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'John Stultz'" <john.stultz@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
References: <51BB50B1.7060308@ahsoftware.de> <51BF2DD8.5030004@ahsoftware.de>
In-reply-to: <51BF2DD8.5030004@ahsoftware.de>
Subject: Re: BUG: rtc: rtc_device_unregister() broken in 3.10-rcN
Date: Tue, 18 Jun 2013 10:59:19 +0900
Message-id: <002901ce6bc7$71d32510$55796f30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDeVsvrEUPPO2Q8UKyq6zdMyqwuMAHfrg/gmwvho/A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zY93v+/YHGqzaaWAxZ/0aNovDi14w
	Wvzr3sVkcXnhJVaLM791LS7vmsNmsb+zg9Hi5J9eRgcOj9mdDWweO2fdZffYM/Ekm8eda3vY
	PE7M+M3i0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBl/J+9hLNjJUdGz+wJbA+Nbti5GDg4J
	AROJe32CXYycQKaYxIV769lAbCGBZYwS51dJQcRNJDofdLN2MXIBxaczSnRf6meGcH4xSix5
	8I4dpIpNQE3iy5fDYLaIgK7ErE3PwIqYBSYxSay6vJgZYqyvRMejTUwgNidQ0dT3e1lAbGEB
	R4lHp86xgtgsAqoSDTtngA3iFbCUODL/AZQtKPFj8j2wemYBLYn1O48zQdjyEpvXvGWGOFVB
	YsfZ14wQR1hJbNi6EqpGRGLfi3eMIAdJCPxll9jz9gMjxDIBiW+TD7FAgkJWYtMBqDmSEgdX
	3GCZwCgxC8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihMR2/w7G
	uwesDzEmA62fyCwlmpwPTA15JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamCcqmb/tZVrdV8Lh7ris68JGiUXbBt4nPrvqplfyXvo3+upXX5HRWFb
	YsGnoxPeOBm8cRdftMeWP9aoOoev3vLSv8sbfs3P/a8gcvGIE5u9kITbx6Qpf7U+TbvNp2P7
	/OQGUfVEy037nq2Y/vDKWeHDwQsqpSRkBArq9CfzWVzoefG4esEJ7bNKLMUZiYZazEXFiQCa
	F9HUAwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jQd3v+/YHGjzv1rGYs34Nm8XhRS8Y
	Lf5172KyuLzwEqvFmd+6Fpd3zWGz2N/ZwWhx8k8vowOHx+zOBjaPnbPusnvsmXiSzePOtT1s
	Hidm/Gbx6NuyitHj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ
	fyfvYSzYyVHRs/sCWwPjW7YuRk4OCQETic4H3awQtpjEhXvrgeJcHEIC0xklui/1M0M4vxgl
	ljx4xw5SxSagJvHly2EwW0RAV2LWpmdgRcwCk5gkVl1ezAySEBLwleh4tIkJxOYEKpr6fi8L
	iC0s4Cjx6NQ5sHUsAqoSDTtngA3iFbCUODL/AZQtKPFj8j2wemYBLYn1O48zQdjyEpvXvGWG
	OFVBYsfZ14wQR1hJbNi6EqpGRGLfi3eMExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnDyeCa9g3FVg8UhRgEORiUe3gSx/YFCrIllxZW5hxglOJiVRHhj
	J+4LFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YGLLK4k3NDYxM7I0MrMwMjE3J01YSZz3
	YKt1oJBAemJJanZqakFqEcwWJg5OqQZGmUdtXR4xNo4JMyUyzQPf58o9/GtkdMqLV2iOjOXs
	rkpx30UXYs+/eNI346p04BuTJxus4g/PZG2zWXPgX1j7Ot7kBy3G8selgub4V1cey/4h/ufM
	y5WihcuD13AsbunaouPW51HXnX3pcO2zLaeFl6zLeVhamhxstk48vz+9N+va+WPdWiFKLMUZ
	iYZazEXFiQBVsmYwYgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 18, 2013 12:40 AM, Alexander Holler wrote:
> Am 14.06.2013 19:19, schrieb Alexander Holler:
> > Hello,
> >
> > I've just tested some things with 3.10-rc5+ and discovered that
> > rtc_device_unregister is broken. This is most likely because of the
> > switch to devm*. As 3.10 is already at -rc5, I'm posting this without

CC'ed Dmitry Torokhov, Sachin Kamat


Hi Alexander,

You are using 'drivers/rtc/rtc-hid-sensor-time.c', right?
If so, would you revert '479243b rtc: hid-sensor-time: use devm_rtc_device_register()',
and give the result?


Hi Dmitry, Sachin,
You can see the kernel debug message, when the problem happens.
(http://lists-archives.com/linux-kernel/27855385-bug-rtc-rtc_unregister_device-broken-in-3-10-rcn.html)


Best regards,
Jingoo Han

> 
> Just in case the question arises, this worked and works perfectly with
> 3.9.x, so maybe I should have named it REGRESSION rather than BUG.
> 
> Regards,
> 
> Alexander
> 
> PS: I changed typo in the subject from rtc_unregister_device to
> rtc_device_unregister

