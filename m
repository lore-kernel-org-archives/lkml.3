Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbaGXHpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:45:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42812 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934195AbaGXHpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:45:43 -0400
X-Sasl-enc: TaUStA7MPTiR9/7VwHjh7ryXTAeD/TkZd7T3ZJatXGJE 1406187940
Date: Thu, 24 Jul 2014 00:45:15 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <mat.krawczuk@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the samsung tree
Message-ID: <20140724074515.GC11963@kroah.com>
References: <20140724163834.430cf674@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724163834.430cf674@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:38:34PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/phy/phy-samsung-usb2.c between commit 949ccc3a9363 ("phy: Add
> support for S5PV210 to the Exynos USB 2.0 PHY driver") from the samsung
> tree and commit 016e0d3cb72c ("drivers: phy: exynos-usb2: add support
> for Exynos 3250") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
