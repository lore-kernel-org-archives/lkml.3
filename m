Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965936AbaFTPtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:49:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbaFTPt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:49:29 -0400
Date: Fri, 20 Jun 2014 08:53:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: rbasukala <basukalaramesh@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix coding style issue
Message-ID: <20140620155330.GA7422@kroah.com>
References: <1403277958-32684-1-git-send-email-basukalaramesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403277958-32684-1-git-send-email-basukalaramesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:25:58AM -0400, rbasukala wrote:
> Signed-off-by: rbasukala <basukalaramesh@gmail.com>
> ---
>  drivers/staging/netlogic/xlr_net.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
> index e320d6b..3ad48a0 100644
> --- a/drivers/staging/netlogic/xlr_net.c
> +++ b/drivers/staging/netlogic/xlr_net.c
> @@ -1105,6 +1105,7 @@ err_gmac:
>  static int xlr_net_remove(struct platform_device *pdev)
>  {
>  	struct xlr_net_priv *priv = platform_get_drvdata(pdev);
> +
>  	unregister_netdev(priv->ndev);
>  	mdiobus_unregister(priv->mii_bus);
>  	mdiobus_free(priv->mii_bus);

Any reason you didn't read the whole message my patch-bot sent to you
and follow its instructions?

greg k-h
