Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab3IDVKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 17:10:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:56845 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760572Ab3IDVKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 17:10:19 -0400
Subject: Re: [PATCH 3/7] powerpc/pci: use pci_is_pcie() to simplify code
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1378193715-25328-3-git-send-email-wangyijing@huawei.com>
Date: Wed, 4 Sep 2013 16:07:15 -0500
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Paul Mackerras <paulus@samba.org>,
        <linuxppc-dev@lists.ozlabs.org>
Content-Transfer-Encoding: 7bit
Message-Id: <F405FCAB-60A8-4341-AEA5-A9E20CDCB85C@kernel.crashing.org>
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com> <1378193715-25328-3-git-send-email-wangyijing@huawei.com>
To: Yijing Wang <wangyijing@huawei.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 3, 2013, at 2:35 AM, Yijing Wang wrote:

> Use pci_is_pcie() to simplify code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
> arch/powerpc/kernel/eeh.c     |    3 +--
> arch/powerpc/sysdev/fsl_pci.c |    2 +-
> 2 files changed, 2 insertions(+), 3 deletions(-)

Acked-by: Kumar Gala <galak@kernel.crashing.org>

(for the fsl_pci.c) change

- k
 
