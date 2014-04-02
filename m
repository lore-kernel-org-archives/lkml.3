Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbaDBLGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:06:41 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:55674 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161AbaDBLGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:06:39 -0400
Message-ID: <533BEF38.50301@de.ibm.com>
Date: Wed, 02 Apr 2014 13:06:32 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
CC: gleb@kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for 3.15 merge window
References: <1396254646-14971-1-git-send-email-pbonzini@redhat.com> <533938AE.5060709@redhat.com>
In-Reply-To: <533938AE.5060709@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040211-4966-0000-0000-000008EDD39B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/14 11:43, Paolo Bonzini wrote:
> Il 31/03/2014 10:30, Paolo Bonzini ha scritto:
>> Linus,
>>
>> The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:
>>
>>   Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.15-1
> 
> Also at tags/for-linus, but request-pull chose this other tag for some reason.
> 
> Paolo
> 
>> for you to fetch changes up to 7227fc0666606b0df2c0d2966a7f4859b01bdf74:
>>
>>   Merge branch 'kvm-ppchv-next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into kvm-next (2014-03-29 15:44:05 +0100)
>>
>> No other changes expected for this merge window.

Linus, fyi, this will cause a merge conflict in arch/s390/include/asm/kvm_host.h

Fixup looks like
	__u32   fac;                    /* 0x01a0 */
	__u8    reserved1a4[20];        /* 0x01a4 */
	__u64   cbrlo;                  /* 0x01b8 */
	__u8    reserved1c0[30];        /* 0x01c0 */
	__u64   pp;                     /* 0x01de */
	__u8    reserved1e6[2];         /* 0x01e6 */
	__u64   itdba;                  /* 0x01e8 */
	__u8    reserved1f0[16];        /* 0x01f0 */


see
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next-history.git/commit/arch/s390/include/asm/kvm_host.h?id=9f6b9558157c2670410827d2ca969bb7a325a8ec

Christian

