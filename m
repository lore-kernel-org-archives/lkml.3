Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3HACZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:25:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56063 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3HACZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130731221421.616d3d20@annuminas.surriel.com>
References: <20130731174335.006a58f9@annuminas.surriel.com>
	<CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
	<51F98CAB.80100@redhat.com>
	<CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com>
	<51F99218.4060104@redhat.com>
	<CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com>
	<51F999DE.7080200@redhat.com>
	<CAPM31R+BiTiLbNrD+33q31z8Ww7dpm7t1vcLak-hZ-z5L2PY-g@mail.gmail.com>
	<CA+55aFwTNQFFJbeP4bYuMBREq=n6GU2vV71ftr_7OnE6SK5OSw@mail.gmail.com>
	<20130731221421.616d3d20@annuminas.surriel.com>
Date: Wed, 31 Jul 2013 19:25:27 -0700
X-Google-Sender-Auth: m__fxnzEQfJl4p4KWjeDu1tkc7k
Message-ID: <CA+55aFzsUhBU2S_GmwYicttnf5MM1Z723xZ9UgYCi5kr8psYEQ@mail.gmail.com>
Subject: Re: [PATCH -v2] sched,x86: optimize switch_mm for multi-threaded workloads
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 7:14 PM, Rik van Riel <riel@redhat.com> wrote:
>
> Is this better?  Not that I really care which version gets applied :)

I'm ok with this.

That said, I'm assuming this goes in through Ingo, since it is both
x86 and scheduler-related. I can take it directly, but see no real
reason to. Ingo?

Talking about x86-specific - I'm assuming other architectures have
similar patterns?

               Linus
