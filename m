Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaIKH5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:57:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:44015 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaIKH47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:56:59 -0400
Message-ID: <54115583.8080306@huawei.com>
Date: Thu, 11 Sep 2014 15:55:47 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: add guard macro of unistd.h to prevent double
 inclusion
References: <1410235185-16652-1-git-send-email-yangyingliang@huawei.com> <20140909123938.GL1754@arm.com>
In-Reply-To: <20140909123938.GL1754@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.231]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/9 20:39, Will Deacon wrote:
> On Tue, Sep 09, 2014 at 04:59:45AM +0100, Yang Yingliang wrote:
>> Add guard macros in both uapi/asm/unistd.h and asm/unistd.h.
>>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>  arch/arm64/include/asm/unistd.h      | 5 +++++
>>  arch/arm64/include/uapi/asm/unistd.h | 5 +++++
>>  2 files changed, 10 insertions(+)
> 
> We probably need something similar for unistd32.h too, as lib/compat_audit.c
> now includes that.
> 
> Can you post a v2 please?
> 
> Will
> 
> 
OK, I'll send a v2.

Regards,
Yang

