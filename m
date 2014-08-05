Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaHEBMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:12:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59760 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752354AbaHEBMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:12:19 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: markus@gutschke.com
Cc: Pavel Machek <pavel@ucw.cz>, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
Date: Tue, 05 Aug 2014 03:30:58 +0200
Message-ID: <11544482.e7kpiLjKfi@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALGCz1oG2g-UsK7FnxRRj7R5n6yxwJey0EBcP8ctRYSGjfw==Q@mail.gmail.com>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com> <20140804141613.GB24261@amd.pavel.ucw.cz> <CALGCz1oG2g-UsK7FnxRRj7R5n6yxwJey0EBcP8ctRYSGjfw==Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 04, 2014 09:06:52 AM Markus Gutschke wrote:
> Thanks for checking in. And no, I have not heard from Zhang since my
> last e-mail. I suspect he is still working on finding a solution. But
> you are of course right, reverting the patch in the meantime might be
> a good idea.

It has too many dependencies.  Besides, reverting it now (at the beginning of
a merge window) won't be particularly useful anyway.

We need to fix it.

> I would love to be able to suspend my laptop again. But I
> defer to Zhang for the final decision. As long as it gets fixed
> eventually, I can personally live with a few weeks of delay while
> things get worked out. And of course, as offered before, I'll run
> whatever tests Zhang asks me to do.

We've created Bugzilla entry at https://bugzilla.kernel.org/show_bug.cgi?id=80911
for this bug, can you please attach your logs in there?

Rafael

