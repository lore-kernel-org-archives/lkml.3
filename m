Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaCYON2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 10:13:28 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:26710 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaCYON1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 10:13:27 -0400
X-IronPort-AV: E=Sophos;i="4.97,728,1389772800"; 
   d="scan'208";a="21167112"
Message-ID: <53318EEC.7050504@broadcom.com>
Date: Tue, 25 Mar 2014 15:13:00 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, <trivial@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <rdunlap@infradead.org>
Subject: Re: [PATCH] [trivial]treewide: Fix typo in printk
References: <1395754375-18482-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1395754375-18482-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/03/14 14:32, Masanari Iida wrote:
> Fix spelling typo in printk from various part of kernel source.
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>   arch/powerpc/platforms/powernv/opal.c                 | 2 +-
>   drivers/i2c/busses/i2c-s3c2410.c                      | 2 +-
>   drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c         | 8 ++++----
>   drivers/misc/mei/hw-txe.c                             | 2 +-
>   drivers/net/bonding/bond_sysfs_slave.c                | 2 +-
>   drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c    | 2 +-
>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c        | 2 +-
>   drivers/net/ethernet/via/via-velocity.c               | 2 +-
>   drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 6 +++---

For this file you may add:

Acked-by: Arend van Spriel <arend@broadcom.com>

>   drivers/scsi/qla2xxx/qla_nx2.c                        | 2 +-
>   drivers/scsi/scsi_transport_fc.c                      | 2 +-
>   sound/soc/davinci/davinci-mcasp.c                     | 2 +-
>   12 files changed, 17 insertions(+), 17 deletions(-)

