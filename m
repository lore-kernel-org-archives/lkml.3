Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3COFNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:13:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51631 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3COFN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:13:29 -0400
Date: Fri, 15 Mar 2013 05:13:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
Message-ID: <20130315051322.GX21522@ZenIV.linux.org.uk>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <20130313160854.54ac0491044371b4db214698@linux-foundation.org>
 <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com>
 <20130315012541.GU21522@ZenIV.linux.org.uk>
 <19058.1363320936@jrobl>
 <20130315044411.GW21522@ZenIV.linux.org.uk>
 <20079.1363324154@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20079.1363324154@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 02:09:14PM +0900, J. R. Okajima wrote:

> If so, it has a big disadvantage for the layer-fs (or branch-fs) to have
> to implement a new method for whiteout.
> 
> Overlayfs implements whiteout as symlink+xattr which consumes an
> inode. And you don't like it, right?
> What I showed is another generic approach without xattr where the new
> method to whiteout is unnecessary.

I'm yet to see the reason that would make implementing that method a big
disadvantage, TBH...
