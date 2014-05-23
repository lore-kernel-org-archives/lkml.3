Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaEWIpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:45:10 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51538 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaEWIpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:45:08 -0400
Message-ID: <537F0A8F.4090104@gmail.com>
Date: Fri, 23 May 2014 10:45:03 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Chris Ball <chris@printf.net>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Markus Pargmann <mpa@pengutronix.de>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
References: <20140523153212.40c9cc95@canb.auug.org.au>
In-Reply-To: <20140523153212.40c9cc95@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 07:32 AM, Stephen Rothwell wrote:
> After merging the mmc tree, today's linux-next build (arm multi_v7_defconfig)
> failed like this:
>
> drivers/mmc/host/sdhci-dove.c: In function 'sdhci_dove_carddetect_irq':
> drivers/mmc/host/sdhci-dove.c:42:24: error: 'struct sdhci_host' has no member named 'card_tasklet'
>
> Caused by commit 3560db8e247a ("mmc: sdhci: push card_tasklet into
> threaded irq handler").
>
> I have used the mmc tree from next-20140522 for today.

Stephen,

I received that build failure yesterday for mmc-next. Patch sent to
Chris and Ulf. Should be fixed as soon as it hits mmc-next.

Sebastian

