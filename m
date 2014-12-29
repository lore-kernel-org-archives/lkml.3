Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaL2DTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 22:19:11 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:5902 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaL2DTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 22:19:08 -0500
Message-ID: <54A0C70D.7040706@huawei.com>
Date: Mon, 29 Dec 2014 11:14:21 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>
CC: <dedekind1@gmail.com>, <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>, <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>
In-Reply-To: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/3 21:58, Tanya Brokhman wrote:
> If there is more then one UBI device mounted, there is no way to
> distinguish between messages from different UBI devices.
> Add device number to all ubi layer message types.
> 
> The R/O block driver messages were replaced by pr_* since
> ubi_device structure is not used by it.
> 
> Amended a bit by Artem.
> 
> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
> Changes from V1:


Hi Artem and Tanya,

Do you think the similar effort is worth to be done on ubifs-level?

We could have several ubifs partition mounted on a host.

Thanks,
Hu


