Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3FTFX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:23:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49444 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3FTFX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:23:26 -0400
Date: Wed, 19 Jun 2013 22:23:25 -0700 (PDT)
Message-Id: <20130619.222325.11404776754498711.davem@davemloft.net>
To: yuvalmin@broadcom.com
Cc: wangyijing@huawei.com, linux-kernel@vger.kernel.org, guohanjun@huawei.com,
        jiang.liu@huawei.com, eilong@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/9] Bnx2x: remove redundant D0 power state set
From: David Miller <davem@davemloft.net>
In-Reply-To: <979A8436335E3744ADCD3A9F2A2B68A52AC8828E@SJEXCHMB10.corp.ad.broadcom.com>
References: <1371542739-13552-1-git-send-email-wangyijing@huawei.com>
	<979A8436335E3744ADCD3A9F2A2B68A52AC8828E@SJEXCHMB10.corp.ad.broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yuval Mintz" <yuvalmin@broadcom.com>
Date: Tue, 18 Jun 2013 09:37:27 +0000

>> Pci_enable_device() will set device power state to D0,
>> so it's no need to do it again in bnx2x_init_dev().
>> Also remove redundant PM Cap find code, because pci core
>> has been saved the pci device pm cap value.
>> 
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Cc: Eilon Greenstein <eilong@broadcom.com>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
> [...]
> 
> Acked-by: Yuval Mintz <yuvalmin@broadcom.com>

Applied.
