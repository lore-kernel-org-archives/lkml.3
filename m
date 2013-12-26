Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3LZSRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:17:44 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:48354 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752829Ab3LZSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:17:42 -0500
Date: Thu, 26 Dec 2013 19:17:25 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        nsekhar@ti.com, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel.Moll@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@kernel.crashing.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, grygorii.strashko@ti.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/5] Update Davinci watchdog driver
Message-ID: <20131226181725.GL10136@spo001.leaseweb.com>
References: <1386185970-14488-1-git-send-email-ivan.khoronzhuk@ti.com> <52A5EF6B.6060700@ti.com> <52ACAED4.7000305@ti.com> <52BC6D76.7000400@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BC6D76.7000400@ti.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

> >> On Wednesday 04 December 2013 02:39 PM, Ivan Khoronzhuk wrote:
> >>> These patches are intended to update Davinci watchdog to use WDT core
> >>> and reuse driver for keystone arch, because Keystone uses the similar
> >>> IP like Davinci.
> >>>
> >>
> >> [..]
> >>
> >>> v4..v5:
> >>> - watchdog: davinci: change driver to use WDT core
> >>> 	switched off CONFIG_WATCHDOG_NOWAYOUT option
> >>>
> >> Can you please apply the series to your watchdog tree ?
> >> Do let me know if you want us to prepare a git branch
> >> to pull from.
> >>
> > ping..
> > 
> I haven't heard anything on this yet from you Wim.
> 
> Guenter,
> I have seen you actively reviewing the $subject patch series.
> Will you be able to pick the series up for 3.14 merge window
> considering almost no response from Wim so far on it ?

I have review the patches and they will go in my tree tomorrow.
I'm first finished the 2 new drivers. Then the davinci patches will go in
and then the s3c2410 patches and then I will review the w836* patches.
After that I will look at the mpc8xxx patches, the at91 patches, the remove
debug from pcwd_usb and whatever is still in my mailbox.

Kind regards,
Wim.

