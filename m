Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab3CDVr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:47:26 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48521 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585Ab3CDVrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:47:25 -0500
MIME-Version: 1.0
Date: Mon, 4 Mar 2013 22:47:24 +0100
Message-ID: <CA+K+NcR9tExM9y-yjH_MB=ZpjeeakMW2GozECg4Pejp54nkCjA@mail.gmail.com>
Subject: BCM4313 problems connecting to AP since 3.8
From: =?UTF-8?B?SsOhbiBWZXNlbMO9?= <jano.vesely@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after upgrading to 3.8 I started running into a timeout problem on
BCM4313 wifi using brcmsmac driver (compiled as module, x86_64).
the card is unable to connect to ap after startup of resume.
Although it eventually connects it takes a long time (several minutes)
and dmesg log is spammed with:

[  144.725431] wlan0: authenticate with 00:23:f8:8f:29:14
[  144.727786] wlan0: capabilities/regulatory prevented using AP
HT/VHT configuration, downgraded
[  144.727820] wlan0: direct probe to 00:23:f8:8f:29:14 (try 1/3)
[  144.930780] wlan0: direct probe to 00:23:f8:8f:29:14 (try 2/3)
[  145.133855] wlan0: direct probe to 00:23:f8:8f:29:14 (try 3/3)
[  145.336931] wlan0: authentication with 00:23:f8:8f:29:14 timed out
[  151.217245] wlan0: authenticate with 00:23:f8:8f:29:14

(30+ times in some cases)

I tested 3.8.0/1/2 as well as 3.9.0-rc1 and the problem is present in
all of them.
returning back to 3.7.10 fixes the problem and the card connects
without a single timeout message.

the AP is an older adsl modem/hotspot and runs in 802.11g mode, my
other machine (x86) with atheros chipset connects without any problems
to the same AP on 3.8 kernel.

let me know if I can provide more info

Jan Vesely
