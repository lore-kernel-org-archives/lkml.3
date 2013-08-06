Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3HFTED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 15:04:03 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38779 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3HFTEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 15:04:01 -0400
Message-ID: <52014A2C.5080705@linux.vnet.ibm.com>
Date: Wed, 07 Aug 2013 00:40:36 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Eric Northup <digitaleric@google.com>
CC: Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        habanero@linux.vnet.ibm.com, Rik van Riel <riel@redhat.com>,
        srivatsa.vaddagiri@gmail.com, KVM <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        chegu_vinod@hp.com, drjones@redhat.com, ouyang@cs.pitt.edu,
        Andi Kleen <andi@firstfloor.org>, avi.kivity@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V12 3/5] kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl
 to aid migration
References: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com> <20130806182309.2386.35697.sendpatchset@codeblue.in.ibm.com> <CAG7+5M3_4D+hQn3xWefniKRWzkdraLCJKHG2PrLGPZLJQQUZVA@mail.gmail.com>
In-Reply-To: <CAG7+5M3_4D+hQn3xWefniKRWzkdraLCJKHG2PrLGPZLJQQUZVA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080618-2000-0000-0000-00000D34CDA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 12:02 AM, Eric Northup wrote:
>
> If this is about migration correctness, could it get folded into the
> previous patch 2/5, so that there's not a broken commit which could
> hurt bisection?

Yes. It could be. Only reason I maintained like that was,
original author in the previous patch is different (Srivatsa) and I did
not want to merge this hunk when the patch series got evolved to mix
the sign-offs.

Gleb, Paolo please let me know.


