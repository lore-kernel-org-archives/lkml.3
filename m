Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3HQLw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 07:52:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54587 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3HQLwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 07:52:24 -0400
Message-ID: <520F63DD.8070607@ti.com>
Date: Sat, 17 Aug 2013 17:21:57 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: David Miller <davem@davemloft.net>, <bigeasy@linutronix.de>,
        <prabhakar.csengg@gmail.com>, <b-liu@ti.com>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3 7/7] net: davinci_mdio: use platform_{get,set}_drvdata()
References: <520CD13E.7090802@huawei.com>
In-Reply-To: <520CD13E.7090802@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 August 2013 06:31 PM, Libo Chen wrote:
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
I had given my ack for your previous version itself, I don't know why
you didn't add my Ack in next version.
Any how

Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N

