Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaBTNXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:23:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55882 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbaBTNXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:23:19 -0500
Message-ID: <53060169.2050207@ti.com>
Date: Thu, 20 Feb 2014 18:51:45 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Chris Ball <chris@printf.net>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH V2 2/2] ARM: dts: omap3-ldp: fix mmc configuration
References: <1392356749-32091-1-git-send-email-nm@ti.com> <1392356749-32091-3-git-send-email-nm@ti.com>
In-Reply-To: <1392356749-32091-3-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 February 2014 11:15 AM, Nishanth Menon wrote:
> MMC1 is the only MMC interface available on the platform. Further,
> since the platform is based on older revision of SoC which is not
> capable of doing multi-block reads, mark it with compatibility for the
> same and add pinmux to ensure that all relevant pins are configured
> for non-MMC boot mode.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>

looks good to me
Acked-by: Balaji T K <balajitk@ti.com>

