Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaH2R0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:26:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaH2R0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:26:12 -0400
Message-ID: <5400B7AE.5000600@infradead.org>
Date: Fri, 29 Aug 2014 10:26:06 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/v2] [trivial] treewide: Fix typo in printk
References: <53FF8D08.5050900@infradead.org> <1409323053-6582-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1409323053-6582-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/14 07:37, Masanari Iida wrote:
> This patch fix spelling typo in printk.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  arch/m68k/Kconfig.devices                   | 2 +-
>  arch/mips/lantiq/falcon/sysctrl.c           | 2 +-
>  arch/mips/lantiq/xway/sysctrl.c             | 2 +-
>  arch/mips/pci/pci-lantiq.c                  | 2 +-
>  arch/powerpc/kvm/e500_mmu_host.c            | 2 +-
>  arch/powerpc/platforms/powernv/opal.c       | 2 +-
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx4/cmd.c    | 4 ++--
>  drivers/net/ethernet/via/via-velocity.c     | 2 +-
>  drivers/net/wireless/libertas/cfg.c         | 2 +-
>  drivers/scsi/fnic/fnic_debugfs.c            | 2 +-
>  drivers/scsi/fnic/fnic_trace.c              | 2 +-
>  drivers/video/backlight/88pm860x_bl.c       | 2 +-
>  net/netfilter/ipset/ip_set_core.c           | 2 +-
>  scripts/sign-file                           | 2 +-
>  16 files changed, 17 insertions(+), 17 deletions(-)


-- 
~Randy
