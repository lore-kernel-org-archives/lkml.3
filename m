Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaLYKsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 05:48:41 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43409 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751830AbaLYKsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 05:48:40 -0500
Date: Thu, 25 Dec 2014 11:48:37 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Alexander Stein <alexanders83@web.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] ALSA: atmel: fix building the ac97 driver for
 at91-multiplatform
Message-ID: <20141225104837.GH4194@piout.net>
References: <1419160689-20447-1-git-send-email-alexandre.belloni@free-electrons.com>
 <s5hppb8hw13.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hppb8hw13.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25/12/2014 at 11:19:04 +0100, Takashi Iwai wrote :
> At Sun, 21 Dec 2014 12:18:09 +0100,
> Alexandre Belloni wrote:
> > 
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > at91 will no longer export the mach/cpu.h and mach/hardware.h header files
> > in the future, which would break building the atmel ac97c driver.
> > 
> > Since the cpu_is_* check is only used to find out whether we are running
> > on avr32 or arm/at91, we can hardcode that check in the ARM case.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Link: http://www.spinics.net/lists/arm-kernel/msg382068.html
> 
> Is this targeted for 3.19 or 3.20?
> 

It is not urgent, that is definitely for 3.20.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
