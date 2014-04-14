Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaDNIFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:05:46 -0400
Received: from mail.codeweavers.com ([216.251.189.131]:53895 "EHLO
	mail.codeweavers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaDNIFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:05:40 -0400
X-Greylist: delayed 1036 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 04:05:40 EDT
From: Alexandre Julliard <julliard@winehq.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
Date: Mon, 14 Apr 2014 09:48:10 +0200
In-Reply-To: <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 11 Apr 2014 11:50:10 -0700")
Message-ID: <87k3aspd1h.fsf@wine.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Apr 11, 2014 at 11:45 AM, Brian Gerst <brgerst@gmail.com> wrote:
>>
>> I haven't tested it recently but I do know it has worked on 64-bit
>> kernels.  There is no reason for it not to, the only thing not
>> supported in long mode is vm86.  16-bit protected mode is unchanged.
>
> Afaik 64-bit windows doesn't support 16-bit binaries, so I just
> assumed Wine wouldn't do it either on x86-64. Not for any real
> technical reasons, though.
>
> HOWEVER. I'd like to hear something more definitive than "I haven't
> tested recently". The "we don't break user space" is about having
> actual real *users*, not about test programs.
>
> Are there people actually using 16-bit old windows programs under
> wine? That's what matters.

Yes, there is still a significant number of users, and we still
regularly get bug reports about specific 16-bit apps. It would be really
nice if we could continue to support them on x86-64, particularly since
Microsoft doesn't ;-)

-- 
Alexandre Julliard
julliard@winehq.org
