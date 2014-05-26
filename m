Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaEZRlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:41:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54934 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaEZRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:41:38 -0400
Message-ID: <53837CCF.7010807@infradead.org>
Date: Mon, 26 May 2014 10:41:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>
Subject: Re: linux-next: Tree for May 26 (syscalls is85/ia32 on x86_64)
References: <20140526193819.2ba7bc07@canb.auug.org.au>
In-Reply-To: <20140526193819.2ba7bc07@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 02:38 AM, Stephen Rothwell wrote:
> Hi all,
> 
> The powerpc allyesconfig is again broken more than usual.
> 
> Changes since 20140523:
> 

I get lots of build errors (and have for the past week of so)
like this:


  CC      arch/x86/kernel/asm-offsets.s
In file included from ../arch/x86/kernel/asm-offsets.c:27:0:
../arch/x86/kernel/asm-offsets_64.c:15:29: fatal error: asm/syscalls_32.h: No such file or directory
compilation terminated.
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1


when CONFIG_X86_X32_ABI is not enabled.

-- 
~Randy
