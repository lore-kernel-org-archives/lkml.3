Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaCNTcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:32:25 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:47521 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbaCNTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140314190824.GA6426@redhat.com>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
	<5321CBDA.1060705@oracle.com>
	<CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
	<20140313231227.GA32178@redhat.com>
	<CAGXu5jLE6WHCwZVcMSUwQAa3=DW1LsxGd_1aGo8SzLpk8jC-xA@mail.gmail.com>
	<20140314190824.GA6426@redhat.com>
Date: Fri, 14 Mar 2014 12:32:23 -0700
X-Google-Sender-Auth: Sp08zLsQD_huJxMV7BPN7WWdKrQ
Message-ID: <CA+55aFznCT20giHq8JxCRduky-dQtVLqpUYrcrK_3XeXN+Wyow@mail.gmail.com>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 12:08 PM, Dave Jones <davej@redhat.com> wrote:
>
> ok, nokalsr makes it work too.
> Booting with that and using the perf binary from 3.14rc6 , I just see..
>
>   9.30%  [kernel]                      [k] 0xffffffffaf18e887

Hmm. Do you have CONFIG_KALLSYMS enabled?

I have CONFIG_RANDOMIZE_BASE=y and perf (both report and top) seems to
work fine for me (current git, not v3.14-rc6, but still)

           Linus
