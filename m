Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaJNDF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 23:05:28 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:51682 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaJNDF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 23:05:27 -0400
X-IronPort-AV: E=Sophos;i="5.04,714,1406617200"; 
   d="scan'208";a="48357115"
Message-ID: <543C92FF.80201@broadcom.com>
Date: Mon, 13 Oct 2014 20:05:35 -0700
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
        "Geert Uytterhoeven" <geert.uytterhoeven@gmail.com>
Subject: Re: [PATCH] spi: spidev: Use separate TX and RX bounce buffers
References: <rjui@broadcom.com> <1412878765-29088-1-git-send-email-rjui@broadcom.com> <20141013110726.GT27755@sirena.org.uk>
In-Reply-To: <20141013110726.GT27755@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 4:07 AM, Mark Brown wrote:
> On Thu, Oct 09, 2014 at 11:19:25AM -0700, Ray Jui wrote:
>> By using separate TX and RX bounce buffers, we avoid potential cache
>> flush and invalidation sequence issue that may be encountered when a
>> single bounce buffer is shared between TX and RX
>
> Applied, thanks.
>
Thanks, Mark.
