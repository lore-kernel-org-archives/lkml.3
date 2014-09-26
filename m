Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaIZBVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:21:34 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:58144 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752669AbaIZBVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:21:33 -0400
X-IronPort-AV: E=Sophos;i="5.04,601,1406563200"; 
   d="scan'208";a="36490363"
Message-ID: <5424BF8B.1010701@cn.fujitsu.com>
Date: Fri, 26 Sep 2014 09:21:15 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, <gleb@kernel.org>,
        <mtosatti@redhat.com>, <nadav.amit@gmail.com>, <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v8 0/8] kvm, mem-hotplug: Do not pin ept identity pagetable
 and apic access page.
References: <1411545478-9848-1-git-send-email-tangchen@cn.fujitsu.com> <54227EB4.7070608@redhat.com> <5423D015.6090107@cn.fujitsu.com> <54241BFA.5000503@redhat.com>
In-Reply-To: <54241BFA.5000503@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/25/2014 09:43 PM, Paolo Bonzini wrote:
> Il 25/09/2014 10:19, Tang Chen ha scritto:
>> Hi Paolo,
>>
>> I'd like to help to test the patches.
>> Would you please tell me what is the best way to test this patch-set ?
> How did _you_ test the patches?...

I just added "-cpu xxx,-x2apic" option, start the guest, using numactl 
to bind it
to a node (eg: node1). And offline the pages on node1. And repeat above 
thing
for a while. And it is OK.

I'm not sure if this is enough.

Thanks.

>
>> I think ept page is being used by regular guest.
>> Is adding "-cpu xxx,-x2apic option" able to make sure guest is using
>> apic page ?
> Yes.
>
> Paolo
> .
>

