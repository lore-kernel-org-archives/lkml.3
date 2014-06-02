Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaFBT72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:59:28 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61487 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaFBT70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:59:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLYPbJKCBvhVxfHEUFeCPJO-OBhRFufUSNy6o1N=LJ6UQ@mail.gmail.com>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org> <CAGXu5jLYPbJKCBvhVxfHEUFeCPJO-OBhRFufUSNy6o1N=LJ6UQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 2 Jun 2014 12:59:06 -0700
Message-ID: <CALCETrV0ZEFipU0E64n5q44LiUV4j4Qqvnz0h_QAoddg+e7V3A@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@google.com>, Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 12:47 PM, Kees Cook <keescook@chromium.org> wrote:
> Hi Andrew,
>
> Would you be willing to carry this series? Andy Lutomirski appears
> happy with it now. (Thanks again for all the feedback Andy!) If so, it
> has a relatively small merge conflict with the bpf changes living in
> net-next. Would you prefer I rebase against net-next, let sfr handle
> it, get carried in net-next, or some other option?

Well, I'm still not entirely convinced that we want to have this much
multiplexing in a prctl, and I'm still a bit unconvinced that the code
wouldn't be better off it it were completely atomic in the sense that
it would either work or fail without doing anything.

--Andy
