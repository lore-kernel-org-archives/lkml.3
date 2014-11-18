Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaKRAi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:38:57 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39293 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaKRAiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:38:55 -0500
X-AuditID: cbfee68e-f79b46d000002b74-8d-546a95193952
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sameo@linux.intel.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
Subject: RE: [PATCH 4/5] rtc: s5m: Add the support for S2MPS13 RTC
Date: Tue, 18 Nov 2014 09:38:49 +0900
Message-id: <012401d002c8$04efe610$0ecfb230$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBIGxsMOaDFXn+jUEunj34K9G6SgJGHyxCm/EcFaA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkRVdyalaIQe8OZYslF6+yW0x9+ITN
	4vqX56wW84+cY7X4M6GVzWLS/QksFmeb3rBb3P96lNHi25UOJovLu+awWTydcJHN4nQ3qwOP
	x85Zd9k9Nq3qZPO4c20Pm8e8k4EefVtWMXpMn/eTyePzJrkA9igum5TUnMyy1CJ9uwSujKf/
	gwsamSr+LjrL3MB4mrGLkZNDQsBE4uyEbnYIW0ziwr31bF2MXBxCAksZJV6+nMgEU/TrxHx2
	iMR0Ront319DVf1mlPi+dA5YFZuAhsTK3W/BEiICzYwSO6+/YQFxmAW2MUpM+HsKbImQQK1E
	w+oPQMs5ODgFXCSmTNcHCQsLOEmcnjkPrIRFQFXi/eqrYPfxClhK7J2ykQ3CFpT4MfkeC4jN
	LKAlsX7ncSYIW15i85q3zBCnKkjsOPsarFdEwEqia/IBVogaEYl9L94xgtwjITCXQ+LM7Hms
	EMsEJL5NPsQCco+EgKzEpgNQcyQlDq64wTKBUWIWktWzkKyehWT1LCQrFjCyrGIUTS1ILihO
	Si8y0itOzC0uzUvXS87P3cQITAGn/z3r28F484D1IUYBDkYlHt4d2ZkhQqyJZcWVuYcYTYEu
	msgsJZqcD0w0eSXxhsZmRhamJqbGRuaWZkrivAlSP4OFBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MDqUhxmrdSs1JIqtCH9zrUi3ajVD3gqt7LT5N9O0+worSvmbDPfMZT3Q5r5pnU6tnmb6
	oQ/K283rpF5VV+Y8SfyXpMz+oex+5/6vXDeK7/iLz21ULC55GbP3m7+e+NlgOcEvHvrc/FWq
	03Yu42TPb2LhThb/5RV1OKm3zvvdGSvpV+vq7XSVWIozEg21mIuKEwGitrOu/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV3JqVkhBlN/yVksuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WR14
	PHbOusvusWlVJ5vHnWt72DzmnQz06NuyitFj+ryfTB6fN8kFsEc1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8x4+j+4oJGp4u+is8wNjKcZuxg5OSQETCR+nZjPDmGLSVy4
	t56ti5GLQ0hgOqPE9u+voZzfjBLfl85hAqliE9CQWLn7LVhCRKCZUWLn9TcsIA6zwDZGiQl/
	T4HNEhKolWhY/QFoBwcHp4CLxJTp+iBhYQEnidMz54GVsAioSrxffRXsDF4BS4m9UzayQdiC
	Ej8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4lQFiR1nX4P1ighYSXRNPsAKUSMise/FO8YJjEKz
	kIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOME8k9rBuLLB4hCj
	AAejEg/vjuzMECHWxLLiytxDjBIczEoivOe6s0KEeFMSK6tSi/Lji0pzUosPMZoCfTqRWUo0
	OR+Y/PJK4g2NTcyMLI3MLIxMzM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTD6dnV6Nuvz
	2U8+2Ll9u/Wa/sqmSRpe/9o5J5T9Y/T7bveCMzxbNkTjVcjGQzvuOk3S/CZRePpbR+e3u0cS
	by3d3XLb7KzxBeXnD9Yu+RJ59VpxcN66w/bi6REdztY5+d4L7V3tJFZYXm1pKk3bfMn6XMei
	tUXpoR9V7yQu+q2d1G17bheLoYQSS3FGoqEWc1FxIgCxufGCRgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Monday, November 17, 2014 9:43 AM, Chanwoo Choi wrote:
> This patch adds only the compatible string for S2MPS13 clock which is identical
> with S2MPS14 clock driver.

What's the relation of S2MPS14 RTC and clock driver?

Thanks,
Sangbeom.

