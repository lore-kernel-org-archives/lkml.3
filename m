Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3IIPQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:16:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3IIPQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:16:19 -0400
Date: Mon, 9 Sep 2013 08:19:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>,
        David Airlie <airlied@linux.ie>,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 5/6] staging/et131x: Use cached pci_dev->pcie_mpss and
 pcie_set_readrq() to simplif code
Message-ID: <20130909151924.GA26295@kroah.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-6-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378732388-4508-6-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:13:07PM +0800, Yijing Wang wrote:
> The PCI core caches the "PCI-E Max Payload Size Supported" in
> pci_dev->pcie_mpss, so use that instead of pcie_capability_read_dword().
> Also use pcie_set_readrq() instead of pcie_capability_clear_and_set_word()
> to simplify code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
