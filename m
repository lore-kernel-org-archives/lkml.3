Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbbASJb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:31:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:45983 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbbASJbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:31:53 -0500
X-AuditID: cbfee691-f79b86d000004a5a-6d-54bccef66adc
Date: Mon, 19 Jan 2015 09:31:34 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4 4/9] clk: samsung: exynos4: Add divider clock id for
 memory bus frequency
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
	<linux-samsung-soc@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150119092949381@myungjoo.ham
Msgkey: 20150119092949381@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150119092949381@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <889613260.1254421421659891455.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkWPfbuT0hBhsfW1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MJQv+sxRsYq042LqHtYFxDmsXIyeHkIC6xKIlJ9lAbAkBE4n1
	n4+wQthiEhfurQeKcwHVLGWUOHVrMTtM0ar+C4wQiTmMEr+fbGQGSbAIqEosWHQHqIODg01A
	T2Lm52SQsLBAgkT7629gJSICeRJX7s4A62UW2MsmsfHmMkaIK5Qk1ux7xQJi8woISpyc+YQF
	YpmqxLRnDewQcTWJG793Q10qLnFh7iWog3glZrQ/haqXk5j2dQ0zhC0tcX7WBkaYbxZ/fwwV
	55c4dnsHE4QtIDH1zEGoGi2JC1MfQ33PJ7Fm4VsWmPpdp5Yzw+y6v2UuVK+ExNaWJ2D1zAKK
	ElO6H7KD/M4soCmxfpc+uld4BTwkNm6axwLyu4TAVA6JtvPrWSYwKs1CUjcLyahZCKOQlSxg
	ZFnFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJEZgYTv97NnEH4/0D1ocYBTgYlXh4N/ruCRFi
	TSwrrsw9xGgKjKWJzFKiyfnA9JNXEm9obGZkYWpiamxkbmmmJM6rI/0zWEggPbEkNTs1tSC1
	KL6oNCe1+BAjEwenVAPj/G673yeefGjwkYt1E155OPL/6k+Nv/4XTXF2KD4V9C/4TS5fyAz2
	DwxOf5UzueuMrY+xZN89MG3VuzyvCRuSp7PVHlZKznh8ep/K0h2nI2rPui7iNV6sEeGjIRSp
	LRh4etq5s9cefs9p2fSF6cuvSNtavp4C+78ur6/tvjXrdlyx8+W4JcH/lFiKMxINtZiLihMB
	GYYv8AcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t/tft1v5/aEGKz/ZGJxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jKW
	LPjPUrCJteJg6x7WBsY5rF2MnBxCAuoSi5acZAOxJQRMJFb1X2CEsMUkLtxbDxTnAqqZwyjx
	+8lGZpAEi4CqxIJFd4ASHBxsAnoSMz8ng4SFBRIk2l9/AysREciTuHJ3BiNIL7PAXjaJjTeX
	MUIsU5JYs+8VC4jNKyAocXLmExaIZaoS0541sEPE1SRu/N4NdZC4xIW5l9ghbF6JGe1Poerl
	JKZ9XcMMYUtLnJ+1Ae7oxd8fQ8X5JY7d3sEEYQtITD1zEKpGS+LC1MesEDafxJqFb1lg6ned
	Ws4Ms+v+lrlQvRISW1uegNUzCyhKTOl+yA7yO7OApsT6XfroXuEV8JDYuGkeywRG2VlIUrOQ
	dM9C6EZWsoCRZRWjaGpBckFxUnqFoV5xYm5xaV66XnJ+7iZGcBJ6tnAH45fz1ocYBTgYlXh4
	N/juCRFiTSwrrsw9xCjBwawkwsu3HijEm5JYWZValB9fVJqTWnyI0RQYZxOZpUST84EJMq8k
	3tDY2MTMxNTSxMLA1FxJnPf/udwQIYH0xJLU7NTUgtQimD4mDk6pBsbJ/ibLXtz+/XGZwF+P
	iMIVxbnrJ+hztp3tbrl21HR5h+YnveSpoX9SUrY+fNDC9O7FuRcqfBLt0bXnC1f8S2lYUn4k
	eLu0sUQcg9PHqDWO+1NnTG75cOjfNebnat1mLnkX0r/ZP3p+RX2Kv2n6R/G0pqA3W6+s9jfv
	u/zUzqLovkKbRoHn2wdKLMUZiYZazEXFiQC2aKicWAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J9W1NF001788

>   
>  This patch adds the divider clock id for Exynos4 memory bus frequency.
> The clock id is used fo DVFS (Dynamic Voltage/Frequency Scaling)
> feature of exynos memory bus frequency.
> 
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Anyway, you will need reviews from Sylwester and/or Tomasz for this one.



Cheers,
MyungJoo
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
