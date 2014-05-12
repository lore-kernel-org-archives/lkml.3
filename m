Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaELGtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:49:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34679 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaELGtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:49:08 -0400
Message-ID: <53706ED6.4000509@ti.com>
Date: Mon, 12 May 2014 12:18:54 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <balbi@ti.com>, <zonque@gmail.com>,
        <mpa@pengutronix.de>, <tklauser@distanz.ch>
Subject: Re: [PATCH v3 0/3] TI CPSW Cleanup
References: <1399870281-27200-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1399870281-27200-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2014 10:21 AM, George Cherian wrote:
> This series does some minimal cleanups.
> 	-Conversion of pr_*() to dev_*()
> 	-Convert kzalloc to devm_kzalloc.
>
> No functional changes.
>
> v1 -> v2 Address review comments.
> v2 -> v3 Remove a stale commit comment.
>
> George Cherian (3):
>   driver net: cpsw: Convert pr_*() to dev_*() calls
>   net: davinci_mdio: Convert pr_err() to dev_err() call
>   drivers: net: davinci_cpdma: Convert kzalloc() to devm_kzalloc().
>
>  drivers/net/ethernet/ti/cpsw.c          | 50 ++++++++++++++++-----------------
>  drivers/net/ethernet/ti/davinci_cpdma.c | 35 ++++++++---------------
>  drivers/net/ethernet/ti/davinci_mdio.c  |  2 +-
>  3 files changed, 38 insertions(+), 49 deletions(-)
>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
