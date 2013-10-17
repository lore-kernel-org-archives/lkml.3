Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab3JQRT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:19:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59851 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3JQRTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:19:54 -0400
Date: Thu, 17 Oct 2013 10:19:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: dudl@cypress.com, kamal@canonical.com, mario_limonciello@dell.com,
        git@status.e4ward.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-br@googlegroups.com
Subject: Re: [PATCH v2] drivers: input: mouse: Remove useless casting in
 cypress_ps2.c
Message-ID: <20131017171948.GB3884@core.coreip.homeip.net>
References: <1381962675-26876-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381962675-26876-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 07:31:15PM -0300, Geyslan G. Bem wrote:
> Get rid of unnecessary (void *) casting in 'cypress_init' function.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>

Applied, thank you.

> ---
>  drivers/input/mouse/cypress_ps2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
> index f51765f..b87d7ba 100644
> --- a/drivers/input/mouse/cypress_ps2.c
> +++ b/drivers/input/mouse/cypress_ps2.c
> @@ -680,7 +680,7 @@ int cypress_init(struct psmouse *psmouse)
>  	struct cytp_data *cytp;
>  
>  	cytp = (struct cytp_data *)kzalloc(sizeof(struct cytp_data), GFP_KERNEL);
> -	psmouse->private = (void *)cytp;
> +	psmouse->private = cytp;
>  	if (cytp == NULL)
>  		return -ENOMEM;
>  
> -- 
> 1.8.4
> 

-- 
Dmitry
