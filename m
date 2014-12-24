Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaLXPo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 10:44:28 -0500
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:54354 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaLXPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 10:44:27 -0500
Date: Wed, 24 Dec 2014 16:44:23 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Panir.Nyan" <panir.nyan@gmail.com>
Cc: gregkh@linuxfoundation.org, w.d.hubbs@gmail.com, chris@the-brannons.com,
        kirk@reisers.ca, speakup@linux-speakup.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: speakup: Combine the consecutive string
Message-ID: <20141224154423.GT3060@type>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Panir.Nyan" <panir.nyan@gmail.com>, gregkh@linuxfoundation.org,
	w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
	speakup@linux-speakup.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1419394052-6551-1-git-send-email-Panir.Nyan@gmail.com>
 <1419394052-6551-2-git-send-email-Panir.Nyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419394052-6551-2-git-send-email-Panir.Nyan@gmail.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panir.Nyan, le Wed 24 Dec 2014 04:07:32 +0000, a écrit :
> Combine the consecutive string
> 
> Signed-off-by: Panir Nyan <Panir.Nyan@gmail.com>

Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

> ---
>  drivers/staging/speakup/kobjects.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
> index b12c76d..3708bc1 100644
> --- a/drivers/staging/speakup/kobjects.c
> +++ b/drivers/staging/speakup/kobjects.c
> @@ -566,7 +566,7 @@ ssize_t spk_var_show(struct kobject *kobj, struct kobj_attribute *attr,
>  				if (ch >= ' ' && ch < '~')
>  					*cp1++ = ch;
>  				else
> -					cp1 += sprintf(cp1, "\\""x%02x", ch);
> +					cp1 += sprintf(cp1, "\\x%02x", ch);
>  			}
>  			*cp1++ = '"';
>  			*cp1++ = '\n';
> --
> 1.7.10.4
> 

-- 
Samuel
"...Unix, MS-DOS, and Windows NT (also known as the Good, the Bad, and
the Ugly)."
(By Matt Welsh)
