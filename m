Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaK2QbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:31:09 -0500
Received: from homie.mail.dreamhost.com ([208.97.132.208]:33776 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335AbaK2QbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:31:07 -0500
Date: Sat, 29 Nov 2014 17:31:05 +0100
From: Jurriaan <jurriaan@onderneming10.net>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ilw@linux.intel.com
Subject: iwlwifi intel 6300 slow
Message-ID: <20141129163104.GA23040@qnap.onderneming10.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a Lenovo W700 laptop with Intel 5300 wireless card, running Debian
Testing. Speed to and from my NAS via a Western Digital N900 router was
about 16 megabyte/s - limited by the NAS.

After updating to a W701 with an Intel 6300 wireless card, speed is down
to 1-2 megabyte/s. Replacing the card is not really an option, Lenovo
has blessed this model with a whitelist in the BIOS.

I tried booting 3.18-rc6, but that made no difference against 3.16.

There's a lot of complaints about this card on the net, but it seems
most are about poor performance when roaming or with a weak signal. 
I've tries the various 11n_disable=x swcrypto=x options, I've tried
fiddling with the router (20/40 MHz, N only or mixed etc) but so far,
the speed remains abysmal.

1)
Can anybody tell me what logs/debugging I can post to help clear up this
issue?

2)
If anybody has this card running great with another router, I'd be very
interested to learn which one!

Thanks,
Jurriaan

wlan0     IEEE 802.11abgn  ESSID:"onderneming10_5"
          Mode:Managed  Frequency:5.2 GHz  Access Point: 00:90:A9:0E:D5:58
          Bit Rate=270 Mb/s   Tx-Power=15 dBm
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=52/70  Signal level=-58 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:101   Missed beacon:0

i03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
	Subsystem: Intel Corporation Centrino Ultimate-N 6300 3x3 AGN
        Flags: bus master, fast devsel, latency 0, IRQ 56
        Memory at f6000000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [c8] Power Management version 3
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [e0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Device Serial Number 00-24-d7-ff-ff-61-65-8c
        Kernel driver in use: iwlwifi

iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
