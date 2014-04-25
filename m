Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaDYQtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:49:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44803 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaDYQtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:49:08 -0400
Date: Fri, 25 Apr 2014 12:49:03 -0400 (EDT)
Message-Id: <20140425.124903.145066741692796378.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: bhelgaas@google.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com,
        linux-ia64@vger.kernel.org, sparclinux@vger.kernel.org,
        tglx@linutronix.de, x86@kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 07/13] sparc/PCI: Use new pci_is_bridge() to simplify
 code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398417515-8740-8-git-send-email-wangyijing@huawei.com>
References: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
	<1398417515-8740-8-git-send-email-wangyijing@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Apr 2014 09:49:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>
Date: Fri, 25 Apr 2014 17:18:29 +0800

> Now we can use new pci_is_bridge() helper function
> to simplify code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Acked-by: David S. Miller <davem@davemloft.net>
