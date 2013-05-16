Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab3EPEvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:51:47 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:62406 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3EPEvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:51:46 -0400
MIME-Version: 1.0
Date: Thu, 16 May 2013 05:51:45 +0100
Message-ID: <CANq10gvZr_2V2W0QBnjzQpNgWGrYsGCV4o=yK0UFqKyJC66Ycw@mail.gmail.com>
Subject: Investigating lockups on Pentium D/SiS 661FX?
From: Mikhail Ramendik <mr@ramendik.ru>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a SiS 661FX motherboard, which was perfectly stable with a
Pentium 4 CPU (with HT). But since I installed a Pentium D (no HT),
the system started to lock up several times a day. The system works
fine under load tests under Windows.

I have moved all processes to core 0 using /dev/cpuset in a scriptthat
I now run as init (I really onlyu need the second core for video
playback). The system got much more stable but still locks up for a
few minutes once in a while. For some reason it is more prone to
lockups when Transmission is running. I also noted that interrupts are
being handled mostly by core 1.

I could not detect anything in /var/log/messages or /var/log/kern.log
for the lockup times.

The kernel is 2.6.32 but I tried 3.0.something too (everything
Debian-built). Nothing past 3.2 is available for this distro (Debian
squeeze) but I will do a compile of any required version with any
required config if necessary.

Is there any way I could collect more information so the reason could
be worked out? Any tests I could run to pinpoint whether it is indeed
a kernel issue and if so what kind of issue - perhaps I could run
tests without X started?

Thanks!


--
Yours, Mikhail Ramendik

Unless explicitly stated, all opinions in my mail are my own and do not
reflect the views of any organization
