Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaLHLgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:36:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16441 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbaLHLgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:36:04 -0500
X-AuditID: cbfee68e-f79b46d000002b74-4a-54858d223a38
Message-id: <54858D2B.3040809@samsung.com>
Date: Mon, 08 Dec 2014 17:06:11 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/19] clk: samsung: exynos5433: Add clocks for CMU_G2D
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-6-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-6-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkSleptzXEYN4bMYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azOPymndVixuSXbBardv1htHj58QSLg6jHmnlrGD1+
	/5rE6LFz1l12j81L6j2unGhi9ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6M+Q9Pshec4qhY
	PJmzgfEzWxcjJ4eEgInE3S8/2SFsMYkL99YDxbk4hASWMkrs2P+HFabo+PYfzBCJ6YwSXx6t
	ZIRwWpkkDvy7ywhSxSugJfFzx3ewsSwCqhIP50wCG8smoCvx5P1cZhBbVCBC4sqaOVD1ghI/
	Jt9jAbFFBLIlnr45DLaaWWAns8T57ilgCWGBEInjN94xgdhCAvUSfd8awU7iFHCVeDTjDVgN
	s4CtxIL366BseYnNa96CnSohcIBDYt2Hn0wQFwlIfJt8CKiIAyghK7HpADPEa5ISB1fcYJnA
	KDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiBSeH0v2d9OxhvHrA+
	xCjAwajEw7vgQUuIEGtiWXFl7iFGU6ArJjJLiSbnA1NPXkm8obGZkYWpiamxkbmlmZI4b4LU
	z2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjG2KTe0Mco0H94s8nsdyzj3mgNGs1gupf6OC
	p95rL355rjpYh12pI6ZI+6yvUoDVo0Rex7/8W/QfXnl/026BzprF5l3BIW55f6+7+q6XPKSf
	vunzMom/17nvS6i9ep/1WVOhtlfm8lrVU6mPHCK3RPSKJfHdVFuU1rw9Nm/S0UUzMy10r7wW
	UWIpzkg01GIuKk4EANCWooIFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jQV2l3tYQg13/uC0er1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnN4vCbdlaLGZNfslms2vWH0eLlxxMsDqIea+atYfT4
	/WsSo8fOWXfZPTYvqfe4cqKJ1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPj
	neNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAvlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih
	6xsSBNdjZIAGEtYwZsx/eJK94BRHxeLJnA2Mn9m6GDk5JARMJI5v/8EMYYtJXLi3HijOxSEk
	MJ1R4sujlYwQTiuTxIF/dxlBqngFtCR+7vgO1s0ioCrxcM4kdhCbTUBX4sn7uWCTRAUiJK6s
	mQNVLyjxY/I9FhBbRCBb4umbw2AbmAV2Mkuc754ClhAWCJE4fuMdE4gtJFAv0fetkRXE5hRw
	lXg04w1YDbOArcSC9+ugbHmJzWveMk9gFJiFZMcsJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iRGccp5J7WBc2WBxiFGAg1GJh3fBg5YQIdbEsuLK3EOMEhzMSiK8iXGtIUK8
	KYmVValF+fFFpTmpxYcYTYFBMJFZSjQ5H5gO80riDY1NzE2NTS1NLEzMLJXEeW/czA0REkhP
	LEnNTk0tSC2C6WPi4JRqYOz3Tr80ccqW9yobXoRnf97iwJs0ofx5WO6+CdLG0xomFu1M0jlW
	sthHJOnrf8ZQRcmA/YstjH892L2MRfU8zxRJ5tc+m0r/rj7HwGmjcfpryKftNunP5h02YTZN
	8DS4I79j3z27sPSW0GVCkb0bRBd8f7kq4eq0Z5sXX+02dJQ/yPL4g4337kYlluKMREMt5qLi
	RAB8tSNbTwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds ths mux/divider/gate clocksof CMU_G2D domain which includes

nit: %s/clocksof/clocks of

> G2D/MDMA IPs. The CMU_G2D must need the clocks related to G2D by providing
> CMU_TOP domain. So, this patch add several clocks for G2D from CMU_TOP domain.
>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>   .../devicetree/bindings/clock/exynos5433-clock.txt |   8 ++
>   drivers/clk/samsung/clk-exynos5433.c               | 144 +++++++++++++++++++++
>   include/dt-bindings/clock/exynos5433.h             |  42 +++++-
>   3 files changed, 193 insertions(+), 1 deletion(-)
>

Verified all changes in clock file against UM I have with me, all 
changes are OK.

With small nit in commit message feel free to add:

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Thanks,
Pankaj Dubey
