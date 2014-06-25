Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaFYPKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:10:45 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41918 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaFYPKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:10:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140625140440.6870eac1@alan.etchedpixels.co.uk>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
	<20140624205615.GW5412@outflux.net>
	<20140625140440.6870eac1@alan.etchedpixels.co.uk>
Date: Wed, 25 Jun 2014 08:10:41 -0700
X-Google-Sender-Auth: bCbTkPScOTHELah4xx8OXxxVzrQ
Message-ID: <CAGXu5j+99NOtJq2-TWYm8mwNw1ki0y3rRH21wX66MVM8=jz1bQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/1] man-pages: seccomp.2: document syscall
From: Kees Cook <keescook@chromium.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 6:04 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Tue, 24 Jun 2014 13:56:15 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> Combines documentation from prctl, in-kernel seccomp_filter.txt and
>> dropper.c, along with details specific to the new syscall.
>
> What is the license on the example ? Probably you want to propogate the
> minimal form of the text in seccomp/dropper into the document example to
> avoid confusion ?

What is the license of the other code examples in man-pages?

-Kees

-- 
Kees Cook
Chrome OS Security
