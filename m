Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbaJXKzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:55:03 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56242 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaJXKzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:55:00 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-55-544a30014a33
Message-id: <544A2FF2.1000105@samsung.com>
Date: Fri, 24 Oct 2014 12:54:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        ben-linux@fluff.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
        arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        geunsik.lim@samsung.com, jh80.chung@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com, yj44.cho@samsung.com
Subject: Re: [PATCH 2/5] clk: samsung: exynos4415: Add clocks using common
 clock framework
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
 <1413775935-17743-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1413775935-17743-2-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t/xa7qMBl4hBpd+81j8nXSM3WLSugNM
	Fte/PGe1+DOhlc1i19/7jBaT7k9gsdjRcITV4savNlaL3gVX2SzONr1ht5jyZzmTxabH11gt
	Lu+aw2Yx4/w+Jovbl3ktll6/yGTxdMJFNotT1z8DxSe/ZLM4NmMJo8WqXX8YLfbunMzoIOax
	Zt4aRo+W5h42j9+/JjF6/F31gtlj56y77B53ru1h89i8pN7jyokmVo++LasYPT5vkgvgiuKy
	SUnNySxLLdK3S+DKaJ6SW7CCreL+8UnMDYzzWbsYOTkkBEwkdv24wARhi0lcuLeerYuRi0NI
	YCmjxPmNU5ggnE+MEqf33GQGqeIV0JL4fvkyWDeLgKrEwuu7wLrZBAwleo/2MYLYogIREifv
	7mGHqBeU+DH5HguILSKgITHz7xWwGmaBqSwSf9+ZgNjCAjESXbOusEIsa2SU2P9wDlgzp4Cb
	RMunX0CLOYAa9CTuX9SC6JWX2LzmLfMERoFZSFbMQqiahaRqASPzKkbR1NLkguKk9FwjveLE
	3OLSvHS95PzcTYyQOP26g3HpMatDjAIcjEo8vD+2eIYIsSaWFVfmHmKU4GBWEuF9qeYVIsSb
	klhZlVqUH19UmpNafIiRiYNTqoHRyufp1S9zV82xvJRTd5p/BZc2Y3Bf28Qc6cjnFuflzMuN
	9ry+YS181P255KYViZLfd1w4/H7Lf4ugxu8uNbd0VCYtCnttxv546lPxcLGU1RU7uti9Xuoc
	3nd5uVHEwznSGptUzlqkXJTijVfRmvflVfKZpTPu3Ug/3H8i1nbFRYsX21YJ5SgeVmIpzkg0
	1GIuKk4EAHs/ZGGxAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/10/14 05:32, Chanwoo Choi wrote:
> This patch adds the new clock driver of Exynos4415 SoC based on Cortex-A9
> using common clock framework. The CMU (Clock Management Unit) of Exynos4415
> controls PLLs(Phase Locked Loops) and generates system clocks for CPU, buses
> and function clocks for individual IPs.
> 
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

The patch looks good to me, I've applied it to my tree and will
be sending in a pull request to Mike next week, if there is no
objections.

--
Thanks,
Sylwester
