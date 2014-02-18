Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaBRTT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:19:57 -0500
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:11123 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaBRTT4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:19:56 -0500
From: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH net-next 29/35] qlge: Get rid of an redundant assignment
Thread-Topic: [PATCH net-next 29/35] qlge: Get rid of an redundant assignment
Thread-Index: AQHPLJG+RoVMxuOd9UK6at5Ea/U5jZq7Y5+A
Date: Tue, 18 Feb 2014 19:19:49 +0000
Message-ID: <BECD8E8A1B550B48A1BF97C13991F60E46D21C6F@avmb2.qlogic.org>
References: <cover.1392717502.git.agordeev@redhat.com>
 <bffe424063b212553530f64b3282e260e2a37074.1392717503.git.agordeev@redhat.com>
In-Reply-To: <bffe424063b212553530f64b3282e260e2a37074.1392717503.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC580FF9B3149B419EAC0A774EE653D2@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7353 signatures=668936
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1402180127
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/18/14 2:11 AM, "Alexander Gordeev" <agordeev@redhat.com> wrote:

>Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
>Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
>Cc: Ron Mercer <ron.mercer@qlogic.com>
>Cc: linux-driver@qlogic.com
>Cc: netdev@vger.kernel.org
>Cc: linux-pci@vger.kernel.org
>---
> drivers/net/ethernet/qlogic/qlge/qlge_main.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)

Acked-by: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
>
>diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
>b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
>index ce2cfdd..82bace5 100644
>--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
>+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
>@@ -3346,7 +3346,6 @@ static void ql_enable_msix(struct ql_adapter *qdev)
> 			qdev->msi_x_entry = NULL;
> 			netif_warn(qdev, ifup, qdev->ndev,
> 				   "MSI-X Enable failed, trying MSI.\n");
>-			qdev->intr_count = 1;
> 			qlge_irq_type = MSI_IRQ;
> 		} else if (err == 0) {
> 			set_bit(QL_MSIX_ENABLED, &qdev->flags);
>-- 
>1.7.7.6
>

Thanks

-Jiten

