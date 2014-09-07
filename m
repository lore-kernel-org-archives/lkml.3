Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaIGS5G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:57:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41949 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIGS5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:57:04 -0400
Date: Sun, 7 Sep 2014 20:57:00 +0200
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: gregkh@linuxfoundation.org, jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        monstr@monstr.eu, michal.simek@xilinx.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH 0/3] Yet another stab at a fpga framework
Message-ID: <20140907185700.GA26553@amd>
References: <1406932118-13885-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406932118-13885-1-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> [resend with fixed email settings]
> 
> The idea of the framework is to provide consistent ways of
> programming raw images into FPGA's.
> 
> Programming from device tree overlays is supported.
> 
> The core (fpga-mgr.c) does not include a userspace interface
> and just exports kernel functions.
> 
> This approach separates the core from the interfaces.
> 
> Each interface can be enabled or disabled in the defconfig.
> In some production contexts, interfaces that might be used
> during development can be disabled.
> 
> The core exports kernel functions to:
>   * write the fpga from a buffer or using the firmware layer
>   * get fpga status
>   * find a particular fpga manager from a device tree phandle
>   * register/unregister lower level fpga drivers.
> 
> The bus allows us to:
>   * program fpga from a device tree overlay using firmware.
>   * automatically reload firmware and reprogram fpga during resume.
> 
> The sysfs interface:
>   * read only, get the name and status of fpga manager.
> 
> I have a configfs interface patch which I haven't included,
> adds configfs as a separate file.

Thanks for the patches... is there new version? Is that corresponding
socfpga code?

I'd like to configure fpga with .rbf file on board similar to SocKit.

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
