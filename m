Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3HLQxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:53:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48958 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318Ab3HLQxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:53:25 -0400
Message-ID: <520912EE.1080202@ti.com>
Date: Mon, 12 Aug 2013 22:23:02 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: David Miller <davem@davemloft.net>, <bigeasy@linutronix.de>,
        <prabhakar.csengg@gmail.com>, <b-liu@ti.com>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 8/8] net: davinci_mdio: use platform_{get,set}_drvdata()
References: <5208E231.60104@huawei.com>
In-Reply-To: <5208E231.60104@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 August 2013 06:55 PM, Libo Chen wrote:
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
Looks good.
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
