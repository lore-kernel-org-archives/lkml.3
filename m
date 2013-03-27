Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3C0MDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:03:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15644 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3C0MDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:03:32 -0400
X-Spam-Score: -100.7
Message-ID: <5152DFF1.2090000@asianux.com>
Date: Wed, 27 Mar 2013 20:02:57 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "anup.patel@linaro.org" <anup.patel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] ARM64:kernel: compiling issue for early_console.
References: <5152DB83.8080703@asianux.com> <20130327115509.GA1603@MacBook-Pro.local>
In-Reply-To: <20130327115509.GA1603@MacBook-Pro.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年03月27日 19:55, Catalin Marinas wrote:
> On Wed, Mar 27, 2013 at 11:44:03AM +0000, Chen Gang wrote:
>> >   the error message:
>> >     arch/arm64/kernel/early_printk.c: At top level:
>> >     arch/arm64/kernel/early_printk.c:98:23: error: conflicting types for ‘early_console’
>> >     In file included from arch/arm64/kernel/early_printk.c:20:0:
>> >     include/linux/console.h:145:24: note: previous declaration of ‘early_console’ was here
>> >     make[1]: *** [arch/arm64/kernel/early_printk.o] Error 1
>> >     make: *** [arch/arm64/kernel] Error 2
> Is this in linux-next? Mainline seems fine.

  yes, it is in next-20130326 at least :-)

> 
> I saw some patches from tglx on unifying the various early printk
> implementations, though not sure whether it's those patches causing it
> (in which case arm64 needs to be updated as well).

  maybe, but we need check the details to prove it :-)


  thanks.

-- 
Chen Gang

Asianux Corporation
