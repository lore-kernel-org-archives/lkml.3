Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3COBZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:25:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50900 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab3COBZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:25:50 -0400
Date: Fri, 15 Mar 2013 01:25:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
Message-ID: <20130315012541.GU21522@ZenIV.linux.org.uk>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <20130313160854.54ac0491044371b4db214698@linux-foundation.org>
 <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 02:43:32PM +0100, Miklos Szeredi wrote:

> > Either way, I suggest the next step is to ask Stephen to line this up
> > in linux-next.
> 
> Al, are you okay with that?  Or do you want it to go though -vfs?

Umm...  I would prefer it to go through vfs.git, with serious modifications.
I really don't like the idea of xattr-based whiteouts, for example.
