Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab3GVTVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:21:14 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37846 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab3GVTVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:21:11 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1307221633010.23128@pobox.suse.cz>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
	<alpine.LNX.2.00.1307221633010.23128@pobox.suse.cz>
Date: Mon, 22 Jul 2013 12:21:10 -0700
X-Google-Sender-Auth: szIvVcgS3GlfbjPlM3yoDe3POAY
Message-ID: <CA+55aFxKZnYResCmCvaYGksdWYuuHCAAjJ1eRkR94GmiTrJrkA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Revert "Revert "HID: Fix logitech-dj: missing
 Unifying device issue""
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        benjamin.tissoires@gmail.com, Andrew de los Reyes <adlr@chromium.org>,
        joseph.salisbury@canonical.com,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 7:35 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Linus -- could you please by any chance test whether the two patches in
> that branch make the problem you are observing any better? (and no, this
> is not a pull request yet).
>
> It's still not clear whether we are chasing two different issues here, or
> not.

I think it's two different issues. It sounds like the USB3 one is
fairly repeatable?

Mine is quite rare. I think it's so far happened just once during the
the 3.11 merge window+, and that's despite me rebooting usually a few
times a day (less now that things are calming down).

On Mon, Jul 22, 2013 at 8:27 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> It might help to get a usbmon trace and dmesg log from Linus, if he
> still has this problem.

So see above. I've sent the dmesg - not that it's useful, since it
just lacks the lines showing the actual wireless device after plugging
it in (but the receiver is recognized). No error messages, just not
any working keyboard.

And it's not common. I think it has happened a handful of times over
the last four months or so.

                  Linus
