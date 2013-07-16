Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3GPHTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:19:50 -0400
Received: from mail.lang.hm ([64.81.33.126]:33664 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab3GPHTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:19:48 -0400
Date: Tue, 16 Jul 2013 00:19:16 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Willy Tarreau <w@1wt.eu>
cc: "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: When to push bug fixes to mainline
In-Reply-To: <20130712051451.GC25815@1wt.eu>
Message-ID: <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013, Willy Tarreau wrote:

> And maybe in the end, having 1/10 patch cause a regression is not *that*
> dramatic, and probably less than not fixing the 9 other bugs. In one case
> we rely on -stable to merge the 10 fixes, and on the other case we'd rely
> on -stable to just revert one of them.

Apologies for the late post, I'm catching up on things, but this jumped out at 
me.

We went through a LOT of pain several years ago when people got into the mindset 
that a patch was acceptable if it fixed more people than it broke. eliminating 
that mindset did wonders for kernel stability.

Regressions are a lot more of a negative than bugfixes are a positive, a 10:1 
ratio of fixes to regressions is _not_ good enough.

David Lang
