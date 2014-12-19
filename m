Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaLSHZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:25:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42988 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLSHZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:25:58 -0500
X-AuditID: cbfee68e-f79b46d000002b74-e5-5493d3024d31
Date: Fri, 19 Dec 2014 07:25:54 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH RESEND v2 01/10] power: charger-manager: Use thermal
 subsystem interface only to get temperature.
To: =?utf-8?Q?=EC=9D=B4=EC=A2=85=ED=99=94?= <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141219071905036@myungjoo.ham
Msgkey: 20141219071905036@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141219071905036@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <2092330842.37501418973954560.JavaMail.weblogic@epmlwas08d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkQJfp8uQQg3dLDCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG14/jzAXz2CpOf53L3MDYwtbFyMkhJKAusWjJSTBbQsBE4lxH
	HxOELSZx4d56oDgXUM1SRokZ80+xwxR92rKYBSIxh1HiWeN7RpAEi4CqxLLfM4BsDg42AT2J
	mZ+TQcLCAqUS145sZgapFxHoZJS4sKaJFcRhFjjLJHG75Q8LxBlKEmv2vQKzeQUEJU7OfMIC
	sU1VYtfB42wQcTWJfYcvQ10hLnFh7iUom1diRvtTqHo5iWlf1zBD2NIS52dtYIR5Z/H3x1Bx
	foljt3dAvSkgMfXMQagaLYn9O25Cg4JPYs3Ctyww9btOLWeG2XV/y1yoXgmJrS1PWEFsZgFF
	iSndD9lBnmcW0JRYv0sf3Su8Au4ST9qnMYL8LiEwlUOirek94wRGpVlI6mYhGTULYRSykgWM
	LKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAlPD6X/P+nYw3jxgfYhRgINRiYe3o3ByiBBr
	YllxZe4hRlNgNE1klhJNzgcmoLySeENjMyMLUxNTYyNzSzMlcd4EqZ/BQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhjXlK2953njk/f5oM021ctn5b3qFT/3geXr1hmHF60MufThSa42G3dn
	/nz2JzcnaHGvO+DOzOvLuifBVaNyn0P7P7nN/p93P9rNmfJOLbhYaa4CxxWmZbI+92ZcEj4g
	UeIWuKBi79fQfbvnbtN/GNG1hD1h8sZNEnvu7Z9lKbzls+AWqW0SvB8fK7EUZyQaajEXFScC
	AGi4BmgIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t/tPl2my5NDDA42aVpc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIyu
	H8eZC+axVZz+Ope5gbGFrYuRk0NIQF1i0ZKTYLaEgInEpy2LWSBsMYkL99YDxbmAauYwSjxr
	fM8IkmARUJVY9nsGkM3BwSagJzHzczJIWFigVOLakc3MIPUiAp2MEhfWNLGCOMwCZ5kkbrf8
	YYHYpiSxZt8rMJtXQFDi5MwnUNtUJXYdPM4GEVeT2Hf4MjtEXFziwtxLUDavxIz2p1D1chLT
	vq5hhrClJc7P2sAIc/Xi74+h4vwSx27vYIKwBSSmnjkIVaMlsX/HTaiP+STWLHzLAlO/69Ry
	Zphd97fMheqVkNja8oQVxGYWUJSY0v2QHeR5ZgFNifW79NG9wivgLvGkfRrjBEbZWUhSs5B0
	z0LoRlaygJFlFaNoakFyQXFSeoWhXnFibnFpXrpecn7uJkZwGnq2cAfjl/PWhxgFOBiVeHgf
	Fk8OEWJNLCuuzD3EKMHBrCTC63gcKMSbklhZlVqUH19UmpNafIjRFBhpE5mlRJPzgSkyryTe
	0NjYxMzE1NLEwsDUXEmc9/+53BAhgfTEktTs1NSC1CKYPiYOTqkGRqWoLSu/9ixjfli4+UW5
	SQjjtG42BoNg1Zec0TM/6C37knE3kf8I+/LfKz4W/3w6e8qslEVpW+df9QmUSPvHWulQKrbW
	Jzm6sViqePNmwwitVRxTebLWsnszfFn39PDLfwcvT3rz9Oev9p1dy01uvXdY80eqInHOuTq7
	VXfX6xX57p4sYM/zuliJpTgj0VCLuag4EQCB8JAXWQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBJ7Q8H2020584

>   
>  It drops the way of using power_supply interface to reference battery's
> temperature. Then it tries to use thermal subsystem's only. This makes driver
> more simple and also can remove ifdeferies.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/power/Kconfig                 |    1 +
>  drivers/power/charger-manager.c       |  113 ++++++++-------------------------
>  include/linux/power/charger-manager.h |    3 +-
>  3 files changed, 28 insertions(+), 89 deletions(-)
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
