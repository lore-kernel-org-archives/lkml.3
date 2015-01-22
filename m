Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbbAVT4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:56:39 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:52601 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbAVT4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:56:36 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1421954363.git.luto@amacapital.net>
References: <cover.1421954363.git.luto@amacapital.net>
Date: Fri, 23 Jan 2015 07:56:35 +1200
X-Google-Sender-Auth: yrpDXB77Syj4pybzdSCFTQiQdTg
Message-ID: <CA+55aFyQ9zfeNoboW_ypYoKCO55CM_9X0Qgi5NkU4AAqSmPuWQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86: TLS regression fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 7:27 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Thoughts?

Looks good to me.

And since I curse at people who ignore regression reports because "it
fixes a bug", I should take the time to say how much I liked seeing
you explain to the people who reported this regression why it happened
and what the thinking was. Now *that* is how things should work. "My
bad, this was the background for why it seemed like a good idea".

And I guess the second patch should also be marked for stable, since
the thing that causes problems got backported too.

                 Linus
