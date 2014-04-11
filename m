Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbaDKSuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:50:14 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:43665 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaDKSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:50:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
Date: Fri, 11 Apr 2014 11:50:10 -0700
X-Google-Sender-Auth: n18GPGWUcy151ug-5A6VHUfWuqA
Message-ID: <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 11:45 AM, Brian Gerst <brgerst@gmail.com> wrote:
>
> I haven't tested it recently but I do know it has worked on 64-bit
> kernels.  There is no reason for it not to, the only thing not
> supported in long mode is vm86.  16-bit protected mode is unchanged.

Afaik 64-bit windows doesn't support 16-bit binaries, so I just
assumed Wine wouldn't do it either on x86-64. Not for any real
technical reasons, though.

HOWEVER. I'd like to hear something more definitive than "I haven't
tested recently". The "we don't break user space" is about having
actual real *users*, not about test programs.

Are there people actually using 16-bit old windows programs under
wine? That's what matters.

                Linus
