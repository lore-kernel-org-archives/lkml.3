Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaBQLlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 06:41:04 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:40345 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBQLlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 06:41:03 -0500
Message-ID: <5301F4FC.30301@huawei.com>
Date: Mon, 17 Feb 2014 19:39:40 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Robert Richter <rric@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        "sdu.liu@huawei.com" <sdu.liu@huawei.com>
Subject: Re: [PATCH] oprofile: check whether oprofile perf enabled in op_overflow_handler()
References: <52D5EC44.30101@huawei.com> <20140115102445.GE20315@rric.localhost> <52D73148.4090408@huawei.com> <52D7A750.50906@huawei.com> <20140116115245.GB8360@rric.localhost> <20140116193652.GD22105@mudshark.cambridge.arm.com> <52D8A56F.1010507@huawei.com> <52F9A82F.3060806@huawei.com> <20140211155207.GK8693@mudshark.cambridge.arm.com> <52FED3C5.1060703@huawei.com> <20140217100827.GA26312@mudshark.cambridge.arm.com>
In-Reply-To: <20140217100827.GA26312@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/17 18:08, Will Deacon wrote:
> On Sat, Feb 15, 2014 at 02:41:09AM +0000, Weng Meiling wrote:
>> Hi Will,
>>
>>  I test kernel with this patch, the problem has be fixed. When the
>>  event's sample_period is small, the cpu will not stall except printing
>>  warning "oprofile: ignoring spurious overflow ignoring spurious overflow".
>>  This is normal for unregistered event.
>>
>>  So would you please send a formal one? :) Thanks very much!
> 
> It's already in -next.
> 
> Will
> 
> 

OK, Thanks~

