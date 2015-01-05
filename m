Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbbAELI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:08:27 -0500
Received: from 8bytes.org ([81.169.241.247]:58052 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbbAELI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:08:26 -0500
Date: Mon, 5 Jan 2015 12:08:23 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 09/28] iommu: drop owner assignment from platform_drivers
Message-ID: <20150105110823.GC19590@8bytes.org>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-10-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419196495-9626-10-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 10:14:30PM +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.
> 
>  drivers/iommu/rockchip-iommu.c | 1 -
>  1 file changed, 1 deletion(-)

Applied to iommu/fixes, thanks Wolfram.

