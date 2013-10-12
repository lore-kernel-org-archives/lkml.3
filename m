Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3JLW2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:28:49 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47485 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3JLW2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 18:28:48 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] arm/arm64: remove atomic_clear_mask() in "include/asm/atomic.h"
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <20131011165530.GS14732@mudshark.cambridge.arm.com>
Date: Sat, 12 Oct 2013 23:28:42 +0100
Cc: Chen Gang <gang.chen@asianux.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <794E70F6-80D3-4100-A0FF-A6F34AFB9A59@arm.com>
References: <5256117A.4000009@asianux.com> <5256121A.9030504@asianux.com> <52561269.60900@asianux.com> <20131010100733.GH3817@mudshark.cambridge.arm.com> <52568998.2080108@asianux.com> <20131010142305.GG6199@mudshark.cambridge.arm.com> <525751E2.3020207@asianux.com> <20131011104419.GE14732@mudshark.cambridge.arm.com> <5257E033.3090607@asianux.com> <5257E539.9080902@asianux.com> <20131011165530.GS14732@mudshark.cambridge.arm.com>
To: Will Deacon <will.deacon@arm.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Oct 2013, at 17:55, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Oct 11, 2013 at 12:47:05PM +0100, Chen Gang wrote:
>> In current kernel wide source code, except other architectures, only
>> s390 scsi drivers use atomic_clear_mask(), and arm/arm64 need not
>> support s390 drivers.
>> 
>> So remove atomic_clear_mask() from "arm[64]/include/asm/atomic.h".
> 
>  Acked-by: Will Deacon <will.deacon@arm.com>
> 
> Catalin, are you happy for me to send this via the ARM tree?

Fine by me.

Catalin
