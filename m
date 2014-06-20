Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbaFTUgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:36:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaFTUgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:36:01 -0400
Date: Fri, 20 Jun 2014 13:40:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ramesh Basukala <basukalaramesh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01] Drivers: Fixes coding style warning
Message-ID: <20140620204003.GB16973@kroah.com>
References: <53A498B2.1000808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A498B2.1000808@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 04:25:22PM -0400, Ramesh Basukala wrote:
> *

What is that for?

> 
> From: Ramesh Basukala <basukalaramesh@gmail.com>
> 
> 
> Attached is a patch which fixes coding style warning message while running
> checkpatch script.
> 
> 
> This patch is currently against a linux 3.15.0-rc15-next kernel. I am

There is no 3.15-rc15 kernel release :(

> submitting this patch as a part of Eudyptula Challenge task.

Not needed here.

> 
> 
> Signed-off-by: Ramesh Basukala <basukalaramesh@gmail.com>
> *---
> Signed-off-by: Ramesh Basukala <basukalaramesh@gmail.com>
> --- xlr_net.c.original 2014-06-20 15:32:10.069732488 -0400
> +++ xlr_net.c 2014-06-20 15:35:06.841105038 -0400
> @@ -1105,6 +1105,7 @@ err_gmac:
> static int xlr_net_remove(struct platform_device *pdev)
> {
> struct xlr_net_priv *priv = platform_get_drvdata(pdev);
> +
> unregister_netdev(priv->ndev);
> mdiobus_unregister(priv->mii_bus);
> mdiobus_free(priv->mii_bus);
> **


This doesn't apply at all, please always test your patches yourself
before resending them.

Also, be explicit as to what you are fixing (what part of the kernel),
and use the scripts/get_maintainers.pl tool to send the patches to the
correct people and mailing list.

Care to try again?

greg k-h
