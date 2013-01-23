Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3AWEvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:51:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:58089 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab3AWEvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:51:17 -0500
Date: Tue, 22 Jan 2013 20:52:42 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <florian@openwrt.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the net-next
 tree
Message-ID: <20130123045242.GA3309@kroah.com>
References: <20130123154525.9f1bd6652f13f2a7a8202bf6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123154525.9f1bd6652f13f2a7a8202bf6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 03:45:25PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/et131x/et131x.c between commit f9a8f83b04e0 ("net: phy:
> remove flags argument from phy_{attach, connect, connect_direct}") from
> the net-next tree and commit 26ef1021c1c7 ("staging: et131x: Modify block
> comments to fit with networking style") from the staging tree.
> 
> I fixed it up (the former adjusted the white space in the same was as the
> latter, so I used thet) and can carry the fix as necessary (no action is
> required).

That sounds good to me, thanks.

greg k-h
