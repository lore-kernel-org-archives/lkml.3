Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaKZBW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:22:29 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:62581 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaKZBW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:22:28 -0500
Message-ID: <54752AC8.70309@huawei.com>
Date: Wed, 26 Nov 2014 09:20:08 +0800
From: Hanjun Guo <guohanjun@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Hanjun Guo <hanjun.guo@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        <linaro-acpi@lists.linaro.org>, Sudeep Holla <Sudeep.Holla@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] ACPI / processor: Update the comments in processor.h
References: <1414662780-2147-1-git-send-email-hanjun.guo@linaro.org> <2001637.yVyNT03Tcn@vostro.rjw.lan>
In-Reply-To: <2001637.yVyNT03Tcn@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.188]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.54752AD1.0095,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 60a80f91b999a528da98cd3ee5404c26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/26 7:13, Rafael J. Wysocki wrote:
> On Thursday, October 30, 2014 05:52:58 PM Hanjun Guo wrote:
>> In commit 46ba51e (ACPI / processor: Introduce ARCH_MIGHT_HAVE_ACPI_PDC),
>> acpi_processor_set_pdc() was moved to processor_pdc.c, so update
>> the comments accordingly.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Patches [2-3/3] from this set need to be rebased on top of current linux-next
> and resent, sorry about that.

No problem. I will rebase and resend today.

Thanks
Hanjun

