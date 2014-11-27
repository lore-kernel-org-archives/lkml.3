Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaK0MQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:16:09 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:44295 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbaK0MQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAN8oO4A+_WyvtitEG75tQR3otfEq6zoou+Ve-OjkEg59agFYVg@mail.gmail.com>
References: <CAN8oO4BwKdK0AioN=r97NKB=RxrUNrn3822o9nrH466ras+aHA@mail.gmail.com>
	<20141127112931.GA3282@kernel>
	<CAN8oO4A+_WyvtitEG75tQR3otfEq6zoou+Ve-OjkEg59agFYVg@mail.gmail.com>
Date: Thu, 27 Nov 2014 17:46:06 +0530
Message-ID: <CAN8oO4Dc2EUtJkhULaV6CJ2RmF1aMXmNBEOwiMEbJ0mrt3ndNQ@mail.gmail.com>
Subject: Re: Allocating dedicated RAM to host that guest can not use
From: mad Engineer <themadengin33r@gmail.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a random thought can we set qemu user/group rss to a particular hard
limit in limits.conf

Can this work?

On Thu, Nov 27, 2014 at 5:39 PM, mad Engineer <themadengin33r@gmail.com> wrote:
> never tried that.
> can we do that transparently ie with out setting cgroups for each
> virtul machines?.
> A global group such that all combined virtual machines RAM utilization
> to be with in a specific value ?
>
> On Thu, Nov 27, 2014 at 4:59 PM, Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
>> On Thu, Nov 27, 2014 at 05:12:52PM +0530, mad Engineer wrote:
>>>Hi,
>>>    Is there any way to set some RAM dedicated to host that guest can
>>>not access?
>>>Similar to setting RAM to Dom0 in Xen.
>>>
>>>I am over committing RAM for the instances but don't want host to swap.
>>>
>>>i understand that virtual machines are process,but can we achieve this
>>
>> How about limit the memory of which guest can access through memory cgroup?
>>
>> Regards,
>> Wanpeng Li
>>
>>>
>>>Thanks
>>>--
>>>To unsubscribe from this list: send the line "unsubscribe kvm" in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
