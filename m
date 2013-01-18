Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3ARB1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:27:54 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33495 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776Ab3ARB1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:27:52 -0500
X-Sasl-enc: QWbwUKkUE1n/GH1k5/jh25HyyoZexUSxQXvpV0V+UYn7 1358472471
Date: Thu, 17 Jan 2013 17:27:50 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: linux-next: manual merge of the tty tree with the tty.current
 tree
Message-ID: <20130118012750.GA29054@kroah.com>
References: <20130117130738.b3d750f70143792e9471063c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130117130738.b3d750f70143792e9471063c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 01:07:38PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/serial/8250/8250_dw.c between commit 68e56cb3a068 ("tty:
> 8250_dw: Fix inverted arguments to serial_out in IRQ handler") from the
> tty.current tree and commit 30046df26187 ("serial: 8250_dw: Set FIFO size
> dynamically") from the tty tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
