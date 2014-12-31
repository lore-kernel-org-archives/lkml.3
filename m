Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaLaPw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:52:29 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45939 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaLaPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:52:27 -0500
MIME-Version: 1.0
In-Reply-To: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
References: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 31 Dec 2014 07:51:46 -0800
Message-ID: <CAGVrzcboyES2DHLY5CW3srz9uf9gFJnjJDRVCo+-+_McA0PgHQ@mail.gmail.com>
Subject: Re: [PATCH V6 00/25] Generic BMIPS kernel
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Jaedon Shin <jaedon.shin@gmail.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Jonas Gorski <jogo@openwrt.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Brian Norris <computersforpeace@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-25 9:48 GMT-08:00 Kevin Cernekee <cernekee@gmail.com>:
> V5->V6: Incorporate several fixes/enhancements from Jaedon Shin:
>
>  - Fix register read/modify/write in RAC flush code.
>
>  - Fix use of "SYS_HAS_CPU_BMIPS32_3300" Kconfig symbol.
>
>  - Add base platform support for 7358 and 7362.
>
> The DTS files follow Andrew Bresticker's new per-vendor directory layout.
>
> This series applies on top of Linus' current head of tree.
>
> Patch 01 (Fix outdated use of mips_cpu_intc_init()) is REQUIRED for 3.19
> to fix a build failure seen in 3.19-rc.  The other patches can
> be queued for 3.20 or later.

For this entire patch series:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
--
Florian
