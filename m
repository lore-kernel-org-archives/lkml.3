Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaJMWvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 18:51:14 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45982 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaJMWvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 18:51:11 -0400
Message-ID: <543C575A.1030105@gmail.com>
Date: Tue, 14 Oct 2014 00:51:06 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Anton Tikhomirov <av.tikhomirov@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
CC: linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kishon@ti.com
Subject: Re: [PATCH v2 1/4] dwc3: exynos: Add support for SCLK present on
 Exynos7
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com> <1412677176-3850-2-git-send-email-gautam.vivek@samsung.com> <00f101cfe6a1$d772c5a0$865850e0$%tikhomirov@samsung.com>
In-Reply-To: <00f101cfe6a1$d772c5a0$865850e0$%tikhomirov@samsung.com>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On 13.10.2014 06:54, Anton Tikhomirov wrote:
> Hi Vivek,
> 
>> Exynos7 also has a separate special gate clock going to the IP
>> apart from the usual AHB clock. So add support for the same.
> 
> As we discussed before, Exynos7 SoCs have 7 clocks to be controlled
> by the driver. Adding only sclk is not enough. 
> 

I'm quite interested in this discussion. Has it happened on mailing lists?

In general, previous SoCs also gave the possibility of controlling all
the bus clocks separately, in addition to bulk gates, but there was no
real advantage in using those, while burdening the clock tree with
numerous clocks. Isn't Exynos7 similar in this aspect?

Best regards,
Tomasz
