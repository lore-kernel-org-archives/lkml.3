Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968284Ab3DSLqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 07:46:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:32677 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968230Ab3DSLqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 07:46:22 -0400
X-Spam-Score: -100.8
Message-ID: <51712E5E.2020809@asianux.com>
Date: Fri, 19 Apr 2013 19:45:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] ARM64: kernel: compiling issue, need implement cmpxchg64
 with assembler language.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in arch/arm64/include/asm, not define the function cmpxchg64

  when compiling with allmodconfig,
    drivers/block/blockconsole.c will need this function.

  I am not quite familiar with ARM64 (neither ARM64 assembler)

  can any member helps to send related patch ?
    if no one have time to send related patch, I should try.
    and I am glad to try, but need additional time resources,
    if I try, I should finish it within this month (2013-4-30).

  welcome any suggestions or completions.

  thanks.


gchen.
