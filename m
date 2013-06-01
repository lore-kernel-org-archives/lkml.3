Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab3FAENm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:13:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44776 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab3FAENd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:13:33 -0400
X-AuditID: cbfee68e-b7f276d000002279-5f-51a974ebe1da
From: Jingoo Han <jg1.han@samsung.com>
To: "'Shuah Khan'" <shuah.kh@samsung.com>, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        rafael.j.wysocki@intel.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Jingoo Han <jg1.han@samsung.com>
References: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
In-reply-to: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
Subject: Re: [PATCH v2] backlight: Convert from Legacy pm ops to dev_pm_ops
Date: Sat, 01 Jun 2013 13:13:31 +0900
Message-id: <005901ce5e7e$60212c00$20638400$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKufEKA6p8I2U1wmqekrAqHkz8ropdgA5Gw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zI93XJSsDDbavlLTonHmN0eLywkus
	Fif6PrBaXN41h81i3cMXTBaPV7xlt9i96ymrxZfPXBZffzpYrJ9/i82By2PnrLvsHh8+xnks
	3vOSyePVhTssHnvm/2D16NuyitHj+I3tTB6fN8kFcERx2aSk5mSWpRbp2yVwZczv/8JUcIml
	YubrZ0wNjI+Zuxg5OCQETCRe7OXpYuQEMsUkLtxbz9bFyMUhJLCMUeLV3q1sEAkTidaJPewQ
	iUWMEve7tzOBJIQEfjFKXO7XB7HZBNQkvnw5DFYkAlJ0Z147M0iCWaBM4tuR/VANzhIbXx1h
	A9nMKeAicWFrLEhYWMBbouPMGrASFgFViU9r/zGBlPAKWEr83y0OEuYVEJT4MfkeC8RELYn1
	O48zQdjyEpvXvGWGuFNBYsfZ14wgtoiAkcTSk+8YIWpEJPa9ALG5gGqmckh8vXaTDWKXgMS3
	yYdYIAEhK7HpANQcSYmDK26wTGCUmIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSi4z0ihNz
	i0vz0vWS83M3MUIivm8H480D1ocYk4HWT2SWEk3OByaMvJJ4Q2MzIwtTE1NjI3NLM9KElcR5
	1VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwlnJPnZJ3a7afxWqjuM8S3vaf9p59bKat
	9nni6vMTI12WZ2h2+pf/Xm+tG5DUOpPjxevaUqOb4o47V7Mt/cfvtMHrW8eN+qTf0R8k5fpb
	tNOElqRfKT+trKZq0rFPQI5nd9uZl6++fT+7efee7mkLGoOLQs5/2iSQtFBW8sHLrjn2le7q
	PvU8SizFGYmGWsxFxYkA2xt7xg4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAd3XJSsDDR5tEbHonHmN0eLywkus
	Fif6PrBaXN41h81i3cMXTBaPV7xlt9i96ymrxZfPXBZffzpYrJ9/i82By2PnrLvsHh8+xnks
	3vOSyePVhTssHnvm/2D16NuyitHj+I3tTB6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rfDNCE0xE3XAqYx
	Qtc3JAiux8gADSSsY8yY3/+FqeASS8XM18+YGhgfM3cxcnJICJhItE7sYYewxSQu3FvP1sXI
	xSEksIhR4n73diaQhJDAL0aJy/36IDabgJrEly+H2UGKRECK7sxrB5vELFAm8e3IfqgGZ4mN
	r44ATeLg4BRwkbiwNRYkLCzgLdFxZg1YCYuAqsSntf+YQEp4BSwl/u8WBwnzCghK/Jh8jwVi
	opbE+p3HmSBseYnNa95C3awgsePsa0YQW0TASGLpyXeMEDUiEvtevGOcwCg0C8moWUhGzUIy
	ahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxghPKM6kdjCsbLA4xCnAwKvHwGqxY
	ESjEmlhWXJl7iFGCg1lJhDd/DlCINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84HJLq8k3tDY
	xMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGI8pTHtlHF1zcc5vi2nX
	Hj958frjcZ2oqSvcNGsrFx5lzrW1Pxr4xnbBootf7R58+rdk99r/xltupp88seHaJWbe/u2s
	3VJLKq7k5rQUvav3ed4ucsxD8clmFZVIpcXWqlHaeRrb5V4vW/5igbGeSNlb0VWRBcycBx66
	rJi7JUvmjo4L707Ghz5KLMUZiYZazEXFiQC34JF0bAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 14, 2040 8:27 PM, Shuah Khan wrote:
> 
> Convert drivers/video/backlight/class to use dev_pm_ops for power
> management and remove Legacy PM ops hooks. With this change, rtc class

There is still the typo.

Please fix it. 
 rtc class -> backlight class


> registers suspend/resume callbacks via class->pm (dev_pm_ops) instead of
> Legacy class->suspend/resume. When __device_suspend() runs call-backs,
> it will find class->pm ops for the backlight class.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> Cc: Shuah Khan <shuahkhan@gmail.com>


