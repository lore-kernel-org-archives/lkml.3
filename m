Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaBTWDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:03:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaBTWDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:03:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1392931828.2594.12.camel@joe-AO722>
References: <1392931828.2594.12.camel@joe-AO722> <20140220211612.506074a7fd876e47130a8c5c@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Fabian Frederick <fabf@skynet.be>,
        linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] afs: afs_alloc_inode: use kmem_cache_zalloc
Date: Thu, 20 Feb 2014 22:03:37 +0000
Message-ID: <32240.1392933817@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> > - * initialise an inode cache slab element prior to any use
> > + * Initialize an inode cache slab element prior to any use
> 
> English spellings don't need to be changed to American.

Indeed! :-)

David
