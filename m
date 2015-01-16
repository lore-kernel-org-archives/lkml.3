Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbbAPAtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 19:49:43 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36514 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbbAPAtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 19:49:41 -0500
Date: Thu, 15 Jan 2015 18:49:37 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Minghuan Lian <minghuan.Lian@freescale.com>,
        Mingkai Hu <mingkai.hu@freescale.com>,
        Roy Zang <tie-fei.zang@freescale.com>, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 13/28] pci: host: drop owner assignment from
 platform_drivers
Message-ID: <20150116004937.GG29776@google.com>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-14-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419196495-9626-14-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Julia]

On Sun, Dec 21, 2014 at 10:14:34PM +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

I already applied the equivalent patch from Julia for v3.20, thanks!
(I know this is my fault because it took me so long to apply Julia's
patch.)

> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.
> 
>  drivers/pci/host/pci-layerscape.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/pci/host/pci-layerscape.c b/drivers/pci/host/pci-layerscape.c
> index 6697b1a4d4fa..68c9e5e9b0a8 100644
> --- a/drivers/pci/host/pci-layerscape.c
> +++ b/drivers/pci/host/pci-layerscape.c
> @@ -167,7 +167,6 @@ MODULE_DEVICE_TABLE(of, ls_pcie_of_match);
>  static struct platform_driver ls_pcie_driver = {
>  	.driver = {
>  		.name = "layerscape-pcie",
> -		.owner = THIS_MODULE,
>  		.of_match_table = ls_pcie_of_match,
>  	},
>  };
> -- 
> 2.1.3
> 
