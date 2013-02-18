Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3BREpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 23:45:19 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48634 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756725Ab3BREpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 23:45:17 -0500
X-Sasl-enc: Kqmq98X0t9gYOnUp/5oI/UP+FVDTCssL0AcBRSucyhsS 1361162715
Date: Sun, 17 Feb 2013 20:45:35 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Manjunath Goudar <manjunath.goudar@linaro.org>
Subject: Re: linux-next: manual merge of the usb tree with the driver-core
 tree
Message-ID: <20130218044535.GA28277@kroah.com>
References: <20130218153242.747962940bbed03bfdb2623b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130218153242.747962940bbed03bfdb2623b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 03:32:42PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/ehci-vt8500.c between commit 148e11349b0c ("usb: Convert
> to devm_ioremap_resource()") from the driver-core tree and commit
> d57ada0c37ec ("USB: EHCI: make ehci-vt8500 a separate driver") from the
> usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
