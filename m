Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbaIOWl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:41:28 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38199 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbaIOWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:41:24 -0400
Message-ID: <54176B0E.7080208@gmail.com>
Date: Tue, 16 Sep 2014 06:41:18 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, eparis@redhat.com,
        paulmck@linux.vnet.ibm.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        zhenglong.cai@cs2c.com.cn, khilman@linaro.org, ak@linux.intel.com,
        mcgrof@suse.com, fabf@skynet.be,
        "dhowells@redhat.com" <dhowells@redhat.com>, pefoley2@pefoley.com,
        mgorman@suse.de, biederm@xmission.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] init/Kconfig: Add ENDIAN attributes for all architectures
 using
References: <540494D6.40701@gmail.com> <5406FFBD.8010207@gmail.com> <54155B14.9060809@gmail.com> <201409151555.03997.arnd@arndb.de>
In-Reply-To: <201409151555.03997.arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 09:55 PM, Arnd Bergmann wrote:
> On Sunday 14 September 2014, Chen Gang wrote:
>> Hello Maintainers:
>>
>> Is this patch worthy enough to be applied?
>>
>> Welcome any ideas, suggestions or completions.
> 
> I find it hard to judge whether it's worth it or not. You gave one example
> for a driver that needs this, but what would be your estimate on how
> many other drivers have the same problem, either producing a #warning
> or misbehaving if neither symbol is set?
> 

For me, it is also hard to judge, so at present, we can assume it is not
worthy enough for other individual modules.

> Having all architectures consistently report the endianess would be nice,
> but we have to weigh the advantages (currently broken code, potential
> simplifications) against the regression risk.
> 

Yeah, so our 'goal' is OK, but we need focus on 'how'.

At present, firstly need modify 'init/Kconfig', and then scan all
architectures one by one, let each related patch pass checking by the
related maintainers (which can avoid the risk).


Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
