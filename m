Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab3KMQFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:05:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48758 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3KMQFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:05:31 -0500
Message-ID: <5283A31E.4070302@ti.com>
Date: Wed, 13 Nov 2013 11:04:46 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <marc.zyngier@arm.com>,
        <grant.likely@linaro.org>, <mark.rutland@arm.com>,
        <robherring2@gmail.com>, <tglx@linutronix.de>, <galak@codeaurora.org>
Subject: Re: [PATCH V3 7/7] ARM: DRA: Enable Crossbar IP support for DRA7XX
References: <1383657257-3458-1-git-send-email-r.sricharan@ti.com> <1383657257-3458-8-git-send-email-r.sricharan@ti.com> <5281BF70.4050708@ti.com> <5281C0E9.8020104@ti.com> <52839B9C.8090707@ti.com>
In-Reply-To: <52839B9C.8090707@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 November 2013 10:32 AM, Nishanth Menon wrote:
> On 11/11/2013 11:47 PM, Sricharan R wrote:
[..]

> 
> Rationale - with more TI SoCs trending towards crossbar, we dont need
> to keep adding to the soc_is checks, further, we intend to remove
> soc_is checks in it's entirety..
> 
Just for record, and thats what am pushing the TI hardware folks is not to
build default IRQ configuration considering the software will clean-up the
mess. So hope is that we don't have to use this infrastructure always but
only for exceptional cases.

Regards,
Santosh

