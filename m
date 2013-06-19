Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783Ab3FSNAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:00:48 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40746 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833Ab3FSNAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:00:47 -0400
Message-ID: <51C1AB74.40503@linux.vnet.ibm.com>
Date: Wed, 19 Jun 2013 21:00:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 5/7] KVM: MMU: document fast page fault in
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <51C1A083.9050209@redhat.com>
In-Reply-To: <51C1A083.9050209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061912-5140-0000-0000-0000036682AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 08:13 PM, Paolo Bonzini wrote:
> Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
>> Document fast page fault to Documentation/virtual/kvm/mmu.txt
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  Documentation/virtual/kvm/mmu.txt | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
>> index 4fb442b..b5ce7dd 100644
>> --- a/Documentation/virtual/kvm/mmu.txt
>> +++ b/Documentation/virtual/kvm/mmu.txt
>> @@ -275,6 +275,9 @@ Handling a page fault is performed as follows:
>>     information is stored and cache the information to vcpu->arch.mmio_gva,
>>     vcpu->arch.access and vcpu->arch.mmio_gfn then call the emulator to emulate
>>     the instruction who will get the benefit from the cached mmio info
>> + - If both P bit and R/W bit of error code are set, there has a chance to
>> +   fast fix the page fault, please see the description of "Fast page fault" in
>> +   Documentation/virtual/kvm/locking.txt

Nice.

