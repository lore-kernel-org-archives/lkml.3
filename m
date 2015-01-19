Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbbASJhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:37:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42716 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbbASJg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:36:59 -0500
X-AuditID: cbfee68e-f79b46d000002b74-f0-54bcd03944d5
Date: Mon, 19 Jan 2015 09:36:57 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4 8/9] ARM: dts: Add the support for exynos busfreq on
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
X-MTR: 20150119093647466@myungjoo.ham
Msgkey: 20150119093647466@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150119093647466@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1571878875.1255011421660214285.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkSNfywp4Qg4erDCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG3/2nGAuesFbcOHuavYHxDGsXIyeHkIC6xKIlJ9lAbAkBE4n+
	XZ+YIGwxiQv31gPFuYBqljJKTLp/hwWmaPnBt8wQiTmMEo1vPoJ1swioSrz99QfI5uBgE9CT
	mPk5GSQsLJApcXH9abBlIgJ5ElfuzmAE6WUW6GGT6Lj6nRniCiWJNftegS3gFRCUODnzCdQy
	VYkHF78xQ8TVJJr2H4aKi0tcmHuJHcLmlZjR/hQqLicx7esaZghbWuL8rA2MMN8s/v4YKs4v
	cez2DqgvBSSmnjnICHKzhICWxIWnNRBhPok1C9+ywJTvOrWcGWbV/S1zoVolJLa2PAH7i1lA
	UWJK90N2kDHMApoS63fpo/uEV8BTYtfaw1BjpnJILF2cOYFRaRaSsllIJs1CmISsZAEjyypG
	0dSC5ILipPQiI73ixNzi0rx0veT83E2MwKRw+t+zvh2MNw9YH2IU4GBU4uHd4LsnRIg1say4
	MvcQoykwjiYyS4km5wNTT15JvKGxmZGFqYmpsZG5pZmSOG+C1M9gIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYwVRU8n/zVeHZ6xoSG2gutz4NYZrh93fdgRbnwn+5f75qJd1R+bHkw7OF2x
	Uzb77aTJVz/yH/5zY82huVt4t737zyzWy3t+l8oh4e1TKrx+uC+70Bbw6kFs4YxWMeWwb2u+
	fX0R7SMZwRR3sHGPdVjO3AdOvnHbD//xVJ+xYhbzuvTZoo3rPZ9qKrEUZyQaajEXFScCAPsf
	a3MFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tfl3LC3tCDGY/0rS4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRl/
	959iLHjCWnHj7Gn2BsYzrF2MnBxCAuoSi5acZAOxJQRMJJYffMsMYYtJXLi3HijOBVQzh1Gi
	8c1HsCIWAVWJt7/+ANkcHGwCehIzPyeDhIUFMiUurj8NNlNEIE/iyt0ZjCC9zAI9bBIdV78z
	QyxTkliz7xULiM0rIChxcuYTFohlqhIPLn5jhoirSTTtPwwVF5e4MPcSO4TNKzGj/SlUXE5i
	2tc1UIdKS5yftYER5ujF3x9Dxfkljt3ewQRhC0hMPXOQEeRmCQEtiQtPayDCfBJrFr5lgSnf
	dWo5M8yq+1vmQrVKSGxteQL2F7OAosSU7ofsIGOYBTQl1u/SR/cJr4CnxK61h5knMMrOQpKa
	haR7FkI3spIFjCyrGEVTC5ILipPSK4z1ihNzi0vz0vWS83M3MYJT0LPFOxj/n7c+xCjAwajE
	w7vBd0+IEGtiWXFl7iFGCQ5mJRFevvVAId6UxMqq1KL8+KLSnNTiQ4ymwCibyCwlmpwPTI95
	JfGGxsYmZiamliYWBqbmSuK8/8/lhggJpCeWpGanphakFsH0MXFwSjUwJlfr7ayd4LzBxXr9
	hIfxVzUZjx4LWdnO/VQkSsDPYL1+r0fC6bKvUg3Hv+jnu3w1CRVg943gyuyIl1t6+bbKw8cr
	+rc5p0kU7VjWt6Jbvvm0K4uL84IDFaw77Tn9GybNOzH96Ar90/cixKVj1PbVLYude21m3dHJ
	uh62F1YHeDA3Hi6TdWhRYinOSDTUYi4qTgQAXl9zwFcDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J9b8i8001840

>   
>  This patch adds the Exynos4412 memory-bus node which includes the regulator
> and devfreq-event phandle. The devfreq-event phandle is used for the
> governor of devfreq device and provide the current usage state of
> MIF (Memory Interface) / INT (Internal) memory bus group.
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
