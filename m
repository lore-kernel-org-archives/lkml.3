Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaGPUws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:52:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33222 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbaGPUwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:52:46 -0400
X-Sasl-enc: FHdEdiKl8QdsVsTzNhYeBxnfFgUeHMSsZjzhdacOF+0v 1405543965
Date: Wed, 16 Jul 2014 13:52:20 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>,
        Kristina =?utf-8?Q?Mart=C5=A1enko?= 
	<kristina.martsenko@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the net-next
 tree
Message-ID: <20140716205220.GA14387@kroah.com>
References: <20140716164322.472de7c7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716164322.472de7c7@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 04:43:22PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/cxt1e1/linux.c between commit c835a6773314 ("net: set
> name_assign_type in alloc_netdev()") from the net-next tree and commit
> 14b596c9d80b ("staging: cxt1e1: remove driver") from the staging tree.
> 
> I fixed it up (I just removed the file) and can carry the fix as
> necessary (no action is required).

That is fine, thanks.

greg k-h
