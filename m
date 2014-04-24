Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbaDXOb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:31:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45396 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaDXOb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:31:26 -0400
Message-ID: <53592037.8050106@ti.com>
Date: Thu, 24 Apr 2014 20:01:19 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mmc: host: omap_hsmmc: a few improvements
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
In-Reply-To: <1395878690-9650-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2014 05:34 AM, Felipe Balbi wrote:
> Hi,
>
> this series lets us access the newer registers introduced
> back in OMAP4 which give us some valid information about
> the OMAP HSMMC IP like max block size, support for ADMA,
> support for Retention.

"Support for Retention" looks interesting, can you shed more lights
on it

>
> Right now, only setting max_blk_size correctly as supporting
> ADMA and Retention will take a lot of work.
>
> Tested on OMAP5 uEVM.
>
> Felipe Balbi (5):
>    mmc: host: omap_hsmmc: pass host as an argument
>    mmc: host: omap_hsmmc: add reg_offset field
>    mmc: host: omap_hsmmc: introduce new accessor functions
>    mmc: host: omap_hsmmc: switch over to new accessors
>    mmc: host: omap_hsmmc: set max_blk_size correctly
>
>   drivers/mmc/host/omap_hsmmc.c | 291 ++++++++++++++++++++++++++----------------
>   1 file changed, 182 insertions(+), 109 deletions(-)
>

