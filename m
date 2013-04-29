Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab3D2VBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:01:45 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:40599 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab3D2VBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:01:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130429195100.202681236@goodmis.org>
References: <20130429195100.202681236@goodmis.org>
Date: Mon, 29 Apr 2013 14:01:42 -0700
X-Google-Sender-Auth: NDsEmbI-zJ-bh0jRB593frZlnCM
Message-ID: <CA+55aFzEwRUWVQ8x1+f=6R_9+JO_Rmg=u2E1k_6jLuQEAorgtQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] localmodconfig: Fix missing depends of
 config files included in if statements
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 12:51 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> Please pull the latest ktest-v3.10 tree, which can be found at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
> ktest-v3.10

Hmm. This is your ktest tree (which I already pulled the ktest changes
from), not your localmodconfig tree. But then all the explanations are
about your localmodconfig changes.

I assume you *meant* to ask me to pull your linux-kconfig.git tree?
That has a "ktest-v3.10" tag too, but I think that's a mistake too,
and you *meant* to make a tag called "localconfig" like you have done
in the past.

There's just too much confusion here for me to touch anything at all,
so please fix things up.

              Linus
