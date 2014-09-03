Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaICOL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:11:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59780 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaICOLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:11:25 -0400
X-AuditID: cbfee68e-f79536d000000fd1-b7-5407218b9fda
Message-id: <5407218B.1020702@samsung.com>
Date: Wed, 03 Sep 2014 23:11:23 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
Cc: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com,
        kgene.kim@samsung.com, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 0/2] thermal: exynos: Add support for TRIMINFO feature of
 Exynos3250
References: <1409713743-6124-1-git-send-email-cw00.choi@samsung.com>
 <20140830023928.GC23645@developer>
In-reply-to: <20140830023928.GC23645@developer>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkSLdbkT3E4OJ3S4uGqyEWG2esZ7W4
	+/wwo8Wa/T+ZLOZfucZq0bvgKpvF2aY37BabHgO5l3fNYbP43HuE0WLG+X1MFk8e9rE58Hjs
	nHWX3WPxnpdMHpuX1Hv0bVnF6HH8xnYmj8+b5ALYorhsUlJzMstSi/TtErgydswyL3jJWrFs
	yW2WBsYbLF2MHBwSAiYSFycldzFyApliEhfurWfrYuTiEBJYyijx7MxrJoiEiUTXmWtQiemM
	Ev1fp0E5rxkllnxczAZSxSugJbHs/lUWEJtFQFXiZucedhCbDSi+/8UNsBpRgTCJldOvsEDU
	C0r8mHwPzBYBqjlxaTvYNmaBrUwSa946gNjCAjESvxuOMILYQgKZEre+XgKr5xTQl5jW28oO
	Ua8jsb91GhuELS+xec1bZpDjJATeskt8e7SBEeIgAYlvkw9BvSwrsekAM8RnkhIHV9xgmcAo
	NgvJSbOQjJ2FZOwCRuZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIHRevrfs74djDcPWB9i
	FOBgVOLhXRDAFiLEmlhWXJl7iNEU6IqJzFKiyfnAlJBXEm9obGZkYWpiamxkbmmmJM6bIPUz
	WEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjwssSh1or/OxX/fy+jcHq9v78RmbbGsUP81ON
	N878d2bvs+o36Yvloh+1Oifvb3309KPCX6FZDYber+XK/yzjdVRfr3P6ypPWfQbzT0zmFjPl
	zJnyXyxbtUP9lPv9BN6aXY0bL9vU6bmdadjbwD1ByKMnxlo1VLlKgr/694cJlltWrfrztdpT
	iaU4I9FQi7moOBEAG1DgxNECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoG63InuIwYGvhhYNV0MsNs5Yz2px
	9/lhRos1+38yWcy/co3VonfBVTaLs01v2C02PQZyL++aw2bxufcIo8WM8/uYLJ487GNz4PHY
	Oesuu8fiPS+ZPDYvqffo27KK0eP4je1MHp83yQWwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA3aikUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzNgxy7zgJWvFsiW3WRoYb7B0MXJySAiYSHSducYGYYtJXLi3Hsjm4hAS
	mM4o0f91GpTzmlFiycfFYFW8AloSy+5fBetmEVCVuNm5hx3EZgOK739xA6xGVCBMYuX0KywQ
	9YISPybfA7NFgGpOXNrOBGIzC2xlkljz1gHEFhaIkfjdcIQRxBYSyJS49fUSWD2ngL7EtN5W
	doh6HYn9rdPYIGx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeu
	l5yfu4kRnAyeSe1gXNlgcYhRgINRiYd3QQBbiBBrYllxZe4hRgkOZiUR3jXS7CFCvCmJlVWp
	RfnxRaU5qcWHGE2BITCRWUo0OR+YqPJK4g2NTcyMLI3MDS2MjM2VxHkPtFoHCgmkJ5akZqem
	FqQWwfQxcXBKNTB6abWJm9baKJ2ZvWdN5c2KV9xHV0Tfsnr+WueuMcc63ZAdUyxOL/KSTKxK
	nmT46lhp1L2thj93LFfnnTC1SP3VUcvtrmuaO74sf/XOcdGLqTeWd/vu6pNc+rdiOZPA99pJ
	2zp6TD9P9Qxy9BKvYp8Umcdzvycs7sRX77uClTrR985KxvObT2ZRYinOSDTUYi4qTgQA5av5
	qxwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eduardo,

On 08/30/2014 11:39 AM, Eduardo Valentin wrote:
> Hi,
> 
> On Wed, Sep 03, 2014 at 12:09:01PM +0900, Chanwoo Choi wrote:
>> This patchset add the support of TRIMINFO_RELOAD feature for Exynos3250.
>> But Exynos3250 has two TRIMINFO_CTRL register instead other Exynos has only one
>> TRIMINFO_CTRL register. So, this patchset support the some Exynos SoC which
>> has more than one TRIMINF_CTRL.
>>
>> Also, this patchset fix wrong value of TRIMINFO_RELOAD_SHIFT and remove
>> duplicate code when reading triminfo register of Exynos5440.
>>
>> Changes from v5:
>> - Rebase this patchset on next branch of linux-soc-thermal.git
>>
> 
> Pulled into my next branch. Thanks.

Thanks.

Best Regards,
Chanwoo Choi
