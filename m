Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030204Ab3DSMND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:13:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58588 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968244Ab3DSMNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:13:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen@asianux.com>
Subject: Re: [Suggestion] ARM64: kernel: compiling issue, need implement cmpxchg64 with assembler language.
Date: Fri, 19 Apr 2013 14:12:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51712E5E.2020809@asianux.com>
In-Reply-To: <51712E5E.2020809@asianux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191412.54601.arnd@arndb.de>
X-Provags-ID: V02:K0:qxATHFze3+3+CnqVL3w00rJBvzSmnl8WkLzOI7pkZpR
 cgoF7CNcAZA+eDUsrTlXfi63tcFQDE5bOTJQsNx9MtyRiUYP6D
 EBLaKMeqYX4Ilgha41VytvlMhcaZqdCk5te0Ud2jtl9KSqx8Sn
 QWOd5HPclPdl4VQlV/t6ABLYRu3TgQrYFJUzszFKpsNwQQN6XQ
 dEWR4Ee11wJIDIP4LDnlxFTYA4U8zqFPJXbTDjYrchQK37tkf8
 qSu7cZNOz99u9rvpeam7likYmVG3N9JhrAa9Ez/6kNW5f5qeZu
 JEKaRspqglJmdiII7ICJoapquMlWzEitOzp1LxP3Iak2chmivO
 LyP/sTQP+mOtGKxmQJmo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013, Chen Gang wrote:
> in arch/arm64/include/asm, not define the function cmpxchg64
> 
>   when compiling with allmodconfig,
>     drivers/block/blockconsole.c will need this function.
> 
>   I am not quite familiar with ARM64 (neither ARM64 assembler)
> 
>   can any member helps to send related patch ?
>     if no one have time to send related patch, I should try.
>     and I am glad to try, but need additional time resources,
>     if I try, I should finish it within this month (2013-4-30).
> 
>   welcome any suggestions or completions.

cmpxchg64 is the same as cmpxchg on 64-bit platforms, can't the
driver be changed to use the latter?

	Arnd
