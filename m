Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbaD3N3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:29:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47373 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964885AbaD3N3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:29:40 -0400
Message-ID: <5360FB07.5030407@arm.com>
Date: Wed, 30 Apr 2014 14:30:47 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>, Will Deacon <Will.Deacon@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
References: <1398133596-29170-1-git-send-email-zhangwm@marvell.com> <20140422103642.GF7484@arm.com> <175CCF5F49938B4D99B2E3EF7F558EBE5507A3B59B@SC-VEXCH4.marvell.com> <20140423170821.GJ5649@arm.com> <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com>
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com>
X-OriginalArrivalTime: 30 Apr 2014 13:29:52.0706 (UTC) FILETIME=[449D8220:01CF6478]
X-MC-Unique: 114043014293800501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 30/04/14 03:21, Neil Zhang wrote:
> 
>> -----Original Message-----
>> From: Will Deacon [mailto:will.deacon@arm.com]

[...]

>>
>> I think we need some input from the device-tree guys to see whether they
>> would object to us solving this locally (in the PMU node) or not.
>> Personally, I'd much prefer a general way to describe the need for pm-notifiers,
>> but if that's not being looked at then we can cook something specifically for
>> our needs.
>>
> 
> No input from device-tree guys :(

The device tree bindings for power domains is under discussion [1]

Regards,
Sudeep

[1] https://lkml.org/lkml/2014/4/23/755

