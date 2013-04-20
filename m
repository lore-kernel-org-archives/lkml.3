Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657Ab3DTCtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 22:49:31 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64642 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965573Ab3DTCta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 22:49:30 -0400
Message-ID: <51720208.3090605@gmail.com>
Date: Sat, 20 Apr 2013 10:48:40 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Chen Gang <gang.chen@asianux.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM64: kernel: compiling issue: need define readq and
 writeq for driver module using.
References: <51712975.8030104@asianux.com> <201304191413.57424.arnd@arndb.de>
In-Reply-To: <201304191413.57424.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月19日 20:13, Arnd Bergmann wrote:
> On Friday 19 April 2013, Chen Gang wrote:
>> >   when compiling with allmodconfig, CONFIG_64BIT=y
>> >     the file drivers/base/regmap/regmap-mmio.c will use readq and writeq.
>> > 
>> >   so we need implement these functions.
>> > 
>> > BTW:
>> >   the coding style can not pass ./scripts/checkpatch.pl.
>> >   it seems better to provide additional patch for beautifying code.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

  thanks.

-- 
Chen Gang

Flying Transformer
