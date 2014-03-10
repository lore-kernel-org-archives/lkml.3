Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaCJJ4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:56:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42568 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCJJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:56:34 -0400
X-AuditID: cbfee68e-b7f566d000002344-64-531d8c50ec0c
Date: Mon, 10 Mar 2014 09:56:32 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/3] regulator: max8997: Remove unnecessary **rdev from
 struct max8997_data
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140310095546594@myungjoo.ham
Msgkey: 20140310095546594@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140310095546594@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <21822707.449031394445390758.JavaMail.weblogic@epv6ml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSpBvQIxtscPSulcXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mo4eWEFY8EW5oof93YxNzAuYe5i5OQQElCXWLTkJBuILSFgItGx
	uZUJwhaTuHBvPRtEzVJGiaWtBjA1/Xd/A9VwAcXnM0os/zqJBSTBIqAq8efcc6AEBwebgJ7E
	zM/JIGFhgXiJA89Wg5WICHhKNBw/wQjSyyxwiVHi44YfUAuUJNbsewVWxCsgKHFy5hMWiGWq
	Eke/LWCHiKtJ9F39xg4Rl5CYNf0CK4TNKzGj/SlUvZzEtK9rmCFsaYnzszYwwjyz+PtjqDi/
	xLHbO8DuBOl9cj8YZszuzV+g4SAgMfXMQahWLYl3hxdBreKTWLPwLQvMmF2nljPD9N7fMhcc
	bswCihJTuh+yQ9haEl9+7GND9xavgIvE2/bb7BMYlWchSc1C0j4LSTuymgWMLKsYRVMLkguK
	k9KLjPSKE3OLS/PS9ZLzczcxAtPC6X/P+nYw3jxgfYgxGRglE5mlRJPzgWklryTe0NjMyMLU
	xNTYyNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwhvmXJu2oTzsZvL1P
	WfHFTKPt1aXzd39KX35h/qtUn50MRZmSgv8sTpRxlVoYsjatX7Zz+75zq8UD9nFqZElpfD73
	/UfxqapXDl0RutujtHgDEs7al/NsbTscOb1vLUushdycS1aVRRw3fkY7LCk1/3pmm/nnzRuq
	BNq/mJw+HSfq/nhF6oH5SizFGYmGWsxFxYkASEIFpyEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2dN2AHtlgg9O3TSwu75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsbJ
	CysYC7YwV/y4t4u5gXEJcxcjJ4eQgLrEoiUn2UBsCQETif67v5kgbDGJC/fWA8W5gGrmM0os
	/zqJBSTBIqAq8efcc6AiDg42AT2JmZ+TQcLCAvESB56tBisREfCUaDh+ghGkl1ngEqPExw0/
	2CCWKUms2fcKrIhXQFDi5MwnLBDLVCWOflvADhFXk+i7+o0dIi4hMWv6BVYIm1diRvtTqHo5
	iWlf1zBD2NIS52dtYIQ5evH3x1Bxfoljt3eA3QnS++R+MMyY3Zu/QP0rIDH1zEGoVi2Jd4cX
	Qa3ik1iz8C0LzJhdp5Yzw/Te3zIXHD7MAooSU7ofskPYWhJffuxjQ/cWr4CLxNv22+wTGOVm
	IUnNQtI+C0k7spoFjCyrGEVTC5ILipPSKwz1ihNzi0vz0vWS83M3MYLT07OFOxi/nLc+xCjA
	wajEw7swXTZYiDWxrLgy9xCjBAezkgjvw1agEG9KYmVValF+fFFpTmrxIcZkYAROZJYSTc4H
	ps68knhDY2MTMxNTSxMLA1Nz0oSVxHnv3kwKEhJITyxJzU5NLUgtgtnCxMEp1cDIsvKaeGPT
	hXeM+190SYhHXWfZvnrNJp126+1+kT49Zs737r7+KlyS1J2TsEzr3s27hny/lh7JlWGXuW/c
	23qyVm22SYux4cXq+Fc+xxtEtrusT8mwaX2sfencLsbPjC9dvfL1hN5eWjRHqC029Je5Z5qr
	oEu3gtseh0L7eNMlX1unO235sEOJpTgj0VCLuag4EQB/tID0kwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2A9uhj8015767

> Now we are using devm_regulator_register(), so we don't need to allocate *rdev[]
> array to store return value of devm_regulator_register. Use a *rdev variable is
> enough for checking return status.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
