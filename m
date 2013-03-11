Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3CKVCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:02:17 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57406 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3CKVCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:02:14 -0400
Date: Mon, 11 Mar 2013 14:02:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
        keyrings@linux-nfs.org, pmatouse@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org, mguzik@redhat.com, ben@decadent.org.uk
Subject: Re: [PATCH] KEYS: Fix race with concurrent install_user_keyrings()
Message-ID: <20130311210211.GA13575@kroah.com>
References: <20130306222412.1255.81929.stgit@warthog.procyon.org.uk>
 <alpine.LRH.2.02.1303071558030.25164@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1303071558030.25164@tundra.namei.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 03:59:09PM +1100, James Morris wrote:
> On Wed, 6 Mar 2013, David Howells wrote:
> 
> > Reported-by: Mateusz Guzik <mguzik@redhat.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Acked-by: James Morris <james.l.morris@oracle.com>

What happened to this patch?  I don't see it in Linus's tree, James, did
you pick it up?

thanks,

greg k-h
