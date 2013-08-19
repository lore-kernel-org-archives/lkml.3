Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126Ab3HSQd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:33:29 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:55478 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3HSQd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:33:27 -0400
MIME-Version: 1.0
In-Reply-To: <1376904368.2679.9.camel@menhir>
References: <1376904368.2679.9.camel@menhir>
Date: Mon, 19 Aug 2013 09:33:27 -0700
X-Google-Sender-Auth: NCLEW1kGH-T80ChlDvzrIgIlLVU
Message-ID: <CA+55aFxtDL=qOJ60gZEaokoW8bV8ZkrMoaOQasaAsY9hiTs-zA@mail.gmail.com>
Subject: Re: GFS2: Pull request (fixes)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cluster-devel@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 2:26 AM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Oops, forgot to sign this when I sent it first, so here is a signed copy of it.

Please sign the git tag instead of the email. There are no sane tools
to check email signatures etc, but git signed tags not only check your
pgp key signature, they also allow you to just write the message into
the tag.

Also, please don't do crap like this:

> are available in the git repository at:
>
>   https://git.kernel.org/cgit/linux/kernel/git/steve/gfs2-3.0-fixes.git master

Yeah, no. The proper address is

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes

not that cgit web page.

                 Linus
