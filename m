Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3KSO2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:28:06 -0500
Received: from sandbox.adsolutions.pl ([62.212.85.93]:34383 "EHLO
	sandbox.adsolutions.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3KSO2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:28:04 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Nov 2013 09:28:04 EST
From: =?utf-8?B?U3RhbmlzxYJhdw==?= Halik <sthalik@misaki.pl>
To: linux-kernel@vger.kernel.org
Subject: sandy broken on master since two days back
Date: Tue, 19 Nov 2013 15:18:31 +0100
Message-ID: <4190477.QT5sbBCpeM@aurora>
User-Agent: KMail/4.11.3 (Linux/3.12.0ricer-10088-g2d3c627; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Unless doing something wrong (likely, though using git kernel for drm pulls 
since few months back), SATA boot's broken on sandy since two days back.

03:00.0 IDE interface: VIA Technologies, Inc. VT6415 PATA IDE Host Controller
00:1f.2 IDE interface: Intel Corporation 6 Series/C200 Series Chipset Family 4 
port SATA IDE Controller (rev 05)

This particular commit stands out:

commit 0a8fd09ca9d4564a1f906b530ea08415a61cff58
mmc: sdhci: Avoid needless loop while handling SDIO interrupts in sdhci_irq

sda boots grub and all that, but shortly before init, fails to attach the 
drive.

This is a plain ol' Caviar Green HDD.

-sh

-- 
xmpp:sthalik@jabster.pl
sip:sthalik@misaki.pl
