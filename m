Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3F0RWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:22:53 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60728 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3F0RWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:22:51 -0400
Date: Thu, 27 Jun 2013 18:22:47 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/2] overlayfs -- follow change to do_splice_direct
 interface
Message-ID: <20130627172247.GC5467@bark>
References: <1372350404-10359-1-git-send-email-apw@canonical.com>
 <1372350404-10359-4-git-send-email-apw@canonical.com>
 <CAJfpegsYPDi2oxt0WKHFrwYBjrk6-SNj_owghtOGxqyVVG45uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsYPDi2oxt0WKHFrwYBjrk6-SNj_owghtOGxqyVVG45uQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 06:37:45PM +0200, Miklos Szeredi wrote:
> Thanks for the patches, Andy.  I already pushed a similar set of fixes
> to overlayfs.current (.v18) and to .v17 for the dentry_open() refcount
> fix.

Bah so you did, that'll teach me for waiting for them to be tested.

> It is interesting how many people end up fixing this the wrong way ;)
> 
> Hint: how will the file offsets advance?

Interesting I got bluffed in by the original implementation which
reloaded the source pos each time.

-apw
