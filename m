Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3AUVCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:02:24 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58978 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718Ab3AUVCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:02:22 -0500
X-Sasl-enc: ILzFNTygsECT8OfRAEw/2bY+zUhWkQkb7c1Py4WseB0c 1358802141
Date: Mon, 21 Jan 2013 13:02:19 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Frisch <wfpub@roembden.net>, Johan Hovold <jhovold@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus' tree
Message-ID: <20130121210219.GB9184@kroah.com>
References: <20130121150711.c4673d930c2f00253c2e471a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121150711.c4673d930c2f00253c2e471a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 03:07:11PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/serial/io_ti.c between commit 1ee0a224bc9a ("USB: io_ti: Fix
> NULL dereference in chase_port()") from Linus' tree and commit
> f40d781554ef ("USB: io_ti: kill custom closing_wait implementation") from
> the usb tree.
> 
> I fixed it up (the latter removed the code fixed by the former, so I just
> used thet) and can carry the fix as necessary (no action is required).

Yes, that is the correct fix, thanks for this.

greg k-h
