Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3CCMtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:49:08 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:64274 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3CCMtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:49:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130222180226.GC19796@opensource.wolfsonmicro.com>
References: <1361536659-23225-1-git-send-email-ldewangan@nvidia.com>
	<CAKDJKT5yngpZQC-ZvHSaKeBVHW97wo4QwLSXQ4KsVWCs5J1YKg@mail.gmail.com>
	<20130222180226.GC19796@opensource.wolfsonmicro.com>
Date: Sun, 3 Mar 2013 18:19:04 +0530
Message-ID: <CAKDJKT6i6ivb6kQ9u3_SUCEJmL0zdXdQAomKS0vRvqXYGumg1g@mail.gmail.com>
Subject: Re: [PATCH V3] spi: tegra114: add spi driver
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        swarren@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Feb 22, 2013 at 11:32 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Feb 22, 2013 at 07:59:11PM +0530, Manish Badarkhe wrote:
>> On Fri, Feb 22, 2013 at 6:07 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>> > Add SPI driver for NVIDIA's Tegra114 SPI controller. This controller
>> > is different than the older SoCs SPI controller in internal design as
>> > well as register interface.
>> >
>> > This driver supports the:
>> > - non DMA based transfer for smaller transfer i.e. less than FIFO depth.
>> > - APB DMA based transfer for lager transfer i.e. more than FIFO depth.
>>
>> s/lager/larger
>>
>> > - Clock gating through runtime PM callbacks.
>> > - registration through DT only.
>
> Delete unneeded context from your replies, we shouldn't need to page
> through the entire patch because you've noticed a spelling error...

Thanks for your reply.
I will take care of this later on.

Thanks
Manish Badarkhe
