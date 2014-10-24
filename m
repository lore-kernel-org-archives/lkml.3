Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbaJXKyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:54:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50677 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaJXKyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:54:22 -0400
Date: Fri, 24 Oct 2014 12:54:20 +0200
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: jgunthorpe@obsidianresearch.com, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, pantelis.antoniou@konsulko.com,
        robh+dt@kernel.org, grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 1/3] add sysfs document for fpga bridges
Message-ID: <20141024105420.GB20775@amd>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
 <1414108267-22058-2-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414108267-22058-2-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-10-23 18:51:05, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add sysfs document for fpga bridges.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
>  Documentation/ABI/testing/sysfs-class-fpga-bridge |    5 +++++
>  1 file changed, 5 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-bridge
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-fpga-bridge b/Documentation/ABI/testing/sysfs-class-fpga-bridge
> new file mode 100644
> index 0000000..b3303ae
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fpga-bridge
> @@ -0,0 +1,5 @@
> +What:		/sys/class/fpga-bridge/<bridge>/enable
> +Date:		October 2014
> +KernelVersion:	3.18
> +Contact:	Alan Tull <atull@opensource.altera.com>
> +Description:	Enable bridge.  Write 1 to bring bridge out of reset.

Specify, what happens when 0 is written there?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
