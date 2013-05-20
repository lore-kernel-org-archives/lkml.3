Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab3ETEPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 00:15:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49879 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab3ETEPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 00:15:21 -0400
X-Sasl-enc: lJJNf8y2c7+vsLB/P8AjKkS+FfK5aILhiIpbXA+1e/sK 1369023318
Date: Sun, 19 May 2013 21:15:36 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Libo Chen <clbchenlibo.chen@huawei.com>
Subject: Re: linux-next: manual merge of the usb.current tree with Linus' tree
Message-ID: <20130520041536.GA15865@kroah.com>
References: <20130520102159.18f2f976cb4000e48b45731e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520102159.18f2f976cb4000e48b45731e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:21:59AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb.current tree got a conflict in
> drivers/usb/host/ohci-nxp.c between commit bb522812a1a6
> ("drivers/usb/host: don't check resource with devm_ioremap_resource")
> from Linus' tree and commit b3517d5de80e ("usb: ohci: fix goto wrong tag
> in err case") from the usb.current tree.
> 
> The former remove a bit of code modified by the latter, so I did that and
> can carry the fix as necessary (no action is required).

Sounds fine to me, thanks.

greg k-h
