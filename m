Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3DLIj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:39:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41919 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3DLIjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:39:55 -0400
Message-ID: <5167C848.4010203@ti.com>
Date: Fri, 12 Apr 2013 14:09:36 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rnayak@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH v2] ARM: OMAP4: hwmod data: make 'ocp2scp_usb_phy_phy_48m"
 as the main clock
References: <1365496101-7829-1-git-send-email-kishon@ti.com> <alpine.DEB.2.00.1304092058450.26840@utopia.booyaka.com> <alpine.DEB.2.00.1304101935450.25123@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1304101935450.25123@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 11 April 2013 01:11 AM, Paul Walmsley wrote:
> From: Kishon Vijay Abraham I <kishon@ti.com>
>
> Commit 92702df3570e ("ARM: OMAP4: PM: fix PM regression introduced by recent
> clock cleanup") makes the 'ocp2scp_usb_phy_phy_48m' as optional
> functional clock causing regression in MUSB. But this 48MHz clock is a
> mandatory clock for usb phy attached to ocp2scp and hence made as the main
> clock for ocp2scp.
>
> Cc: Keerthy <j-keerthy@ti.com>
> Cc: Benoît Cousson <b-cousson@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> [paul@pwsan.com: add comment to the hwmod data to try to prevent any
>   future mistakes here]
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> ---
>
> Nothing further received from Kishon per the request:
>
> http://marc.info/?l=linux-omap&m=136554118302342&w=2

Sorry. Missed reading this mail.

Thanks
Kishon
