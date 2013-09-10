Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3IJP75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:59:57 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54538 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3IJP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:59:56 -0400
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
Date: Tue, 10 Sep 2013 17:59:54 +0200
Message-ID: <CAN8YU5NTKUtS8+YzmcOSM3=YUX-FSwLTD86F_hXsNdVkw5NEGA@mail.gmail.com>
Subject: RTL8187SE staging Linux driver
From: Andrea Merello <andrea.merello@gmail.com>
To: wlanfae@realtek.com, shwei <shwei@realtek.com.tw>
Cc: John Linville <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-wireless@vger.kernel.org,
        Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As you probably know, in the current Linux kernel there is a staging
driver for the RTL8187SE device (based on my older RTL8180/RTL8185
Linux driver), while there also a regular (not staging) driver
supporting older RTL8185 and RTL8180 devices
(net/wireless/rtl818x/rtl8180) .

As far as I can see, the RTL8187SE device seems not so much different
from an RTL8185 device.
I would like to try (in my spare time) to add support for RTL8187SE
device in the current RTL818x driver, in order to avoid code
duplication, remove a driver from staging, and make RTL8187SE using
mac80211.

Do any one of you have any comment/objection/suggestions about this ?

Is it possible to get the RTL8187SE documentation to make things easier?

For now I will probably keep different RF code for the two cards even
if the RTL8225 (zebra 2) radio is used by both RTL8187SE and some
RTL8185 devices, however if I could get enough documentation about it,
it would be great to try to merge also RF code..

Thank you,
Andrea
