Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbbAQXej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:34:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbbAQXei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:34:38 -0500
Date: Sat, 17 Jan 2015 14:57:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Robert Nachlinger <robert.nachlinger@googlemail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: gdm724x: fix space before comma coding style
 issue in gdm_mux.c
Message-ID: <20150117225711.GA30146@kroah.com>
References: <1419158683-6113-1-git-send-email-robert.nachlinger@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419158683-6113-1-git-send-email-robert.nachlinger@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 11:44:43AM +0100, Robert Nachlinger wrote:
> This is a patch to the gdm_mux.c file that fixes a space before comma
> coding style issue found by the checkpatch.pl tool.
> 
> Signed-off-by: Robert Nachlinger <robert.nachlinger@googlemail.com>
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
> 2.2.0

Someone else sent this same patch :(
