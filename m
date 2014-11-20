Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaKTMoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:44:06 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:52608 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaKTMoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:44:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.19 #1
Date: Thu, 20 Nov 2014 13:43:10 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        a.zummo@towertech.it, rtc-linux@googlegroups.com,
        Johan Hovold <johan@kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1415976210-3665-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1415976210-3665-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201411201343.11011.arnd@arndb.de>
X-Provags-ID: V02:K0:LZFQHxFI6tCajS9OzZie/SzAyYD0IbG3qSI/nJ2pziq
 Mvw84xtAtFDXcg9qNWsNptlM+7IfivSgNpdDfNLy6eZzAiTmy4
 mYpaa3IWzGMoLYSru9OAHjQfG+yIIsPZ+6IVwdM+LUijqvEdaf
 I9dVMV756fLSlfBysR/cMAuTW1WmVL6LTdiQQBCPAp5d18Hq0g
 jhfuF7Csp6na2niys998t2MNZaphhQVdi6RNVWfk9GNYG9gDiW
 m/JDT6TZ9lZ8N5N7+pVSLfmZfkRcFzl0gdzrjW581d0PDTUqTg
 qqRRkkjQLXX8VTF2Az/TbBmYhlX58B5cuxcCxpyUu73kVhgIOP
 PNSali4xelucZ8N9YHLJfDyiXOwJSOoYPsU9pFihk
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is a pull-request about AT91-related drivers that are easier to take via
> arm-soc.
> 
> There is a little merge conflict with the "cleanup" branch because of removal
> of at91sam9g45 and at91sam9rl legacy code. The resolution is pretty simple but
> you can have a look at the resolution example here:
> https://git.kernel.org/cgit/linux/kernel/git/nferre/linux-at91.git/log/?h=at91-next
> 
> Thanks, best regards,
> 
> The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:
> 
>   Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-drivers
> 
> for you to fetch changes up to 2c91e61dc97cce57ffd9dd654a6ee284e1f45a1f:
> 
>   rtc: at91sam9: add DT bindings documentation (2014-11-13 16:08:48 +0100)
> 
> ----------------------------------------------------------------
> First batch of drivers for 3.19:
> It is only about a not so recent driver for old platforms: RTT as RTC driver:
> - RTT as RTC driver enhancements and machine specific include files removal
> - RTT as RTC driver conversion to device tree

Pulled into next/drivers, thanks!

	Arnd
