Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319AbaJ2Por (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:44:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbaJ2PmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:08 -0400
Date: Wed, 29 Oct 2014 17:25:48 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mike Roocroft <mike.linux@btinternet.com>
Cc: fabio.falzoi84@gmail.com, micky_ching@realsil.com.cn,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rts5208: rtsx_scsi: Fixed a brace coding style
 issue
Message-ID: <20141029092548.GA5913@kroah.com>
References: <1413502251-32223-1-git-send-email-mike.linux@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413502251-32223-1-git-send-email-mike.linux@btinternet.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 12:30:51AM +0100, Mike Roocroft wrote:
> Fixed a coding style issue.
> 
> Signed-off-by: Mike Roocroft <mike.linux@btinternet.com>
> ---
>  drivers/staging/rts5208/rtsx_scsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
> index bbbf796..1161082 100644
> --- a/drivers/staging/rts5208/rtsx_scsi.c
> +++ b/drivers/staging/rts5208/rtsx_scsi.c
> @@ -584,9 +584,8 @@ static int start_stop_unit(struct scsi_cmnd *srb, struct rtsx_chip *chip)
>  
>  	case MAKE_MEDIUM_READY:
>  	case LOAD_MEDIUM:
> -		if (check_card_ready(chip, lun)) {
> +		if (check_card_ready(chip, lun))
>  			return TRANSPORT_GOOD;
> -		}
>  		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_NOT_PRESENT);
>  		TRACE_RET(chip, TRANSPORT_FAILED);
>  
> -- 
> 2.1.2

Does not apply :(
