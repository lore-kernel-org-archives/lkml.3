Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbbALUbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:31:40 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:55245 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbbALUbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:31:38 -0500
MIME-Version: 1.0
In-Reply-To: <20150112202647.GB4425@pd.tnic>
References: <20141218175126.GA78864@vmdeb7> <20150111225802.GA12944@node.dhcp.inet.fi>
 <20150112183831.GA99900@vmdeb7> <CAObL_7FCiZJuTQNUfqjoxaRscB+_2fvwpnXDt3d8E+0dFm=i6A@mail.gmail.com>
 <20150112200331.GA23277@node.dhcp.inet.fi> <CAObL_7FwxW=oq9L+POVx_4S9HSZW2QM3bnTNW37rDsUA=-U3FA@mail.gmail.com>
 <20150112202647.GB4425@pd.tnic>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 12 Jan 2015 12:31:18 -0800
X-Google-Sender-Auth: Cgr-rOecbsUAMhwaI1cN57KVssU
Message-ID: <CAObL_7H+cgTLVYvOWVW6BacO169c00kfbYvE0F_zT9N_jh6zOw@mail.gmail.com>
Subject: Re: [GIT PULL] platform-drivers-x86 for 3.19
To: Borislav Petkov <bp@alien8.de>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Darren Hart <dvhart@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:26 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jan 12, 2015 at 12:05:45PM -0800, Andrew Lutomirski wrote:
>> What aspect of the old behavior is better than the new default behavior?
>
> Btw, in my case, if I boot without the thinkpad_acpi.software_mute=0
> thing, the small control light in the mute button doesn't light up to
> show that mute is enabled. It still mutes properly in both cases though
> so it is only a feedback thing which doesn't work anymore...

This is supposed to work, and it works fine on my X220.  What Thinkpad
do you have, and what distro are you running?

Can you run alsamixer (with software_mute=1) and watch the controls to
see what changes when you press mute?  IIRC, when the master volume
goes to 0 or is muted, the magic ALSA hooks will tell thinkpad_acpi so
that thinkpad_acpi can adjust the LED.

--Andy

>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
