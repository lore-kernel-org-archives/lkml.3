Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3FYJkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:40:22 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46997 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3FYJkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:40:20 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <51C96322.9000801@suse.cz>
References: <20130625184420.b811089a069c63ccd3721d68@canb.auug.org.au>
	<CA+icZUUH7AeR7OSm-SB56AGRiE815tTkQW9fFkKzyrSvzs3Etg@mail.gmail.com>
	<201306251121.53862.yann.morin.1998@free.fr>
	<CA+icZUU06C43bxyX2UGtDxRQqcyqeAQgt7fZHq7H7HgcJ6sHzQ@mail.gmail.com>
	<51C96322.9000801@suse.cz>
Date: Tue, 25 Jun 2013 11:40:18 +0200
Message-ID: <CA+icZUWS6d98YA7_rdjXw-R3V+OyV2YCH9Hpn-C+qB385-QO_g@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 25
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:30 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 25.6.2013 11:26, Sedat Dilek wrote:
>> On Tue, Jun 25, 2013 at 11:21 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
>> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=a11650e11093ed57dca78bf16e7836517c599098
>>
>>>   - for tristate choices, it is possible to select zero, one or more of the
>>>     symbols in the choice
>>>   - if no symbol is selected (randomly or otherwise) in a tristate choice,
>>>     then the choice symbol itself has no assigned 'value'
>>>   - then silentoldconfig whines
>>
>> Bad bad bad Yann, didn't Marek told you to test always with...
>>
>>     $ yes "" | make oldconfig; make silentoldconfig </dev/null
>>
>> Anyway, have fun.
>
> You only hit this if you have CONFIG_RAPIDIO=y in the original config.
>

OK, my kernel-config base was from a Ubuntu/precise kernel.
You are right for x86 it is not a defconfig.

$ grep RAPIDIO arch/x86/configs/*_defconfig

$ grep RAPIDIO arch/powerpc/configs/*_defconfig
arch/powerpc/configs/corenet32_smp_defconfig:CONFIG_RAPIDIO=y
arch/powerpc/configs/corenet64_smp_defconfig:CONFIG_RAPIDIO=y
arch/powerpc/configs/mpc85xx_defconfig:CONFIG_RAPIDIO=y
arch/powerpc/configs/mpc85xx_smp_defconfig:CONFIG_RAPIDIO=y

Anyway, it is good we catched this.

- Sedat -


> Michal
