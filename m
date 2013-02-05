Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3BEPme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:42:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57324 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab3BEPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:42:31 -0500
Message-ID: <5111285D.3030503@ti.com>
Date: Tue, 5 Feb 2013 10:42:21 -0500
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, <balbi@ti.com>,
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
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
References: <20130204154153.GA18237@arwen.pp.htv.fi> <510FF1A6.403@mvista.com> <20130204164712.GB4269@arwen.pp.htv.fi> <510FF5C9.3030600@mvista.com> <20130204170216.GC4269@arwen.pp.htv.fi> <51100A72.6030909@ti.com> <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com> <20130204203358.GX4720@opensource.wolfsonmicro.com> <CACRpkdbPyZt8=pLhz-5qcaSSAk6VBn61dPTNp6teU9HksBwN2w@mail.gmail.com> <51102E25.8040107@ti.com> <20130205124120.GC17852@n2100.arm.linux.org.uk>
In-Reply-To: <20130205124120.GC17852@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 07:41 AM, Russell King - ARM Linux wrote:
> On Mon, Feb 04, 2013 at 04:54:45PM -0500, Cyril Chemparathy wrote:
>> You're assuming that cookies complete in order.  That is not necessarily
>> true.
>
> Under what circumstances is that not true?
>

Notably when hardware can prioritize certain classes of traffic over 
others, for instance with data center bridging mechanisms.
