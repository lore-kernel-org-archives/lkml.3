Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaICOwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:52:22 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56157 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaICOwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:52:20 -0400
Date: Wed, 3 Sep 2014 20:22:04 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Piotr Witoslawski <pwitos@gmail.com>
Cc: lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, markh@compro.net
Subject: Re: [PATCH] drivers: staging: dgap: fix the checkpatch.pl issue
 "Warning: line over 80 characters"
Message-ID: <20140903145203.GB15176@sudip-PC>
References: <20140903140959.GA24601@pwitoslawski.warsaw.osa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903140959.GA24601@pwitoslawski.warsaw.osa>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 04:09:59PM +0200, Piotr Witoslawski wrote:
> Done as Eudyptula task 10.
use proper commit message mentioning what changes you have done. 
and you have not sent the patch to all the people who were
supposed to be sent. 

thanks
sudip

> Signed-off-by: Piotr Witoslawski <pwitos@gmail.com>
> ---
>  drivers/staging/dgap/dgap.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
> index 8929dbf..67da1d5 100644
> --- a/drivers/staging/dgap/dgap.c
> +++ b/drivers/staging/dgap/dgap.c
> @@ -88,7 +88,8 @@ static int dgap_block_til_ready(struct tty_struct *tty, struct file *file,
>  				struct channel_t *ch);
>  static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
>  				unsigned long arg);
> -static int dgap_tty_digigeta(struct channel_t *ch, struct digi_t __user *retinfo);
> +static int dgap_tty_digigeta(struct channel_t *ch,
> +			     struct digi_t __user *retinfo);
>  static int dgap_tty_digiseta(struct channel_t *ch, struct board_t *bd,
>  			     struct un_t *un, struct digi_t __user *new_info);
>  static int dgap_tty_digigetedelay(struct tty_struct *tty, int __user *retinfo);
> @@ -104,8 +105,9 @@ static void dgap_tty_flush_chars(struct tty_struct *tty);
>  static void dgap_tty_flush_buffer(struct tty_struct *tty);
>  static void dgap_tty_hangup(struct tty_struct *tty);
>  static int dgap_wait_for_drain(struct tty_struct *tty);
> -static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd, struct un_t *un,
> -			       unsigned int command, unsigned int __user *value);
> +static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd,
> +			       struct un_t *un, unsigned int command,
> +			       unsigned int __user *value);
>  static int dgap_get_modem_info(struct channel_t *ch,
>  				unsigned int __user *value);
>  static int dgap_tty_digisetcustombaud(struct channel_t *ch, struct board_t *bd,
> @@ -3076,8 +3078,9 @@ static int dgap_get_modem_info(struct channel_t *ch, unsigned int __user *value)
>   *
>   * Set modem signals, called by ld.
>   */
> -static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd, struct un_t *un,
> -			       unsigned int command, unsigned int __user *value)
> +static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd,
> +			       struct un_t *un, unsigned int command,
> +			       unsigned int __user *value)
>  {
>  	int ret;
>  	unsigned int arg;
> @@ -3153,7 +3156,8 @@ static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd, struct
>   *
>   *
>   */
> -static int dgap_tty_digigeta(struct channel_t *ch, struct digi_t __user *retinfo)
> +static int dgap_tty_digigeta(struct channel_t *ch,
> +			     struct digi_t __user *retinfo)
>  {
>  	struct digi_t tmp;
>  	ulong lock_flags;
> -- 
> 1.8.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
