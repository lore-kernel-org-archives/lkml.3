Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaBSVkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:40:19 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:45549 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbaBSVkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:40:17 -0500
MIME-Version: 1.0
In-Reply-To: <20140205133736.GF7550@arm.com>
References: <1389950591-4212-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140123150123.GH27520@arm.com>
	<20140205133736.GF7550@arm.com>
Date: Wed, 19 Feb 2014 22:40:16 +0100
Message-ID: <CAKv+Gu9kKAYTmP-j0wqM6xHaAHCWYbqxzoeJPPsTNW2Ozujbfw@mail.gmail.com>
Subject: Re: [PATCH v2 resend 0/5] arm64: advertise availability of CRC and
 crypto instructions
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 February 2014 14:37, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Thu, Jan 23, 2014 at 03:01:23PM +0000, Catalin Marinas wrote:
>> On Fri, Jan 17, 2014 at 09:23:06AM +0000, Ard Biesheuvel wrote:
>> > Ard Biesheuvel (5):
>> >   ARM: add support for AT_HWCAP2 ELF auxv entry
>> >   binfmt_elf: add ELF_HWCAP2 to compat auxv entries
>> >   arm64: add AT_HWCAP2 support for 32-bit compat
>> >   ARM: introduce HWCAP2 feature bits for ARMv8 Crypto Extensions
>> >   arm64: advertise ARMv8 extensions to 32-bit compat ELF binaries
>>
>> I think I acked this series but probably after you posted the resend.
>> Just in case I haven't:
>>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>
> Just to get things moving on this, I suggest you get an ack on the
> binfmt_elf patch from Al Viro and linux-fsdevel or get them to merge
> this patch. Afterwards, if there are no further comments from Russell,
> you should send the arm patches to the patch system. Only after that
> I'll update the compat arm64 support. Feel free to add my ack on the
> whole series.
>

ARM patches submitted to the patch system as 7981/1 and 7982/1

Regards,
Ard.
