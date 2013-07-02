Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3GBDB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:01:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:8873 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab3GBDBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:01:52 -0400
Message-ID: <51D24299.9050209@atmel.com>
Date: Tue, 2 Jul 2013 11:01:45 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [RFC PATCH 01/13] misc: atmel_ssc: add device tree DMA support
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com> <1372667978-4718-2-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1372667978-4718-2-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 7/1/2013 16:39, Richard Genoud wrote:
> The ssc device has to fill the at_dma_slave structure with the
> device tree informations.
> Doing a of_dma_request_slave_channel()+dma_release_channel() for that
> seems wrong (or at least not very clean).

Please hold on of this, as to the ASoC dmaengine will deal with this. 
So, we not need do it manually.

Now, I am working on it. And will send out the patch soon after testing OK.

> Signed-off-by: Richard Genoud<richard.genoud@gmail.com>
> ---
>   drivers/misc/atmel-ssc.c                |   56 +++++++++++++++++++++++++++++++
>   include/linux/atmel-ssc.h               |    2 ++
>   include/linux/platform_data/dma-atmel.h |    2 ++
>   3 files changed, 60 insertions(+)

Best Regards,
Bo Shen
