Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaKUUHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:07:16 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:56220 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaKUUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:07:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 00/12]
Date: Fri, 21 Nov 2014 21:07:09 +0100
Message-ID: <2946373.UZAWO9ynEM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALAqxLVRJKHiZVr2_gW-uos-LtW5iQLs-qOWUedfWp70f9iHDw@mail.gmail.com>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org> <CALAqxLVRJKHiZVr2_gW-uos-LtW5iQLs-qOWUedfWp70f9iHDw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zIjW8xqC5H0yMGXpWC9keg1JfFdwCOvy2NBUsUhU9nm
 ATqc4/1DfOt+6RY5gXL3mC/GGgp55MiWMZfAt+HSqMwSNcV7O+
 qp9ArzBVOEJg62xvZ00j6kmEOx8coG3putxFz9yjWgD2yj8brL
 fo6waLg7rPvRMd2Bi3liHZWRNGF7pr8FJ3I5pDZLS4cIMUGycR
 MjdZcPJKkO0/QF6rdZpUaPQSgaXhfpAMonEm728WCZ2Te4LYxM
 OztIPcawUBpOqw0KhlSPJ5FKbbBOcHbmDQ6v6MDmJYxFzLU2g2
 xU1mH5/cWyTHhHc7Rcswz+Rk52Brbm+5sCnwBbc16aOynGy/0p
 xDukF//mR1ktzm/w0+W0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 11:53:04 John Stultz wrote:
> On Fri, Nov 21, 2014 at 11:44 AM, John Stultz <john.stultz@linaro.org> wrote:
> > Hey Thomas, All,
> >
> > Just wanted to submit a handful of changes for 3.19
> >
> > * udelay_test/test_udelay consistent file naming
> > * Time / ntp edge-case fixes from Xunlei
> > * y2038-safe internal interfaces from Xunlei and me
> > * Celanup suspend/resume timing y2038 issues
> > * Remove y2038 unsafe inject_sleeptime inteface
> >
> > Just as an FYI, I'm trying out signing this tag with
> > a new subkey on my yubikey. Hopefully haven't mucked
> > it up.

Hmm, patch 1 doesn't seem to have made it to the list.
Can you send that again?

	Arnd
