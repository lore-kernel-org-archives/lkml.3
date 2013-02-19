Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab3BSKRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:17:31 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33333 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758633Ab3BSKR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:17:29 -0500
Message-ID: <51235173.5020000@ti.com>
Date: Tue, 19 Feb 2013 15:48:27 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 3/8] ARM: twd: clock rate from DT (if no DT clk tree)
References: <cover.1361186097.git.afzal@ti.com> <94cb377171f84ceefd667aead4602d70adab6619.1361186097.git.afzal@ti.com>
In-Reply-To: <94cb377171f84ceefd667aead4602d70adab6619.1361186097.git.afzal@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2013 05:07 PM, Afzal Mohammed wrote:
> Add an optional property to find clock-frequency from DT. This helps
> as a fallback mechanism in case there is no representation of clock
> tree in DT.
>
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
This won't work always because twd clock is CPU dependent and changes
with CPU clock speed. And more importantly to get CPUFreq working, you
need to provide the correct clock-node to TWD library. Refer OMAP4 clock
data for reference.

Regards,
Santosh


