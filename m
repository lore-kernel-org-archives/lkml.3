Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3BEMqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:46:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35684 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3BEMqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:46:54 -0500
Date: Tue, 5 Feb 2013 12:41:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Cyril Chemparathy <cyril@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, balbi@ti.com,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        "Nair, Sandeep" <sandeep_n@ti.com>, Chris Ball <cjb@laptop.org>,
        Matt Porter <mporter@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
	arm/common
Message-ID: <20130205124120.GC17852@n2100.arm.linux.org.uk>
References: <20130204154153.GA18237@arwen.pp.htv.fi> <510FF1A6.403@mvista.com> <20130204164712.GB4269@arwen.pp.htv.fi> <510FF5C9.3030600@mvista.com> <20130204170216.GC4269@arwen.pp.htv.fi> <51100A72.6030909@ti.com> <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com> <20130204203358.GX4720@opensource.wolfsonmicro.com> <CACRpkdbPyZt8=pLhz-5qcaSSAk6VBn61dPTNp6teU9HksBwN2w@mail.gmail.com> <51102E25.8040107@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51102E25.8040107@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 04:54:45PM -0500, Cyril Chemparathy wrote:
> You're assuming that cookies complete in order.  That is not necessarily  
> true.

Under what circumstances is that not true?
