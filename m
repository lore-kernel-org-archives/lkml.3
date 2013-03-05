Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3CECCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:02:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27431 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab3CECCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:02:23 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-e2-5135522e3b3c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] misc: arm-charlcd: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 11:02:21 +0900
Message-id: <004b01ce1945$79486af0$6bd940d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ZRXktbgD8B1v7QgSgtGTX79fL8Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI129INNAgzNLeSz+TjrGbtG8eD2b
	xeWFl1gtLu+aw+bA4vH71yRGj/1z17B79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bWw64F
	r9grrvz5wtrAeI+ti5GTQ0LAROJly3IoW0ziwr31QDYXh5DAMkaJc0+mMMIUbfq1jgkiMZ1R
	ovXSZWYI5xejxL2rE8Da2QTUJL58OcwOYosIREi0tDYDdXNwMAu4SBydJgISFhbwkljdd5sF
	JMwioCrR2qAEEuYVsJV4c+MCO4QtKPFj8j0WEJtZQEti87YmVghbXmLzmrfMIK0SAuoSj/7q
	QizSk1jzfjI7RImIxL4X7xhBLpMQ2MYucfvQD7BeFgEBiW+TD7FA9MpKbDrADPGWpMTBFTdY
	JjCKzUKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCERNnEH4/0D
	1ocYk4HWT2SWEk3OB0ZoXkm8obGxiZmJqYm5pam5KWnCSuK88pdkAoUE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwXhDSmKSgIM58xPE773q5iIvcU//d/m6S2WS4tfV2UEHTWfXuQrm4So6S
	5mSh1wr2UWybFrl9tjgqZTjvysXjN6V6zpvtKeVxnZ6sIbZcOMqg4+3J7+1XGUJjN8XnMSze
	qdXB5KJtsm0za4eZam3urwk/fZXSr108JFd9eNeHdRP22s+VZ/urxFKckWioxVxUnAgAU7jq
	OsYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQV29INNAgwcTOSz+TjrGbtG8eD2b
	xeWFl1gtLu+aw+bA4vH71yRGj/1z17B79G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG1sOuBa/YK678+cLawHiPrYuRk0NCwERi0691TBC2mMSFe+uB
	4lwcQgLTGSVaL11mhnB+MUrcuzoBrINNQE3iy5fD7CC2iECEREtrM2MXIwcHs4CLxNFpIiBh
	YQEvidV9t1lAwiwCqhKtDUogYV4BW4k3Ny6wQ9iCEj8m32MBsZkFtCQ2b2tihbDlJTavecsM
	0iohoC7x6K8uxCI9iTXvJ7NDlIhI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIjt9n0jsYVzVYHGIU4GBU4uFlOGoSKMSaWFZcmXuIUYKDWUmE
	9z6vaaAQb0piZVVqUX58UWlOavEhxmSgPycyS4km5wNTS15JvKGxiZmRpZGZhZGJuTlpwkri
	vIynngQICaQnlqRmp6YWpBbBbGHi4JRqYKx2DdocsM7ulLHzxz8J331aUjStZ7edDLn7uVFd
	+sSnOUbJ3zgmfulQnPZl+a5mjzWZq1jldP6GVHeGup/YsnZbzZW36bqKPwt5/8UubVicpBny
	cVWZjoDo8sDu3yv0axclf9nQs2u3ydLegzt7bn/LiXTe19Yse3X/ZCUhy3Pr6j+ke71dME2J
	pTgj0VCLuag4EQDqBoUEIwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/arm-charlcd.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/arm-charlcd.c b/drivers/misc/arm-charlcd.c
index fe8616a..48651ef 100644
--- a/drivers/misc/arm-charlcd.c
+++ b/drivers/misc/arm-charlcd.c
@@ -378,18 +378,7 @@ static struct platform_driver charlcd_driver = {
 	.remove = __exit_p(charlcd_remove),
 };
 
-static int __init charlcd_init(void)
-{
-	return platform_driver_probe(&charlcd_driver, charlcd_probe);
-}
-
-static void __exit charlcd_exit(void)
-{
-	platform_driver_unregister(&charlcd_driver);
-}
-
-module_init(charlcd_init);
-module_exit(charlcd_exit);
+module_platform_driver_probe(charlcd_driver, charlcd_probe);
 
 MODULE_AUTHOR("Linus Walleij <triad@df.lth.se>");
 MODULE_DESCRIPTION("ARM Character LCD Driver");
-- 
1.7.2.5


