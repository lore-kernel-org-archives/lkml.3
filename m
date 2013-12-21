Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3LUX0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 18:26:50 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:35967 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3LUX0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 18:26:48 -0500
MIME-Version: 1.0
Date: Sun, 22 Dec 2013 00:26:47 +0100
Message-ID: <CAAfyv36c8XktjUxpX0NQLh9vgBdr-FTKToamUT5ankzTZG_wJw@mail.gmail.com>
Subject: 3.13 gta04 mmc not working
From: Belisko Marek <marek.belisko@gmail.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to boot gta04 board with DT with latest 3.13-rc4 kernel.
Most of the parts seems to work except of mmc. I can see for mmc0 only
messages (vmmc1  and vsim regulators seems to be fine):
[    1.969573] VMMC1: 1850 <--> 3150 mV at 3000 mV
[    2.016784] VSIM: 1800 <--> 3000 mV at 1800 mV

[    2.399444] mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
[    2.749694] Waiting for root device /dev/mmcblk0p2...
[    4.588562] mmc0: error -110 whilst initialising SD card

Any ideas where to look or it is already know issue (not enough
googling on my side?)

Thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
