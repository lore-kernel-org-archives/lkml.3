Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3C0Lze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:55:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46104 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149Ab3C0Lzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:55:33 -0400
Date: Wed, 27 Mar 2013 11:55:09 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "anup.patel@linaro.org" <anup.patel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] ARM64:kernel: compiling issue for early_console.
Message-ID: <20130327115509.GA1603@MacBook-Pro.local>
References: <5152DB83.8080703@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5152DB83.8080703@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:44:03AM +0000, Chen Gang wrote:
>   the error message:
>     arch/arm64/kernel/early_printk.c: At top level:
>     arch/arm64/kernel/early_printk.c:98:23: error: conflicting types for ‘early_console’
>     In file included from arch/arm64/kernel/early_printk.c:20:0:
>     include/linux/console.h:145:24: note: previous declaration of ‘early_console’ was here
>     make[1]: *** [arch/arm64/kernel/early_printk.o] Error 1
>     make: *** [arch/arm64/kernel] Error 2

Is this in linux-next? Mainline seems fine.

I saw some patches from tglx on unifying the various early printk
implementations, though not sure whether it's those patches causing it
(in which case arm64 needs to be updated as well).

-- 
Catalin
