Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3FRQCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:02:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38821 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648Ab3FRQCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:02:48 -0400
X-Sasl-enc: MnFBxaPkA++kdoJtXClFIxoP8rUEWzXVR5opISwKQhHC 1371571356
Date: Tue, 18 Jun 2013 09:03:12 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tushar Behera <tushar.behera@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
Message-ID: <20130618160312.GB28961@kroah.com>
References: <20130618161239.5ce92432180d9418831d2514@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618161239.5ce92432180d9418831d2514@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 04:12:39PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/usb/phy/phy-rcar-usb.c between commit 56a9a6de2a87 ("usb: phy:
> rcar-usb: Fix comment w.r.t. devm_ioremap_resource") from the usb tree
> and commit 725bf9dcafe1 ("phy-rcar-usb: correct base address") from the
> arm-soc tree.
> 
> I fixed it up (The latter removed the comment corrected by the former)
> and can carry the fix as necessary (no action is required).

That sounds fine to me, thanks.

greg k-h
