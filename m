Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbaDWHap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:30:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10740 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaDWHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:30:26 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-42-53576c10fe79
Message-id: <53576C17.5000601@samsung.com>
Date: Wed, 23 Apr 2014 16:30:31 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCHv2] pinctrl: exynos: Add driver data for Exynos3250
References: <1397439947-31592-1-git-send-email-cw00.choi@samsung.com>
 <CACRpkdaycY=Mba1pYQMv-Yq87JGfyJEnwmrT+qwDhrZ_4Rqs+g@mail.gmail.com>
In-reply-to: <CACRpkdaycY=Mba1pYQMv-Yq87JGfyJEnwmrT+qwDhrZ_4Rqs+g@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkSFcgJzzYYEUnn0XvgqtsFmeb3rBb
	TPmznMli0+NrrBaXd81hs5hxfh+TxfoZr1ksjs1YwujA4XHn2h42j81L6j36tqxi9Pi8SS6A
	JYrLJiU1J7MstUjfLoEr4+7b3IK97BUbTs9gaWCcwdbFyMkhIWAicfv2DihbTOLCvfVANheH
	kMBSRokJxxfAFTVuuMQKkZjOKNG1fxUzSEJI4DWjxMLTRiA2r4CWxJwdd8EaWARUJfbMPMUE
	YrMBxfe/uAEWFxUIk1g5/QoLRL2gxI/J98BsEQEdie5tP8EWMAu8YZJ49PgcUIKDQ1jATeJp
	jyzE4h5GiWk3W9lBGjgFgiUenrwFtoBZQF1i0rxFzBC2vMTmNW+ZQRokBM6xS7z6PZEd4iIB
	iW+TD4ENlRCQldh0gBniM0mJgytusExgFJuF5KZZSMbOQjJ2ASPzKkbR1ILkguKk9CJTveLE
	3OLSvHS95PzcTYzAqDv979nEHYz3D1gfYkwGWjmRWUo0OR8YtXkl8YbGZkYWpiamxkbmlmak
	CSuJ86Y/SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLiENeNDzanpOssmrXsx5eDT3NBv
	x1p7ilxnfZ7bcaK8P8Eq72KGXe6nI+EV2jcuOLglvGV6833+cd91C0zONjHYXT/+uO2/318R
	Bk+Hk53qSm+X+u+55DfVqmLiRYHX9Qkb5aatqFhmd9An1/my7NbXW8K9txx8tKT03JYHLZ8u
	zLWvsNqt/GutEktxRqKhFnNRcSIADA/FuNACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQV2BnPBgg/XT2Sx6F1xlszjb9Ibd
	Ysqf5UwWmx5fY7W4vGsOm8WM8/uYLNbPeM1icWzGEkYHDo871/aweWxeUu/Rt2UVo8fnTXIB
	LFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDPuvs0t2MteseH0DJYGxhls
	XYycHBICJhKNGy6xQthiEhfurQeKc3EICUxnlOjav4oZJCEk8JpRYuFpIxCbV0BLYs6Ou2DN
	LAKqEntmnmICsdmA4vtf3ACLiwqESaycfoUFol5Q4sfke2C2iICORPe2n6wgC5gF3jBJPHp8
	DijBwSEs4CbxtEcWYnEPo8S0m63sIA2cAsESD0/eAlvALKAuMWneImYIW15i85q3zBMYBWYh
	2TELSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH9DOpHYwrGywOMQpwMCrx
	8BasDAsWYk0sK67MPcQowcGsJMI78yNQiDclsbIqtSg/vqg0J7X4EGMyMAgmMkuJJucD001e
	SbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAe+rkjxfD8vKXL
	8+fMdiu4vDOWcZVrj7/ip9pH7235lG9qHHxRu/j59Icv+cKeNCpsNb3ywrOPO2TvytRrIdGb
	Nq3LWTN737aJ0+Uun7pccKbsnLLAro1PJab9Skq3Xbt8qWhTy8cZeoySnXvXh6Z8e2fBe5u9
	KEyO2zqMU9uAYcqhT29WJJt0KbEUZyQaajEXFScCALwPk3AtAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 04:01 PM, Linus Walleij wrote:
> On Mon, Apr 14, 2014 at 3:45 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> 
>> From: Tomasz Figa <t.figa@samsung.com>
>>
>> This patch adds driver data (bank list and EINT layout) for Exynos3250
>> to pinctrl-exynos driver. Exynos3250 includes 158 multi-functional input/output
>> ports. There are 23 general port groups.
>>
>> Changes from v1:
>> - Add signed-off of sender
>> - Post only separated patch for pinctrl from following patchset(v1)
>>   : https://lkml.org/lkml/2014/4/10/286
>>
>> Cc: Thomas Abraham <thomas.abraham@linaro.org>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> This v2 patch applied.
> 

Thanks for your apply.

Best regards,
Chanwoo Choi

