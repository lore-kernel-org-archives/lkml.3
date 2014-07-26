Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaGZPw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:52:56 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:59411 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaGZPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:52:55 -0400
MIME-Version: 1.0
Reply-To: markus@gutschke.com
In-Reply-To: <1405988531.2455.14.camel@rzhang1-toshiba>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
 <CALGCz1oYYkKp1frPF4vExiwqW=euYY8An+Yum4U-qsBc5NyjFg@mail.gmail.com>
 <1405587482.28592.64.camel@rzhang1-toshiba> <CALGCz1qzmK_0Mq8JNFYUnGtDGWSqYoHfqv0MKbqG1RySQ4bt6g@mail.gmail.com>
 <1405988531.2455.14.camel@rzhang1-toshiba>
From: Markus Gutschke <markus@gutschke.com>
Date: Sat, 26 Jul 2014 08:52:34 -0700
X-Google-Sender-Auth: hT1QHFQgIZ-F0VKZLGi22GN5MA0
Message-ID: <CALGCz1okgr4K9S+6NfohM1Y3LregQLEKaj7FuON0xkk7xX1Jhg@mail.gmail.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay. Remotely debugging kernels over a shared and
flaky 1MBps terrestrial wireless connection is quite a new experience
to me.

In any case, I was able to collect all the data that you asked for. I
then used "pm-suspend" to put the machine to sleep and asked a helper
to physically press the power button to wake the computer back up. My
helper told me that it crashed just as before, and they had to
power-cycle the machine to bring it back to life.

Please let me know, what other data I can get for you. And thank you
very much for putting up with my slow turn-around. I should have much
better response time again in about two to three weeks when I return
to civilization.

# Startup log file for stock 3.15 kernel
https://medusa.gutschke.com/markus/3.15-dmesg.txt

# Startup log file for b04c58b1ed26317bfb4b33d3a2d16377fc6acd0f
https://medusa.gutschke.com/markus/3.15-rc8-dmesg.txt

# /sys/* files for b04c58b1ed26317bfb4b33d3a2d16377fc6acd0f
https://medusa.gutschke.com/markus/3.15-rc8-platform-devices-firmware-node.txt
https://medusa.gutschke.com/markus/3.15-rc8-platform-devices.txt
https://medusa.gutschke.com/markus/3.15-rc8-pnp-devices-firmware-node.txt
https://medusa.gutschke.com/markus/3.15-rc8-pnp-devices.txt

# /sys/* files for b04c58b1ed26317bfb4b33d3a2d16377fc6acd0f with patch applied
https://medusa.gutschke.com/markus/3.15-rc8-patched-dmesg.txt
https://medusa.gutschke.com/markus/3.15-rc8-patched-platform-devices-firmware-node.txt
https://medusa.gutschke.com/markus/3.15-rc8-patched-platform-devices.txt
https://medusa.gutschke.com/markus/3.15-rc8-patched-pnp-devices-firmware-node.txt
https://medusa.gutschke.com/markus/3.15-rc8-patched-pnp-devices.txt
