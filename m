Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3FTFYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:24:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49479 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3FTFYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:24:17 -0400
Date: Wed, 19 Jun 2013 22:24:16 -0700 (PDT)
Message-Id: <20130619.222416.737701720649805813.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: linux-kernel@vger.kernel.org, guohanjun@huawei.com, jiang.liu@huawei.com,
        kaber@trash.net, wfp5p@virginia.edu, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/9] amd8111e: use pdev->pm_cap instead of
 pci_find_capability(..,PCI_CAP_ID_PM)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371542797-14964-1-git-send-email-wangyijing@huawei.com>
References: <1371542797-14964-1-git-send-email-wangyijing@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>
Date: Tue, 18 Jun 2013 16:06:37 +0800

> Pci core has been saved pm cap register offset by pdev->pm_cap in pci_pm_init()
> in init path. So we can use pdev->pm_cap instead of using
> pci_find_capability(pdev, PCI_CAP_ID_PM) for better performance and simplified code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Applied.
