Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3KDHJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 02:09:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57454 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3KDHJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 02:09:03 -0500
Message-ID: <52774801.6030207@ti.com>
Date: Mon, 4 Nov 2013 12:38:49 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: <devicetree@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <sw0312.kim@samsung.com>, <inki.dae@samsung.com>,
        <rahul.sharma@samsung.com>, <kgene.kim@samsung.com>,
        <s.nawrocki@samsung.com>, <thomas.abraham@linaro.org>,
        <mturquette@linaro.org>
Subject: Re: [RFC 04/12] phy: Add simple-phy driver
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com> <1382365111-6533-5-git-send-email-t.stanislaws@samsung.com> <52694238.7050607@ti.com> <526A231E.2090504@samsung.com>
In-Reply-To: <526A231E.2090504@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 25 October 2013 01:21 PM, Tomasz Stanislawski wrote:
> Hi,
> Please refer to the comments below.
>
> On 10/24/2013 05:52 PM, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Monday 21 October 2013 07:48 PM, Tomasz Stanislawski wrote:
>>> Add simple-phy driver to support a single register
>>> PHY interfaces present on Exynos4 SoC.
>>
>> How are these PHY interfaces modelled in the SoC? Where does the register
>> actually reside?
>
> Initially, I was planning to add PHY for HDMI_PHY register in
> power management register set on s5pv310 soc.

If that register is part of the power management register space, I don't 
think it justifies creating a PHY driver for it.
>
> However other PHYs use very similar interface (setting bit 0).
> This includes DAC_PHY, ADC_PHY, PCIe_PHY, SATA_PHY.
> Moreover it suits well to USBDEVICE_PHY, USBHOST_PHY.

How is it currently being done for these drivers? Is it being done in 
the patches sent by Kamil or Vivek?

Thanks
Kishon
