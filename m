Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaLXPmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 10:42:04 -0500
Received: from sonata.ens-lyon.org ([140.77.166.138]:54328 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaLXPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 10:42:02 -0500
Date: Wed, 24 Dec 2014 16:41:57 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Panir.Nyan" <panir.nyan@gmail.com>
Cc: gregkh@linuxfoundation.org, w.d.hubbs@gmail.com, chris@the-brannons.com,
        kirk@reisers.ca, speakup@linux-speakup.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: speakup: Split the comment to fit the length
Message-ID: <20141224154157.GS3060@type>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Panir.Nyan" <panir.nyan@gmail.com>, gregkh@linuxfoundation.org,
	w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
	speakup@linux-speakup.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1419394052-6551-1-git-send-email-Panir.Nyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419394052-6551-1-git-send-email-Panir.Nyan@gmail.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panir.Nyan, le Wed 24 Dec 2014 04:07:31 +0000, a écrit :
> Split the comment to fit the length.
> 
> Signed-off-by: Panir Nyan <Panir.Nyan@gmail.com>

Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

> ---
>  drivers/staging/speakup/synth.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
> index f3aa423..01eddab 100644
> --- a/drivers/staging/speakup/synth.c
> +++ b/drivers/staging/speakup/synth.c
> @@ -30,9 +30,9 @@ struct speakup_info_t speakup_info = {
>  	 * must be taken at each kernel->speakup transition and released at
>  	 * each corresponding speakup->kernel transition.
>  	 *
> -	 * The progression thread only interferes with the speakup machinery through
> -	 * the synth buffer, so only needs to take the lock while tinkering with
> -	 * the buffer.
> +	 * The progression thread only interferes with the speakup machinery
> +	 * through the synth buffer, so only needs to take the lock
> +	 * while tinkering with the buffer.
>  	 *
>  	 * We use spin_lock/trylock_irqsave and spin_unlock_irqrestore with this
>  	 * spinlock because speakup needs to disable the keyboard IRQ.
> --
> 1.7.10.4
> 

-- 
Samuel
Linux, c'est simple : ça s'adresse à une machine qui est parfois un peu
maraboutée mais qui d'habitude n'a pas d'états d'âme. Sur Usenet y'a
plein d'humains et de primates, et ça devient vraiment gore par moment.
-+- TP in : Guide du linuxien pervers - "Le linuxien a-t-il une âme ?" -+-
