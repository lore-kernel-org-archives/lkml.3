Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3G2UhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:37:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46476 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab3G2UhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:37:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
Date: Mon, 29 Jul 2013 22:47:26 +0200
Message-ID: <1481385.FnXPIp62HH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s1=VfRLPVxwuu1Qhim-nyCHe1gKzQDfiffWw3DDpK0Apg@mail.gmail.com>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com> <7981076.SojlpLkL71@vostro.rjw.lan> <CAMP44s1=VfRLPVxwuu1Qhim-nyCHe1gKzQDfiffWw3DDpK0Apg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 03:22:56 PM Felipe Contreras wrote:
> On Mon, Jul 29, 2013 at 3:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, July 29, 2013 02:20:58 PM Felipe Contreras wrote:
> >> Since v3.7 the acpi backlight driver doesn't work at all on this machine
> >> because presumably the ACPI code contains stub code when Windows 8 OSI is
> >> reported.
> >>
> >> The commit ea45ea7 (in v3.11-rc2) tried to fix this problem by using the intel
> >> backlight driver, however, on this machine it turns the backlight completely
> >> off when it reaches level 0%, after which the user might have a lot trouble
> >> trying to bring it back.
> >>
> >> This patch fixes both regressions by blacklisting the win8 OSI, so we are back
> >> to v3.6 behavior, and it should remain that way until the intel backlight
> >> driver is fixed.
> >
> > Well, it really is a workaround, so perhaps it would be fair to call it this
> > way?
> 
> Maybe, but to me, and to most users, the important thing is that it
> fixes a regression.
> 
> >> Since v3.7, users have been forced to fix the initial regression by modifying
> >> the boot arguments [1].
> >>
> >> [1] https://wiki.archlinux.org/index.php/ASUS_Zenbook_Prime_UX31A
> >>
> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >
> > I don't really feel this is the right approach, but then I don't care enough
> > to fight with you. :-)
> 
> It's not the right approach, I don't think I (or anybody) argued
> otherwise, but unless the Intel driver is fixed before 3.11, it's the
> only sane approach.

Oh, you're *so* sure about that ...

What I'm actually thinking is that applying this workaround will reduce the
incentive to fix intel_backlight for the users in question, so it's not like
there are no drawbacks.

But as I said, I'm not going to fight over this.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
