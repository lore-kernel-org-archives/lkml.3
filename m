Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaC0KwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:52:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44215 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbaC0KwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:52:20 -0400
X-AuditID: cbfee68e-b7f566d000002344-c0-533402e3987a
Date: Thu, 27 Mar 2014 10:52:19 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCHv4 0/5] devfreq: exynos: Fix minor issue and code clean
 to remove legacy method
To: =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140327105046859@myungjoo.ham
Msgkey: 20140327105046859@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140327105046859@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2623633.147631395917538263.JavaMail.weblogic@epml10>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSoPuYySTYYNFxOYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWxa/8jxoIdnBW/Xy1ia2CcwtnFyMkhJKAusWjJSTYQW0LARKL7
	+xwWCFtM4sK99UBxLqCapYwSn36vYYEpun52GhNE83xGiZtTckFsFgFViY7zvxm7GDk42ATM
	Je7PCAIJCwukSVz7+xesVQTI3rF7HQvITGaBV0wS6/eeZIeYoySxZt8rsCJeAUGJkzOfQO1S
	lTiwZB8rRFxNonPVD6hDJSRmTb/ACmHzSsxofwpVLycx7esaZghbWuL8rA2MMM8s/v4YKs4v
	cez2DiaQO0F6n9wPhhmze/MXqPECElPPHIRq1ZJYsW4f1Co+iTUL37LAjNl1ajkzTO/9LXPB
	QcIsoCgxpfshO4StJfHlxz42VG9xANmOErsPek9gVJ6FJDMLSfcsJN3IahYwsqxiFE0tSC4o
	TkovMtIrTswtLs1L10vOz93ECEwKp/8969vBePOA9SHGZGCMTGSWEk3OByaVvJJ4Q2MzIwtT
	E1NjI3NLM9KElcR5Fz1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqOD/etWEWZx5vRMW
	hEU+VU+94rHC91jGkbya9PT1rz/pmv5d2fzpTrvgXBW969fM9s7S2ZTY+dik4NbcXJuMWmeP
	grVr+zl2b3MwbUrbHD7vrrWqG+Mj4zlzGoumN5+U/eqwvC3owbrLlXdltx25kFudvPDY9M0z
	J2R/mLxGxyDLZOO24D9N75RYijMSDbWYi4oTAY5cIt4gAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tmbqPmUyCDdb0Slhc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIxd
	+x8xFuzgrPj9ahFbA+MUzi5GTg4hAXWJRUtOsoHYEgImEtfPTmOCsMUkLtxbzwZRM59R4uaU
	XBCbRUBVouP8b8YuRg4ONgFzifszgkDCwgJpEtf+/mUBsUWA7B271wHZXBzMAq+YJNbvPckO
	MUdJYs2+V2BFvAKCEidnPmGB2KUqcWDJPlaIuJpE56ofUPdISMyafoEVwuaVmNH+FKpeTmLa
	1zXMELa0xPlZGxhhbl78/TFUnF/i2O0dTCB3gvQ+uR8MM2b35i9Q4wUkpp45CNWqJbFi3T6o
	VXwSaxa+ZYEZs+vUcmaY3vtb5oKDh1lAUWJK90N2CFtL4suPfWyo3uIAsh0ldh/0nsAoNwtJ
	ZhaS7llIupHVLGBkWcUomlqQXFCclF5holecmFtcmpeul5yfu4kRnJqeLdnB2HDB+hCjAAej
	Eg/vjvtGwUKsiWXFlbmHGCU4mJVEePv/GgcL8aYkVlalFuXHF5XmpBYfYkwGxt9EZinR5Hxg
	2swriTc0NjYxMzG1NLEwMDUnTVhJnHfBraQgIYH0xJLU7NTUgtQimC1MHJxSDYx+Cpu+ts13
	WV30P9U/J9litdWZapWqk0FrWWZ/3Xbk256ZgVv+zFr6Y644Y9R5ywPZe1iOaKnPX3+hUK5k
	xyd/w29n7afdmP50v2LJQqbDZ/aIOX3YcfN9a9abI98Y2g5JmyYGHl98aW1CyAQOg63S32NX
	Z/+2NvrvJRGweNrM9VmHnGPPlGbUK7EUZyQaajEXFScCABP+56WRAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2RAqR4H005166


On Mon, Mar 24, 2014 at 10:36 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> Hi Tomasz,
>
> On 03/22/2014 11:52 PM, Tomasz Figa wrote:
>> Hi,
>>
>> [fixing mistyped addresses of me and Bartlomiej]
>>
>> On 20.03.2014 03:59, Chanwoo Choi wrote:
>>> This patchset use SIMPLE_DEV_PM_OPS macro intead of legacy method and fix
>>> probe fail if CONFIG_PM_OPP is disabled. Also, this patchset fix minor issue.
>>>
>>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>>
>
> Thanks for your review always.
>
> Best Regards,
> Chanwoo Choi
>

Applied/Merged.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
 ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
