Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3C1Lll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:41:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8776 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab3C1Llk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:41:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 28 Mar 2013 04:41:11 -0700
Message-ID: <51542BC5.10701@nvidia.com>
Date: Thu, 28 Mar 2013 17:08:45 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Manish Badarkhe <badarkhe.manish@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V3] spi: tegra114: add spi driver
References: <1361536659-23225-1-git-send-email-ldewangan@nvidia.com> <CAKDJKT5yngpZQC-ZvHSaKeBVHW97wo4QwLSXQ4KsVWCs5J1YKg@mail.gmail.com> <20130302230906.141BE3E336A@localhost>
In-Reply-To: <20130302230906.141BE3E336A@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 March 2013 04:39 AM, Grant Likely wrote:
> On Fri, 22 Feb 2013 19:59:11 +0530, Manish Badarkhe <badarkhe.manish@gmail.com> wrote:
>> On Fri, Feb 22, 2013 at 6:07 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>>> Add SPI driver for NVIDIA's Tegra114 SPI controller. This controller
>>> is different than the older SoCs SPI controller in internal design as
>>> well as register interface.
>>>
>>> This driver supports the:
>>> - non DMA based transfer for smaller transfer i.e. less than FIFO depth.
>>> - APB DMA based transfer for lager transfer i.e. more than FIFO depth.
>> s/lager/larger
> Applied, thanks. And I fixed up the typo when I did.
>

Grant,
I still do not see this change in linux-next? Are you going to put this 
change for K3.10? Wanted to close some of stuff from Tegra side.
