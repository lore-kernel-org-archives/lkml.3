Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab3CKVVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:21:21 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59273 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3CKVVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:21:18 -0400
Date: Mon, 11 Mar 2013 14:21:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        torvalds@linux-foundation.org, keyrings@linux-nfs.org,
        pmatouse@redhat.com, security@kernel.org, linux-kernel@vger.kernel.org,
        mguzik@redhat.com, ben@decadent.org.uk
Subject: Re: [PATCH] KEYS: Fix race with concurrent install_user_keyrings()
Message-ID: <20130311212114.GA1118@kroah.com>
References: <20130306222412.1255.81929.stgit@warthog.procyon.org.uk>
 <alpine.LRH.2.02.1303071558030.25164@tundra.namei.org>
 <20130311210211.GA13575@kroah.com>
 <20130311141032.7c0fa60279fa172b72fc0bf7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311141032.7c0fa60279fa172b72fc0bf7@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 02:10:32PM -0700, Andrew Morton wrote:
> On Mon, 11 Mar 2013 14:02:11 -0700 Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Thu, Mar 07, 2013 at 03:59:09PM +1100, James Morris wrote:
> > > On Wed, 6 Mar 2013, David Howells wrote:
> > > 
> > > > Reported-by: Mateusz Guzik <mguzik@redhat.com>
> > > > Signed-off-by: David Howells <dhowells@redhat.com>
> > > 
> > > Acked-by: James Morris <james.l.morris@oracle.com>
> > 
> > What happened to this patch?  I don't see it in Linus's tree, James, did
> > you pick it up?
> 
> James has acked it.  I have it queued for processing so it isn't lost. 

Ok, I'll keep a lookout for it.

> It has no cc:stable's in it, but David always forgets that ;)

Yeah, I'm used to that :)
