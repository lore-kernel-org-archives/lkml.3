Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3CLEJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:09:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:38938 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab3CLEJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:09:07 -0400
Date: Tue, 12 Mar 2013 15:09:45 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Greg KH <gregkh@linuxfoundation.org>
cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
        keyrings@linux-nfs.org, pmatouse@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org, mguzik@redhat.com, ben@decadent.org.uk
Subject: Re: [PATCH] KEYS: Fix race with concurrent install_user_keyrings()
In-Reply-To: <20130311210211.GA13575@kroah.com>
Message-ID: <alpine.LRH.2.02.1303121509340.25612@tundra.namei.org>
References: <20130306222412.1255.81929.stgit@warthog.procyon.org.uk> <alpine.LRH.2.02.1303071558030.25164@tundra.namei.org> <20130311210211.GA13575@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013, Greg KH wrote:

> On Thu, Mar 07, 2013 at 03:59:09PM +1100, James Morris wrote:
> > On Wed, 6 Mar 2013, David Howells wrote:
> > 
> > > Reported-by: Mateusz Guzik <mguzik@redhat.com>
> > > Signed-off-by: David Howells <dhowells@redhat.com>
> > 
> > Acked-by: James Morris <james.l.morris@oracle.com>
> 
> What happened to this patch?  I don't see it in Linus's tree, James, did
> you pick it up?

I'll push it to Linus.


-- 
James Morris
<jmorris@namei.org>
