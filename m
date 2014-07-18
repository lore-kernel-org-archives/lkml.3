Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945996AbaGRS6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:58:55 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:37476 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407AbaGRS6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:58:53 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWj-NJeeKe6+qTZd3QsvLNMV_K=2swoNXza7Ef2xHkXoQ@mail.gmail.com>
References: <1405620518-18495-1-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.11.1407181325200.15709@namei.org>
	<CALCETrUv3G+C3PTOD1FJGOG8AQCA30hNkUiusCnQDGq6Kt_Feg@mail.gmail.com>
	<CAGXu5jL9wQ4ZJ1kDRx_Y_cyGQEjO_Ugmcc--Q71x32_x1q9ScA@mail.gmail.com>
	<CALCETrWj-NJeeKe6+qTZd3QsvLNMV_K=2swoNXza7Ef2xHkXoQ@mail.gmail.com>
Date: Fri, 18 Jul 2014 11:58:52 -0700
X-Google-Sender-Auth: fuCvvmzPgfxmRfezjpzvlQBmDBE
Message-ID: <CAGXu5jK4vzx-8Wo==BONNGnbm1hdawv2wc2sJb2AFzMf52AgGg@mail.gmail.com>
Subject: Re: [PATCH v12 11/11] seccomp: add thread sync ability
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, David Drysdale <drysdale@google.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 11:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Jul 18, 2014 at 11:13 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Fri, Jul 18, 2014 at 10:17 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Thu, Jul 17, 2014 at 8:26 PM, James Morris <jmorris@namei.org> wrote:
>>>> On Thu, 17 Jul 2014, Kees Cook wrote:
>>>>
>>>>> Twelfth time's the charm! :)
>>>>
>>>> Btw, there doesn't seem to be an official seccomp maintainer.  Kees, would
>>>> you like to volunteer for this?  If so, send in a patch for MAINTAINERS,
>>>> and set up a git tree for me to pull from.
>>
>> Sure thing, I'll get this set up now. I wonder if I should include the
>> glob "arch/*/kernel/ptrace.c" in the MAINTAINERS entry. :P
>
> You might want to convince some arch maintainers first, and that's
> like herding cats.  Or Oleg, at least.  Also, do you really want to be
> asked to deal with the never-ending stream of bugs that people find in
> files matching that glob?

Yeah, I've opted for "K: \bsecure_computing" Seemed like a decent middle-ground.

>>> *snicker* :)
>>>
>>> Kees, if you take on this awesome responsibility, should I send you a
>>> rebased version of the fastpath stuff?  If so, I think that the
>>> arch-neutral part should go in through your shiny new tree (once it's
>>> reviewed to your satisfaction), and I'll ask hpa to pick up the x86
>>> part.
>>
>> Yeah, that sounds perfect.
>>
>>> I'd volunteer to be a "R:eviewer", but I don't think that the R tag
>>> has made it into MAINTAINERS yet.
>>
>> I'd love to have you listed. :)
>
> Feel free to pester me once "R" appears in case I forget.

I will indeed! :)

-Kees

>
> You might be able to convince me to co-maintain some day.  Hmm.
>
> --Andy
>
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Chrome OS Security
>
>
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC



-- 
Kees Cook
Chrome OS Security
