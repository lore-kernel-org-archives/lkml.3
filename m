Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3AWElP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:41:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:57952 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab3AWElL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:41:11 -0500
Date: Tue, 22 Jan 2013 20:42:36 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: manual merge of the driver-core tree with Linus' tree
Message-ID: <20130123044236.GB3079@kroah.com>
References: <20130123151552.1b8723dfa9c9a5dd75f7fec2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123151552.1b8723dfa9c9a5dd75f7fec2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 03:15:52PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/gpio/gpio-mvebu.c between commit 11c0ceec073c ("gpio: mvebu:
> Don't free chip label memory") from Linus' tree and commit 641d03422a59
> ("gpio: Convert to devm_ioremap_resource()") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
