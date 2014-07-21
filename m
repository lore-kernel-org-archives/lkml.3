Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaGUMbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:31:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaGUMbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:31:22 -0400
Message-ID: <53CD080A.1000400@redhat.com>
Date: Mon, 21 Jul 2014 14:31:06 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: x86: Additional rflags.rf fixes
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il> <53CD056E.4050203@redhat.com> <53CD077A.1020409@gmail.com>
In-Reply-To: <53CD077A.1020409@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/07/2014 14:28, Nadav Amit ha scritto:
>>
> 
> Thanks for the quick response. I will address the issues you raised.
> 
> Please review and apply as well "[PATCH] KVM: x86: emulator injects #DB
> when RFLAGS.RF is set" which was submitted before. (
> http://www.spinics.net/lists/kvm/msg105858.html ).
> as well.

That's the penultimate patch I applied:

>>        KVM: x86: Clearing rflags.rf upon skipped emulated instruction
>>        KVM: x86: popf emulation should not change RF
>>        KVM: x86: Clear rflags.rf on emulated instructions
>>        KVM: x86: Cleanup of rflags.rf cleaning
>>        KVM: x86: emulator injects #DB when RFLAGS.RF is set
>>        KVM: x86: Defining missing x86 vectors 

Paolo
