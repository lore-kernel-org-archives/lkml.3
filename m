Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaDRBHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:07:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51605 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaDRBHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:07:50 -0400
Message-ID: <53507AC0.4020602@huawei.com>
Date: Fri, 18 Apr 2014 09:07:12 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>,
        Kefeng Wang <kefeng.wang@linaro.org>
Subject: Re: [PATCH V2 2/2] ahci: add support for Hisilicon sata
References: <1397107468-640-1-git-send-email-wangkefeng.wang@huawei.com> <1397107468-640-3-git-send-email-wangkefeng.wang@huawei.com> <20140416204917.GB26632@htj.dyndns.org> <534F8733.1080009@redhat.com> <20140417133151.GC15326@htj.dyndns.org>
In-Reply-To: <20140417133151.GC15326@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17 21:31, Tejun Heo wrote:
> On Thu, Apr 17, 2014 at 09:48:03AM +0200, Hans de Goede wrote:
>>> Hmmm.... this should work but looks a bit tedious and it could be
>>> better to have a better mechanism to match devices to their
>>> port_infos.  Hans, can you please comment?  If getting something more
>>> structured is too much work, I can go with this but wanna find out
>>> whether that's the case.
>>
>> The more structured solution would be v1 of this patch, which I asked
>> Kefan to change since it seemed overkill. But if you prefer that version
>> that is fine with me.
> 
> I don't care either way at this point but if this grows to a large
> list, having a matching mechanism will probably be more manageable.
> 
>> Note that as I've already mentioned earlier in the thread this could be
>> made somewhat cleaner by having an host_flags parameter to
>> ahci_platform_init_host().
> 
> Kefeng, can you please update accordingly to Hans' comment and repost?

Sure, Thanks for the advice from you and Hans, will update.

> 
> Thanks.
> 


