Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaLEOAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:00:17 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61648 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaLEOAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:00:15 -0500
Date: Fri, 5 Dec 2014 06:00:11 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Athira Lekshmi <andnlnbn18@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: Fixed missing blank line warning
Message-ID: <20141205140011.GA5184@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Athira Lekshmi <andnlnbn18@gmail.com>, linux-kernel@vger.kernel.org
References: <1417787034-7833-1-git-send-email-andnlnbn18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417787034-7833-1-git-send-email-andnlnbn18@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Athira,

On Fri, Dec 05, 2014 at 07:13:54PM +0530, Athira Lekshmi wrote:
> Fixed the checkpatch warning:
> Missing a blank line after declarations
> 
> Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
> ---
>  drivers/watchdog/mixcomwd.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
> index be86ea3..03b7612e 100644
> --- a/drivers/watchdog/mixcomwd.c
> +++ b/drivers/watchdog/mixcomwd.c
> @@ -183,6 +183,7 @@ static ssize_t mixcomwd_write(struct file *file, const char __user *data,
>  
>  			for (i = 0; i != len; i++) {
>  				char c;
> +
>  				if (get_user(c, data + i))
>  					return -EFAULT;
>  				if (c == 'V')
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

It is helpful to add a version number when patches are re-submitted to
avoid them being confused for a new patch.  git-format-patch has the
--reroll-count option which makes this easy to do.

-- 
- Jeremiah Mahler
