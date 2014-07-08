Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaGHPUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:20:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbaGHPUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:20:37 -0400
Message-ID: <53BC0C2B.4060604@redhat.com>
Date: Tue, 08 Jul 2014 17:20:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Gabriel L. Somlo" <gsomlo@gmail.com>, KVM <kvm@vger.kernel.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Eric Northup <digitaleric@google.com>,
        Nadav Amit <namit@cs.technion.ac.il>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nadav.amit@gmail.com, joro@8bytes.org, agraf@suse.de
Subject: Re: Ping: Re: [PATCH] Revert "kvm: x86: emulate monitor and mwait
 instructions as nop"
References: <20140619135935.GG1695@ERROL.INI.CMU.EDU> <20140708151542.GF1688@ERROL.INI.CMU.EDU>
In-Reply-To: <20140708151542.GF1688@ERROL.INI.CMU.EDU>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/07/2014 17:15, Gabriel L. Somlo ha scritto:
> Any decision on this ? If we're going to revert monitor/mwait as nop,
> it's hopefully not too late to avoid having it show up in an official
> (3.16 ?) kernel release...

I don't really see a reason to revert it.

Paolo
