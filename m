Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbbASJed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:34:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23968 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbASJeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:34:31 -0500
X-AuditID: cbfee68d-f79296d000004278-be-54bccf730d69
Date: Mon, 19 Jan 2015 09:33:39 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4 6/9] ARM: dts: Add memory bus node for Exynos4210
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
X-MTR: 20150119093149531@myungjoo.ham
Msgkey: 20150119093149531@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150119093149531@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <53274700.1254611421660016720.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWyRsSkWLf4/J4Qgyt7LS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG7aX1BYu4Kq7t/MPSwPiHs4uRk0NIQF1i0ZKTbCC2hICJxOu5
	W9ghbDGJC/fWA8W5gGqWMkq8XDGXFaZow659TBCJOYwS7x7/Zexi5OBgEVCVaJrLBWKyCehJ
	zPycDFIuLOAhseTTJbD5IgJ5ElfuzmAEaWUW6GGT6Lj6nRniCCWJNftesYDYvAKCEidnPmEB
	mSMBNHLPV16IsJrEyfsToG4Tl7gw9xKUzSsxo/0pC4QtJzHt6xpmCFta4vysDYwwvyz+/hgq
	zi9x7PYOJghbQGLqmYNQNVoSC0/tgarhk1iz8C0LTP2uU8uZYXbd3zIXqldCYmvLE3CQMAso
	SkzpfsgOcjKzgKbE+l366D7hFXCXOLFaHuRzCYGpHBIPW84yT2BUmoWkbBaSSbMQJiErWcDI
	sopRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjMCGc/vesdwfj7QPWhxgFOBiVeHg3+O4JEWJN
	LCuuzD3EaAqMoonMUqLJ+cC0k1cSb2hsZmRhamJqbGRuaaYkzqso9TNYSCA9sSQ1OzW1ILUo
	vqg0J7X4ECMTB6dUA+OB0sWVwRlLfE/PLN9grWw+ScDv2p/7u7qvRkUcPaOg+8+ZfWfIlylr
	pvUkrHEMvDFpj5jTxgLDGykL+7fULGL4vHJZyOui1d7af3/LezkYpp5755n6cPPm149Oh8wv
	nhakVpx7QWuhQOvvzUsyRVj5r6qlelbUhRp51s8zOJXu1qNdKsO9zl2JpTgj0VCLuag4EQCP
	cCNWAwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t/tPt3i83tCDFruGllc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIzb
	S+sLFnFVXNv5h6WB8Q9nFyMnh5CAusSiJSfZQGwJAROJDbv2MUHYYhIX7q0HinMB1cxhlHj3
	+C9jFyMHB4uAqkTTXC4Qk01AT2Lm52SQcmEBD4klny6BjRERyJO4cncGI0grs0APm0TH1e/M
	ELuUJNbse8UCYvMKCEqcnPmEBWSOBNDIPV95IcJqEifvT2CHOEFc4sLcS1A2r8SM9qcsELac
	xLSva5ghbGmJ87M2MMKcvPj7Y6g4v8Sx2zugXhGQmHrmIFSNlsTCU3ugavgk1ix8ywJTv+vU
	cmaYXfe3zIXqlZDY2vKEFcRmFlCUmNL9kB3kZGYBTYn1u/TRfcIr4C5xYrX8BEbZWUgys5A0
	z0JoRlaygJFlFaNoakFyQXFSeoWhXnFibnFpXrpecn7uJkZw8nm2cAfjl/PWhxgFOBiVeHg3
	+O4JEWJNLCuuzD3EKMHBrCTCy7ceKMSbklhZlVqUH19UmpNafIjRFBhhE5mlRJPzgYkxryTe
	0NjYxMzE1NLEwsDUXEmc9/+53BAhgfTEktTs1NSC1CKYPiYOTqkGxl23nEIlHx6VjZyy/Ple
	s+Qrvo9cDGY5MEj2Xvn6RKHxddq0HQfnNG77xBCpPJWh50ncVINE44PLiwL1Qi8dqsn/3LL0
	iV7A4vOCF+WMVQu1reZOXP9fv+TG/GcSem0HlQI+Tj2xudP7y6OJV3hNKzbxXe64xntwTcIK
	X/fn2jfVVc6qZVn9X6zEUpyRaKjFXFScCADu0qJZVAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J9Ycwq001809

>   
>  This patch adds the memory bus node for Exynos4210 SoC. Exynos4210 SoC has
> one memory bus to translate data between DRAM and eMMC/sub-IPs because
> Exynos4210 must need only one regulator for memory bus.
> 
> Following list specifies the detailed relation between memory bus clock and
> sub-IPs:
> - DMC/ACP clock : DMC (Dynamic Memory Controller)
> - ACLK200 clock : LCD0
> - ACLK100 clock : PERIL/PERIR/MFC(PCLK)
> - ACLK160 clock : CAM/TV/LCD0/LCD1
> - ACLK133 clock : FSYS/GPS
> - GDL/GDR clock : leftbus/rightbus
> - SCLK_MFC clock : MFC
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


Revisiting good old days..?
(good to see the first busfreq driver experimented with is
being DT-nized... :)  )


Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
