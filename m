Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaBKEgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 23:36:00 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:50221 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaBKEf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 23:35:57 -0500
Message-ID: <52F9A82F.3060806@huawei.com>
Date: Tue, 11 Feb 2014 12:33:51 +0800
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
References: <52B3F66D.6060707@huawei.com> <20140113084555.GU20315@rric.localhost> <52D4984B.9090600@huawei.com> <20140114150553.GC20315@rric.localhost> <52D5EC44.30101@huawei.com> <20140115102445.GE20315@rric.localhost> <52D73148.4090408@huawei.com> <52D7A750.50906@huawei.com> <20140116115245.GB8360@rric.localhost> <20140116193652.GD22105@mudshark.cambridge.arm.com> <52D8A56F.1010507@huawei.com>
In-Reply-To: <52D8A56F.1010507@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

> 
>>> how userland can be notified about throttling. Throttling could be
>>> worth for operf too, not only for the oprofile kernel driver.
>>>
> 
>>> From a quick look it seems there is also code in x86 that dynamically
>>> adjusts the rate which might be worth being implemented for ARM too.
>>
>> Are you referring to the perf_sample_event_took callback? If so, that
>> certainly looks worth persuing. I'll stick it on my list, thanks!
>>

Is there any progress on this work? Because this is important for me.
Sorry for trouble you.

Thanks!
Weng Meiling


