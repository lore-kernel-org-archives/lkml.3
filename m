Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab3BVGeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:34:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22538 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3BVGd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:33:59 -0500
X-AuditID: cbfee690-b7f066d00000169f-3a-512711560402
Date: Fri, 22 Feb 2013 06:33:58 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] PM / devfreq: fix missing unlock on error in
 exynos4_busfreq_pm_notifier_event()
To: Nishanth Menon <nm@ti.com>, Wei Yongjun <weiyj.lk@gmail.com>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20130222063349729@myungjoo.ham
Msgkey: 20130222063349729@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130222063349729@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2946170.20251361514836501.JavaMail.weblogic@epml14>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+Ztm6YoHqgwe+NAhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjzqtL7AUPOCv+LVrE2sC4h7OLkZNDSEBdYtGSk2wgtoSAicSj
	vU/YIWwxiQv31rNB1MxilLjxxL6LkQOs5tm1tC5GLqDwfEaJtec3soLUsAioSlxbs5MVpIZN
	QE9i5udkkLCwQKbE1JaVYGERATeJn6sdQFqZBZ4wSuy8/I8RYrySxJp9r1hAbF4BQYmTM5+w
	QJygKrHr7n4WkF5eATWJOW18EGEJiVnTL7BC2LwSM9qfQpXLSUz7uoYZwpaWOD9rAyPMJ4u/
	P4aK80scu72DCeITXokn94Nhxuze/AUaCAISU88chGrVkliwZSOUzSexZuFbFpgxu04tZ4bp
	vb9lLhOIzSygKDGl+yE7hK0l8eXHPjZ0X/EKOEhsf7yXcQKj8iwkqVlI2mchaUdWs4CRZRWj
	aGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSEKYsIPx3gHrQ4zJwAiZyCwlmpwPTCh5JfGGxgbG
	hoaWhmamlqYGpAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDYs7ZWVDSV17F0
	9e2zzXm3CsM/zl3P8C77bZDhpAD1joBj014o3d3f0J/PrCje4LB5WzrfPu4Wew8G0Tz2ubOj
	r7KbzNXZ47XHo1t0fW3RkqKtjAfEAquKev/7pC2IuLy9/nSue9a2bo+bvDUuB0/fKFfU+Rb4
	xZfPWeHrhFAvTeP8oraPU5VYijMSDbWYi4oTAU4eQNUeAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/t6bphguqBBieucFtc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jDuvLrEXPOCs+LdoEWsD4x7OLkZODiEBdYlFS06ydTFycEgImEg8u5YGEpYQEJO4cG89UJgL
	qGQ+o8Ta8xtZQRIsAqoS19bsZAWpZxPQk5j5ORkkLCyQKTG1ZSVYWETATeLnageQVmaBJ4wS
	Oy//Y4RYpSSxZt8rFhCbV0BQ4uTMJywQu1Qldt3dzwLSyyugJjGnjQ8iLCExa/oFVgibV2JG
	+1OocjmJaV/XMEPY0hLnZ21ghDl58ffHUHF+iWO3dzBBfMUr8eR+MMyY3Zu/sEHYAhJTzxyE
	atWSWLBlI5TNJ7Fm4VsWmDG7Ti1nhum9v2UuE4jNLKAoMaX7ITuErSXx5cc+NnRf8Qo4SGx/
	vJdxAqPcLCSpWUjaZyFpR1azgJFlFaNoakFyQXFSeqqZXnFibnFpXrpecn7uJkZwcnomsINx
	SYPFIUYBDkYlHt4GF7VAIdbEsuLK3EOMEhzMSiK8+qFAId6UxMqq1KL8+KLSnNTiQ4zJwOib
	yCwlmpwPTJx5JfGGxgbGhoaW5gamhkYWpAkrifOyV0wPEBJITyxJzU5NLUgtgtnCxMEp1cDI
	yVAxIfhK0e9X10+vWsikeapbcAOfDodUkFugpKXnrxWWmQvlA9KSYmUtdISOnslwUzxa/LFg
	ywXfpCVyu+5Nm8zLIHvs/bU1faXWZx7sllI+tUXc6m8s617X4scdVQwJE/3+eX7mjLg6QUZB
	NWxO7ermo7mTN11epe5Xbv/c+ynryn05ZteUWIozEg21mIuKEwHHsvr8kgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1M6Yc78014207

> On 12:33-20130222, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Add the missing unlock before return from function
> > exynos4_busfreq_pm_notifier_event() in the error
> > handling case.
> > 
> > This issue introduced by commit 8fa938
> > (PM / devfreq: exynos4_bus: honor RCU lock usage)
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> Arrgh.. Thanks for catching this :( My bad.
> 
> Fix looks good to me. upto  MyungJoo.

Applied to devfreq repository.
I'll send pull request to Rafael soon along with other patches.

> 
> MyungJoo, Rafael,
> btw, adding linux-pm@vger.kernel.org to  MAINTAINERS for devfreq might
> be a nice idea to have right audience.

It appears that replacing the current mailing list address with linux-pm is appropriate. If no one objects, I'll post the suggestion later.


Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
