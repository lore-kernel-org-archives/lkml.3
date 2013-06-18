Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3FRJhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:37:36 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4074 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab3FRJhe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:37:34 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Yuval Mintz" <yuvalmin@broadcom.com>
To: "Yijing Wang" <wangyijing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hanjun Guo" <guohanjun@huawei.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "Eilon Greenstein" <eilong@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/9] Bnx2x: remove redundant D0 power state set
Thread-Topic: [PATCH 1/9] Bnx2x: remove redundant D0 power state set
Thread-Index: AQHOa/rf18YMG1nGeUa0RHvOdk2sipk7NmNA
Date: Tue, 18 Jun 2013 09:37:27 +0000
Message-ID: <979A8436335E3744ADCD3A9F2A2B68A52AC8828E@SJEXCHMB10.corp.ad.broadcom.com>
References: <1371542739-13552-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1371542739-13552-1-git-send-email-wangyijing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7DDEF6F131W38431114-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pci_enable_device() will set device power state to D0,
> so it's no need to do it again in bnx2x_init_dev().
> Also remove redundant PM Cap find code, because pci core
> has been saved the pci device pm cap value.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Eilon Greenstein <eilong@broadcom.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
[...]

Acked-by: Yuval Mintz <yuvalmin@broadcom.com>

Thanks,
Yuval

