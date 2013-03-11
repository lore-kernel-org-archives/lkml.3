Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab3CKVKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:10:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3CKVKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:10:35 -0400
Date: Mon, 11 Mar 2013 14:10:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        torvalds@linux-foundation.org, keyrings@linux-nfs.org,
        pmatouse@redhat.com, security@kernel.org, linux-kernel@vger.kernel.org,
        mguzik@redhat.com, ben@decadent.org.uk
Subject: Re: [PATCH] KEYS: Fix race with concurrent install_user_keyrings()
Message-Id: <20130311141032.7c0fa60279fa172b72fc0bf7@linux-foundation.org>
In-Reply-To: <20130311210211.GA13575@kroah.com>
References: <20130306222412.1255.81929.stgit@warthog.procyon.org.uk>
	<alpine.LRH.2.02.1303071558030.25164@tundra.namei.org>
	<20130311210211.GA13575@kroah.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013 14:02:11 -0700 Greg KH <gregkh@linuxfoundation.org> wrote:

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

James has acked it.  I have it queued for processing so it isn't lost. 
It has no cc:stable's in it, but David always forgets that ;)

