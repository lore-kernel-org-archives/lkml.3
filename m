Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3LSAus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:50:48 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60718 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3LSAuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:50:46 -0500
Message-ID: <1387414241.31516.19.camel@host5.omatika.ru>
Subject: Re: [PATCH v3 07/21] ARM: dts: parse DMA config in pxamci
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Ball <cjb@laptop.org>,
        Mark Brown <broonie@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mmc@vger.kernel.org
Date: Thu, 19 Dec 2013 04:50:41 +0400
In-Reply-To: <1387309071-22382-8-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
	 <1387309071-22382-8-git-send-email-ynvich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Tue, 2013-12-17 at 23:37 +0400, Sergei Ianovich wrote:
> The existing PXA MMC driver cannot get DMA channels in a proper
> way from the respective device tree binding.
> 
> This patch provides temporary workaround which allows using the
> existing driver in DT machines by pointing to the proper
> dmaengine-based "marvell,pdma-1.0" DMA.
> 
> Even though the new DMA provider is not present we can parse device node
> attributes manually and use channel numbers to acquire DMA channel
> from the existing non-dmaengine provider.
> 
> When Daniel's DMA series is merged there will be no need to manually
> parse for "dmas" and this patch can be safely reverted.
> 
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> CC: Daniel Mack <zonque@gmail.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> ---
>    v2..v3
>    * split into good (PATCH 07/21) and temporary (this one) parts
> 
>    v1..v2
>    * add binding for next-gen dma controller
>    * use correct dma declararion
>    * number changed from 5 to 3

Could you please comment on this solution for PXA DMA?

There may appear new, but it remains the last open review comment for
the series at the moment.

