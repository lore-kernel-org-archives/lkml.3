Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaI2WAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:00:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaI2WAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:00:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140929141457.GB5011@tucsk.piliscsaba.szeredi.hu>
References: <20140929141457.GB5011@tucsk.piliscsaba.szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-unionfs@vger.kernel.org
Subject: Re: [PULL for 3.18] overlay filesystem v24
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26821.1412028003.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Sep 2014 23:00:03 +0100
Message-ID: <26822.1412028003@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> I'd like to propose overlayfs for inclusion into 3.18.
> 
> Al, would you mind giving it a review?
> 
> Git tree is here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.current

Tested-by: David Howells <dhowells@redhat.com>
