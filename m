Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab3DAVxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:53:12 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37405 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3DAVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:53:10 -0400
MIME-Version: 1.0
In-Reply-To: <1363618233-6375-2-git-send-email-nschichan@freebox.fr>
References: <1363618233-6375-1-git-send-email-nschichan@freebox.fr>
	<1363618233-6375-2-git-send-email-nschichan@freebox.fr>
Date: Mon, 1 Apr 2013 14:53:09 -0700
X-Google-Sender-Auth: RdjL7wsmZj5eQRVhG64VfSJxOuQ
Message-ID: <CAGXu5j+jpXrcLDyAV+p81pjapaQeKQTMz4+JXjKj03DV-yoC=w@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] seccomp: add generic code for jitted seccomp filters.
From: Kees Cook <keescook@chromium.org>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 7:50 AM, Nicolas Schichan <nschichan@freebox.fr> wrote:
> Architecture must select HAVE_SECCOMP_FILTER_JIT and implement
> seccomp_jit_compile() and seccomp_jit_free() if they intend to support
> jitted seccomp filters.
>
> struct seccomp_filter has been moved to <linux/seccomp.h> to make its
> content available to the jit compilation code.
>
> In a way similar to the net BPF, the jit compilation code is expected
> to updates struct seccomp_filter.bpf_func pointer to the generated
> code.
>
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>

Acked-by: Kees Cook <keescook@chromium.org>

I'd love to see this for x86 too. I suspect it'd be a small change
after this series lands.

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
