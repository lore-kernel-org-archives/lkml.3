Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaFERO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:14:56 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36973 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaFEROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:14:53 -0400
MIME-Version: 1.0
In-Reply-To: <1401975635-6162-1-git-send-email-drysdale@google.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
Date: Thu, 5 Jun 2014 10:14:52 -0700
X-Google-Sender-Auth: XRIXWnpz9N8r5L6GQ6jFM6t2EK4
Message-ID: <CAGXu5jLjneRP=eF67k86cZNNGczZ=9-D4x9GQ-TaSKheCoG-Tg@mail.gmail.com>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
From: Kees Cook <keescook@chromium.org>
To: David Drysdale <drysdale@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, "x86@kernel.org" <x86@kernel.org>,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale@google.com> wrote:
> Resending, adding cc:linux-api.
>
> Also, it may help to add a little more background -- this patch is
> needed as a (small) part of implementing Capsicum in the Linux kernel.
>
> Capsicum is a security framework that has been present in FreeBSD since
> version 9.0 (Jan 2012), and is based on concepts from object-capability
> security [1].
>
> One of the features of Capsicum is capability mode, which locks down
> access to global namespaces such as the filesystem hierarchy.  In
> capability mode, /proc is thus inaccessible and so fexecve(3) doesn't
> work -- hence the need for a kernel-space alternative.
>
> [1] http://www.cl.cam.ac.uk/research/security/capsicum/papers/2010usenix-security-capsicum-website.pdf

Thanks for reposting!

I think it'd be quite helpful to have this available for very tightly
confined sandboxes. And in a larger sense, Capsicum itself is an
interesting way to do programmatic isolation.

-Kees

-- 
Kees Cook
Chrome OS Security
