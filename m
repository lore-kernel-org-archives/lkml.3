Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbaGASMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:12:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaGASMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:12:36 -0400
Message-ID: <53B2FA13.2070000@infradead.org>
Date: Tue, 01 Jul 2014 11:12:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] treewide: Fix typo in printk
References: <1404229455-7248-1-git-send-email-standby24x7@gmail.com> <1404229455-7248-2-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1404229455-7248-2-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 08:44, Masanari Iida wrote:
> This patch fix spelling typo in printk within vairous
> part of the code.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  arch/blackfin/mach-common/ints-priority.c          | 2 +-
>  drivers/gpu/drm/i915/intel_bios.c                  | 2 +-
>  drivers/i2c/busses/i2c-s3c2410.c                   | 2 +-
>  drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      | 2 +-
>  drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c   | 2 +-
>  drivers/net/bonding/bond_sysfs_slave.c             | 2 +-
>  drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c | 2 +-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c     | 2 +-
>  drivers/net/wireless/libertas_tf/main.c            | 2 +-
>  drivers/scsi/aic7xxx/Kconfig.aic79xx               | 2 +-
>  drivers/scsi/nsp32.c                               | 2 +-
>  drivers/scsi/pcmcia/nsp_cs.c                       | 2 +-
>  drivers/scsi/qla2xxx/qla_nx2.c                     | 2 +-
>  drivers/scsi/scsi_transport_fc.c                   | 2 +-
>  net/mac802154/wpan.c                               | 2 +-
>  15 files changed, 15 insertions(+), 15 deletions(-)

-- 
~Randy
