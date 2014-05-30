Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaE3JP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:15:59 -0400
Received: from mail02-md.ns.itscom.net ([175.177.155.112]:56865 "EHLO
	mail02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaE3JP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:15:56 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@gmail.com, mszeredi@suse.cz
In-Reply-To: <7184.1401439773@warthog.procyon.org.uk>
References: <11446.1401420931@jrobl> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk> <7184.1401439773@warthog.procyon.org.uk>
Date: Fri, 30 May 2014 18:15:50 +0900
Message-ID: <2325.1401441350@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells:
> >   Does readlink(2) return "/u/fileA" instead of /ro/fileA?"
>
> No.
>
> The test suite sets the lower symlink to point to the union path for its target.
>
> [root@andromeda union-testsuite]# readlink /lower/a/indirect_dir_sym100 
> /mnt/a/direct_dir_sym100

Now I've found your latest commit fixed the path.
No problemo.


J. R. Okajima
