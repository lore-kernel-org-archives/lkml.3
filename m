Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaDES5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 14:57:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34169 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbaDES5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 14:57:06 -0400
X-Sasl-enc: QQzCM/nkd1OHgrXNQ3D2sHmRNmGfwpgiVzIPObYF4l5l 1396724224
Date: Sat, 5 Apr 2014 11:59:29 -0700
From: Greg KH <greg@kroah.com>
To: Camille Bordignon <camille.bordignon@gmail.com>
Cc: paul.gortmaker@windriver.com, rashika.kheria@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: sep: Fix coding style
Message-ID: <20140405185929.GA16278@kroah.com>
References: <CAPF_0gn1r1R0eatLDqKUqmMc=n9xYufxbg==zv3RS4wS8fbJpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPF_0gn1r1R0eatLDqKUqmMc=n9xYufxbg==zv3RS4wS8fbJpA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 08:24:04PM +0200, Camille Bordignon wrote:
> This fixes coding style warning "Missing a blank line after
> declarations" in files sep_dev.h and sep_crypto.c.
> 
> Signed-off-by: Camille Bordignon <camille.bordignon@gmail.com>
> ---
> diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
> index 965485f..415f8ec 100644
> --- a/drivers/staging/sep/sep_crypto.c
> +++ b/drivers/staging/sep/sep_crypto.c
> @@ -93,6 +93,7 @@ static void sep_do_callback(struct work_struct *work)
>  {
>      struct sep_work_struct *sep_work = container_of(work,
>          struct sep_work_struct, work);
> +
>      if (sep_work != NULL) {
>          (sep_work->callback)(sep_work->data);
>          kfree(sep_work);

Tabs got converted all to spaces here, making it impossible to apply
your patch :(

Can you try this again after fixing up your email client?

thanks,

greg k-h
