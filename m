Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab3CLQQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:16:37 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41077 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923Ab3CLQQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:16:32 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Matt Porter <mporter@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, "Nori\, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson\, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 5/9] dmaengine: edma: Add TI EDMA device tree binding
References: <1362586540-10393-1-git-send-email-mporter@ti.com>
	<1362586540-10393-6-git-send-email-mporter@ti.com>
	<90c29a73df9e495f907517c49dd45b88@DFLE72.ent.ti.com>
	<20130312160945.GX6209@beef>
Date: Tue, 12 Mar 2013 17:16:26 +0100
In-Reply-To: <20130312160945.GX6209@beef> (Matt Porter's message of "Tue, 12
	Mar 2013 12:09:45 -0400")
Message-ID: <878v5stwyt.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Matt" == Matt Porter <mporter@ti.com> writes:

Hi,

 Matt> +edma: edma@49000000 {
 Matt> +	reg = <0x49000000 0x10000>;
 Matt> +	interrupt-parent = <&intc>;
 Matt> +	interrupts = <12 13 14>;
 >> 
 >> Probably interrupt-parent should be removed from the example as well to
 >> match am33xx.dtsi

 Matt> On second thought, I'm not sure we're going to get any direction
 Matt> on this one so let's just do what feels right and make it reflect
 Matt> common usage like you suggested.

Sounds good to me!

-- 
Bye, Peter Korsgaard
