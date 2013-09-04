Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352Ab3IDK0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:26:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041Ab3IDK0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:26:53 -0400
Date: Wed, 4 Sep 2013 12:26:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [trivial PATCH] treewide: Convert retrun typos to return
In-Reply-To: <1378241158.7347.26.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1309041226410.3684@pobox.suse.cz>
References: <1378241158.7347.26.camel@joe-AO722>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Joe Perches wrote:

> Tyops should be fixed.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.

> ---
>  drivers/net/wireless/rtlwifi/rtl8192de/dm.c | 2 +-
>  drivers/scsi/bfa/bfad_im.c                  | 2 +-
>  drivers/scsi/hpsa.c                         | 2 +-
>  drivers/scsi/lpfc/lpfc_bsg.c                | 2 +-
>  drivers/scsi/qla2xxx/qla_bsg.c              | 2 +-
>  drivers/tty/serial/kgdboc.c                 | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> index 47875ba..f700f7a 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> @@ -416,7 +416,7 @@ static void rtl92d_dm_dig(struct ieee80211_hw *hw)
>  
>  	/* because we will send data pkt when scanning
>  	 * this will cause some ap like gear-3700 wep TP
> -	 * lower if we retrun here, this is the diff of
> +	 * lower if we return here, this is the diff of
>  	 * mac80211 driver vs ieee80211 driver */
>  	/* if (rtlpriv->mac80211.act_scanning)
>  	 *      return; */
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 9796284..9967f9c 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -206,7 +206,7 @@ bfad_im_abort_handler(struct scsi_cmnd *cmnd)
>  	spin_lock_irqsave(&bfad->bfad_lock, flags);
>  	hal_io = (struct bfa_ioim_s *) cmnd->host_scribble;
>  	if (!hal_io) {
> -		/* IO has been completed, retrun success */
> +		/* IO has been completed, return success */
>  		rc = SUCCESS;
>  		goto out;
>  	}
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index b766f5a..fac8cf5 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1054,7 +1054,7 @@ free_and_out:
>  }
>  
>  /*
> - * Lookup bus/target/lun and retrun corresponding struct hpsa_scsi_dev_t *
> + * Lookup bus/target/lun and return corresponding struct hpsa_scsi_dev_t *
>   * Assume's h->devlock is held.
>   */
>  static struct hpsa_scsi_dev_t *lookup_hpsa_scsi_dev(struct ctlr_info *h,
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index bc27063..79c13c3 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -2628,7 +2628,7 @@ err_get_xri_exit:
>   * @phba: Pointer to HBA context object
>   *
>   * This function allocates BSG_MBOX_SIZE (4KB) page size dma buffer and.
> - * retruns the pointer to the buffer.
> + * returns the pointer to the buffer.
>   **/
>  static struct lpfc_dmabuf *
>  lpfc_bsg_dma_page_alloc(struct lpfc_hba *phba)
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index b989add..aa57bf0 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1895,7 +1895,7 @@ done:
>  	bsg_job->reply->reply_payload_rcv_len = 0;
>  	bsg_job->reply->result = (DID_OK) << 16;
>  	bsg_job->job_done(bsg_job);
> -	/* Always retrun success, vendor rsp carries correct status */
> +	/* Always return success, vendor rsp carries correct status */
>  	return 0;
>  }
>  
> diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
> index 1002054..a260cde 100644
> --- a/drivers/tty/serial/kgdboc.c
> +++ b/drivers/tty/serial/kgdboc.c
> @@ -45,7 +45,7 @@ static int kgdboc_reset_connect(struct input_handler *handler,
>  {
>  	input_reset_device(dev);
>  
> -	/* Retrun an error - we do not want to bind, just to reset */
> +	/* Return an error - we do not want to bind, just to reset */
>  	return -ENODEV;
>  }
>  
> 
> 

-- 
Jiri Kosina
SUSE Labs
