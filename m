Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbaDHP0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:26:13 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:52656 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaDHP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:26:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140407201919.GA15838@sepie.suse.cz>
References: <20140407201919.GA15838@sepie.suse.cz>
Date: Tue, 8 Apr 2014 08:26:09 -0700
X-Google-Sender-Auth: Kh0ocpV2FOB0j9nJ7BTaKisTJzc
Message-ID: <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 1:19 PM, Michal Marek <mmarek@suse.cz> wrote:
>
> besides the kbuild branch, here is the LTO build support by Andi. It is
> a separate branch, because it depends on other patches by Andi which
> were merged through other trees. The link-time-optimization build is an
> experimental feature, so there one kconfig option to enable it and
> another kconfig option to disable it (behind a door with a sign "Beware
> of the Leopard"...), so that it is not enabled by
> allmodconfig/allyesconfig.

So right now, I see several reasons not to merge it ("It's so
experimental that we don't even want to encourage people to test it"
to "it's not fully fleshed out yet and makes compile times _much_
longer").

And yet nobody has actually talked about why I *should* merge it.

Which - I think understandably - makes me less than enthusiastic.

So I think I'll let this wait a bit longer, _unless_ people start
talking about the upsides. How much smaller is the end result? How
much faster is it? How much more beautiful is it? Does it make new
cool things possible? Are those cool things really close on the
horizon and really want this merged even though it's not really quite
ready yet?

So please: convince me. Andi?

              Linus
