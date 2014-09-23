Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaIWUWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:22:37 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:32794 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaIWUWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:22:36 -0400
Date: Tue, 23 Sep 2014 16:22:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 3/6] AHCI: Make few function names more
 descriptive
Message-ID: <20140923202231.GE14111@mtj.dyndns.org>
References: <cover.1411297686.git.agordeev@redhat.com>
 <fe20e3ee0fb7b3f68de0015dac11021c68823cf6.1411297686.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe20e3ee0fb7b3f68de0015dac11021c68823cf6.1411297686.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 03:19:26PM +0200, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: linux-ide@vger.kernel.org
> ---
>  drivers/ata/ahci.c    |  7 +++----
>  drivers/ata/ahci.h    |  6 +++---
>  drivers/ata/libahci.c | 16 ++++++++--------
>  3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 7ce8e01..4a849f8 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
...
> @@ -1305,9 +1305,8 @@ int ahci_host_activate(struct ata_host *host, int irq,
>  	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
>  		rc = ahci_host_activate_multi_irqs(host, irq, sht);
>  	else
> -		rc = ata_host_activate(host, irq, ahci_interrupt,
> +		rc = ata_host_activate(host, irq, ahci_single_irq_intr,
>  				       IRQF_SHARED, sht);
> -	return rc;

Hmmm... why is return removed here?

Thanks.

-- 
tejun
