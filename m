Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaBYQry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:47:54 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47696 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbaBYQrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:47:52 -0500
X-Sasl-enc: XqKchg1qdw0ItRm2Wh8Wr1gmwD/TiIR6pSie1ZEP94M+ 1393346867
Date: Tue, 25 Feb 2014 08:49:21 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: linux-next: manual merge of the staging tree with the arm-soc
 tree
Message-ID: <20140225164921.GA4458@kroah.com>
References: <20140225170944.d322d9868871bc2f669b92e5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225170944.d322d9868871bc2f669b92e5@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 05:09:44PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> arch/arm/boot/dts/imx53-qsb.dts between commit d5eb195f26fa ("ARM: dts:
> i.MX53: move common QSB nodes to new file") from the arm-soc tree and
> commit 17b5001b5143 ("imx-drm: convert to componentised device support")
> from the staging tree.
> 
> I fixed it up (see at bottom) and can carry the fix as necessary (no
> action is required).  I also added the following fix up patch:

I think it's right, but I really have no idea about any of these.  I'll
defer to Russell to ensure they are correct.

thanks,

greg k-h
