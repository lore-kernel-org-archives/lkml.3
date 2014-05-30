Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaE3Eoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:44:39 -0400
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:37148 "EHLO
	mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaE3Eoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:44:37 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
To: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@gmail.com, mszeredi@suse.cz
In-Reply-To: <11446.1401420931@jrobl>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk> <11446.1401420931@jrobl>
Date: Fri, 30 May 2014 13:44:34 +0900
Message-ID: <16621.1401425074@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"J. R. Okajima":
> - readlink.test,
> 	fs_op readlink $file -R $testdir/direct_dir_sym100 ${termslash:+-E EINVAL}
>   It expects "$testdir/direct_dir_sym100". Does it mean UnionMount
>   converts the target path?
>   For example,
>   - /u = /rw + /ro
>   - /rw/symlinkA doesn't exist
>   - /ro/symlinkA points to /ro/fileA
>   Does readlink(2) return "/u/fileA" instead of "/u/fileA"?

Ouch!
I meant "Does ... instead of /ro/fileA?"


J. R. Okajima
