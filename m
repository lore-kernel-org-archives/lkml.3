Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030770Ab3DSPOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:14:47 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55922 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030715Ab3DSPOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:14:46 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 0/3] rtc: rtc-hid-sensor-time
Date: Fri, 19 Apr 2013 17:14:09 +0200
Message-Id: <1366384452-14367-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

as I'm not sure if the maintainer of the RTC subsystem is active again,
I've added the people which where involved with rtc-hid-sensor-time
before to cc too. That might be a good idea even he is active again,
as the driver depends on hid-sensor-hub and as such works a bit
outside the stuff other RTC drivers do use.

This small series of patches do extend the driver a bit. They make
the driver more standard (draft) compliant and I've added a replacement
for the usual hctosys, because that isn't usable with this driver.

I've already send the first patch two weeks before (unchanged) therefor
I've marked it as RESEND (see https://lkml.org/lkml/2013/4/5/177 ).

Actually I wanted to have added another patch to adjust the system time
too (when the clock sends HID reports which are including milliseconds
regulary by itself), but I have to read about the in-kernel timekeeping
(kernel/time/timekeeping.c, kernel/time/ntp.c) for that and I don't know
if I will find the time without missing the next merge window.

Personally I would like if they went into 3.9 too, but beeing realistic,
I'm happy if they end up in 3.11. ;)

If someone is curious about my other side of that driver, I've setup a
website with explanations and source which should make it easy build a
similiar hot-pluggable RTC: http://ahsoftware.de/dcf77-hid-usb-rtc/

Regards,

Alexander
