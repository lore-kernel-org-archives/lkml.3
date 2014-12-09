Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaLIBFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:05:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40853 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaLIBFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:05:40 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-e6-54864ae26cd9
Message-id: <54864AE2.7080405@samsung.com>
Date: Tue, 09 Dec 2014 10:05:38 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/19] clk: samsung: exynos5433: Add MUX clocks of CMU_TOP
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-3-git-send-email-cw00.choi@samsung.com>
 <54858BF6.4040407@samsung.com>
In-reply-to: <54858BF6.4040407@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWyRsSkSPeRV1uIwcVX1haP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWmx5fY7W4vGsOm8WM
	8/uAWu/8Y7NYev0ik8Wp65/ZLBZt/cJucfhNO6vFjMkv2SxW7frDaPHy4wkWB1GPNfPWMHr8
	/jWJ0WPnrLvsHpuX1HtcOdHE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZK770Mhf8Za1Y
	d+cKewPjJ5YuRk4OCQETibUrXjBD2GISF+6tZ+ti5OIQEljKKPH62C42mKJX92awQiSmM0r8
	fLOUCcJ5zSixecU+RpAqXgEtiRvntgNVcXCwCKhKHJ1pCxJmAwrvf3EDbJCoQJjEyulXWCDK
	BSV+TL4HZosIaEt0Xr4HtoBZ4A+zxOnDe8FmCguES1w6/Y8JxBYSWMAocfyuOojNCdSwZN8N
	dpBdzAJ6EvcvaoGEmQXkJTaveQv1zREOiWN9PiA2i4CAxLfJh1hAyiUEZCU2HYAqkZQ4uOIG
	ywRGsVlILpqFMHQWkqELGJlXMYqmFiQXFCelF5noFSfmFpfmpesl5+duYgSmg9P/nk3YwXjv
	gPUhRgEORiUeXg3LthAh1sSy4srcQ4ymQEdMZJYSTc4HJp28knhDYzMjC1MTU2Mjc0szJXHe
	11I/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwFjTsi5jyUOXq226Xv6s33mI3Pal3LXJO
	Oz//oW/PnBwuPnvjfYLx419j5iKJTVo/r7wwFDyfk9LLwL66eNk7b+7sC3sfqGbGR9++9PTP
	fU//W4onLnmsWhig53H1zxL/KTfYlqasS+dbVN8uPtH5fJ1O/dfAdmXP7deYOBi21P4X3lPV
	2rDlhBJLcUaioRZzUXEiAI4E3NwCAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQd1HXm0hBiefGFo8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbbHp8jdXi8q45bBYz
	zu8Dar3zj81i6fWLTBanrn9ms1i09Qu7xeE37awWMya/ZLNYtesPo8XLjydYHEQ91sxbw+jx
	+9ckRo+ds+6ye2xeUu9x5UQTq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzFjxpZe54C9rxbo7V9gbGD+xdDFyckgImEi8ujeDFcIWk7hwbz1bFyMX
	h5DAdEaJn2+WMkE4rxklNq/YxwhSxSugJXHj3HagDg4OFgFViaMzbUHCbEDh/S9usIHYogJh
	EiunX2GBKBeU+DH5HpgtIqAt0Xn5HivITGaBP8wSpw/vBZspLBAucen0PyYQW0hgAaPE8bvq
	IDYnUMOSfTfYQXYxC+hJ3L+oBRJmFpCX2LzmLfMERoFZSFbMQqiahaRqASPzKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzgdPNMagfjygaLQ4wCHIxKPLyalm0hQqyJZcWVuYcYJTiYlUR4
	l+9sDRHiTUmsrEotyo8vKs1JLT7EaAr0/0RmKdHkfGAqzCuJNzQ2MTOyNDI3tDAyNlcS51Wy
	B5ojkJ5YkpqdmlqQWgTTx8TBKdXAqBuWpi3Cdl17xesTv28bbuDp3ZEYnvt27dkUPpcrn69f
	tpY+u+BPqEXkgWtPlpqeulNiWso8f4v69Ce+a5n9s4y2O+TPEBZTc3ieO92ubpZ0WDW7jcrR
	/6E1im0qDeVZz/KL4r32rlzM8vvpr2mth0Q8bBetW5FUvvfcIsYv84I1xDzeXap1V2Ipzkg0
	1GIuKk4EAFu8dL9NAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 12/08/2014 08:31 PM, Pankaj Dubey wrote:
> Hi Chanwoo,
> 
> On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
>> This patch adds the MUX (multiplexer) clocks for CMU_TOP domain of Exynos5433.
>> CMU_TOP domain provides source clocks to other CMU domains.
>>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
> 
> Reviewed all registers and clock relationships w.r.t UM I have and all changes are OK. So
> 
> Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Thanks for your review.

Best Regards,
Chanwoo Choi

