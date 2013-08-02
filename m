Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3HBA1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:27:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32912 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab3HBA1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:27:38 -0400
X-Sasl-enc: hy3KOYQNfy9Q7ocKoIHC5ij6y0cyVVyaDmtZPleEsOe5 1375403256
Date: Fri, 2 Aug 2013 08:28:51 +0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the driver-core tree with the
 net-next tree
Message-ID: <20130802002851.GD11408@kroah.com>
References: <20130801152148.c98a281ec6e076646edeb7cb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801152148.c98a281ec6e076646edeb7cb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:21:48PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> net/core/net-sysfs.c between commit ff80e519ab1b ("net: export physical
> port id via sysfs") from the net-next tree and commit 6be8aeef348a ("net:
> core: convert class code to use dev_groups") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
