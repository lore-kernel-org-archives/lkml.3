Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3CFCcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 21:32:12 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:35545 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3CFCcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 21:32:08 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1303041234550.3981@tux.localdomain>
References: <alpine.LFD.2.02.1303041234550.3981@tux.localdomain>
Date: Tue, 5 Mar 2013 18:32:07 -0800
X-Google-Sender-Auth: W85grtYjxkX9rmrTjx-vlMaAMfE
Message-ID: <CA+55aFxV=xs9a8H1YbFSjNzMeebixFaA4hShdHwfRKndFU8FUA@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 2:35 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> It contains more of Christoph's SLAB unification work that reduce the
> differences between different slab allocators. The code has been sitting
> in linux-next without problems.
>
> If you feel this is inappropriate for -rc2, just skip the pull and I'll
> requeue it for 3.10.

Ugh. It only came a day late, and if you had pushed a bit harder, I'd
have pulled it. But when you put it that way, I really cannot see any
valid reason why it cannot wait, and so I think I'll just expect it
for the next release.

If you change your mind and realize that it fixes some major bug and
really needs to be pulled after all, holler.

               Linus
