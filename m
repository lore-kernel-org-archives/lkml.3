Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaCOTk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 15:40:56 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:33982 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752163AbaCOTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 15:40:54 -0400
Date: Sat, 15 Mar 2014 20:40:52 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Marc van der Wal <x0r+kernel@x0r.fr>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] it87_wdt: Work around non-working CIR interrupts
Message-ID: <20140315194052.GA14327@spo001.leaseweb.com>
References: <20140306093659.GA24854@freyja>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306093659.GA24854@freyja>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> From: Marc van der Wal <x0r+kernel@x0r.fr>
> 
> On some hardware platforms, the it87_wdt watchdog resets the machine
> despite the watchdog daemon running and writing to /dev/watchdog.
> 
> This is due to Consumer IR buffer underrun interrupts being used as
> triggers to reset the timer.  On some buggy hardware implementations
> such as the iEi AFL-12A-N270 single-board computer, this method does 
> not work.
> 
> However, resetting the timer by writing its original timeout value in
> its configuration register over and over again suppresses the unwanted
> reboots.
> 
> Add a module option (nocir), 0 by default in order not to break existing
> setups.  Setting it to 1 enables the workaround.
> 
> Fixes bug #42801 <https://bugzilla.kernel.org/show_bug.cgi?id=42801>.
> Tested primarily on Linux 3.5.7, applies cleanly on Linux 3.13.5.
> 
> Signed-off-by: Marc van der Wal <x0r+kernel@x0r.fr>
> ---

Patch has been added to linux-watchdog-next.

Kind regards,
Wim.

