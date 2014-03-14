Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaCNQzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:55:39 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:64590 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbaCNQzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:55:37 -0400
Date: Fri, 14 Mar 2014 12:55:33 -0400
From: Matt Porter <mporter@linaro.org>
To: Alex Elder <elder@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Cc: Mark Brown <broonie@kernel.org>, Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: bcm28155-ap: leave camldo1 on to fix reboot
Message-ID: <20140314165533.GD25092@beef>
References: <1394630079-12063-1-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394630079-12063-1-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 09:14:39AM -0400, Matt Porter wrote:
> The BCM28155-AP board has a bootloader that expects the camldo1
> regulator to be enabled on entry. Currently, the camldo1 regulator
> is disabled when no longer in use as is the case during a reboot /
> warm reset. This causes the early bootloader to hang upon entry. Add
> regulator-always-on to the camldo1 constraint to fix reboot.
> 
> Reported-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Matt Porter <mporter@linaro.org>
> ---
> [Depends on BCM59056 regulator series dts support:
>  http://www.gossamer-threads.com/lists/linux/kernel/1885489]

Applied to mach-bcm armsoc/for-3.15/dt

-Matt
