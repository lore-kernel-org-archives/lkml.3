Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBXN5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:57:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35471 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbaBXN5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:57:21 -0500
Message-ID: <530B4F9C.2050302@ti.com>
Date: Mon, 24 Feb 2014 19:26:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>, <kgene.kim@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <swarren@wwwdotorg.org>, <mark.rutland@arm.com>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Vasanth Ananthan <vasanth.a@samsung.com>
Subject: Re: [PATCH V8 1/2] PHY: Exynos: Add Exynos5250 SATA PHY driver
References: <1393248775-3283-1-git-send-email-yuvaraj.cd@samsung.com> <1393248775-3283-2-git-send-email-yuvaraj.cd@samsung.com>
In-Reply-To: <1393248775-3283-2-git-send-email-yuvaraj.cd@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 24 February 2014 07:02 PM, Yuvaraj Kumar C D wrote:
> This patch adds the SATA PHY driver for Exynos5250.Exynos5250 SATA
> PHY comprises of CMU and TRSV blocks which are of I2C register Map.
> So this patch also adds a i2c client driver, which is used configure

We no longer have i2c client driver here.
> the CMU and TRSV block of exynos5250 SATA PHY.
> 
> This patch incorporates the generic PHY framework to deal with SATA
> PHY.

It should be rephrased to have *uses* generic PHY framework. However I feel we
can do away with this line.
> 
> This patch depends on the below patch for the sata functionality
> 	[1].ata: ahci_platform: Manage SATA PHY
> 		by Roger Quadros <rogerq@ti.com>

hasn't this patch merged yet?

Thanks
Kishon
