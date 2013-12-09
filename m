Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441Ab3LIR42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:56:28 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9385 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841Ab3LIR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:56:26 -0500
Date: Mon, 9 Dec 2013 09:57:51 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: panchaxari <panchaxari.prasannamurthy@linaro.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH CFT] ARM:MSM: Enable ARM_PATCH_PHYS_VIRT and
 AUTO_ZRELADDR default
Message-ID: <20131209175751.GB15223@sonymobile.com>
References: <1386582050-21375-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386582050-21375-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:40:50AM +0100, panchaxari wrote:
> ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR have been enabled as default configs
> to MSM platform
> 
> Introduction of PHYS_VIRT config as default would enable phy-to-virt and
> virt-to-phy translation function at boot and module loading time
> and enforce dynamic reallocation of memory. AUTO_ZRELADDR config would
> enable calculation of kernel load address at run time.
> 
> PHYS_VIRT config is mutually exclusive to XIP_KERNEL, XIP_KERNEL is used in
> systems with NOR flash devices, and ZRELADDR config is mutually exclusive
> to ZBOOT_ROM.
> 
> CFT::Call For Testing
> 
> Requesting maintainers of MSM platforms to evaluate the changes on the board
> and comment, as I dont have the board for testing and also requesting an ACK
> 
> Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-arm-msm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org

We run with these enabled on our development boards already.

Tested-by: Courtney Cavin <courtney.cavin@sonymobile.com>

-Courtney
