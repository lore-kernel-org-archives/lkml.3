Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaKRIxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:53:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23489 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaKRIx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:53:27 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-97-546b0905daba
Message-id: <546B0905.4020700@samsung.com>
Date: Tue, 18 Nov 2014 17:53:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it, lgirdwood@gmail.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 4/5] rtc: s5m: Add the support for S2MPS13 RTC
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
 <012401d002c8$04efe610$0ecfb230$@samsung.com>
In-reply-to: <012401d002c8$04efe610$0ecfb230$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWyRsSkUJeVMzvEYNJyWYslF6+yW0x9+ITN
	Yv6Rc6wWfya0sllMuj+BxeJs0xt2i/tfjzJafLvSwWRxedccNounEy6yWZzuZrW4uOILkwOP
	x85Zd9k9Nq3qZPO4c20Pm8e8k4EefVtWMXpMn/eTyePzJrkA9igum5TUnMyy1CJ9uwSujJWP
	ljMWdDJXHJ4/g7mBcRtTFyMnh4SAicSPxxeYIWwxiQv31rN1MXJxCAksZZS4svYUK0zRybm9
	7BCJ6YwSa06/AUsICbxmlNjWGg5i8wpoScy49xaom4ODRUBVYv0KbpAwG1B4/4sbbCC2qECY
	xMrpV1ggygUlfky+B2aLCKhJHDl1nglkPrNAP5PE9wvXwRLCAk4Sk+Z/grpoLaPEnwXTwSZx
	ClhJ3Dm+BOxsZgEdif2t09ggbHmJzWveMoM0SAg0ckj8b94FVsQiICDxbfIhFpDrJARkJTYd
	gHpZUuLgihssExjFZiE5ahaSsbOQjF3AyLyKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzB2
	T/97NmEH470D1ocYBTgYlXh4E6dmhQixJpYVV+YeYjQFumIis5Rocj4wQeSVxBsamxlZmJqY
	GhuZW5opifO+lvoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFRZMVM+9f/RFlOP/L8Wsdn
	FbbzQY7U3Rwmv10pkvwnCxZuX7Rr3bLVGxQkpurd8f7kxBJwkqu1KSnfj+n0muq6yR5npOIK
	k/cWVqmkv/9Z+DrWy/lDlX3O3WmKR1/2PBLQFtepERGQzPxT++KezRuT5UUXSpnPK+uczd95
	5/wnL4bPxXsN6vKVWIozEg21mIuKEwFj42Ca2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoC4rZ3aIwa3TohZLLl5lt5j68Amb
	xfwj51gt/kxoZbOYdH8Ci8XZpjfsFve/HmW0+Halg8ni8q45bBZPJ1xkszjdzWpxccUXJgce
	j52z7rJ7bFrVyeZx59oeNo95JwM9+rasYvSYPu8nk8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIcqKZQl5pQChQISi4uV9O0wTQgN
	cdO1gGmM0PUNCYLrMTJAAwlrGDNWPlrOWNDJXHF4/gzmBsZtTF2MnBwSAiYSJ+f2skPYYhIX
	7q1n62Lk4hASmM4oseb0G1aQhJDAa0aJba3hIDavgJbEjHtvgYo4OFgEVCXWr+AGCbMBhfe/
	uMEGYosKhEmsnH6FBaJcUOLH5HtgtoiAmsSRU+eZQOYzC/QzSXy/cB0sISzgJDFp/ieoxWsZ
	Jf4smA42iVPASuLO8SXMIDazgI7E/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECE4Mz6R3MK5qsDjEKMDBqMTDmzg1K0SINbGsuDL3EKME
	B7OSCO+5bqAQb0piZVVqUX58UWlOavEhRlNgEExklhJNzgcmrbySeENjEzMjSyNzQwsjY3Ml
	cd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYy1v4VcXPSN7G/J1bx+on8p4PX1a5/nK1t1Vs1O
	ONn37V/lwj/pux+0Rll9UlMLW8y79tgfn8iyK2fa+i2/a/+LeKP7535+lXPmX9umn9t/fC8T
	YvOa4+uVFn3dSEcnIqtPjed8aH1qx5o0vxvmK5rehTY0Z115NnHnuyv3xeZqFW9bajLfa7ES
	S3FGoqEWc1FxIgDOHdHrIgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sangbeom,

On 11/18/2014 09:38 AM, Sangbeom Kim wrote:
> Hi,
> On Monday, November 17, 2014 9:43 AM, Chanwoo Choi wrote:
>> This patch adds only the compatible string for S2MPS13 clock which is identical
>> with S2MPS14 clock driver.
> 
> What's the relation of S2MPS14 RTC and clock driver?

Sorry, I write wrong patch description. I'll fix it.

Best Regards,
Chanwoo Choi
