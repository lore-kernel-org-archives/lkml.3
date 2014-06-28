Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaF1RIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:08:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44444 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaF1RIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:08:02 -0400
Date: Sat, 28 Jun 2014 19:07:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tthayer@altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tthayer.linux@gmail.com
Subject: Re: [PATCHv8 1/3] devicetree: Addition of the Altera SDRAM
 Controller.
Message-ID: <20140628170753.GC23634@xo-6d-61-c0.localdomain>
References: <1403882819-24929-1-git-send-email-tthayer@altera.com>
 <1403882819-24929-2-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403882819-24929-2-git-send-email-tthayer@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Thor Thayer <tthayer@altera.com>
> 
> Add the Altera SDRAM controller bindings and device tree changes to the Altera SoC project.
> 
> Signed-off-by: Thor Thayer <tthayer@altera.com>

> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> new file mode 100644
> index 0000000..5027026
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> @@ -0,0 +1,11 @@
> +Altera SOCFPGA SDRAM Controller
> +
> +Required properties:
> +- compatible : "altr,sdr-ctl";
> +- reg : Should contain 1 register ranges(address and length)

"1 register range ("

Otherwise:

Acked-by: Pavel Machek <pavel@denx.de>
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
