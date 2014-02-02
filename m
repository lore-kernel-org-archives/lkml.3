Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBBTPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 14:15:09 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:59132 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaBBTPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 14:15:07 -0500
MIME-Version: 1.0
In-Reply-To: <1391325599.6481.5.camel@europa>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	<1391325599.6481.5.camel@europa>
Date: Sun, 2 Feb 2014 11:15:05 -0800
X-Google-Sender-Auth: xqr4GQzQgCDdx6a4MzUJ2wPMw2U
Message-ID: <CA+55aFzz8a7K+KSB_TkGb1ih1hAg09-0TQusQgE5vwMJGegHDw@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <sbsiddha@gmail.com>
Cc: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 11:19 PM, Suresh Siddha <sbsiddha@gmail.com> wrote:
>
> The real fix for Nate's problem will be coming from Linus, with a
> slightly modified option-b that Linus proposed. Linus, please let me
> know if you want me to spin it. I can do it sunday night.

Please do it, since clearly I wasn't aware enough about the whole
non-TS-checking FPU state details.

Also, since this issue doesn't seem to be a recent regression, I'm not
going to take this patch directly (even though I'm planning on doing
-rc1 in a few hours), and expect that I'll get it through the normal
channels (presumably together with the __kernel_fpu_end cleanups). Ok
with everybody?

              Linus
