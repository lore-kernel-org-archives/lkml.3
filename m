Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaGLMPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:15:33 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53637 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaGLMPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:15:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 36/55] misc: ioc4: Use ktime_get_ns()
Date: Fri, 11 Jul 2014 19:03:02 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <20140711133623.530368377@linutronix.de> <20140711133708.353543709@linutronix.de>
In-Reply-To: <20140711133708.353543709@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407111903.02325.arnd@arndb.de>
X-Provags-ID: V02:K0:HAhlEKXOARVFn2DIccrQ4KCnxcQfDAfXLv99WRTz3+Y
 aLbKAp0ewoIjs6SRJRlDZ5Zn8VSPBtGBAW2EoWAFhuU9KYJTUo
 7E35rawDU3C6OHTeQ8jXZxdJ+qT030f9QeF9decOxICp0xtg4S
 rv+W7ChE0PRfRuxcbdDc7ojqDKNX6lkgLULiEaVqk/NcWIOLiV
 wXPHwebT7mcngmeFTdecoam6vMLuRaBu1jpxe3Lebd6iVYna3s
 VYXxr6lRcHspUu1hQIbwIX0sNO9dNlnohjXCng8WEFKARWWD53
 VqG9wOL2ivCSbHHQW+RA2Z6zRTIehDL7lC5ZsJlM2C8ORz+R7+
 Z3X/d+jHFvEmnPkbbXlc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2014, Thomas Gleixner wrote:
> Replace the ever recurring:
>         ts = ktime_get_ts();
>         ns = timespec_to_ns(&ts);
> with
>         ns = ktime_get_ns();
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
