Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaH1ULy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:11:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaH1ULx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:11:53 -0400
Message-ID: <53FF8D08.5050900@infradead.org>
Date: Thu, 28 Aug 2014 13:11:52 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] treewide: Fix typo in printk
References: <1409246765-28327-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1409246765-28327-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/14 10:26, Masanari Iida wrote:
> This patch fix spelling typo in printk.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
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

> diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
> index 08f14bb..c33cc7d 100644
> --- a/arch/powerpc/kvm/e500_mmu_host.c
> +++ b/arch/powerpc/kvm/e500_mmu_host.c
> @@ -663,7 +663,7 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu, enum instruction_type type,
>  	if (unlikely((pr && !(mas3 & MAS3_UX)) ||
>  		     (!pr && !(mas3 & MAS3_SX)))) {
>  		pr_err_ratelimited(
> -			"%s: Instuction emulation from guest addres %08lx without execute permission\n",
> +			"%s: Instuction emulation from guest address %08lx without execute permission\n",

			     Instruction

>  			__func__, geaddr);
>  		return EMULATE_AGAIN;
>  	}
> diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
> index f5fbc12..24ef4ca 100644
> --- a/drivers/net/ethernet/via/via-velocity.c
> +++ b/drivers/net/ethernet/via/via-velocity.c
> @@ -2056,7 +2056,7 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
>  	struct sk_buff *skb;
>  
>  	if (rd->rdesc0.RSR & (RSR_STP | RSR_EDP)) {
> -		VELOCITY_PRT(MSG_LEVEL_VERBOSE, KERN_ERR " %s : the received frame span multple RDs.\n", vptr->netdev->name);
> +		VELOCITY_PRT(MSG_LEVEL_VERBOSE, KERN_ERR " %s : the received frame span multiple RDs.\n", vptr->netdev->name);

		                                                                   spans

>  		stats->rx_length_errors++;
>  		return -EINVAL;
>  	}

Thanks,

-- 
~Randy
