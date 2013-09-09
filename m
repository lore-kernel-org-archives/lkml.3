Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3IIFPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:15:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39315 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3IIFPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:15:53 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-39-522d59889dca
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] misc: ibmasm: Remove casting the return value which is a void
 pointer
Date: Mon, 09 Sep 2013 14:15:52 +0900
Message-id: <004201cead1b$a76a8020$f63f8060$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6tG6Oe980RD64NSAuhyIxNqwLhbg==
Content-language: ko
x-cr-hashedpuzzle: CNBL ChZ2 GYxT J5aI K6W1 QiLw VIys VYq7 Zd/b aFbZ bA9w c2l9
 dCTy e3nO ouVm
 qhpZ;4;YQByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGcAcgBlAGcAawBoAEAAbABpAG4AdQB4AGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{C0657ED2-4D58-4FFB-A95D-BF786C386A66};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 09 Sep 2013 05:15:46
 GMT;WwBQAEEAVABDAEgAXQAgAG0AaQBzAGMAOgAgAGkAYgBtAGEAcwBtADoAIABSAGUAbQBvAHYAZQAgAGMAYQBzAHQAaQBuAGcAIAB0AGgAZQAgAHIAZQB0AHUAcgBuACAAdgBhAGwAdQBlACAAdwBoAGkAYwBoACAAaQBzACAAYQAgAHYAbwBpAGQAIABwAG8AaQBuAHQAZQByAA==
x-cr-puzzleid: {C0657ED2-4D58-4FFB-A95D-BF786C386A66}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zY92OSN0gg+VLNCz+TjrGbtG8eD2b
	xeWFl1gtLu+aw+bA4vH71yRGj/1z17B79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bPU6/Z
	C7awVXxfMY21gXEjaxcjJ4eEgInEyY1f2SFsMYkL99azdTFycQgJLGOUOPLpKxtM0eT3PewQ
	iUWMEnc274NyfjFKTH03lxGkik1ATeLLl8Ngo0QETCU2vp8CFmcWSJX4O/cj2DphgQiJBz3/
	wGwWAVWJlTv2gdXzCthKLO7dDWULSvyYfI8FoldLYv3O40wQtrzE5jVvmbsYOYAuUpd49FcX
	YpWexKWp56DKRST2vXjHCHKbhMAWVomP868zQtSbSqx6XgLxzCl2iRudORAnCEh8m3yIBaJE
	VmLTAWaIEkmJgytusExglJiF5KBZSA6aheSgWUg2L2BkWcUomlqQXFCclF5kqFecmFtcmpeu
	l5yfu4kREpW9OxhvH7A+xJgMtH4is5Rocj4wqvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4U
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwHjP2a5R+q7YuVnaN0SWS7+27LrPrnHrefHks7Kz
	s/S9Xp3ecmpysI/Hx9BV37pYztm2fl+W9lhw/pSYaSfM1C9JaC7f/dUtc8sXV+OKn5YsEQfn
	BU6ekeW4lsdplsTFTwe/TcnWPNH54NyTHdF6ogtOTFm53+DAR4cfP7IsVn45Nv3InT6vlMd7
	lFiKMxINtZiLihMB1H49iOACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd2OSN0gg5c3VCz+TjrGbtG8eD2b
	xeWFl1gtLu+aw+bA4vH71yRGj/1z17B79G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGz1Ov2Qu2sFV8XzGNtYFxI2sXIyeHhICJxOT3PewQtpjEhXvr
	2boYuTiEBBYxStzZvI8dwvnFKDH13VxGkCo2ATWJL18Og3WICJhKbHw/BSzOLJAq8XfuR7Cp
	wgIREg96/oHZLAKqEit37AOr5xWwlVjcuxvKFpT4MfkeC0SvlsT6nceZIGx5ic1r3jJ3MXIA
	XaQu8eivLsQqPYlLU89BlYtI7HvxjhHkNgmBLawSH+dfZ4SoN5VY9bxkAqPQLCQbZiHZMAvJ
	hllIRi1gZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERz1z6R3MK5qsDjEKMDBqMTDe0NQ
	N0iINbGsuDL3EKMEB7OSCO/55zpBQrwpiZVVqUX58UWlOanFhxiTgQEwkVlKNDkfmJDySuIN
	jU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoHRxW5fWdThKq5Wl60q
	C92LSi48POl0oZn34pU9Wer81WvjNnbGCOzzE6rWPjV/w8dorQOWmgkts4//NQpSPfrfo+jA
	5BOZLB+OB6cesv+0lt3wydOXr7VS8i/vVm+1DXBUPlIi4tizomNK88EoV/2mT0kbHczXqRkf
	fXRPvk66PFVwt2P2uXlKLMUZiYZazEXFiQAag7fmPgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/ibmasm/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/ibmasm/module.c b/drivers/misc/ibmasm/module.c
index 0346d87..0c290e4 100644
--- a/drivers/misc/ibmasm/module.c
+++ b/drivers/misc/ibmasm/module.c
@@ -165,7 +165,7 @@ error_resources:
 
 static void ibmasm_remove_one(struct pci_dev *pdev)
 {
-	struct service_processor *sp = (struct service_processor *)pci_get_drvdata(pdev);
+	struct service_processor *sp = pci_get_drvdata(pdev);
 
 	dbg("Unregistering UART\n");
 	ibmasm_unregister_uart(sp);
-- 
1.7.10.4


