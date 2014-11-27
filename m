Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaK0L4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:56:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22182 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaK0L4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:56:38 -0500
X-AuditID: cbfee68f-f791c6d000004834-3c-547711731191
Message-id: <54771173.6090408@samsung.com>
Date: Thu, 27 Nov 2014 20:56:35 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for
 CMU_BUS{0|1|2} domains
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-12-git-send-email-cw00.choi@samsung.com>
 <6217579.xNXtO7YiDs@wuerfel>
In-reply-to: <6217579.xNXtO7YiDs@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsWyRsSkSLdYsDzE4MgdWYvHaxYzWfyddIzd
	4v2yHkaLy/u1LeYfOcdq8WdCK5vFpPsTWCxu/GpjtehdcJXN4mzTG3aLKX+WM1lsenyN1eLy
	rjlsFjPO72OyWHr9IpPFqeuf2SwOv2lntZgx+SWbxbEZSxgtVu36w2jx8uMJFgdRjzXz1jB6
	/P41idFj56y77B53ru1h89i8pN7jyokmVo++LasYPT5vkgvgiOKySUnNySxLLdK3S+DKuNt0
	h6XgJ0fFxtspDYwz2bsYOTkkBEwkDrbvZIawxSQu3FvP1sXIxSEksJRR4tHeL3BFy26vY4ZI
	LGKU+H/xEZTzmlFi++WfjCBVvAJaErP2TGABsVkEVCWu/WljBbHZgOL7X9xgA7FFBcIkVk6/
	wgJRLyjxY/I9MFtEQFFi6otnYEOZBfpYJL5fWg7WICwQI3F1zV9GiG0LGSUuzZ8Jto1TQFOi
	8/h8sMOZBXQk9rdOY4Ow5SU2r3kLNklC4ASHxImJ56BOEpD4NvkQkM0BlJCV2HQA6mlJiYMr
	brBMYBSbheSoWUjGzkIydgEj8ypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwARx+t+z/h2M
	dw9YH2IU4GBU4uG1OFAWIsSaWFZcmXuI0RToionMUqLJ+cA0lFcSb2hsZmRhamJqbGRuaaYk
	zrtQ6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkaOudcmnk+68GOjxXX3/nl3t5z69Eo+
	tFBhGhOnzVzNmbnRTxn+6N9SsBP1f7fW889l13Pmyyw1T/9UTsoWyTJKv56efnS53plk6z21
	hnv259T73LVy4Hbw9a8XWtPd5TstVGjHTOmLnqEvJzV0rYwRn+x0SLbzrZ55X/jzPTvtbP2u
	LtM5Pk+JpTgj0VCLuag4EQCERIoUCwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t9jAd1iwfIQgymtIhaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWU/4sZ7LY9Pgaq8Xl
	XXPYLGac38dksfT6RSaLU9c/s1kcftPOajFj8ks2i2MzljBarNr1h9Hi5ccTLA6iHmvmrWH0
	+P1rEqPHzll32T3uXNvD5rF5Sb3HlRNNrB59W1YxenzeJBfAEdXAaJORmpiSWqSQmpecn5KZ
	l26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JqSQlliTilQKCCxuFhJ3w7ThNAQ
	N10LmMYIXd+QILgeIwM0kLCGMeNu0x2Wgp8cFRtvpzQwzmTvYuTkkBAwkVh2ex0zhC0mceHe
	erYuRi4OIYFFjBL/Lz5ihnBeM0psv/yTEaSKV0BLYtaeCSwgNouAqsS1P22sIDYbUHz/ixts
	ILaoQJjEyulXWCDqBSV+TL4HZosIKEpMffEMbCizQB+LxPdLy8EahAViJK6u+csIsW0ho8Sl
	+TPBtnEKaEp0Hp8Pdh+zgI7E/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECE4/z6R3MK5qsDjEKMDBqMTDa3GgLESINbGsuDL3EKMEB7OS
	CC8XY3mIEG9KYmVValF+fFFpTmrxIUZTYBhMZJYSTc4Hpsa8knhDYxMzI0sjc0MLI2NzJXHe
	GzdzQ4QE0hNLUrNTUwtSi2D6mDg4pRoYmys/F3n2O/H59+SrHTMovCpTYvvZbYWInM6t56/v
	tbVsf3HhSN2/YuPfCo5fj3hn3Cl9XvVua2W0yZWqy7LqDNn1vGwtOWpJsTO3vtmks15SXGxV
	6+tM5aR3T44nssU++TFZuO7NpbPNfdbPVrk8XiC16ia7v8bCi4KnD6ot032SMvuqY+I+JZbi
	jERDLeai4kQALlBPTVUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd,

On 11/27/2014 08:41 PM, Arnd Bergmann wrote:
> On Thursday 27 November 2014 16:35:08 Chanwoo Choi wrote:
>> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
>> +    and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
>> +    which generates global data buses clock and global peripheral buses clock.
>>  
>>  - reg: physical base address of the controller and length of memory mapped
>>    region.
>>
> 
> This looks like you are duplicating the bindings and the code, but
> it's really the same hardware multiple times with minor variations
> that you should be able to describe properly here. Why not make
> three nodes with the same compatible string and have them handled
> by the same code?

Each CMU_BUSx domain of Exynos5433 have different base address as following:
- CMU_BUS0's base address and range : 0x1360_0000 ~ 0x1360_0b04
- CMU_BUS1's base address and range : 0x1480_0000 ~ 0x1480_0b04
- CMU_BUS2's base address and range : 0x1340_0000 ~ 0x1340_0b04

So, I implement CMU_BUSx domain which has each compatible string.

Best Regards,
Chanwoo Choi


