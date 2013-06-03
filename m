Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3FCHQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:16:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:28466 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FCHQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:16:26 -0400
Message-ID: <51AC42AC.9000606@huawei.com>
Date: Mon, 3 Jun 2013 15:15:56 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <nsujir@broadcom.com>, <mchan@broadcom.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <guohanjun@huawei.com>, <liuj97@gmail.com>
Subject: Re: [PATCH] tg3: remove redundant pm init code
References: <1369818032-36272-1-git-send-email-wangyijing@huawei.com> <20130603.001301.239203578028894121.davem@davemloft.net>
In-Reply-To: <20130603.001301.239203578028894121.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-7"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/3 15:13, David Miller wrote:
> From: Yijing Wang <wangyijing@huawei.com>
> Date: Wed, 29 May 2013 17:00:32 +0800
> 
>> Pci_enable_device() will set device pm state to D0, so
>> it's no need to do it again in tg3_init_one().
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> 
> This patch introduces a warning:
> 
> drivers/net/ethernet/broadcom/tg3.c: In function ¡tg3_init_one¢:
> drivers/net/ethernet/broadcom/tg3.c:17231:13: warning: ¡pm_cap¢ may be used uninitialized in this function [-Wuninitialized]
> 
Sorry, I will update it and resend soon.

Thanks!
Yijing.

-- 
Thanks!
Yijing

