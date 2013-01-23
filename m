Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028Ab3AWFBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:01:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:58321 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab3AWFBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:01:49 -0500
Date: Tue, 22 Jan 2013 21:03:14 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: linux-next: manual merge of the pinctrl tree with the
 driver-core tree
Message-ID: <20130123050314.GA3450@kroah.com>
References: <20130123155852.e8b35c4e85b0c65c4635b422@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123155852.e8b35c4e85b0c65c4635b422@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 03:58:52PM +1100, Stephen Rothwell wrote:
> Hi Linus,
> 
> Today's linux-next merge of the pinctrl tree got a conflict in
> drivers/pinctrl/pinctrl-nomadik.c between commit 9e0c1fb29a7c ("pinctrl:
> Convert to devm_ioremap_resource()") from the driver-core tree and commit
> 50f690d85e4e ("pinctrl/nomadik: simplify GPIO probe") from the pinctrl
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
