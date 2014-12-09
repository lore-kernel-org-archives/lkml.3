Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaLIG2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:28:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34034 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaLIG2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:28:23 -0500
X-AuditID: cbfee68f-f791c6d000004834-5e-548696846bdb
Message-id: <54869689.5010103@samsung.com>
Date: Tue, 09 Dec 2014 11:58:25 +0530
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
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for CMU_G3D
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-12-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-12-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkSrdlWluIwYJDJhaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbfY9Pgaq8Xl
	XXPYLGac3wfUf+cfm8XS6xeZLE5d/8xmcfhNO6vFjMkv2SxW7frDaPHy4wkWB1GPNfPWMHr8
	/jWJ0WPnrLvsHpuX1HtcOdHE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZC+9qFvSzVLza
	8Y6xgXEPcxcjJ4eEgInEzI+/GSFsMYkL99azdTFycQgJLGWU6P09kQmmaN/1E6wQiUWMEsv3
	nINyWpkk/l/oZAWp4hXQklg2Yx3YKBYBVYnGphZ2EJtNQFfiyfu5YOtEBSIkrqyZwwhRLyjx
	Y/I9FhBbRCBb4umbw2CrmQV2Mkuc754ClhAWCJGY0T2LCWJbA6PEiiOXwW7iFHCTeHZmL1gR
	s4CtxIL366BseYnNa94ygzRICOzhkHh55yErxEkCEt8mHwIq4gBKyEpsOgANAEmJgytusExg
	FJuF5KhZSMbOQjJ2ASPzKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYzAtHD637P+HYx3D1gf
	YhTgYFTi4dWwbAsRYk0sK67MPcRoCnTFRGYp0eR8YPLJK4k3NDYzsjA1MTU2Mrc0UxLnXSj1
	M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo+uXxOUnG4IbfJ6/jz1xbTUTp47FT/PAN8lu
	8jLfVeef/bv249IXl4M/pNVtk5O5OX3uDAMTg8pkB6FqNhVNN/O07aeKqt65XVpnfG5np0tW
	ym6F/yHLO/hOFd7nM9lf3+NhFyMgctqp8tWhzckNSjfvMi3LilknJNxV7Jph5lttPL9gdrer
	EktxRqKhFnNRcSIAHyzugwYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd2WaW0hBuubdCwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnN4vCbdlaLGZNfslms2vWH0eLlxxMsDqIea+atYfT4
	/WsSo8fOWXfZPTYvqfe4cqKJ1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPj
	neNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAvlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih
	6xsSBNdjZIAGEtYwZiy8q1nQz1Lxasc7xgbGPcxdjJwcEgImEvuun2CFsMUkLtxbz9bFyMUh
	JLCIUWL5nnOsEE4rk8T/C51gVbwCWhLLZqxjBLFZBFQlGpta2EFsNgFdiSfv54JNFRWIkLiy
	Zg4jRL2gxI/J91hAbBGBbImnbw6DbWAW2Mkscb57ClhCWCBEYkb3LCaIbQ2MEiuOXGYCSXAK
	uEk8O7MXrIhZwFZiwft1ULa8xOY1b5knMArMQrJkFpKyWUjKFjAyr2IUTS1ILihOSs810itO
	zC0uzUvXS87P3cQITjrPpHcwrmqwOMQowMGoxMOrYdkWIsSaWFZcmXuIUYKDWUmE934dUIg3
	JbGyKrUoP76oNCe1+BCjKTAMJjJLiSbnAxNiXkm8obGJuamxqaWJhYmZpZI4r5I9UJNAemJJ
	anZqakFqEUwfEwenVAMj25aOMy1GZiW/PDMcvHSvz6j1KuGZFmCmsask5hnvA1WjeFkB5TjP
	x1xRE3viNkTMPhDe6vTg/8uKF8+YE+Zs1KnbsT8s98hJa69ph40/pThWrtC/l2GnNudp1J89
	aposu8/fWq/nvFbadU3kjdnWCR5bVvtVfIw7GrTPXUm4y31nRHZK4HElluKMREMt5qLiRACa
	G0reUAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds the mux/divider/gate clocks for CMU_G3D domain which contains
> the clocks for GPU(3D Graphics Engine).
>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Thanks,
Pankaj Dubey
