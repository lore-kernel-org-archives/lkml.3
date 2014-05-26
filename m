Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaEZQEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:04:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39317 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaEZQEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:04:13 -0400
Date: Mon, 26 May 2014 18:04:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: ACPI Error: Could not enable RealTimeClock event
 (20140214/evxfevnt-212)
Message-ID: <20140526160403.GA26531@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

so I get this with rc7+tip but not with rc6+tip:

ACPI Error: Could not enable RealTimeClock event (20140214/evxfevnt-212)
ACPI Warning: Could not enable fixed event - RealTimeClock (4) (20140214/evxface-628)

rtc_cmos gets initialized fine with both though:

rc6+tip:
========
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:06: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
rtc_cmos 00:06: setting system clock to 2014-05-26 17:21:31 UTC (1401124891)


rc7+tip:
========
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:06: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
rtc_cmos 00:06: setting system clock to 2014-05-26 17:50:18 UTC (1401126618)

Any ideas?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
