Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaKZV7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:59:14 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45620 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKZV7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:59:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141127084614.209450b9@canb.auug.org.au>
References: <20141125194319.GA9328@www.outflux.net>
	<alpine.LRH.2.11.1411270022240.22560@namei.org>
	<20141127084614.209450b9@canb.auug.org.au>
Date: Wed, 26 Nov 2014 13:59:11 -0800
X-Google-Sender-Auth: fAv504a-xeO5n0sKBKBso_NWujQ
Message-ID: <CAGXu5jJQK39HnyVMmVrerY+wiL+P80JTE8nscDa7Wyyk1hZing@mail.gmail.com>
Subject: Re: [PULL] seccomp update (next)
From: Kees Cook <keescook@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pranith Kumar <bobby.prani@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 1:46 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi James,
>
> On Thu, 27 Nov 2014 00:23:06 +1100 (AEDT) James Morris <jmorris@namei.org> wrote:
>>
>> On Tue, 25 Nov 2014, Kees Cook wrote:
>>
>> > Please pull these seccomp changes for next.
>> >
>> > Thanks!
>> >
>> > -Kees
>> >
>> > The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:
>> >
>> >   Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)
>> >
>> > are available in the git repository at:
>> >
>> >   git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/seccomp-next
>> >
>> > for you to fetch changes up to cb24de187b9a0717246f05afc0f2be070e075d80:
>> >
>> >   seccomp: Replace smp_read_barrier_depends() with lockless_dereference() (2014-11-25 11:40:24 -0800)
>> >
>> > ----------------------------------------------------------------
>> > Improves SMP dereferencing with new macro.
>> >
>> > ----------------------------------------------------------------
>> > Pranith Kumar (1):
>> >       seccomp: Replace smp_read_barrier_depends() with lockless_dereference()
>> >
>> >  kernel/seccomp.c | 7 +++----
>> >  1 file changed, 3 insertions(+), 4 deletions(-)
>> >
>>
>> This is what I get when pulling to my next branch:
>>
>> 9128 files changed, 468773 insertions(+), 340317 deletions(-)
>
> That would be because your tree is based on v3.17 and Kees' is based on
> v3.18-rc6 ...

James, I can base on whatever you like. I can do v3.17, or even
against your security-next. It seems everyone uses something
different. :)

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
