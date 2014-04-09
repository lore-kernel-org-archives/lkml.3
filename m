Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895AbaDITXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:23:50 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:33711 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118AbaDITXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <5345258C.1070308@ti.com>
References: <5345258C.1070308@ti.com>
Date: Wed, 9 Apr 2014 12:23:47 -0700
X-Google-Sender-Auth: 8J3at8F1Z5jFXkgvHxMh-4rtfcc
Message-ID: <CA+55aFytXaTBE6Uf2H=C-XX01Pk1-QArF6u7+yhditk-cJLVQw@mail.gmail.com>
Subject: Re: [GIT PULL] fbdev reorder for 3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 3:48 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>
> The patches are based on 3.14-rc4, and cause big conflicts, although the
> conflicts are not complex as such. They are resolved in linux-next, and also in
> my two branches below. The first one contains a resolved merge for your master
> branch, the second one contains rebased patches on top of your master.

Ok, I did the merge, and it wasn't horrid, although it was good that
you had pre-merged and I could double-check because I did miss some
things (that would likely have shown up in my test builds, but maybe
not).

But looking at the reaulting history, I think I will undo the merge
after all, and end up using your rebased branch instead. Simply
because the mixed file movement and other changes during this merge
window just make the end result unnecessarily hard to follow wrt how
the changes happened.

Let me ruminate on this a while. I don't generally like rebasing, but
for something fairly "mindless" like the file rename, it seems a
better option.

Are there other things pending in this area? Because if there are, I
think I'll take you up on your "or we can rebase on top of -rc1" offer
instead.

          Linus
