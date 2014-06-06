Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaFFAUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 20:20:38 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52690 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFFAUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 20:20:36 -0400
Message-ID: <5391094D.7090104@ozlabs.ru>
Date: Fri, 06 Jun 2014 10:20:29 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 0/3] Prepare for in-kernel VFIO DMA operations acceleration
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru> <53905B14.5020204@suse.de>
In-Reply-To: <53905B14.5020204@suse.de>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 09:57 PM, Alexander Graf wrote:
> 
> On 05.06.14 09:25, Alexey Kardashevskiy wrote:
>> This reserves 2 capability numbers.
>>
>> This implements an extended version of KVM_CREATE_SPAPR_TCE_64 ioctl.
>>
>> Please advise how to proceed with these patches as I suspect that
>> first two should go via Paolo's tree while the last one via Alex Graf's tree
>> (correct?).
> 
> They would just go via my tree, but only be actually allocated (read:
> mergable to qemu) when they hit Paolo's tree.
> 
> In fact, I don't think it makes sense to split them off at all.


So? Are these patches going anywhere? Thanks.


-- 
Alexey
