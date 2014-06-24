Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaFXUxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:53:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54179 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482AbaFXUwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:52:14 -0400
Message-ID: <53A9E4CC.4050409@ti.com>
Date: Tue, 24 Jun 2014 16:51:24 -0400
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, Benoit Cousson <bcousson@baylibre.com>
CC: <robh+dt@kernel.org>, <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Nishanth Menon <nm@ti.com>,
        <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] arm: dts: am4372: let boards access all nodes
 through phandles
References: <1403547659-24558-1-git-send-email-balbi@ti.com> <1403547659-24558-2-git-send-email-balbi@ti.com>
In-Reply-To: <1403547659-24558-2-git-send-email-balbi@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 02:20 PM, Felipe Balbi wrote:
> by providing phandles to rtc, wdt, cpu and dispc nodes,
> boards can access them to add board-specific data.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Tested-by: Tom Rini <trini@ti.com>

-- 
Tom
