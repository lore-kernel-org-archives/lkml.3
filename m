Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaAMVCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:02:23 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:52248 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751236AbaAMVCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:02:20 -0500
Date: Mon, 13 Jan 2014 22:02:11 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Christian Daudt <bcm@fixthebug.org>,
        Linaro Patches <patches@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/2] watchdog: bcm281xx: Watchdog Driver
Message-ID: <20140113210211.GB23454@spo001.leaseweb.com>
References: <1385160964-18578-1-git-send-email-markus.mayer@linaro.org> <20131228204039.GA19982@spo001.leaseweb.com> <CAPdLdqkNtvPwETc+TK9xRSh-ru6q4VvUk7zfYEbjPb1TOESMaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPdLdqkNtvPwETc+TK9xRSh-ru6q4VvUk7zfYEbjPb1TOESMaA@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

> Now I have a question (or rather a comment) of my own. I noticed that
> you "squashed" my two original patches into a single patch before
> breaking out the debugfs related code. The side-effect of this was
> that two lines of my bcm_defconfig change (CONFIG_WATCHDOG=y and
> CONFIG_BCM_KONA_WDT=y) were included in the patch you took into
> linux-watchdog-next.
> 
> If I understand correctly (and this is why I had broken out the
> bcm_defconfig change into a separate patch), a defconfig change would
> normally go through the platform maintainer's tree, in this case
> Christian, whereas the actual driver would go upstream through your
> tree.
> 
> I don't think it makes too much of a difference with regards to this
> driver where the defconfig change goes. In fact, taking it all through
> one tree might even be slightly easier and reduce the chance of
> conflicts, but I still think Christian needs to at least be aware of
> this change going through the watchdog tree. He owns bcm_defconfig,
> after all.

If it is an existing driver then it makes sense to go through the platform
maintainer's tree. If it is a new driver then I prefer to keep it as one
patch. Suppose the defconfig stuff get's in via the platform tree and I
don't sent the watchdog driver; would be an annoying situation in my opinion...
So that's why I prefer it as a single patch.

Kind regards,
Wim.

