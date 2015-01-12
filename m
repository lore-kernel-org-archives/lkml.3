Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbbALJwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:52:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59776 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbbALJw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:52:27 -0500
X-AuditID: cbfee68e-f79b46d000002b74-87-54b3995a99b1
Date: Mon, 12 Jan 2015 09:52:26 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv7 10/10] ARM: dts: exynos: Add PPMU node for
 Exynos4412-based TRATS2 board
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>
Cc: =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150112095217326@myungjoo.ham
Msgkey: 20150112095217326@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150112095217326@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1678780582.904251421056343037.JavaMail.weblogic@epmlwas01a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkRDdq5uYQg6WvZSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG6dM/mAtusVV0LZRqYDzA1sXIySEkoC6xaMlJMFtCwESi68s/
	FghbTOLCvfVQNUsZJV78N4Wpeb13ElANF1B8DqPEq/8zGUESLAKqErvW7mLtYuTgYBPQk5j5
	ORkkLCwQJ3H8zASwEhGBPIkrd2cwgvQyC/SwSXRc/c4MsUBJYs2+V2CLeQUEJU7OfMICMkcC
	aOarWwIQYTWJvZMPQ90mLnFh7iV2CJtXYkb7U6i4nMS0r2uYIWxpifOzNjDC/LL4+2OoOL/E
	sds7mCBsAYmpZw5C1WhJnD/bBVXDJ7Fm4VsWmPpdp5Yzw+y6v2UuVK+ExNaWJ6wgNrOAosSU
	7ofsICczC2hKrN+lj+oTENtD4s3z1+BgkxCYyCGx6Mc+lgmMSrOQ1M1CMmoWwihkJQsYWVYx
	iqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBKaE0/+e9e1gvHnA+hCjAAejEg+vhdTmECHWxLLi
	ytxDjKbASJrILCWanA9MPHkl8YbGZkYWpiamxkbmlmZK4rwJUj+DhQTSE0tSs1NTC1KL4otK
	c1KLDzEycXAC04uQ9I+Ov0LN6bPfGWeuVJzrIJfTmXl6xjwbviulJaonfxa7/LLQUblVdPfK
	DuWrrmcsjqc6JOkdmvxt0re5R5Y915Pf364UzhXwdIvDxfP55oFsCwTz3PSeHrV65jujfv1z
	1h9yEy2XcTyuu+HxW+Tn9LMOTC/X7nnpluqQsLPJQ+z71B3603mVWIozEg21mIuKEwE0Korl
	BAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t/tXt2omZtDDNpmi1tc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIzT
	p38wF9xiq+haKNXAeICti5GTQ0hAXWLRkpNgtoSAicTrvZNYIGwxiQv31gPFuYBq5jBKvPo/
	kxEkwSKgKrFr7S7WLkYODjYBPYmZn5NBwsICcRLHz0wAKxERyJO4cncGI0gvs0APm0TH1e/M
	EMuUJNbsewW2gFdAUOLkzCcsIHMkgGa+uiUAEVaT2Dv5MNQN4hIX5l5ih7B5JWa0P4WKy0lM
	+7qGGcKWljg/awMjzM2Lvz+GivNLHLu9gwnCFpCYeuYgVI2WxPmzXVA1fBJrFr5lganfdWo5
	M8yu+1vmQvVKSGxtecIKYjMLKEpM6X7IDnIys4CmxPpd+qg+AbE9JN48f80ygVF2FpLULCTd
	sxC6kZUsYGRZxSiaWpBcUJyUXmGsV5yYW1yal66XnJ+7iRGcgJ4t3sH4/7z1IUYBDkYlHl4L
	qc0hQqyJZcWVuYcYJTiYlUR4XcuAQrwpiZVVqUX58UWlOanFhxhNgVE2kVlKNDkfmBzzSuIN
	jY1NzExMLU0sDEzNlcR5/5/LDRESSE8sSc1OTS1ILYLpY+LgBKaSuJ8THL/1Bdrv/5u5+v7+
	o2X94ucy1ryJVK6PeGZQ7HAmXPitb5ZwRrVNljez2Z3p31k+ChTJTExXurld9cJxhcSwK3V9
	U2T+rZe92Zqea12f/DTtPvvyCSWBXneFssUu3VXjvL7WQWrz7+fXnk6+OLmRZVbW8k+FynuX
	qWRs/L5u5T9ZOSkfJZbijERDLeai4kQAadz9clYDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0C9qZRc017184

>  This patch add dt node for PPMU_{DMC0|DMC1|LEFTBUS|RIGHTBUS} for
> exynos4412-trats2 board. Each PPMU dt node includes one event of 'PPMU Count3'.
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4412-trats2.dts | 40 +++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)


Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

I didn't review 5260, Rinato, and Monk as I am not familiar with those.

Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
