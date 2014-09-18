Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaIRNHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbaIRNHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:07:47 -0400
Message-ID: <541AD8F3.5010700@redhat.com>
Date: Thu, 18 Sep 2014 15:06:59 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Nadav Amit <namit@cs.technion.ac.il>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
References: <20140917124501.GC5358@nazgul.tnic> <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il> <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il> <20140917132141.GD5358@nazgul.tnic> <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com> <20140917140601.GE5358@nazgul.tnic>
In-Reply-To: <20140917140601.GE5358@nazgul.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/09/2014 16:06, Borislav Petkov ha scritto:
>> > AFAIK backward compatibility is usually maintained in x86. I did not
>> > see in Intel SDM anything that says "this CPUID field means something
>> > for CPU X and something else for CPU Y". Anyhow, it is not different
>> > than bitmasks in this respect.
> You still don't get my point: what are you going to do when
> min_monitor_line_size needs to be 17 bits all of a sudden?

The extra bit used to be reserved and thus will be zero on older
families.  So, nothing?

Paolo
