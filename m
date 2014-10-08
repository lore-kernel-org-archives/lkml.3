Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaJHSb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:31:28 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:40541 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaJHSbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:31:25 -0400
X-IronPort-AV: E=Sophos;i="5.04,679,1406617200"; 
   d="scan'208";a="47585799"
Message-ID: <54358301.20505@broadcom.com>
Date: Wed, 8 Oct 2014 11:31:29 -0700
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Grant Likely <grant.likely@linaro.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, JD Zheng <jdzheng@broadcom.com>,
        "Scott Branden" <sbranden@broadcom.com>
Subject: Re: [PATCH] spi: pl022: Fix broken spidev when DMA is enabled
References: <rjui@broadcom.com> <1412743127-4523-1-git-send-email-rjui@broadcom.com> <20141008112143.GT4609@sirena.org.uk> <543562EB.8060300@broadcom.com> <20141008182123.GH4609@sirena.org.uk>
In-Reply-To: <20141008182123.GH4609@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/8/2014 11:21 AM, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 09:14:35AM -0700, Ray Jui wrote:
>
>> Thanks for the reply. It looks like you are also the maintainer of spidev.
>> In this case, could you please help to confirm that you expect spidev to use
>> separate buffers for TX and RX? If so, I can go ahead and make the change in
>> spidev.
>
> Yes, that would be my expectation for maximum robustness (or if it is
> going to use one buffer it explicitly maps it for mixed use but I'd
> expect that to be asking for trouble).
>
Okay, Mark. I'm going to make the change in the spidev and submit a new 
patch.

Thanks for the feedback.

Ray
