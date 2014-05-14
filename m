Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaENM6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:58:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60424 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbaENM6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:58:22 -0400
Message-ID: <53736854.7090101@ti.com>
Date: Wed, 14 May 2014 15:57:56 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <balajitk@ti.com>
Subject: Re: [PATCH 01/17] phy: phy-omap-pipe3: Add support for PCIe PHY
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-2-git-send-email-kishon@ti.com>
In-Reply-To: <1399383244-14556-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 04:33 PM, Kishon Vijay Abraham I wrote:
> PCIe PHY uses an external pll instead of the internal pll used by SATA
> and USB3. So added support in pipe3 PHY to use external pll.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Reviewed-by: Roger Quadros <rogerq@ti.com>

--
cheers,
-roger
