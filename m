Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3G2VEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:04:55 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:48610 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3G2VEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:04:54 -0400
MIME-Version: 1.0
In-Reply-To: <1481385.FnXPIp62HH@vostro.rjw.lan>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
	<7981076.SojlpLkL71@vostro.rjw.lan>
	<CAMP44s1=VfRLPVxwuu1Qhim-nyCHe1gKzQDfiffWw3DDpK0Apg@mail.gmail.com>
	<1481385.FnXPIp62HH@vostro.rjw.lan>
Date: Mon, 29 Jul 2013 16:04:52 -0500
Message-ID: <CAMP44s1jt1qcu6mXmEpEg0Gr4Fx3v50kUXZ3mCvnzXB3c1gE+w@mail.gmail.com>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 3:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, July 29, 2013 03:22:56 PM Felipe Contreras wrote:
>> On Mon, Jul 29, 2013 at 3:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Monday, July 29, 2013 02:20:58 PM Felipe Contreras wrote:
>> >> Since v3.7 the acpi backlight driver doesn't work at all on this machine
>> >> because presumably the ACPI code contains stub code when Windows 8 OSI is
>> >> reported.
>> >>
>> >> The commit ea45ea7 (in v3.11-rc2) tried to fix this problem by using the intel
>> >> backlight driver, however, on this machine it turns the backlight completely
>> >> off when it reaches level 0%, after which the user might have a lot trouble
>> >> trying to bring it back.
>> >>
>> >> This patch fixes both regressions by blacklisting the win8 OSI, so we are back
>> >> to v3.6 behavior, and it should remain that way until the intel backlight
>> >> driver is fixed.
>> >
>> > Well, it really is a workaround, so perhaps it would be fair to call it this
>> > way?
>>
>> Maybe, but to me, and to most users, the important thing is that it
>> fixes a regression.
>>
>> >> Since v3.7, users have been forced to fix the initial regression by modifying
>> >> the boot arguments [1].
>> >>
>> >> [1] https://wiki.archlinux.org/index.php/ASUS_Zenbook_Prime_UX31A
>> >>
>> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> >
>> > I don't really feel this is the right approach, but then I don't care enough
>> > to fight with you. :-)
>>
>> It's not the right approach, I don't think I (or anybody) argued
>> otherwise, but unless the Intel driver is fixed before 3.11, it's the
>> only sane approach.
>
> Oh, you're *so* sure about that ...

Yeah, I have heard Linus say many many times that Linux should never
ever break user-experience, that's the number one rule.

http://www.youtube.com/watch?v=kzKzUBLEzwk&t=1m58s

-- 
Felipe Contreras
