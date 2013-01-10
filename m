Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3AJVuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 16:50:51 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37136 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab3AJVuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 16:50:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from platform data
Date: Thu, 10 Jan 2013 22:56:36 +0100
Message-ID: <2426125.yN3kXlp07z@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130110135852.GS13897@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com> <20130110133319.GT20956@opensource.wolfsonmicro.com> <20130110135852.GS13897@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 10, 2013 03:58:52 PM Mika Westerberg wrote:
> On Thu, Jan 10, 2013 at 01:33:19PM +0000, Mark Brown wrote:
> > On Thu, Jan 10, 2013 at 02:18:08PM +0100, Rafael J. Wysocki wrote:
> > > On Thursday, January 10, 2013 12:51:59 PM Mark Brown wrote:
> > 
> > > > Sounds sensible, yes - about what I'd expect.  Is it possible to match
> > > > on CPUID or similar information (given that this is all in the SoC)
> > > > instead of ACPI, that might be more robust I guess?
> > 
> > > This particular part may be present in different SoCs.
> > 
> > Right, but I'd expect you could enumerate the SoCs?  Someone might
> > decide to change the clock configuration for future SoCs anyway.
> 
> Well, they can use the same LPSS block with a different CPU but then we
> expect the ACPI IDs to change as well (so we can then make another set of
> clocks for those).

Also, as I said in another message, even if the LPSS block is used, the SPI
may not be exposed to us by the BIOS, so SoC enumeration is not sufficient
in general.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
