Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaD0Xab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 19:30:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35253 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaD0Xa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 19:30:29 -0400
Date: Sun, 27 Apr 2014 19:30:27 -0400 (EDT)
Message-Id: <20140427.193027.1833767089712636627.davem@davemloft.net>
To: agordeev@redhat.com
Cc: linux-kernel@vger.kernel.org, mitch.a.williams@intel.com,
        jesse.brandeburg@intel.com, linux.nics@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH net-next 1/2] i40evf: Use pci_enable_msix_range()
 instead of pci_enable_msix()
From: David Miller <davem@davemloft.net>
In-Reply-To: <110dd7806f49f62272bd960ae8101c9da81a3f01.1398412015.git.agordeev@redhat.com>
References: <cover.1398412015.git.agordeev@redhat.com>
	<110dd7806f49f62272bd960ae8101c9da81a3f01.1398412015.git.agordeev@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 27 Apr 2014 16:30:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Gordeev <agordeev@redhat.com>
Date: Fri, 25 Apr 2014 10:06:24 +0200

> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Jeff, I assume you will take this in via your tree.

Thanks.
