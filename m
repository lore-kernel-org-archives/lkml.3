Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaGTX2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 19:28:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62385 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaGTX2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 19:28:23 -0400
X-AuditID: cbfee690-b7fb56d000003439-fa-53cc50931aec
Date: Sun, 20 Jul 2014 23:28:19 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
To: Punit Agrawal <punit.agrawal@arm.com>,
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
X-MTR: 20140720232604838@myungjoo.ham
Msgkey: 20140720232604838@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140720232604838@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <32148397.172891405898897186.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSrDs54EywwbeX0haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj7dYTTAWbWCsm/HrH2sA4h7WLkZNDSEBdYtGSk2wgtoSAicSx
	dddZIWwxiQv31gPFuYBqljJKnJy3mb2LkQOsaPNrU4j4HEaJvtdTmUDiLAKqElv7wkBMNgFz
	ifszgkDGCAt4ScxpmMkMUi4isJ5RYu+bGewgDrNAA5PE2kUP2SGOUJJYs+8VC4jNKyAocXLm
	ExaIXaoSky8LQYTVJPp/zWWCuE1CYtb0C1B38krMaH/KAmHLSUz7uoYZwpaWOD9rAyPML4u/
	P4aK80scu72DCWI8r8ST+8EwY3Zv/gINBgGJqWcOQrVqSax7f5cdwuaTWLPwLQvMmF2nljPD
	9N7fAnEas4CixJRuiK+YgXq//NjHhuorENtJomXDfvYJjMqzkKRmIWmfhaQdWc0CRpZVjKKp
	BckFxUnpRSZ6xYm5xaV56XrJ+bmbGIFJ4fS/ZxN2MN47YH2IMRkYIxOZpUST84FJJa8k3tDY
	zMjC1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGLsaz0/JnvH2
	ISffZumLL4v75/e9eSRdwnyEuWX21V0rXfz/OrYklivVqS68fiFr/YSp1eaK13wTDBek3Viy
	aemy6VFRTicX/hCy0Y5xr5s27e4H6+7Z3Dlu/xnO6N5M2Nvl/UCpb5+YZdfbql/aB+oKJ/f5
	HH6z6sJnzV0tuv/9HifnpgdN+KvEUpyRaKjFXFScCACS9K2hIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tXt3JAWeCDT7PELW4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRlv
	t55gKtjEWjHh1zvWBsY5rF2MnBxCAuoSi5acZOti5OCQEDCR2PzaFCQsISAmceHeeqAwF1DJ
	HEaJvtdTmUBqWARUJbb2hYGYbALmEvdnBIGUCwt4ScxpmMkMUi4isJ5RYu+bGewgDrNAA5PE
	2kUP2SF2KUms2feKBcTmFRCUODnzCQvEXlWJyZeFIMJqEv2/5jJB3CAhMWv6BVYIm1diRvtT
	FghbTmLa1zXMELa0xPlZGxhhbl78/TFUnF/i2O0dTBDjeSWe3A+GGbN78xc2CFtAYuqZg1Ct
	WhLr3t9lh7D5JNYsfMsCM2bXqeXMML33t0CcxiygKDGlG+IrZqDeLz/2saH6CsR2kmjZsJ99
	AqPcLCSpWUjaZyFpR1azgJFlFaNoakFyQXFSeoWxXnFibnFpXrpecn7uJkZwanq2eAfj//PW
	hxgFOBiVeHgXMJ8JFmJNLCuuzD3EKMHBrCTCO98KKMSbklhZlVqUH19UmpNafIgxGRh/E5ml
	RJPzgWkzryTe0NjYxMzE1NLEwsDUnDRhJXHe+FtJQUIC6YklqdmpqQWpRTBbmDg4pRoYdZ1u
	WKQsz9OftsHjdfiLF7LNb+4kyb3k3apQkZfwfrXekj2pmfyLBTXMp1+f5FfblLos8c1HbalO
	63W8AZ/9k99pPL4sMPNvUeO+ulMLN/x9x6uwfY7hTWcBybd12z6/XOfXlG2SUff2T9X1pfts
	X8VYROzNv+Fv6HP/WcL9g6xrQi49T94iocRSnJFoqMVcVJwIAEew08SRAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6KNShR2026397



Sender : Punit Agrawal<punit.agrawal@arm.com>
> From: ®™rjan Eide 
>
> These functions are indended for use by drivers and should be available
> also when the driver is built as a module.
>
> Cc: MyungJoo Ham 
> Cc: Kyungmin Park 
> Signed-off-by: ®™rjan Eide 

Dear Punit,


Just being curious, is there any reason not to use EXPORT_SYMBOL_GPL ?


Cheers,
MyungJoo.

--
MyungJoo Ham («‘∏Ì¡÷), PHD
Frontier CS Lab, Software Center
Samsung Electronics
Cell: +82-10-6714-2858ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
