Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3LJDyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:54:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11174 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3LJDyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:54:47 -0500
X-AuditID: cbfee6a3-b7f186d0000073e2-ca-52a6908420b2
Date: Tue, 10 Dec 2013 03:54:44 +0000 (GMT)
From: Anurag Aggarwal <a.anurag@samsung.com>
Subject: Re: [PATCH V6] ARM : unwinder : Prevent data abort due to stack
 overflow
To: Dave Martin <Dave.Martin@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Naveen Kumar <naveen.sel@samsung.com>,
        Narendra Meher <narendra.m1@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ashish Kalra <ashish.kalra@samsung.com>, "cpgs ." <cpgs@samsung.com>,
        "anurag19aggarwal@gmail.com" <anurag19aggarwal@gmail.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        Rajat Suri <rajat.suri@samsung.com>,
        Poorva Srivastava <poorva.s@samsung.com>,
        Mohammad Irfan Ansari <mohammad.a2@samsung.com>
Reply-to: a.anurag@samsung.com
MIME-version: 1.0
X-MTR: 20131210034807821@a.anurag
Msgkey: 20131210034807821@a.anurag
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131210034807821@a.anurag
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: Y
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <16479184.50751386647682015.JavaMail.weblogic@epv6ml09>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/tGbotE5YFGTSf17K4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZV//0MBY8Y684/WA1UwPjCfYuRk4OIQFlid6969lAbAkBE4lF
	l3dA2WISF+6BxLmAauYzSkxoeMMIkmARUJXYNPErE4jNJqArMfHGFWYQW1ggUOLY/UNAQzk4
	RATUJY7uswTpZRY4xSrxaf1DJohlchJ3120Hq+cVEJQ4OfMJC0i9hICixOZNXBBhJYnO+RNZ
	IW6Qk1gy9TIThM0rMaP9KQtMfNrXNcwQtrTE+VkbGGFuXvz9MVScX+LY7R1MEON5JZ7cD4YZ
	s3vzF6gXBSSmnjkI1aomcfrFd6g4n8SahW9ZYMbsOrWcGaa3YeNvcLAxA108pfshlG0gcWTR
	HFZUX4HYzhLLfu1nmsAoNwtJahaS9llI2pHVLGBkWcUomlqQXFCclF5hrFecmFtcmpeul5yf
	u4kRHOXPFu9g/H/e+hCjAAejEg9vAcOyICHWxLLiytxDjBIczEoivJ51QCHelMTKqtSi/Pii
	0pzU4kOM0hwsSuK88beSgoQE0hNLUrNTUwtSi2CyTBycUg2MPHZXtZfNMXszOyB8ls26h59K
	TNa/Wdr7iVdWK6tBTFuq3tG0cuWDX6lFm3uvehtt8fzFWRx2NnV/e+nbaZdmvkwo4qusma75
	YWrJ1utKCyx/H0o3FpBm37XiauO0M1PtDoRE+v7Nm7ZV+06I351g02e6i9btM+lNe1Wx3Vv2
	Jdeaz3tW7N/mp8RSnJFoqMVcVJwIAOcEQsPuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBA3ssUb011039

>Reviewed-by: Dave Martin <Dave.Martin@arm.com>
>
>I can confirm that the kernel "doesn't crash" with this applied, and
>that backtracing at least partially works.  But this is not really
>sufficient to demontrate that the now code works better than the old
>code in corner cases (which is the point of the patch).
>
>Can you give details of what additional testing you have, or plan to
>do?

We saw a data abort in unwinder for one of Samsung Project, during a
Samsung Automation test case. 
After that I created the initial the patch, and the data abort has not been
seen till now.

Is it possible for you to give an idea on what other kind of additional testing 
do you have in mind.

Regads
Anurag

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
