Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaBDSPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:15:18 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:45296 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaBDSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:15:15 -0500
MIME-Version: 1.0
In-Reply-To: <1391508908-32239-2-git-send-email-stefani@seibold.net>
References: <1391508908-32239-1-git-send-email-stefani@seibold.net> <1391508908-32239-2-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Feb 2014 10:14:54 -0800
Message-ID: <CALCETrXyZjvfVek2=fapFcuOQTU=-8xUj6T-wE6t=_fGVHXPKg@mail.gmail.com>
Subject: Re: [PATCH v11 1/9] Make vsyscall_gtod_data handling x86 generic
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 2:15 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This patch move the vsyscall_gtod_data handling out of vsyscall_64.c
> into an additonal file vsyscall_gtod.c to make the functionality
> available for x86 32 bit kernel.
>
> It also adds a new vsyscall_32.c which setup the VVAR page.

Other than the unconditional __set_fixmap calls, I think this is okay.

(Can you *please* directly answer review comments rather than just
sending out new versions at high speed.  The current approach means
that I need to reread the patch again every time to see how you've
responded, and I'm currently disinclined to believe that a new version
will actually address a review comment *at all*.)

--Andy
