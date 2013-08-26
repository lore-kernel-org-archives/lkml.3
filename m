Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab3HZKWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:22:41 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42031 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3HZKWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:22:39 -0400
Message-ID: <521B2DE1.4060306@linux.vnet.ibm.com>
Date: Mon, 26 Aug 2013 15:58:49 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        jeremy@goop.org, konrad.wilk@oracle.com, peterz@infradead.org,
        tglx@linutronix.de, agraf@suse.de, digitaleric@google.com,
        riel@redhat.com, avi.kivity@gmail.com, habanero@linux.vnet.ibm.com,
        chegu_vinod@hp.com, ouyang@cs.pitt.edu, drjones@redhat.com,
        linux-doc@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, andi@firstfloor.org,
        virtualization@lists.linux-foundation.org, mtosatti@redhat.com,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH V13 0/4] Paravirtualized ticket spinlocks for KVM host
References: <y> <1377506916-26946-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20130826100401.GZ8218@redhat.com>
In-Reply-To: <20130826100401.GZ8218@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082610-5816-0000-0000-0000099514C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 03:34 PM, Gleb Natapov wrote:
> On Mon, Aug 26, 2013 at 02:18:32PM +0530, Raghavendra K T wrote:
>>
>>   This series forms the kvm host part of paravirtual spinlock
>>   based against kvm tree.
>>
>>   Please refer to https://lkml.org/lkml/2013/8/9/265 for
>>   kvm guest and Xen, x86 part merged to -tip spinlocks.
>>
>>   Please note that:
>>   kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi is a common patch
>>   for both guest and host.
>>
> Thanks, applied. The patchset is not against kvm.git queue though, so I
> had to fix one minor conflict manually.

Thank you Gleb.

