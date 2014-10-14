Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaJNDFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 23:05:49 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:58450 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaJNDFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 23:05:47 -0400
X-IronPort-AV: E=Sophos;i="5.04,714,1406617200"; 
   d="scan'208";a="48357138"
Message-ID: <543C9314.4080507@broadcom.com>
Date: Mon, 13 Oct 2014 20:05:56 -0700
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: pl022: Fix incorrect dma_unmap_sg
References: <rjui@broadcom.com> <1412880294-9860-1-git-send-email-rjui@broadcom.com> <20141013110851.GU27755@sirena.org.uk>
In-Reply-To: <20141013110851.GU27755@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 4:08 AM, Mark Brown wrote:
> On Thu, Oct 09, 2014 at 11:44:54AM -0700, Ray Jui wrote:
>> When mapped RX DMA entries are unmapped in an error condition when DMA
>> is firstly configured in the driver, the number of TX DMA entries was
>> passed in, which is incorrect
>
> Applied, thanks.
>
Thanks, Mark.
