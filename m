Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab3KYRC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:02:27 -0500
Received: from smtp-out.abv.bg ([194.153.145.70]:59095 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab3KYRCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:02:01 -0500
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=IUXjUZR2D00du288NCEDMFODL8+SeFRf2QuHrZ+vdKpY4wDCDpV418nAJjDMPqL7R
	SAcZ8aBQcHaOFHqcDxwOi/0H4FptzMnUgiKVMefdGG0CAKlmep7unboF+U6LNfxOMGV
	WXiwBiB6Wfby8bZeOrhd/I4EgyuiV7IyzKxYzow=
Date: Mon, 25 Nov 2013 19:01:54 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@ring0.de, anton@enomsg.org, dwmw2@infradead.org,
        tony@atomide.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi
Message-ID: <1851041258.29554.1385398914287.JavaMail.apache@mail83.abv.bg>
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 46.249.74.23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 




 >-------- Оригинално писмо --------
 >От:  Pavel Machek 
 >Относно: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for
 automode
 >До: Pali Rohár 
 >Изпратено на: Понеделник, 2013, Ноември 25 17:18:39 EET
 >
 >
 >On Mon 2013-11-25 15:10:00, Pali Rohár wrote:
 >> On Monday 25 November 2013 15:01:27 Pavel Machek wrote:
 >> > Where can I get dsme sources?
 >> > 									Pavel
 >> 
 >> dsme daemon: https://gitorious.org/community-ssu/dsme
 >> dsme thermal plugin: https://gitorious.org/rx51-bme-replacement/dsme-thermalobject-surface
 >> 
 >> dsme thermal plugin is responsible for checking temperature of 
 >> battery and send it to dsme damon. dsme daemon itself checking 
 >> temperature limits and do something (e.g reboot device)
 >
 >Thanks for links!
 >
 >AFAICT.... dsme daemon does some kind of system management, not
 >directly controlling charging, right? It does monitor system temperature.
 >
 >Now.. Imagine phone left in car in charger (on sun). Likely
 >temperature will reach high values, kernel is charging, dsme will
 >reboot the system, but kernel will start charging again, dsme will
 >reboot again, ...
 >
 >And it is not only high temperatures that are problem for li-ion
 >charging; battery should not be fast charged below 5C and should not
 >be charged below 0C. (Again, both are likely to happen if you leave
 >your phone in car).
 >
 >AFAICT, we should simply disable charging below 5C or above 45C.
 >
 >									Pavel
 >-- 
 >(english) http://www.livejournal.com/~pavelmachek
 >(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
 >

AFAIK dsme will not restart it, but power it off, so the above scenario won't happen.

Regards,
Ivo
