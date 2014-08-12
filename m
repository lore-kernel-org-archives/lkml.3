Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaHLXha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 19:37:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11985 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaHLXh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 19:37:28 -0400
X-AuditID: cbfee690-b7f526d000003627-70-53eaa536aa8c
Date: Tue, 12 Aug 2014 23:37:26 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: RE: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
To: "Hernandez, Carlos" <ceh@ti.com>, Punit Agrawal <punit.agrawal@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Cc: "orjan.eide@arm.com" <orjan.eide@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140812233359247@myungjoo.ham
Msgkey: 20140812233359247@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140812233359247@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2126088679.390471407886644188.JavaMail.weblogic@epmlwas02a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsWyRsSkUNds6atgg8s/rSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG8+cZTAVH+Cp+bZjE3sA4ga+LkZNDSEBdYtGSk2wgtoSAicT6
	WfeZIWwxiQv31gPFuYBqljJKLN7WxgpT1LNrORNEYg6jxLffi9hBEiwCqhJ97zYBdXBwsAmY
	S9yfEQQSFhbwk/i66Sw7SL2IwGVGiclv1oJNZRZoYJJYu+ghO8QZShJr9r1iAbF5BQQlTs58
	wgKxTVXiYMNadoi4msTZh4uZIOISErOmX4C6iFdiRvtTqHo5iWlf10C9IC1xftYGRph3Fn9/
	DBXnlzh2ewcTyKEgvU/uB8OM2b35CzQkBCSmnjkI1aolMf98O9QqPok1C9+ywIzZdWo5M0zv
	/S1zwU5jFlCUmNIN8RYzUO+XH/vY0L3FK+Ah8XbpdPYJjMqzkKRmIWmfhaQdWc0CRpZVjKKp
	BckFxUnpRSZ6xYm5xaV56XrJ+bmbGIGp4fS/ZxN2MN47YH2IMRkYJxOZpUST84GpJa8k3tDY
	zMjC1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGKdPrTfMzJta
	H/W3cvOCHVeOB7p/PxEX1jV13v1gq1b1t6LLA/g29rjyiH6vFDHsSD7Tc9Bo7bxok0tHll7T
	ODZDnyPfwPonc+PG78/rW/5MeeJsclenyYFf7PsN5udHth3JPMbGYTbhbnGHZNjiUpc2m88V
	/wVlFp+pTj9Ts33+Y91XG5tY3ZVYijMSDbWYi4oTAb+JMSojAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e92v67Z0lfBBpd+Gltc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIzm
	zzOYCo7wVfzaMIm9gXECXxcjJ4eQgLrEoiUn2UBsCQETiZ5dy5kgbDGJC/fWA8W5gGrmMEp8
	+72IHSTBIqAq0fduE1CCg4NNwFzi/owgkLCwgJ/E101n2UHqRQQuM0pMfrMWrJlZoIFJYu2i
	h+wQ25Qk1ux7xQJi8woISpyc+YQFYpuqxMGGtewQcTWJsw8XQ10hITFr+gVWCJtXYkb7U6h6
	OYlpX9cwQ9jSEudnbWCEuXrx98dQcX6JY7d3MIEcCtL75H4wzJjdm79APSwgMfXMQahWLYn5
	59uhVvFJrFn4lgVmzK5Ty5lheu9vmQt2GrOAosSUboi3mIF6v/zYx4buLV4BD4m3S6ezT2CU
	m4UkNQtJ+ywk7chqFjCyrGIUTS1ILihOSq8w0StOzC0uzUvXS87P3cQITlDPluxgbLhgfYhR
	gINRiYf3Av+rYCHWxLLiytxDjBIczEoivOVdQCHelMTKqtSi/Pii0pzU4kOMycAYnMgsJZqc
	D0yeeSXxhsbGJmYmppYmFgam5qQJK4nzLriVFCQkkJ5YkpqdmlqQWgSzhYmDU6qBsfjw9xLr
	LfN/Zrs+XlIhx9T0p8Ll8s6vBWka6zmW7/f5phFgr73g56TboUmNfJOXf02Yqlz4/uxvDwPf
	qR0XHOPntu4/rn558Ynf4Y4Hnto+fHX8x8qP67ebadZYNRhLzRJ/22u76IewbdfM1LC7B7uP
	qqX86WESevFydfZkf1aF3nuld/9Zn1FiKc5INNRiLipOBAA479jRlAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7CNbiIa016712



> ------- Original Message -------
> Sender : Hernandez, Carlos<ceh@ti.com>
> Date : 2014-08-12 22:49 (GMT+09:00)
> Title : RE: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
> 
> Acked-By: Carlos Hernandez 
> 
> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Punit Agrawal
> Sent: Friday, July 18, 2014 10:10 AM
> To: linux-pm@vger.kernel.org; linux-samsung-soc@vger.kernel.org
> Cc: orjan.eide@arm.com; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; MyungJoo Ham; Kyungmin Park
> Subject: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
> 
> From: ®™rjan Eide 
> 
> These functions are indended for use by drivers and should be available also when the driver is built as a module.> 
> 
> Cc: MyungJoo Ham 
> Cc: Kyungmin Park 
> Signed-off-by: ®™rjan Eide 

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

There will be some modifications to this patch for consistency with other pending patches, but please don't worry about them. I'll handle them while merging this.


Cheers,
MyungJoo.

> ---
> drivers/devfreq/devfreq.c |    3 +++
> 1 file changed, 3 insertions(+)



--
MyungJoo Ham («‘∏Ì¡÷), PHD
Frontier CS Lab, Software Center
Samsung Electronics
Cell: +82-10-6714-2858ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
