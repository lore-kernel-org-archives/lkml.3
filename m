Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbbAQXe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:34:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbbAQXe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:34:27 -0500
Date: Sat, 17 Jan 2015 14:56:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Cc: josh@joshtriplett.org, gulsah.1004@gmail.com, daniel.dy.ngu@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging : gdm724x: Remove space before , in function
 arguments
Message-ID: <20150117225633.GA25264@kroah.com>
References: <1419130099-6256-1-git-send-email-md.jamalmohiuddin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419130099-6256-1-git-send-email-md.jamalmohiuddin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 08:18:19AM +0530, Mohammad Jamal wrote:
> This patch solves space prohibited before , warning in gdm_mux.c
> 
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
> ---
>  drivers/staging/gdm724x/gdm_mux.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
> index b5b063a..d1ab996 100644
> --- a/drivers/staging/gdm724x/gdm_mux.c
> +++ b/drivers/staging/gdm724x/gdm_mux.c
> @@ -220,7 +220,7 @@ static int up_to_host(struct mux_rx *r)
>  static void do_rx(struct work_struct *work)
>  {
>  	struct mux_dev *mux_dev =
> -		container_of(work, struct mux_dev , work_rx.work);
> +		container_of(work, struct mux_dev, work_rx.work);
>  	struct mux_rx *r;
>  	struct rx_cxt *rx = (struct rx_cxt *)&mux_dev->rx;
>  	unsigned long flags;
> -- 
> 1.7.9.5

Someone else sent this same fix before you did :(
