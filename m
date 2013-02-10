Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3BJKvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 05:51:00 -0500
Received: from smtprelay0239.b.hostedemail.com ([64.98.42.239]:51369 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752441Ab3BJKu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 05:50:58 -0500
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2013 05:50:58 EST
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1747
Date: Sun, 10 Feb 2013 10:43:15 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <494703114.34959.1360492995961.JavaMail.mail@webmail19>
Subject: Abysmal HDD/USB write speed after sleep on a UEFI system
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.68.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a P8P67 Pro motherboard made by ASUS and recently I decided to switch to EUFI boot.
Maybe it's a coincidence or maybe Linux kernel 3.7.6 (vanilla) has some serious bug but after
waking up from sleep write performance becomes intolerable.

On boot I have:

HDD write performance: ~120MB/sec
USB write performance: ~18MB/sec

After sleep:

HDD write performance: ~7MB/sec (i.e 17 times slower)
USB write performance: ~0.5MB/sec (i.e. 36 times slower)

This is totally unacceptable, the computer becomes unusable.

I'm open to suggestions how to debug this extremely serious problem.

P.S. Since I'm still using x86 kernel, on boot it switches x86-64 UEFI off:

[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0xdf385000  ACPI 2.0=0xdf385000  SMBIOS=0xdec28e98  MPS=0xfc9a0
[    0.000000] efi: No EFI runtime due to 32/64-bit mismatch with kernel
...
[    0.000000] efi: Setup done, disabling due to 32/64-bit mismatch

Best regards,

Artem
