Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab3EKL1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 07:27:25 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33315 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3EKL1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 07:27:23 -0400
Message-ID: <518E2B34.7080503@gmail.com>
Date: Sat, 11 May 2013 19:27:48 +0800
From: Libo Chen <chenlibo.3@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: ben-linux@fluff.org, kgene.kim@samsung.com, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, libo.chen@huawei.com,
        stern@rowland.harvard.edu, akpm@linux-foundation.org
Subject: Re: [PATCH] usb: gadget: s3c2410: fix clk resource leak and update
References: <518DE4FF.1000702@gmail.com> <1684189.YrZqmJjoym@flatron>
In-Reply-To: <1684189.YrZqmJjoym@flatron>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013-5-11 18:15, Tomasz Figa 写道:
> Hi Libo,
>
> On Saturday 11 of May 2013 14:28:15 Libo Chen wrote:
>> >From: Libo Chen<libo.chen@huawei.com>
> The patch subject is slightly misleading. It suggests that the patch only
> changes clock handling, but in fact the biggest part of the patch is
> conversion to devm_ helpers.
>
> I think following subject would suit this patch better:
>
> [PATCH] usb: gadget: s3c2410: Convert to managed resource allocation
>
> What do you think?
>
> Also please see my comments inline.
>

Hi Tomasz,

Thank you for your remind. Sorry, I forgeted to add RFC.

"Convert to managed resource allocation" is more suitable.

Your advice is very helpfull for me to understand those interfaces.
I will be careful in the future patches.

Thanks again


