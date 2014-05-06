Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934524AbaEFMDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:03:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54282 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301AbaEFMDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:03:50 -0400
Message-ID: <5368CF8A.2060808@ti.com>
Date: Tue, 6 May 2014 17:33:22 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>
CC: <mugunthanvnm@ti.com>, <balbi@ti.com>, <zonque@gmail.com>,
        <mpa@pengutronix.de>, <bhutchings@solarflare.com>,
        <tklauser@distanz.ch>, <christian.riesch@omicron.at>
Subject: Re: [PATCH v2 0/3]  TI CPSW Cleanup
References: <1399264035-22530-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1399264035-22530-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
On 5/5/2014 9:57 AM, George Cherian wrote:
> This series does some minimal cleanups.
> 	-Conversion of pr_*() to dev_*()
> 	-Convert kzalloc to devm_kzalloc.
>
> No functional changes.
>
> v1 -> v2 Address review comments.
>
> George Cherian (3):
>    driver net: cpsw: Convert pr_*() to dev_*() calls
>    net: davinci_mdio: Convert pr_err() to dev_err() call
>    drivers: net: davinci_cpdma: Convert kzalloc() to devm_kzalloc().
>
>   drivers/net/ethernet/ti/cpsw.c          | 50 ++++++++++++++++-----------------
>   drivers/net/ethernet/ti/davinci_cpdma.c | 35 ++++++++---------------
>   drivers/net/ethernet/ti/davinci_mdio.c  |  8 ++----
>   3 files changed, 39 insertions(+), 54 deletions(-)
For some reason i cant see this series in netdev patchwork.
Did I miss something?  If not can you please take this series.


-- 
-George

