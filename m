Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3A2Njn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:39:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:45067 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab3A2Njl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:39:41 -0500
Date: Tue, 29 Jan 2013 05:41:27 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the driver-core
 tree
Message-ID: <20130129134127.GC1505@kroah.com>
References: <20130128212309.58732e2b08398c4ecf326dfb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128212309.58732e2b08398c4ecf326dfb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 09:23:09PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/musb/omap2430.c between commit 148e11349b0c ("usb: Convert to
> devm_ioremap_resource()") from the driver-core tree and commit
> ca784be36cc7 ("usb: start using the control module driver") from the usb
> tree.
> 
> I fixed it up (the latter removed the code modified by the former, so I
> did that) and can carry the fix as necessary (no action is required).

Looks good, thanks.

greg k-h
