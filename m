Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaFKR4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:56:10 -0400
Received: from mail03-md.ns.itscom.net ([175.177.155.113]:35371 "EHLO
	mail03-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaFKR4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:56:08 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Linux 3.15 .. and continuation of merge window
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20140611123022.GW18016@ZenIV.linux.org.uk>
References: <CA+55aFw3A=ycq4kRpsDDoV4+rzg0z2kwfE9C9Bg1nSwiYfUpLw@mail.gmail.com> <13591.1402284634@jrobl> <20140611011036.GV18016@ZenIV.linux.org.uk> <26914.1402479178@jrobl> <20140611123022.GW18016@ZenIV.linux.org.uk>
Date: Thu, 12 Jun 2014 02:56:05 +0900
Message-ID: <26330.1402509365@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> The former guarantees that the address we are doing trylock on would be that
> of a live dentry.  The latter makes sure that anything assigned to 
> dentry->d_parent after we drop ->d_lock will not be freed until we drop
> rcu_read_lock.

Although I don't know how to reproduce the problem for the latter case,
I think the patch is good.


J. R. Okajima
