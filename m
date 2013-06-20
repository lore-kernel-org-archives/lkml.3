Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3FTFYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:24:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49475 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3FTFYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:24:12 -0400
Date: Wed, 19 Jun 2013 22:24:11 -0700 (PDT)
Message-Id: <20130619.222411.875430840716764954.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: linux-kernel@vger.kernel.org, guohanjun@huawei.com, jiang.liu@huawei.com,
        eilong@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/9] Bnx2x: remove redundant D0 power state set
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371542739-13552-1-git-send-email-wangyijing@huawei.com>
References: <1371542739-13552-1-git-send-email-wangyijing@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>
Date: Tue, 18 Jun 2013 16:05:39 +0800

> Pci_enable_device() will set device power state to D0,
> so it's no need to do it again in bnx2x_init_dev().
> Also remove redundant PM Cap find code, because pci core
> has been saved the pci device pm cap value.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Applied.
