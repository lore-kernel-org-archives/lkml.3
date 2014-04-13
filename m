Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaDMPqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 11:46:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaDMPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 11:46:05 -0400
Date: Sun, 13 Apr 2014 08:48:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pascal COMBES <pascom@orange.fr>
Cc: devel@driverdev.osuosl.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jarod Wilson <jarod@wilsonet.com>, Jingoo Han <jg1.han@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Scott Davilla <davilla@4pi.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Foss <dev@robertfoss.se>
Subject: Re: [PATCH] Fix coding style in
 drivers/staging/crystalhd/crystalhd_lnx.c
Message-ID: <20140413154859.GA18189@kroah.com>
References: <534AAED2.7050205@orange.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534AAED2.7050205@orange.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 05:35:46PM +0200, Pascal COMBES wrote:
> From: Pascal COMBES <pascom@orange.fr>
> 
> Fix alignement issues and two or three other coding style problems in 
> drivers/staging/crystalhd/crystalhd_lnx.c.

Patches need to do one thing, as you are addressing a number of
different things all in one patch, this needs to be broken up into
smaller pieces, and sent as a series of patches.

> 
> NB:	-I did this for task 10 of Eudyptula challenge <http://eudyptula-challenge.org/>
> 	-I did not address camel case related problem because it would have make a big patch.

This doesn't belong here, in the patch changelog body, please remove it.
If you want to include comments like this, they need to be below the
"---" line where git will remove them when the patch is applied.

> 
> Signed-off-by: Pascal COMBES <pascom@orange.fr>
> ---
> diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
> index 20be957..9f6a9d4 100644
> --- a/drivers/staging/crystalhd/crystalhd_lnx.c
> +++ b/drivers/staging/crystalhd/crystalhd_lnx.c
> @@ -28,7 +28,7 @@ static struct crystalhd_adp *g_adp_info;
>  
>  static irqreturn_t chd_dec_isr(int irq, void *arg)
>  {
> -	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
> +	struct crystalhd_adp *adp = (struct crystalhd_adp *)arg;
>  	int rc = 0;
>  	if (adp)
>  		rc = crystalhd_cmd_interrupt(&adp->cmds);
> @@ -112,7 +112,7 @@ static void chd_dec_free_iodata(struct crystalhd_adp *adp,
>  }
>  
>  static inline int crystalhd_user_data(void __user *ud, void *dr,
> -			 int size, int set)
> +				      int size, int set)
>  {
>  	int rc;
>  
> @@ -135,7 +135,9 @@ static inline int crystalhd_user_data(void __user *ud, void *dr,
>  }
>  
>  static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
> -	 struct crystalhd_ioctl_data *io, uint32_t m_sz, unsigned long ua)
> +			       struct crystalhd_ioctl_data *io,
> +			       uint32_t m_sz,
> +			       unsigned long ua)

Why can't these two lines be on the same line?

thanks,

greg k-h
