Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaE0P1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:27:07 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60557 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777AbaE0P1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:27:04 -0400
X-Sasl-enc: RF6+gGmCYuk6z8JYyKXMwy1oLTDc1qRHX/h9OifcSmCB 1401204420
Date: Tue, 27 May 2014 08:30:34 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Rob Herring <robh@kernel.org>
Subject: Re: linux-next: manual merge of the tty tree with the m68k tree
Message-ID: <20140527153034.GA20250@kroah.com>
References: <20140527165337.5c7d4fa4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527165337.5c7d4fa4@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 04:53:37PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> Documentation/kernel-parameters.txt between commit d5ebf7cc86a7 ("m68k:
> Multi-platform EARLY_PRINTK") from the m68k tree and commit
> 0d3c673e7881 ("tty/serial: pl011: add generic earlycon support") from
> the tty tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).  Thanks Geert for the heads up.

Looks good, thanks.

greg k-h
