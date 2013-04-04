Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764179Ab3DDT6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:58:48 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46522 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763740Ab3DDT6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:58:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+jpXrcLDyAV+p81pjapaQeKQTMz4+JXjKj03DV-yoC=w@mail.gmail.com>
References: <1363618233-6375-1-git-send-email-nschichan@freebox.fr>
	<1363618233-6375-2-git-send-email-nschichan@freebox.fr>
	<CAGXu5j+jpXrcLDyAV+p81pjapaQeKQTMz4+JXjKj03DV-yoC=w@mail.gmail.com>
Date: Thu, 4 Apr 2013 14:58:46 -0500
Message-ID: <CABqD9hZp7FiQjvLrauV1rkUqgXZyCxmbOKA+6rzpDNEEfJ0NPw@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] seccomp: add generic code for jitted seccomp filters.
From: Will Drewry <wad@chromium.org>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Mircea Gherzan <mgherzan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 4:53 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Mar 18, 2013 at 7:50 AM, Nicolas Schichan <nschichan@freebox.fr> wrote:
>> Architecture must select HAVE_SECCOMP_FILTER_JIT and implement
>> seccomp_jit_compile() and seccomp_jit_free() if they intend to support
>> jitted seccomp filters.
>>
>> struct seccomp_filter has been moved to <linux/seccomp.h> to make its
>> content available to the jit compilation code.
>>
>> In a way similar to the net BPF, the jit compilation code is expected
>> to updates struct seccomp_filter.bpf_func pointer to the generated
>> code.
>>
>> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
>
> Acked-by: Kees Cook <keescook@chromium.org>
>
> I'd love to see this for x86 too. I suspect it'd be a small change
> after this series lands.

Agreed - and thanks for working through the necessary changes!

Acked-By: Will Drewry <wad@chromium.org>
(for the series)
