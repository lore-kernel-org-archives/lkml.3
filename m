Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaE2K1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:27:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaE2K1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:27:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140528160653.GL17233@tucsk.piliscsaba.szeredi.hu>
References: <20140528160653.GL17233@tucsk.piliscsaba.szeredi.hu> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <25513.1401069402@jrobl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, "J. R. Okajima" <hooanon05g@gmail.com>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 00/13] overlay filesystem v22
Date: Thu, 29 May 2014 11:26:44 +0100
Message-ID: <27746.1401359204@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Perfect solution would be an invisible temp directory.  This needs filesystem
> support, but perhaps not so difficult.  Again could be done later without
> backward compatibility issues.

Maybe make a tempfile and hardlink it into place when complete.  That's what
unionmount is doing.

David
