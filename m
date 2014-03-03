Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaCCIsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:48:55 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:57250 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaCCIsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:48:54 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s238m579019862, This message is accepted by code: ctloc85258
Message-ID: <531441D8.8090209@realtek.com>
Date: Mon, 3 Mar 2014 16:48:24 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Chris Ball <chris@printf.net>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v4 1/3] mfd: Add realtek USB card reader driver
References: <1392199238-14500-1-git-send-email-rogerable@realtek.com>	<1392199238-14500-2-git-send-email-rogerable@realtek.com>	<20140214094427.GA7380@lee--X1> <5301A786.8040607@realtek.com>	<20140217082222.GA17875@lee--X1> <5301D369.5010100@realtek.com>	<20140217100211.GE17875@lee--X1> <5301E376.8010000@realtek.com>	<20140217120326.GC20218@lee--X1> <530AB4D3.4090103@realtek.com> <86mwhhrz9b.fsf@void.printf.net>
In-Reply-To: <86mwhhrz9b.fsf@void.printf.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 11:00 AM, Chris Ball wrote:
> Hi,
>
> On Mon, Feb 24 2014, Roger wrote:
>> Would you please help comment PATCH 2/3 and 3/3 (for mmc and memstick,
>> respectively) or give Acks? Thus we can proceed with applying or
>> revision if necessary.
>
> For 2/3:
>
> Acked-by: Chris Ball <chris@printf.net>
>
> Thanks,
>
> - Chris.
>
Hi Andrew,

Could you please give some comment to the 3/3(memstick) patch?


Best regards,
Roger Tseng
