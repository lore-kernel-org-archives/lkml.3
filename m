Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3GNT6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:58:43 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:41093 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3GNT6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.03.1307142205090.2124@kernel.org>
References: <alpine.LFD.2.03.1307142205090.2124@kernel.org>
Date: Sun, 14 Jul 2013 12:58:41 -0700
X-Google-Sender-Auth: oxHTIWREUdgz_SvnudVLYPpUe7Y
Message-ID: <CA+55aFytd8NZeX1ux8U56uQk65N3jcq_7UMv1RrFgAPmLJc-dw@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v3.11-rc0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 12:06 PM, Pekka Enberg <penberg@kernel.org> wrote:
>
> The tree also contains Christoph's unification work that I merged in
> too late had to revert because it broke things. We'll try again for
> v3.12.

Ugh. I'll merge the commits leading up to that, but not the actual
broken try at unification at all.

There's just one one-liner patch in between the broken commits and
their reverts, I don't see the point of pulling that part at all, and
I can take the one-liner separately.

              Linus
