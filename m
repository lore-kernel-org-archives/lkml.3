Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3JOAwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:52:09 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:51056 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3JOAwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:52:08 -0400
MIME-Version: 1.0
In-Reply-To: <1381774575-8817-1-git-send-email-roland@kernel.org>
References: <1381774575-8817-1-git-send-email-roland@kernel.org>
Date: Mon, 14 Oct 2013 17:52:06 -0700
X-Google-Sender-Auth: XWwJBOHytK6kqeYuEnuHjeOKfzc
Message-ID: <CA+55aFw151GyGbAEStnvj41pokNfUegQW2uGWFw59FCvT--jRA@mail.gmail.com>
Subject: Re: [GIT PULL] please pull infiniband.git
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland Dreier <roland@kernel.org>, Eli Cohen <eli@mellanox.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 11:16 AM, Roland Dreier <roland@kernel.org> wrote:
>
> Last batch of IB changes for 3.12: many mlx5 hardware driver fixes plus
> one trivial semicolon cleanup.

Quite frankly, these mlx5 updates don't look like regression fixes.
They look like "continued development" to me, and seem to be things
that never worked. At least some of them look like performance
enhancements, in fact, not even resembling bugfixes. Others look like
"not a bug, but let's improve random behavior".

I pulled this once, because hardly anybody really cares. But the other
side of that "nobody cares" is that I might as well not have pulled.
If this kind of "continued development" patches keep happening, I'll
just start ignoring pull requests after the merge window.

So get your act together, and push back on the people you are supposed
to manage. Because this is *not* acceptable for post-rc5, and I'm
giving this single warning. Next time, I'll just ignore the sh*t you
send me.

Comprende?

             Linus
