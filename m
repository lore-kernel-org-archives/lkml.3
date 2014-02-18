Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaBRUem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:34:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35567 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaBRUek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:34:40 -0500
Date: Tue, 18 Feb 2014 15:34:34 -0500 (EST)
Message-Id: <20140218.153434.1953797715072458396.davem@davemloft.net>
To: agordeev@redhat.com
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-driver@qlogic.com, linux-net-drivers@solarflare.com,
        linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, pv-drivers@vmware.com,
        wil6210@qca.qualcomm.com
Subject: Re: [PATCH net-next 00/35] net: Use pci_enable_msix_range()
 instead of pci_enable_msix()
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1392717502.git.agordeev@redhat.com>
References: <cover.1392717502.git.agordeev@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2014 12:34:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Gordeev <agordeev@redhat.com>
Date: Tue, 18 Feb 2014 11:07:52 +0100

> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
> 
> Cc: e1000-devel@lists.sourceforge.net
> Cc: linux-driver@qlogic.com
> Cc: linux-net-drivers@solarflare.com
> Cc: linux-pci@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: pv-drivers@vmware.com
> Cc: wil6210@qca.qualcomm.com

Series applied, thanks.
