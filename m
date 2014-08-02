Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaHBAZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 20:25:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50137 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaHBAZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 20:25:13 -0400
Date: Sat, 2 Aug 2014 02:25:11 +0200
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
Subject: Re: [PATCH 3/3] fpga sysfs interface
Message-ID: <20140802002511.GD11170@amd.pavel.ucw.cz>
References: <1406932118-13885-1-git-send-email-atull@opensource.altera.com>
 <1406932118-13885-4-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406932118-13885-4-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-08-01 17:28:38, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add basic sysfs interface.  Only exports two files:
> 
> /sys/class/fpga_manager/fpga0/name
>    Name of low level driver.
> 
> /sys/class/fpga_manager/fpga0/status
>    status of fpga framework as returned by core
>    fpga-mgr.c's fpga_mgr_ops_framework_status
>    function or by the low level driver's status
>    function.

I believe sysfs additions need to be documented in
Documentation/ABI/. Otherwise it looks  good.

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
