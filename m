Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbbAEWhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:37:41 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36448 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbbAEWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:37:40 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19cOpdjAUqy8hfhPf2OkXH2
Date: Mon, 5 Jan 2015 14:33:47 -0800
From: Tony Lindgren <tony@atomide.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: omap5/dra7xx: Enable booting secondary CPU in HYP
 mode
Message-ID: <20150105223347.GL4081@atomide.com>
References: <20141219214924.GA17160@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141219214924.GA17160@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lennart Sorensen <lsorense@csclub.uwaterloo.ca> [141219 13:51]:
> If the boot loader enables HYP mode on the boot CPU, the secondary CPU
> also needs to call into the ROM to switch to HYP mode before booting.
> The firmwares on the omap5 and dra7xx unfortunately do not take care
> of this, so it has to be handled by the kernel.
> 
> This patch is based on "[PATCH 2/2] ARM: OMAP5: Add HYP mode entry support
> for secondary CPUs" by Santosh Shilimkar <santosh.shilimkar@ti.com>,
> except this version does not require a compile time CONFIG to control
> if it should enable HYP mode or not, it simply does it based on the mode
> of the boot CPU, so it works whether the CPU boots in SVC or HYP mode,
> and should even work as a guest kernel inside kvm if qemu decides to
> support emulating the omap5 or dra7xx.

Applying into omap-for-v3.19/fixes with cc stable for v3.16+.

Thanks,

Tony
