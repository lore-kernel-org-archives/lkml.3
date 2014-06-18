Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaFRWU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:20:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFRWU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:20:58 -0400
Date: Wed, 18 Jun 2014 15:24:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Adithya Krishnamurthy <linux.challenge1@gmail.com>
Cc: omar.ramirez@copitl.com, rashika.kheria@gmail.com, freemangordon@abv.bg,
        dan.carpenter@oracle.com, ody.guru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Staging:tidspbridge Fix minor checkpatch.pl warning.
Message-ID: <20140618222457.GA2317@kroah.com>
References: <y>
 <1401893916-23366-1-git-send-email-linux.challenge1@gmail.com>
 <53942534.9010701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53942534.9010701@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 02:26:20PM +0530, Adithya Krishnamurthy wrote:
> From: Adithya Krishnamurthy <linux.challenge1@gmail.com>
> 
> Fixed checkpatch "WARNING: Missing a blank line after declarations"
> 
> Signed-off-by: Adithya Krishnamurthy <linux.challenge1@gmail.com>
> ---
>  drivers/staging/tidspbridge/core/chnl_sm.c       |    1 +
>  drivers/staging/tidspbridge/core/io_sm.c         |    1 +
>  drivers/staging/tidspbridge/core/tiomap3430.c    |    2 ++
>  drivers/staging/tidspbridge/core/tiomap_io.c     |    2 ++
>  drivers/staging/tidspbridge/core/wdt.c           |    1 +
>  drivers/staging/tidspbridge/dynload/cload.c      |    7 +++++++
>  drivers/staging/tidspbridge/dynload/reloc.c      |    2 ++
>  drivers/staging/tidspbridge/pmgr/chnl.c          |    1 +
>  drivers/staging/tidspbridge/rmgr/dbdcd.c         |    1 +
>  drivers/staging/tidspbridge/rmgr/drv_interface.c |    2 ++
>  drivers/staging/tidspbridge/rmgr/nldr.c          |    1 +
>  drivers/staging/tidspbridge/rmgr/node.c          |    2 ++
>  drivers/staging/tidspbridge/rmgr/proc.c          |    3 +++
>  13 files changed, 26 insertions(+)
> 
> diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
> index 16fa346..c855992 100644
> --- a/drivers/staging/tidspbridge/core/chnl_sm.c
> +++ b/drivers/staging/tidspbridge/core/chnl_sm.c
> @@ -486,6 +486,7 @@ int bridge_chnl_get_info(struct chnl_object *chnl_obj,
>  {
>  	int status = 0;
>  	struct chnl_object *pchnl = (struct chnl_object *)chnl_obj;
> +
>  	if (channel_info != NULL) {
>  		if (pchnl) {
>  			/* Return the requested information: */


Your email client put an extra space in front of every line, making this
patch not able to be applied :(

Care to fix that up and resend?

thanks,

greg k-h
