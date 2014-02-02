Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaBBJnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 04:43:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaBBJnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 04:43:39 -0500
Date: Sun, 2 Feb 2014 11:43:34 +0200
From: Amir Vadai <avadai@redhat.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: mlx4: Use pci_enable_msix_range()
Message-ID: <20140202094334.GE24400@mtl-eit-vdi-22.mtl.labs.mlnx>
References: <cover.1391172839.git.agordeev@redhat.com>
 <2f6674dabb90d4cbca3ef4039c3b893f2e5e9ec4.1391172839.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f6674dabb90d4cbca3ef4039c3b893f2e5e9ec4.1391172839.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/01/14 16:08 +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c |   19 ++++---------------
>  1 files changed, 4 insertions(+), 15 deletions(-)
> 

Acked By: Amir Vadai <amirv@mellanox.com>

