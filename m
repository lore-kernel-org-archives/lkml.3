Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaJVOUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:20:31 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36748 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaJVOU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:20:27 -0400
MIME-Version: 1.0
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540D6BE1@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
	<alpine.DEB.2.11.1410202027220.5308@nanos>
	<alpine.DEB.2.11.1410202034150.5308@nanos>
	<CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
	<20141021040212.GA6278@unpythonic.net>
	<20141021082058.GB6808@netboy>
	<CD2CABCB2C0A0D4682C5F8AD840141540D33BC@HKXPRD3002MB006.064d.mgd.msft.net>
	<CAL7Bo8EUcmUXhpJvrz_G-Svs+GwSF9CQec5oWWQSYBqWiJYH2w@mail.gmail.com>
	<alpine.DEB.2.11.1410221441370.5308@nanos>
	<CD2CABCB2C0A0D4682C5F8AD840141540D6BE1@HKXPRD3002MB006.064d.mgd.msft.net>
Date: Wed, 22 Oct 2014 15:20:25 +0100
Message-ID: <CAL7Bo8GzE+qdz0Y2HkjpZwPSrGxs-KpzW6qaDoXkfntmSNuQ2g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for do_adjtimex()
From: Mike Surcouf <mps.surcouf.lkml@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Jeff Epler <jepler@unpythonic.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <rcochran@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mike, can you share me your kernel version and which Linux distro do you use?

2.6.32-504.el6.x86_64 AKA RHEL 6.6
Happened on centos 7 and 6.5 too.
#cat /var/lib/ntp/drift
-248.869
About 20 secs a day (constant)

Its not a new problem I had this in other distros and other kernels.
I would say its environmental but not just my environment.

Confirmed with Olaf on SUSEvariants back in  2012 but never came to anything

see enc email

---------------------------------------------
> > KY, can your team have a look at this?
>
> Vijay, have we done time stability test in the recent past. We should
> look at replicating this issue on Distros of interest. Olaf, on sles11
> sp2, were you running NTP and how much was the drift.

sles11sp2: uptime 23:45 hours, its 38 seconds ahead

12.2: uptime 1 day, 5:17 hours, its 47 seconds ahead

ntpd is not running in both guests.

> Also, what was the host in this test.

The host is an uptodate w2k8 r2.

Olaf
-----------------------------------------------

Thanks

Mike
