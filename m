Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3FGRjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:39:04 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47471 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399Ab3FGRjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:39:02 -0400
X-Sasl-enc: AwXnyxENBvDmrA6MUwxxy9T37u8Lh0oxPOoFqZrwgTrW 1370626740
Date: Fri, 7 Jun 2013 10:38:59 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: manual merge of the driver-core tree with the pm tree
Message-ID: <20130607173859.GC29615@kroah.com>
References: <20130607144936.6ea0c2d9a7fcf321e59cc6d6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607144936.6ea0c2d9a7fcf321e59cc6d6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 02:49:36PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/memory.c between commit 4960e05e2260 ("Driver core:
> Introduce offline/online callbacks for memory blocks") from the pm tree
> and commit 96b2c0fc8e74 ("drivers/base: Use attribute groups to create
> sysfs memory files") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
