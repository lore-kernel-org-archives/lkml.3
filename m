Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3EPSp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:45:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46619 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3EPSp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:45:27 -0400
Message-ID: <5195293D.1060107@linux.vnet.ibm.com>
Date: Fri, 17 May 2013 02:45:17 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 4/8] KVM: x86: use the fast way to invalidate all pages
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1368706673-8530-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130516161903.GH14597@redhat.com>
In-Reply-To: <20130516161903.GH14597@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051618-5564-0000-0000-000007F52D1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 12:19 AM, Gleb Natapov wrote:
> On Thu, May 16, 2013 at 08:17:49PM +0800, Xiao Guangrong wrote:
>> Replace kvm_mmu_zap_all by kvm_mmu_invalidate_memslot_pages except on
>> the path of mmu_notifier->release() which will be fixed in
>> the later patch
>>
> Why ->release() cannot use kvm_mmu_invalidate_memslot_pages()?

Good eyes.

Forgot to update this part after applying new approach of
kvm_mmu_invalidate_memslot_pages(). Will update it.

