Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbaLBSMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:12:38 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51874 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932861AbaLBSMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:12:32 -0500
X-Sasl-enc: uz5fg03xbPjRhjyeVzbYSc7dSr4JyN7uleQgRsIXNU6o 1417543951
Date: Tue, 2 Dec 2014 10:12:30 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20141202181230.GD11700@kroah.com>
References: <20141201191923.6366f9b5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201191923.6366f9b5@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 07:19:23PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the usb tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> arch/arm/mach-omap2/twl-common.c:94:21: error: array type has incomplete element type
>  struct phy_consumer consumers[] = {
>                      ^
> 
> Caused by commit dbc98635e0d4 ("phy: remove the old lookup method").
> 
> I have used the usb tree from next-20141128 for today.

Ick, Heikki and Kishon, do you want me to just revert this patch?  How
did you test it?

greg k-h
