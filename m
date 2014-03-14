Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaCNSbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:31:18 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64669 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaCNSbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:31:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140313231227.GA32178@redhat.com>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
	<5321CBDA.1060705@oracle.com>
	<CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
	<20140313231227.GA32178@redhat.com>
Date: Fri, 14 Mar 2014 11:31:11 -0700
X-Google-Sender-Auth: PJftzqGEsKztta_-23MiWpIIgwk
Message-ID: <CAGXu5jLE6WHCwZVcMSUwQAa3=DW1LsxGd_1aGo8SzLpk8jC-xA@mail.gmail.com>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
From: Kees Cook <keescook@chromium.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 4:12 PM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Mar 13, 2014 at 03:03:41PM -0700, Linus Torvalds wrote:
>
>  > You need to look at the *symbol* number. In this output:
>  >
>  >      [<ffffffff810020c2>] do_one_initcall+0xc2/0x1e0
>  >
>  > that "ffffffff810020c2" is crap, and is going away. The address that
>  > is meaningful and valid is the "do_one_initcall+0xc2" part.
>  >
>  > *That* is the part you'd use to parse in user space.
>  >
>  > Try it today with the CONFIG_RANDOMIZE_BASE option to see. Using the
>  > hex number doesn't *work*.
>
> That reminds me, perf top is still busted when this option is enabled.

Hrm, works for me. I'm not very familiar with what to expect, but
comparing output between kaslr boot and nokaslr boot, it looks the
same to me.

-Kees

-- 
Kees Cook
Chrome OS Security
