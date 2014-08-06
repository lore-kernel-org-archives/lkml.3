Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaHFSbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:31:31 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:38487 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbaHFSb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:31:29 -0400
MIME-Version: 1.0
Reply-To: markus@gutschke.com
In-Reply-To: <1407206650.10148.28.camel@rzhang1-toshiba>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
 <CALGCz1oYYkKp1frPF4vExiwqW=euYY8An+Yum4U-qsBc5NyjFg@mail.gmail.com>
 <1405587482.28592.64.camel@rzhang1-toshiba> <CALGCz1qzmK_0Mq8JNFYUnGtDGWSqYoHfqv0MKbqG1RySQ4bt6g@mail.gmail.com>
 <1405988531.2455.14.camel@rzhang1-toshiba> <CALGCz1okgr4K9S+6NfohM1Y3LregQLEKaj7FuON0xkk7xX1Jhg@mail.gmail.com>
 <20140804141613.GB24261@amd.pavel.ucw.cz> <CALGCz1oG2g-UsK7FnxRRj7R5n6yxwJey0EBcP8ctRYSGjfw==Q@mail.gmail.com>
 <1407206650.10148.28.camel@rzhang1-toshiba>
From: Markus Gutschke <markus@gutschke.com>
Date: Wed, 6 Aug 2014 11:31:07 -0700
X-Google-Sender-Auth: roUXo4hqa_5W3b-Jk4QJkK-P9SU
Message-ID: <CALGCz1pSpzDVb8sQx=QFKjdR4fi566h42p2nRkFx+RXairbgFQ@mail.gmail.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
To: Zhang Rui <rui.zhang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried removing snd_hda_intel, but it didn't make any difference.

I then followed your instructions to turn on tracing, but I am more
puzzled than I was before. The crash reliably happens, every time I
suspend/resume without first having tracing turned on. But as soon as
I enter "echo devices >/sys/power/pm_test" to enable tracing things
change. Upon suspending, the machine now happily resumes itself again
a few seconds later. No crash whatsoever.

Is this the expected behavior? Anything else you want me to do?


Markus
