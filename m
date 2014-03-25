Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaCYRFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:05:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34096 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaCYRFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:05:03 -0400
Message-ID: <5331B73B.8080104@infradead.org>
Date: Tue, 25 Mar 2014 10:04:59 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial]treewide: Fix typo in printk
References: <1395754375-18482-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1395754375-18482-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 06:32 AM, Masanari Iida wrote:
> Fix spelling typo in printk from various part of kernel source.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  arch/powerpc/platforms/powernv/opal.c                 | 2 +-
>  drivers/i2c/busses/i2c-s3c2410.c                      | 2 +-
>  drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c         | 8 ++++----
>  drivers/misc/mei/hw-txe.c                             | 2 +-
>  drivers/net/bonding/bond_sysfs_slave.c                | 2 +-
>  drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c    | 2 +-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c        | 2 +-
>  drivers/net/ethernet/via/via-velocity.c               | 2 +-
>  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 6 +++---
>  drivers/scsi/qla2xxx/qla_nx2.c                        | 2 +-
>  drivers/scsi/scsi_transport_fc.c                      | 2 +-
>  sound/soc/davinci/davinci-mcasp.c                     | 2 +-
>  12 files changed, 17 insertions(+), 17 deletions(-)

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
> index ad61d26..0a85eb6 100644
> --- a/drivers/net/ethernet/via/via-velocity.c
> +++ b/drivers/net/ethernet/via/via-velocity.c
> @@ -2056,7 +2056,7 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
>  	struct sk_buff *skb;
>  
>  	if (rd->rdesc0.RSR & (RSR_STP | RSR_EDP)) {
> -		VELOCITY_PRT(MSG_LEVEL_VERBOSE, KERN_ERR " %s : the received frame span multple RDs.\n", vptr->netdev->name);
> +		VELOCITY_PRT(MSG_LEVEL_VERBOSE, KERN_ERR " %s : the received frame span multiple RDs.\n", vptr->netdev->name);

I would say "spans" here.

>  		stats->rx_length_errors++;
>  		return -EINVAL;
>  	}


Thanks.

-- 
~Randy
