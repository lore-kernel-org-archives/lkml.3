Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3DYJFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:05:53 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41436 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3DYJFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:05:51 -0400
X-Spam-Score: -100.8
Message-ID: <5178F1BC.6050905@asianux.com>
Date: Thu, 25 Apr 2013 17:05:00 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Mike Qiu <qiudayu@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] PowerPC: kernel: compiling issue, make additional room
 in exception vector area
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com> <5178E6C3.4060603@asianux.com> <1659.1366880440@ale.ozlabs.ibm.com>
In-Reply-To: <1659.1366880440@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月25日 17:00, Michael Neuling wrote:
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  arch/powerpc/include/asm/kvm_asm.h   |    2 +-
>> >  arch/powerpc/kernel/exceptions-64s.S |    6 +++---
>> >  2 files changed, 4 insertions(+), 4 deletions(-)
>> > 
>> > diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
>> > index b9dd382..2c65bae 100644
>> > --- a/arch/powerpc/include/asm/kvm_asm.h
>> > +++ b/arch/powerpc/include/asm/kvm_asm.h
>> > @@ -86,7 +86,7 @@
>> >  #define BOOK3S_INTERRUPT_PROGRAM	0x700
>> >  #define BOOK3S_INTERRUPT_FP_UNAVAIL	0x800
>> >  #define BOOK3S_INTERRUPT_DECREMENTER	0x900
>> > -#define BOOK3S_INTERRUPT_HV_DECREMENTER	0x980
>> > +#define BOOK3S_INTERRUPT_HV_DECREMENTER	0x988
> This is hardwird in the architecture.. you can't just move it
> 

OK, thank you, I need continue to fix it. It seems we have to read the
details to shrink one instruction (4 bytes), at least.

Welcome additional suggestions or completions.

Thanks.

-- 
Chen Gang

Asianux Corporation
