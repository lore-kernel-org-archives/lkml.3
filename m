Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaG1GKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:10:09 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56137 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbaG1GKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:10:06 -0400
X-Sasl-enc: MtKF/ulBiNS91sC4quQkUn5Ypc7yRGZVgb3Mq9N9eZLc 1406527804
Date: Sun, 27 Jul 2014 23:09:35 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Simon Horman <horms@verge.net.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 renesas tree
Message-ID: <20140728060935.GA753@kroah.com>
References: <20140725162353.04cacc71@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725162353.04cacc71@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 04:23:53PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/arm/mach-shmobile/setup-r7s72100.c between commit 9394af431455
> ("ARM: shmobile: genmai-reference: Enable MTU2 in device tree") from
> the renesas tree and commit d2168146c222 ("platform: Remove most
> references to platform_bus device") from the driver-core tree.
> 
> I fixed it up (the former removed the code that the latter modified)
> and can carry the fix as necessary (no action is required).

Sounds good, thanks.

greg k-h
