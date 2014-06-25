Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbaFYVMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:12:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbaFYVMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:12:14 -0400
Message-ID: <53AB3B28.3040708@suse.de>
Date: Wed, 25 Jun 2014 23:12:08 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 0/3] Prepare for in-kernel VFIO DMA operations acceleration
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru> <53905B14.5020204@suse.de> <5391094D.7090104@ozlabs.ru>
In-Reply-To: <5391094D.7090104@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06.06.14 02:20, Alexey Kardashevskiy wrote:
> On 06/05/2014 09:57 PM, Alexander Graf wrote:
>> On 05.06.14 09:25, Alexey Kardashevskiy wrote:
>>> This reserves 2 capability numbers.
>>>
>>> This implements an extended version of KVM_CREATE_SPAPR_TCE_64 ioctl.
>>>
>>> Please advise how to proceed with these patches as I suspect that
>>> first two should go via Paolo's tree while the last one via Alex Graf's tree
>>> (correct?).
>> They would just go via my tree, but only be actually allocated (read:
>> mergable to qemu) when they hit Paolo's tree.
>>
>> In fact, I don't think it makes sense to split them off at all.
>
> So? Are these patches going anywhere? Thanks.

So? Are you going to address the comments?


Alex

