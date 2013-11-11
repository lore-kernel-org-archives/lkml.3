Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3KKUcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:32:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48585 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab3KKUcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:32:06 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAGXu5jJuNRuU99DS0gWvFw71roJUPNdtFimqvuw9qungNE8ZBw@mail.gmail.com>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org> <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org> <20131111182046.GA14961@gmail.com> <20131111183101.GA16051@gmail.com> <CAGXu5jL96B4+McO=K9dptu81m+bdKWOZ8YS9x7+SZxkjfUsg9Q@mail.gmail.com> <528131E7.2060509@zytor.com> <20131111200748.GB17408@gmail.com> <CAGXu5jJuNRuU99DS0gWvFw71roJUPNdtFimqvuw9qungNE8ZBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 11 Nov 2013 12:16:12 -0800
To: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Message-ID: <8fc0bcac-b07e-47e9-9cf8-e71e9a603c51@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XOR and rotate is probably a good start.

Kees Cook <keescook@chromium.org> wrote:
>On Mon, Nov 11, 2013 at 12:07 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> Of course, perhaps we could just hash struct boot_params as a
>starting
>>> point?
>>
>> Yeah, that would be a good first step, before trying to parse DMI or
>ACPI.
>> Anything that is reasonably system dependent and gives at least some
>> amount of unpredicability.
>
>Given the very limited nature of the early boot environment, what
>would you recommend for the hashing routine itself? There's nothing in
>boot/ that does any kind of "real" crypto hashing. Should I just XOR
>the entire contents of boot_params together?
>
>-Kees

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
