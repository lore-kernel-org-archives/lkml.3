Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbbAQXew (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:34:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbbAQXev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:34:51 -0500
Date: Sat, 17 Jan 2015 14:57:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ning Zhou <zhou.ning.gd@gmail.com>
Cc: gulsah.1004@gmail.com, daniel.dy.ngu@gmail.com, josh@joshtriplett.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm724x: fix space coding style issue in
 gdm_mux.c
Message-ID: <20150117225731.GB30146@kroah.com>
References: <1420359824-7081-1-git-send-email-zhou.ning.gd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420359824-7081-1-git-send-email-zhou.ning.gd@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 09:23:44AM +0100, Ning Zhou wrote:
> This is a patch to fix a space error found by the checkpatch.pl in
> file gdm_mux.c.
> 
> Signed-off-by: Ning Zhou <zhou.ning.gd@gmail.com>
> ---
>  drivers/staging/gdm724x/gdm_mux.c | 2 +-
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
> 1.9.1

Someone sent this same patch before you did, sorry.
