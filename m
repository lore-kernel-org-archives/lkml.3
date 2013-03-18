Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3CRHiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 03:38:17 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58383 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3CRHiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 03:38:16 -0400
Message-ID: <5146C45D.4010903@linux.vnet.ibm.com>
Date: Mon, 18 Mar 2013 15:38:05 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] KVM: MMU: fast invalid all mmio sptes
References: <51433D98.4050605@linux.vnet.ibm.com> <51433E71.2070107@linux.vnet.ibm.com> <20130316111330.6e077a421aa580d80dc08641@gmail.com>
In-Reply-To: <20130316111330.6e077a421aa580d80dc08641@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031807-4790-0000-0000-0000076F2267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 10:13 AM, Takuya Yoshikawa wrote:
> On Fri, 15 Mar 2013 23:29:53 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> +/*
>> + * The caller should protect concurrent access on
>> + * kvm->arch.mmio_invalid_gen. Currently, it is used by
>> + * kvm_arch_commit_memory_region and protected by kvm->slots_lock.
>> + */
>> +void kvm_mmu_invalid_mmio_spte(struct kvm *kvm)
> 
> kvm_mmu_invalidate_mmio_sptes() may be a better name.

Yes, i am not good at naming, this is a better name, thank you!

