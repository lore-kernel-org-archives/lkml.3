Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaIZIOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbaIZINW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:13:22 -0400
Message-ID: <54252014.5080805@redhat.com>
Date: Fri, 26 Sep 2014 10:13:08 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/8] kvm, mem-hotplug: Do not pin ept identity pagetable
 and apic access page.
References: <1411545478-9848-1-git-send-email-tangchen@cn.fujitsu.com> <54227EB4.7070608@redhat.com> <5423D015.6090107@cn.fujitsu.com> <54241BFA.5000503@redhat.com> <5424BF8B.1010701@cn.fujitsu.com>
In-Reply-To: <5424BF8B.1010701@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/09/2014 03:21, Tang Chen ha scritto:
>>>
>>> I'd like to help to test the patches.
>>> Would you please tell me what is the best way to test this patch-set ?
>> How did _you_ test the patches?...
> 
> I just added "-cpu xxx,-x2apic" option, start the guest, using numactl
> to bind it
> to a node (eg: node1). And offline the pages on node1. And repeat above
> thing
> for a while. And it is OK.
> 
> I'm not sure if this is enough.

Yes, this should be enough.

Paolo
