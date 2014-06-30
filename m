Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaF3MMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:12:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbaF3MMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:12:33 -0400
Message-ID: <53B1541E.4080008@redhat.com>
Date: Mon, 30 Jun 2014 14:12:14 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Bandan Das <bsd@redhat.com>,
        Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix lapic.c debug prints
References: <1404034131-2392-1-git-send-email-namit@cs.technion.ac.il> <jpgr427kys6.fsf@redhat.com> <53B0B773.3030107@gmail.com>
In-Reply-To: <53B0B773.3030107@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/06/2014 03:03, Nadav Amit ha scritto:
>>>
>>>           sipi_vector = apic->sipi_vector;
>>> -        pr_debug("vcpu %d received sipi with vector # %x\n",
>>> +        apic_debug("vcpu %d received sipi with vector # %x\n",
>>
>> Why don't we just use pr_debug all throughout ?
>>
> I don't know. I just tried to make it consistent, since it really bugged
> me while I was debugging the local-apic.
> If you prefer the other way around (which does seem to be better), I can
> do the search-and-replace.

vcpu number probably could be moved inside apic_debug, at which point 
apic_debug becomes preferrable.

Paolo
