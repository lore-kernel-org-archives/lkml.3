Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaE1Sbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:31:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56916 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbaE1Sbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:31:49 -0400
X-Sasl-enc: ++Y24F3s3rphNBCyvzJwqi3iRNZEQHOcddDbZyAN55Wo 1401301908
Date: Wed, 28 May 2014 11:35:23 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joerg Roedel <joro@8bytes.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the iommu
 tree
Message-ID: <20140528183523.GA16719@kroah.com>
References: <20140528175531.4ce48afd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528175531.4ce48afd@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 05:55:31PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/iommu/exynos-iommu.c between commit 7222e8db2d50
> ("iommu/exynos: Fix build errors") from the iommu tree and commit
> 8283b4919e00 ("driver core: dev_set_drvdata can no longer fail") from
> the driver-core tree.
> 
> I fixed it up (the former removed the code changed by the latter) and
> can carry the fix as necessary (no action is required).

Sounds good, thanks.

greg k-h
