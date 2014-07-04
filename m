Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbaGDBdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:33:31 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49704 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbaGDBda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:33:30 -0400
MIME-Version: 1.0
In-Reply-To: <5EB3BFCD089AD643B9BB63439F5FD5E9012BF6F220@SHAASIEXM01.ASIA.ROOT.PRI>
References: <cover.1404425176.git.joe@perches.com> <32eedc96dfe8761925d0663e50cd29aaac32e9af.1404425176.git.joe@perches.com>
 <5EB3BFCD089AD643B9BB63439F5FD5E9012BF6F220@SHAASIEXM01.ASIA.ROOT.PRI>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 4 Jul 2014 09:33:10 +0800
Message-ID: <CAGsJ_4wkWcczu=EN=ZeKCS_++D2aH3nWxdC_oion+j6au=idCA@mail.gmail.com>
Subject: Re: FW: [PATCH 04/16] MAINTAINERS: Update clk/sirf patterns
To: Barry Song <Barry.Song@csr.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Joe Perches [mailto:joe@perches.com]
>> Sent: Friday, July 04, 2014 6:08 AM
>> To: Andrew Morton
>> Cc: Barry Song; linux-kernel@vger.kernel.org
>> Subject: [PATCH 04/16] MAINTAINERS: Update clk/sirf patterns
>>
>> commit 7bf21bc81f28 ("clk: sirf: re-arch to make the codes support both
>> prima2 and atlas6") moved the files, update the patterns.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> cc: Barry Song <Baohua.Song@csr.com>
>> ---
>>  MAINTAINERS | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index e3531a5..90ee3d6 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -894,7 +894,7 @@ L:        linux-arm-kernel@lists.infradead.org
>> (moderated for non-subscribers)
>>  T:   git git://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git
>>  S:   Maintained
>>  F:   arch/arm/mach-prima2/
>> -F:   drivers/clk/clk-prima2.c
>> +F:   drivers/clk/sirf/

has "N:   [^a-z]sirf" included this?

>>  F:   drivers/clocksource/timer-prima2.c
>>  F:   drivers/clocksource/timer-marco.c
>>  N:   [^a-z]sirf
>> --
>> 1.8.1.2.459.gbcd45b4.dirty

-barry
