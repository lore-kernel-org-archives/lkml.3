Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaGGPmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:42:33 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58421 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaGGPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:42:30 -0400
Message-ID: <53BABFDE.1000703@gmail.com>
Date: Mon, 07 Jul 2014 09:42:22 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/4] perf kvm: Use defines of kvm events
References: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com> <1404397747-20939-2-git-send-email-yarygin@linux.vnet.ibm.com> <53BAA963.2010800@de.ibm.com>
In-Reply-To: <53BAA963.2010800@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/7/14, 8:06 AM, Christian Borntraeger wrote:
> On 03/07/14 16:29, Alexander Yarygin wrote:
>> Currently perf-kvm uses string literals for kvm event names,
>> but it works only for x86, because other architectures may have
>> other names for those events.
>>
>> To reduce dependence on architecture, we add <asm/kvm_perf.h> file with
>> defines for:
>> - kvm_entry and kvm_exit events,
>> - exit reason field name in kvm_exit event,
>> - length of exit reasons strings,
>> - vcpu_id field name in kvm trace events,
>>
>> and replace literals in perf-kvm.
>>
>> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
>> Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Would be good if Paolo and David could ack the KVM/perf parts. Then this should also go into next merge window.

I want to try out the patches on x86 and verify compiles on ppc; 
hopefully by end of day tomorrow.

David

