Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3KTSkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:40:39 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50318 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab3KTSkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:40:36 -0500
Date: Wed, 20 Nov 2013 10:40:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Christian Daudt <bcm@fixthebug.org>,
        Linaro Patches <patches@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] watchdog: bcm281xx: Watchdog Driver
Message-ID: <20131120184034.GC30952@roeck-us.net>
References: <1384888074-19696-1-git-send-email-markus.mayer@linaro.org>
 <1384888074-19696-2-git-send-email-markus.mayer@linaro.org>
 <CAPdLdqmxFnJ9HZa04buh8NecMszEAp11VRU4Q159vZ+=NG9p3A@mail.gmail.com>
 <20131120162721.GB28683@roeck-us.net>
 <CAPdLdq=xUjsr1ykTHh3t_Uy9kBkKXbW0gpAmtgiOfj8gC42yeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPdLdq=xUjsr1ykTHh3t_Uy9kBkKXbW0gpAmtgiOfj8gC42yeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:24:54AM -0800, Markus Mayer wrote:
> > Hi Markus,
> >
> > Yes, I noticed when I merged it into my watchdog-next branch.
> >
> > Reminds me ... v3 had a whitespace problem. I don't recall if you fixed
> > that in v4. If you didn't, that might be a better reason to send v5.
> 
> That's still there, unfortunately. Trailing space on the first
> help-text line in Kconfig:
>     Support for the watchdog timer on the following Broadcom BCM281xx
> 
> So, I'll generate v5 with that fixed. Do you prefer I also rebase it
> right now to whatever current tip is to take care of the merge
> conflict?
> 
I would suggest to wait for -rc1 and rebase to it before you send the new
version. After all, it won't make it into 3.13 anyway, so no need to hurry.

Thanks,
Guenter
