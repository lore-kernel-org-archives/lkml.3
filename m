Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3KYEEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 23:04:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59074 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3KYEEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 23:04:50 -0500
Message-ID: <5292CC5E.3000405@infradead.org>
Date: Sun, 24 Nov 2013 20:04:46 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, tomas.winkler@intel.com
Subject: Re: [PATCH 3/3] [trivial] mei: Fix typo in mei drivers
References: <1385220974-3469-1-git-send-email-standby24x7@gmail.com> <1385220974-3469-3-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1385220974-3469-3-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/13 07:36, Masanari Iida wrote:
> Correct spelling typo in comments within mei.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/misc/mei/amthif.c  |  4 ++--
>  drivers/misc/mei/debugfs.c |  2 +-
>  drivers/misc/mei/hbm.c     | 12 ++++++------
>  drivers/misc/mei/mei_dev.h |  2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
> index e3870f2..10b172a 100644
> --- a/drivers/misc/mei/debugfs.c
> +++ b/drivers/misc/mei/debugfs.c
> @@ -43,7 +43,7 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
>  
>  	mutex_lock(&dev->device_lock);
>  
> -	/*  if the driver is not enabled the list won't b consitent */
> +	/*  if the driver is not enabled the list won't b consistent */

	                                                be

>  	if (dev->dev_state != MEI_DEV_ENABLED)
>  		goto out;
>  
> diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
> index 9b3a0fb..96fed82 100644
> --- a/drivers/misc/mei/hbm.c
> +++ b/drivers/misc/mei/hbm.c
> @@ -90,7 +90,7 @@ void mei_hbm_cl_hdr(struct mei_cl *cl, u8 hbm_cmd, void *buf, size_t len)
>   * @file: private data of the file object.
>   * @disconn: disconnection request.
>   *
> - * returns true if addres are same
> + * returns true if address are same

                      addresses

>   */
>  static inline
>  bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)


-- 
~Randy
