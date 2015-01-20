Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbbATEqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 23:46:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18795 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbATEqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 23:46:37 -0500
X-AuditID: cbfee68e-f79b46d000002b74-3e-54bdddaa3ceb
Date: Tue, 20 Jan 2015 04:46:34 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv8 2/9] devfreq: event: Add resource-managed function for
 devfreq-event device
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
X-MTR: 20150120044614661@myungjoo.ham
Msgkey: 20150120044614661@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150120044614661@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <900879710.1308121421729191415.JavaMail.weblogic@epmlwas04a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkUHfV3b0hBmcPmVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MtbeOshQ0sFd8PMDXwPiErYuRk0NIQF1i0ZKTYLaEgInExen7
	oGwxiQv31gPZXEA1SxklDu29ww5TtOn1KkaIxBxGibV7+8ESLAKqErtmnmDqYuTgYBPQk5j5
	ORnEFBZIlNh8hgukQkQgT+LK3RlgrcwCPWwSHVe/M0McoSSxZt8rFhCbV0BQ4uTMJywQu1Ql
	tpx7wQwRV5OY3niJGSIuLnFh7iWoe3glZrQ/haqXk5j2dQ1UjbTE+VkbGGGeWfz9MVScX+LY
	7R1MELaAxNQzB6FqtCSO3d3PCmHzSaxZ+JYFpn7XqeXMMLvub5kL1SshsbXlCVg9s4CixJTu
	h+wg/zILaEqs36WP6hUOINtDYu0xD5DXJQQmckh0HX3FOoFRaRaSsllIJs1CmISsZAEjyypG
	0dSC5ILipPQiI73ixNzi0rx0veT83E2MwJRw+t+zvh2MNw9YH2IU4GBU4uF9uWpviBBrYllx
	Ze4hRlNgHE1klhJNzgcmnrySeENjMyMLUxNTYyNzSzMlcd4EqZ/BQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhh1DORvXfq7/ApvbIRbp+T7h7cUjRbuja6bppPDnOH0fnfBY82MkKc+dm3s
	Vdk7M/fkqZWG35m6bO7OxolyvHt+z5zo9ODWBu2mM4sUk9m/rZhQfsuyWGWy3QYL5c6jn7Om
	XuGdpqD7ozQ+Nfa3neDFl0pBxW/3B9isF7GvZyv5nXbx58+WAE0lluKMREMt5qLiRAB4YIyy
	BAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t/tft1Vd/eGGJxt0rO4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRlr
	bx1lKWhgr/h4gK+B8QlbFyMnh5CAusSiJSfBbAkBE4lNr1cxQthiEhfurQeKcwHVzGGUWLu3
	nx0kwSKgKrFr5gmmLkYODjYBPYmZn5NBTGGBRInNZ7hAKkQE8iSu3J3BCNLKLNDDJtFx9Tsz
	xC4liTX7XrGA2LwCghInZz5hgdilKrHl3AtmiLiaxPTGS8wQcXGJC3MvsUPYvBIz2p9C1ctJ
	TPu6BqpGWuL8rA1wNy/+/hgqzi9x7PYOJghbQGLqmYNQNVoSx+7uZ4Ww+STWLHzLAlO/69Ry
	Zphd97fMheqVkNja8gSsnllAUWJK90N2kH+ZBTQl1u/SR/UKB5DtIbH2mMcERtlZSDKzkDTP
	QmhGVrKAkWUVo2hqQXJBcVJ6hZFecWJucWleul5yfu4mRnD6ebZoB+O/89aHGAU4GJV4eB3W
	7g0RYk0sK67MPcQowcGsJMJ79BJQiDclsbIqtSg/vqg0J7X4EKMpMMYmMkuJJucDU2NeSbyh
	sbGJmYmppYmFgam5kjjv/3O5IUIC6YklqdmpqQWpRTB9TBycUg2MTFf32U5fO2O+Vsf81/d5
	5shf9psye63Wt/lxm77JrmCY/tHR3jBjfkSclcnSzvsxaey64X1MbC+Pcf2dG2uuMGlG+Nam
	v2yiaQEPBfLPP9vi+frO7Mf+fu94FD1/nVy7cdNKk4Ad3/31Ty8Lmz9ri41HdXlb+BLJmTbN
	E79JGjnN893z7eJ2LiWW4oxEQy3mouJEAGAY0C1VAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0K4kvx5008505

>   
>  This patch add the resource-managed function for devfreq-event device as
> following functions. The devm_devfreq_event_add_edev() manages automatically
> the memory of devfreq-event device using resource management.
> - devm_devfreq_event_add_edev()
> - devm_devfreq_event_remove_edev()
> 
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.comA

Reviewed-by: MyungJoo Ham <myungjoo.ham@samsung.com>

You may merge this patch with 1/9 as well.
I don't think this is a major change the requires a seperated patch.


Cheers,
MyungJoo
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
