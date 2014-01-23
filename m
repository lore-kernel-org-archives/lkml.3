Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaAWR3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:29:36 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34694 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaAWR3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:29:34 -0500
MIME-Version: 1.0
In-Reply-To: <20140123091921.GB11454@gmail.com>
References: <20140122235615.GA21632@www.outflux.net>
	<20140123091921.GB11454@gmail.com>
Date: Thu, 23 Jan 2014 09:29:33 -0800
X-Google-Sender-Auth: VK3SxHYubuds26N4q3ufZ3QchGk
Message-ID: <CAGXu5jL+Z0kgEMp65D2zV5BnceRKtjVJtYMoPU3u5ODUS06_Ag@mail.gmail.com>
Subject: Re: [PATCH] x86, kaslr: export offset in VMCOREINFO ELF notes
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Discussion list for crash utility usage, maintenance and development" 
	<crash-utility@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Anderson <anderson@redhat.com>, Andrew Honig <ahonig@google.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 1:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> Include kASLR offset in VMCOREINFO ELF notes to assist in debugging.
>>
>> Signed-off-by: Eugene Surovegin <surovegin@google.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> The signoff sequence is weird. If this came from Eugene then the patch
> is missing a From: line. If he reviewed or acked it then it should be
> a Reviewed-by or Acked-by tag.

Ah, yes, seems like the From: got removed by my MUA, I will resend.

-Kees

-- 
Kees Cook
Chrome OS Security
