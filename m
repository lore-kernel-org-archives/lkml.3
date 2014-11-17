Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaKQBz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 20:55:59 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:59530 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaKQBz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 20:55:58 -0500
Message-ID: <546955BF.6020104@lab.ntt.co.jp>
Date: Mon, 17 Nov 2014 10:56:15 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC: imammedo@redhat.com
Subject: Re: [PATCH 0/3] KVM: simplification to the memslots code
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 20:11, Paolo Bonzini wrote:
> Hi Igor and Takuya,
> 
> here are a few small patches that simplify __kvm_set_memory_region
> and associated code.  Can you please review them?

Ah, already queued.  Sorry for being late to respond.

	Takuya

> 
> Thanks,
> 
> Paolo
> 
> Paolo Bonzini (3):
>    kvm: memslots: track id_to_index changes during the insertion sort
>    kvm: commonize allocation of the new memory slots
>    kvm: simplify update_memslots invocation
> 
>   virt/kvm/kvm_main.c | 87 ++++++++++++++++++++++-------------------------------
>   1 file changed, 36 insertions(+), 51 deletions(-)
> 


