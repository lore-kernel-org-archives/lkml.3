Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3KKUME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:12:04 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34632 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3KKULy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:11:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131111200748.GB17408@gmail.com>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>
	<tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>
	<20131111182046.GA14961@gmail.com>
	<20131111183101.GA16051@gmail.com>
	<CAGXu5jL96B4+McO=K9dptu81m+bdKWOZ8YS9x7+SZxkjfUsg9Q@mail.gmail.com>
	<528131E7.2060509@zytor.com>
	<20131111200748.GB17408@gmail.com>
Date: Mon, 11 Nov 2013 12:11:54 -0800
X-Google-Sender-Auth: hHMqmPfaWus9Rm0loSG66LAWI9U
Message-ID: <CAGXu5jJuNRuU99DS0gWvFw71roJUPNdtFimqvuw9qungNE8ZBw@mail.gmail.com>
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 12:07 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * H. Peter Anvin <hpa@zytor.com> wrote:
>
>> Of course, perhaps we could just hash struct boot_params as a starting
>> point?
>
> Yeah, that would be a good first step, before trying to parse DMI or ACPI.
> Anything that is reasonably system dependent and gives at least some
> amount of unpredicability.

Given the very limited nature of the early boot environment, what
would you recommend for the hashing routine itself? There's nothing in
boot/ that does any kind of "real" crypto hashing. Should I just XOR
the entire contents of boot_params together?

-Kees

-- 
Kees Cook
Chrome OS Security
