Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaAFKYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:24:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34300 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbaAFKYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:24:45 -0500
Message-ID: <52CA845C.5080308@ti.com>
Date: Mon, 6 Jan 2014 15:54:28 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>,
        <tjakobi@math.uni-bielefeld.de>, <stern@rowland.harvard.edu>
Subject: Re: [PATCH RFC alternative ver 1] phy: Exynos 421x USB 2.0 PHY support
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com> <1387545857-9472-11-git-send-email-k.debski@samsung.com>
In-Reply-To: <1387545857-9472-11-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 20 December 2013 06:54 PM, Kamil Debski wrote:
> This the alternative version of the support for Exynos 421x USB 2.0 PHY
> in the Generic PHY framework. In this version the support for Exynos
> 4210 and 4212 was joined into one file.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
> Hi,
>
> Me and Kishon were discussing for quite a long time the way how Exynos 4
> should be handled. I have decided to post the original patches and try
> to make an alternative version with support for Exynos 4210 and 4212 joined
> in one file. I have prepared two versions. The first one has 506 lines (vs
> 563 when two files are used). When doing the second version I was a little
> more aggresive in removing code. This was done at a cost of adding if's
> deciding which SoC version the driver is dealing with in some internal functions.
> This resulted in a better number of removed lines - the second version has
> only 452 lines (vs 563 original and 506 version 1).

Alright.. If the alternate approach doesn't give too much of advantage, 
lets stick with the original one. I would recommend creating a 
documentation (Documentation/phy/?) for the samsung PHY since that 
actually creates a layer on top of generic PHY framework. That would 
help while adding new samsung PHY drivers.

Btw thank you for preparing alternate versions for your original patches.

Cheers
Kishon
