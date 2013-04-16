Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3DPL7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:59:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40310 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab3DPL7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:59:04 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQU97FHKpKQjZJq+Nfz18eM2n0-V2n4B6m=ozjkycP+Rng@mail.gmail.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org> <1365797627-20874-7-git-send-email-keescook@chromium.org> <CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com> <516A1D49.1050100@zytor.com> <CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com> <516C702C.2030209@zytor.com> <CAGXu5jJkA0y+5-or4vxUHE5GyNODSoefrYJO7scM1Jh56FoUuA@mail.gmail.com> <516C751B.4020505@zytor.com> <CAE9FiQW5X80bxOURTkhnELuV_AzYXBHEudxN1eUg_1jehrcfww@mail.gmail.com> <516CB937.2000305@zytor.com> <CAE9FiQU97FHKpKQjZJq+Nfz18eM2n0-V2n4B6m=ozjkycP+Rng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 15 Apr 2013 20:02:00 -0700
To: Yinghai Lu <yinghai@kernel.org>
CC: Kees Cook <keescook@chromium.org>, Eric Northup <digitaleric@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Message-ID: <7f907e0b-c397-460f-a8ec-ce84b119ce84@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No.  Fixing one bootloader is almost impossible.  Fixing them all is a Sisiphyean task.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Mon, Apr 15, 2013 at 7:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/15/2013 03:00 PM, Yinghai Lu wrote:
>>>
>>> looks you are trying redo the work for bootloader to pick loaded
>phys addr.
>>>
>>
>> Well, that is exactly what they are doing.  On top of that they also
>> need to randomize the 64-bit virtual mapping.
>>
>> I wonder if we need a bootloader bit to inhibit kaslr in addition to
>the
>> command line...
>
>so let the bootloader to parse kaslr and pick ramdom address,
>and kernel arch/x86/boot/compressed/head_64.S to pick random virtual
>address?
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
