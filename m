Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab3ETQ3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:29:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34063 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3ETQ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:29:36 -0400
Message-ID: <519A4F3F.1010001@infradead.org>
Date: Mon, 20 May 2013 09:28:47 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial]treewide: Fix typo in printk
References: <1369063075-13798-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1369063075-13798-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/13 08:17, Masanari Iida wrote:
> Correct spelling typo in various part of drivers
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Ack except for one line below:

Thanks.

> 
> ---
>  drivers/gpu/drm/drm_fb_cma_helper.c                      | 4 ++--
>  drivers/gpu/drm/radeon/radeon_fb.c                       | 2 +-
>  drivers/infiniband/ulp/isert/ib_isert.c                  | 2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c             | 2 +-
>  drivers/misc/dummy-irq.c                                 | 2 +-
>  drivers/misc/lattice-ecp3-config.c                       | 2 +-
>  drivers/misc/mei/hbm.c                                   | 2 +-
>  drivers/misc/mei/init.c                                  | 2 +-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 +-
>  drivers/nfc/pn533.c                                      | 2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c                         | 2 +-
>  drivers/tty/serial/serial-tegra.c                        | 2 +-
>  drivers/usb/musb/musb_dsps.c                             | 2 +-
>  drivers/usb/musb/omap2430.c                              | 2 +-
>  drivers/video/omap2/displays/panel-n8x0.c                | 2 +-
>  fs/btrfs/free-space-cache.c                              | 2 +-
>  tools/testing/ktest/ktest.pl                             | 2 +-
>  17 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 302514d..e4a0d01 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3204,7 +3204,7 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  		break;
>  	case OPC_OUB_DEREG_DEV:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("unresgister the deviece\n"));
> +			pm8001_printk("unresgister the device\n"));

			               unregister

>  		pm8001_mpi_dereg_resp(pm8001_ha, piomb);
>  		break;
>  	case OPC_OUB_GET_DEV_HANDLE:



-- 
~Randy
