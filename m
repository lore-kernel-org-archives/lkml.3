Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaE0S4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:56:31 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:49893 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaE0S4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:56:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140526160403.GA26531@pd.tnic>
References: <20140526160403.GA26531@pd.tnic>
Date: Tue, 27 May 2014 11:56:29 -0700
Message-ID: <CALAqxLWSLq8vgkcs3-Cu-coMB9L=eL-gmBPfsZ+ZuxF0LuY5LA@mail.gmail.com>
Subject: Re: ACPI Error: Could not enable RealTimeClock event (20140214/evxfevnt-212)
From: John Stultz <john.stultz@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 9:04 AM, Borislav Petkov <bp@alien8.de> wrote:
> Hi guys,
>
> so I get this with rc7+tip but not with rc6+tip:
>
> ACPI Error: Could not enable RealTimeClock event (20140214/evxfevnt-212)
> ACPI Warning: Could not enable fixed event - RealTimeClock (4) (20140214/evxface-628)

Does it happen on -rc7 w/o tip?

Looking at the -rc6 to -rc7 commit list, I don't see anything that
pops out at me.  There's no changes to drivers/rtc nor drivers/acpi.

The only change that might be relevant from arch/x86/ is:
a4b4f11b2783ec678cccb4ce7e4ce9665aa04a24 (perf/x86/intel: Fix
Silvermont's event constraints).  Any other hardware details, etc?

thanks
-john
