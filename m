Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaFEWO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:14:58 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:45398 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaFEWO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:14:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140605053032.E84EE146058C@linuxdev-32>
References: <20140605053032.E84EE146058C@linuxdev-32>
Date: Thu, 5 Jun 2014 15:14:55 -0700
X-Google-Sender-Auth: AGZanv8WEUyN9rNx8lyebuqEIaA
Message-ID: <CA+55aFzjjgXhCgyzzsq2iCH6=X_GVPF-cw8TW6dsNuoQJcYKeQ@mail.gmail.com>
Subject: Re: [GIT PULL] UniCore32 update for v3.15-rc8
From: Linus Torvalds <torvalds@linux-foundation.org>
To: guanxuetao <guanxuetao@mprc.pku.edu.cn>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 10:30 PM, guanxuetao <guanxuetao@mprc.pku.edu.cn> wrote:
>
> This is unicore32 pull request for v3.15-rc8.

So I can't pull this, because you rebased it recently, and you rebased
it on a random git-tree-of-the-day thing.

That's a bad idea in general and I ask people to not do that, but it's
*doubly* bad this time, because I don't think it's critical enough to
hit 3.15 (there are *no* unicore32 changes pending in 3.15, so "fixes"
that come in after -rc8 are clearly not fixing anything that happened
during the merge window).

So I could pull it into my "next" branch for 3.16, but that one was
based on 3.15-rc8, and you rebased your patches on top of somethinig
more recent than that.

End result: I'm not pulling this. You shouldn't have rebased things in
the first place, and you definitely shouldn't have rebased on some
random "git tree of the day" that wasn't any real release or even rc.

I can pull it after I've done 3.15 and merged that into my next branch
(which will then become my normal "master" branch), because by then my
development tree will have the base that you used for applying your
patches.

            Linus
