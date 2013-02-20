Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852Ab3BTEeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:34:02 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47505 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934191Ab3BTEd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:33:59 -0500
X-Sasl-enc: I+AxqhjyZujxiq5JWqy6cgjCkBNPO+C3ppGdfHoJA77y 1361334837
Date: Tue, 19 Feb 2013 20:34:24 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the virtio
 tree
Message-ID: <20130220043424.GA2513@kroah.com>
References: <20130220152507.4d7405fcb3561213b4ccd7ab@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220152507.4d7405fcb3561213b4ccd7ab@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 03:25:07PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got conflicts in
> drivers/vhost/Kconfig and drivers/vhost/Kconfig.tcm between commit
> 4d8dc8b44748 ("vringh: host-side implementation of virtio rings") from
> the virtio tree and commit 43893cbefc1b ("drivers/vhost: remove depends
> on CONFIG_EXPERIMENTAL") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
