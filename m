Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031134Ab3HIUvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:51:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51558 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031087Ab3HIUvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:51:02 -0400
Date: Fri, 09 Aug 2013 13:51:01 -0700 (PDT)
Message-Id: <20130809.135101.2061941695616790943.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: guohanjun@huawei.com, jiang.liu@huawei.com, nsujir@broadcom.com,
        mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/16] tg3: clean up unnecessary MSI/MSI-X capability
 find
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375966992-33236-1-git-send-email-wangyijing@huawei.com>
References: <1375966992-33236-1-git-send-email-wangyijing@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 09 Aug 2013 13:51:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>
Date: Thu, 8 Aug 2013 21:03:12 +0800

> PCI core will initialize device MSI/MSI-X capability in
> pci_msi_init_pci_dev(). So device driver should use
> pci_dev->msi_cap/msix_cap to determine whether the device
> support MSI/MSI-X instead of using
> pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
> Access to PCIe device config space again will consume more time.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Applied.
