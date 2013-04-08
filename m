Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936266Ab3DHO7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:59:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37480 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936056Ab3DHO7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:59:07 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130408115823.GC7513@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org> <515DE0C9.3030709@zytor.com> <20130405080418.GG26889@gmail.com> <515EEE25.1030402@zytor.com> <20130408115823.GC7513@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 08 Apr 2013 07:58:23 -0700
To: Ingo Molnar <mingo@kernel.org>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <16dc4736-347a-4102-b21b-0e35e060108b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not if we do it right, but there is a huge potential boot time penalty.

Ingo Molnar <mingo@kernel.org> wrote:

>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> On 04/05/2013 01:04 AM, Ingo Molnar wrote:
>> > 
>> > Random runtime shuffling of the kernel image - is that possible
>with 
>> > existing toolchains?
>> > 
>> 
>> Yes... the question is how much work we'd be willing to go through to
>make it 
>> happen.
>> 
>> One approach: the kernel already contains a linker -- used for
>modules -- and 
>> the bulk of the kernel could actually be composed to a "pile of
>modules" that 
>> gets linked on boot.  This would provide very large amounts of
>randomness.
>
>Is there no code generation / micro-performance disadvantage to that?
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
