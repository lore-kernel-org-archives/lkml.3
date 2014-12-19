Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaLSIVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:21:12 -0500
Received: from mout.web.de ([212.227.15.3]:56869 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbaLSIVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:21:11 -0500
From: Alexander Stein <alexanders83@web.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ALSA: atmel: fix building the ac97 driver for at91-multiplatform
Date: Fri, 19 Dec 2014 09:20:47 +0100
Message-ID: <27289342.ORBlKX4LWa@kongar>
User-Agent: KMail/4.14.3 (Linux/3.14.14-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1418944390-27719-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1418944390-27719-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:A/Gc5cyOjH++8v6lfk72PCf3In7PDtMYxd02LRMI0Mm0o0jAGvv
 K3A42eBC8MKlQ3xQGuNDOVAewmn8fob/Iwlbz45stwzMPOQU41JCg7Q9H5xO1tzviaFDQpn
 tLHNPf72wv9NY6wiKS5EMGUgwf8ssBV3ACi776u0nzPr5oKP9NL5YAxQ0du0IBfgB1FXI52
 JXEJ+E0b93GO0xLp0e7ow==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

Am Freitag 19 Dezember 2014, 00:13:10 schrieb Alexandre Belloni:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> at91 will no longer export the mach/cpu.h and mach/hardware.h header files
> in the future, which would break building the atmel ac97c driver.
> 
> Since the cpu_is_* check is only used to find out whether we are running
> on avr32 or arm/at91, we can hardcode that check in the ARM case.
> 
> Unfortunately the driver is missing other work to be useful again on ARM,
> if anyone wants to actually use it, they need to add a DT binding, and
> the driver should really be converted to use the ASoC framework.

I recently send 3 patches to make DT working with this driver, you were on CC :). Please refer to http://comments.gmane.org/gmane.linux.alsa.devel/131686
I wonder though why all 3 are listed there although they were sent to different lists.

Best regards,
Alexander

