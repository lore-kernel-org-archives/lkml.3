Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaKQJai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:30:38 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:52819 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKQJag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:30:36 -0500
Message-ID: <5469C04D.6060702@lab.ntt.co.jp>
Date: Mon, 17 Nov 2014 18:30:53 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, imammedo@redhat.com
Subject: Re: [PATCH 0/3] KVM: simplification to the memslots code
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com> <546955BF.6020104@lab.ntt.co.jp> <5469BEAF.9030707@redhat.com>
In-Reply-To: <5469BEAF.9030707@redhat.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/17 18:23, Paolo Bonzini wrote:
> 
> 
> On 17/11/2014 02:56, Takuya Yoshikawa wrote:
>>>> here are a few small patches that simplify __kvm_set_memory_region
>>>> and associated code.  Can you please review them?
>> Ah, already queued.  Sorry for being late to respond.
> 
> While they are not in kvm/next, there's time to add Reviewed-by's and
> all that.  kvm/queue basically means "I want Fengguang to compile-test
> them, some testing done on x86_64".
> 
> Paolo
> 

OK.

I reviewed patch 2/3 and 3/3, and saw no problem, some
improvements, there.

	Takuya


