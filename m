Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3K2APx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:15:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14516 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3K2APu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:15:50 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-d0-5297dcb56891
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-5-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1385626183-22990-5-git-send-email-k.kozlowski@samsung.com>
Subject: RE: [PATCH v2 4/5] rtc: s5m: Enable IRQ wake during suspend
Date: Fri, 29 Nov 2013 09:15:51 +0900
Message-id: <05ca01ceec98$295a9730$7c0fc590$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIn7cDk689h23sBcLg83vR3zAVxUwIzcObEmXe4zuA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zoe7WO9ODDLbvYrFYcvEqu8XUh0/Y
	LJ7d2stk8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt9jf2cFocbqb1YHbY+esu+we
	eyaeZPPYtKqTzePOtT1sHocOdzB6zDsZ6NG3ZRWjx/R5P5k8Pm+SC+CM4rJJSc3JLEst0rdL
	4MrY8XU2U8El5orL51cxNTA2MHcxcnBICJhI7LpS28XICWSKSVy4t56ti5GLQ0hgGaPErDnP
	GSESJhLT7mwBs4UEFjFKLO7Og7D/MEq0LweLswloSKzc/RasWURgG5PE3C1nwRxmgX5GiUd7
	VjJBjG1llJgzo5EdpIVTwEPi+qM9rCC2sICLxIcpX5lBbBYBVYn/x/eDjeUVsJR4tvA2E4Qt
	KPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZIU5VkNhx9jVYr4iAlcSez3uZIWpEJPa9eMcIcoSE
	wFwOiedfpkAtE5D4NvkQCyQsZCU2HYCaIylxcMUNlgnAUECyehaS1bOQrJ6FZMUCRpZVjKKp
	BckFxUnpRYZ6xYm5xaV56XrJ+bmbGCGpoHcH4+0D1ocYk4HWT2SWEk3OB6aSvJJ4Q2MzIwtT
	E1NjI3NLM9KElcR5kx4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgXPck5v4PHZczcnes
	r/xmfsTh4ld5Ust/D8/b9bcsrOaLyH4p4zUTmMnAz3WvUeWJsv2GudxRmUuD1IxFRMX33xHY
	fqbwxbYp9Vn71beE5CYmqd+54hC06PiukyqHvj3XZ+G5tjWQ0TlTzb5Y52XqKkeBzztuf7V8
	Oc9Wuy+13+BoV9YuWeMVSizFGYmGWsxFxYkA+AoVuRsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jAd2td6YHGUzgtFhy8Sq7xdSHT9gs
	nt3ay2Tx+oWhxdmmN+wW978eZbT4dqWDyeLyrjlsFmuP3GW32N/ZwWhxupvVgdtj56y77B57
	Jp5k89i0qpPN4861PWwehw53MHrMOxno0bdlFaPH9Hk/mTw+b5IL4IxqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpVSaEsMacUKBSQWFyspG+H
	aUJoiJuuBUxjhK5vSBBcj5EBGkhYx5ix4+tspoJLzBWXz69iamBsYO5i5OSQEDCRmHZnCyOE
	LSZx4d56NhBbSGARo8Ti7jwI+w+jRPtysBo2AQ2JlbvfAtVwcYgIbGOSmLvlLJjDLNDPKPFo
	z0omEEdIoJVRYs6MRnaQFk4BD4nrj/awgtjCAi4SH6Z8BVvNIqAq8f/4frCxvAKWEs8W3maC
	sAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLdTZChI7zr4G6xURsJLY83kvM0SNiMS+F+8YJzAK
	zUIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBE80xqB+PKBotD
	jAIcjEo8vCu6pwcJsSaWFVfmHmKU4GBWEuH9VQQU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR
	5HxgEswriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkbrOjYV
	cwddD8dYVaZWEZ8v/zQ2ZHP/3DZ/uezSGb09L0TMLkc5WrzbueRbuKlFyNfvOh/nLe4Tmtqc
	sOd51HGemtMHmZVNle9sFJqeOYGhJDqazX5GZn6PYt517b25S2UfPleYuSP9/m/BnT1awlM/
	hoWY7D2nNE8sln1ncKpF/HLVJEHlq0osxRmJhlrMRcWJAHxDaZZ4AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 5:10 PM, Krzysztof Kozlowski wrote:
> Add PM suspend/resume ops to rtc-s5m driver and enable IRQ wake during
> suspend so the RTC would act like a wake up source. This allows waking
> up from suspend to RAM on RTC alarm interrupt.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

