Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbaFYRzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:55:13 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:44616 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbaFYRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:55:10 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAGXu5j+99NOtJq2-TWYm8mwNw1ki0y3rRH21wX66MVM8=jz1bQ@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
 <20140624205615.GW5412@outflux.net> <20140625140440.6870eac1@alan.etchedpixels.co.uk>
 <CAGXu5j+99NOtJq2-TWYm8mwNw1ki0y3rRH21wX66MVM8=jz1bQ@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 25 Jun 2014 19:54:49 +0200
Message-ID: <CAKgNAkgU+igKYKtzk3u83ZTcR-ov7kq_J9mbTeHuOt7Zkbpy6Q@mail.gmail.com>
Subject: Re: [PATCH v8 1/1] man-pages: seccomp.2: document syscall
To: Kees Cook <keescook@chromium.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
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

On Wed, Jun 25, 2014 at 5:10 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jun 25, 2014 at 6:04 AM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
>> On Tue, 24 Jun 2014 13:56:15 -0700
>> Kees Cook <keescook@chromium.org> wrote:
>>
>>> Combines documentation from prctl, in-kernel seccomp_filter.txt and
>>> dropper.c, along with details specific to the new syscall.
>>
>> What is the license on the example ? Probably you want to propogate the
>> minimal form of the text in seccomp/dropper into the document example to
>> avoid confusion ?
>
> What is the license of the other code examples in man-pages?

Typically, just the same as the rest if the page text. Perhaps that
should be rethought for future examples. I haven't thought about it at
length, but, at first glance, I'm not against having separate licenses
for the page text and the code sample.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
