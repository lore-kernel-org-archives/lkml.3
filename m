Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070Ab3CGX3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:29:05 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55893 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218Ab3CGX3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:29:03 -0500
Date: Fri, 8 Mar 2013 07:24:53 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Andy King <acking@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        pv-drivers@vmware.com
Subject: Re: [PATCH] VSOCK: Split vm_sockets.h into kernel/uapi
Message-ID: <20130307232453.GD10304@kroah.com>
References: <1362669973-26984-1-git-send-email-acking@vmware.com>
 <26621.1362675490@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26621.1362675490@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 04:58:10PM +0000, David Howells wrote:
> Andy King <acking@vmware.com> wrote:
> 
> > Split the vSockets header into kernel and UAPI parts.  The former gets the bits
> > that used to be in __KERNEL__ guards, while the latter gets everything that is
> > user-visible.  Tested by compiling vsock (+transport) and a simple user-mode
> > vSockets application.
> > 
> > Reported-by: David Howells <dhowells@redhat.com>
> > Acked-by: Dmitry Torokhov <dtor@vmware.com>
> > Signed-off-by: Andy King <acking@vmware.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>

David, is there any rush to get stuff like this into 3.9 for any
uapi-type changes, or can it just wait for 3.10?

thanks,

greg k-h
