Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3DOQjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:39:25 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34252 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab3DOQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:39:23 -0400
Message-ID: <516C2D33.9010104@ahsoftware.de>
Date: Mon, 15 Apr 2013 18:39:15 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: rtc-hid-sensor-time: example firmware implementation
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If someone is interested, I've setup a web page which describes how to 
build a DCF77 (radio) HID USB RTC using an Atmel ATmega32U4 (e.g. an 
Arduino Leonardo, Teensy or another clone), which uses the 
rtc-hid-sensor-time driver to function as a stratum 0 time source:

http://ahsoftware.de/dcf77-hid-usb-rtc/

Regards,

Alexander
