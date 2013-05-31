Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3EaNt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 09:49:29 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:47239
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab3EaNtV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 09:49:21 -0400
X-Forefront-Antispam-Report: CIP:198.70.193.116;KIP:(null);UIP:(null);IPV:NLI;H:avcashub1.qlogic.com;RD:avcashub2.qlogic.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz9371I103dK542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2ei2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
From: Rajesh Borundia <rajesh.borundia@qlogic.com>
To: Yijing Wang <wangyijing@huawei.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: RE: [PATCH 6/7] qlcnic: remove redundant D0 power state set
Thread-Topic: [PATCH 6/7] qlcnic: remove redundant D0 power state set
Thread-Index: AQHOXSAoejYWNd6vokO6VFP7gIGZX5kfUECw
Date: Fri, 31 May 2013 13:48:27 +0000
Message-ID: <C562D0E12CBDE44E8A0CCAB7706009673539F21B@AVMB1.qlogic.org>
References: <1369909569-33096-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1369909569-33096-1-git-send-email-wangyijing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Yijing Wang [mailto:wangyijing@huawei.com]
>Sent: Thursday, May 30, 2013 3:56 PM
>To: Rajesh Borundia; Shahed Shaikh; Jitendra Kalsaria; Sony Chacko
>Cc: linux-kernel; Dept-Eng Linux Driver; netdev; Hanjun Guo; Jiang Liu;
>Yijing Wang
>Subject: [PATCH 6/7] qlcnic: remove redundant D0 power state set
>
>Pci_enable_device() will set device power state to D0,
>so it's no need to do it again in qlcnic_attach_func().
>
>Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>---
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>index aeb26a8..3585c2c 100644
>--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>@@ -3219,7 +3219,6 @@ static int qlcnic_attach_func(struct pci_dev
>*pdev)
> 	if (err)
> 		return err;
>
>-	pci_set_power_state(pdev, PCI_D0);
> 	pci_set_master(pdev);
> 	pci_restore_state(pdev);
>
>--
>1.7.1
>
>

Acked-by: Rajesh Borundia <rajesh.borundia@qlogic.com>

Thanks!

