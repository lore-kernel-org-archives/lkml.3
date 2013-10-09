Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3JIONB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:13:01 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33384 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3JIONA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:13:00 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzdABn=TiBbM0fdok1xO3UY7hUjXA8q7rUrg2dHCsN=Ng@mail.gmail.com>
References: <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
	<CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
	<CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
	<20131008020918.GA1220@localhost>
	<20131008021452.GA6456@localhost>
	<CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com>
	<20131008031152.GA8218@localhost>
	<20131008121742.GA29280@localhost>
	<20131008221417.GF25034@n2100.arm.linux.org.uk>
	<20131008224840.GA15303@kroah.com>
	<CA+55aFzdABn=TiBbM0fdok1xO3UY7hUjXA8q7rUrg2dHCsN=Ng@mail.gmail.com>
Date: Wed, 9 Oct 2013 10:12:58 -0400
X-Google-Sender-Auth: KZHin47Zsn23aBt-3HnR10eS7mE
Message-ID: <CA+5PVA405_hXZWU0=je1VvFg15eS0Vb1WFn9+PmhZ0RWmHizag@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fengguang Wu <fengguang.wu@intel.com>, xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 8:45 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Oct 8, 2013 at 3:48 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> It's going to make things really noisy at boot time, but then it should
>> settle down and not be bad at all.  Let's try it and see if it helps or
>> not.
>
> Yeah. And quite frankly, normally that whole DEBUG_KOBJECT_RELEASE
> thing is hopefully only enabled in debug kernels (like maybe the
> Fedora rawhide one, or at developers), so being a bit more verbose is
> likely ok.

We haven't enabled it yet.  Dave hit issues with it early in the merge
window and we left it off.  That being said, it's something we'll look
at again soon and having it be a bit more verbose wouldn't be
horrible.

josh
