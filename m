Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaDYEIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 00:08:06 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:61890 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbaDYEID convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 00:08:03 -0400
From: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
To: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>
CC: Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/5] qlge: Convert /n to \n
Thread-Topic: [PATCH 1/5] qlge: Convert /n to \n
Thread-Index: AQHPYCjZvPmg7ORvN0GQuceZyxn4OZsht40A
Date: Fri, 25 Apr 2014 04:07:58 +0000
Message-ID: <BECD8E8A1B550B48A1BF97C13991F60E46D4E975@avmb2.qlogic.org>
References: <cover.1398390579.git.joe@perches.com>
 <0cfcf37f20b78a2bc3cde9f56aa27ca53a802184.1398390579.git.joe@perches.com>
In-Reply-To: <0cfcf37f20b78a2bc3cde9f56aa27ca53a802184.1398390579.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.8.4.145]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F00F37E7108B224E89CD25BD7B9B7A9C@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7418 signatures=670421
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1404250069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/14 6:50 PM, "Joe Perches" <joe@perches.com> wrote:

>Use a newline character appropriately.
>
>Signed-off-by: Joe Perches <joe@perches.com>
>---
> drivers/net/ethernet/qlogic/qlge/qlge_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
>b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
>index 0a1d76a..6e36fe1 100644
>--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
>+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
>@@ -3595,7 +3595,7 @@ static int ql_request_irq(struct ql_adapter *qdev)
> 	}
> 	return status;
> err_irq:
>-	netif_err(qdev, ifup, qdev->ndev, "Failed to get the interrupts!!!/n");
>+	netif_err(qdev, ifup, qdev->ndev, "Failed to get the interrupts!!!\n");
> 	ql_free_irq(qdev);
> 	return status;
> }
>-- 
>1.8.1.2.459.gbcd45b4.dirty
Acked-by: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>

