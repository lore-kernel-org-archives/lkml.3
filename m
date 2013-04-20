Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965541Ab3DTByq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 21:54:46 -0400
Received: from intranet.asianux.com ([58.214.24.6]:29059 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965470Ab3DTByp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 21:54:45 -0400
X-Spam-Score: -100.8
Message-ID: <5171F539.90604@asianux.com>
Date: Sat, 20 Apr 2013 09:54:01 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM64: kernel: compiling issue: need define readq and
 writeq for driver module using.
References: <51712975.8030104@asianux.com> <20130419123513.GB18443@arm.com>
In-Reply-To: <20130419123513.GB18443@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月19日 20:35, Catalin Marinas wrote:
> On Fri, Apr 19, 2013 at 12:24:37PM +0100, Chen Gang wrote:
>> > 
>> >   when compiling with allmodconfig, CONFIG_64BIT=y
>> >     the file drivers/base/regmap/regmap-mmio.c will use readq and writeq.
>> > 
>> >   so we need implement these functions.
>> > 
>> > BTW:
>> >   the coding style can not pass ./scripts/checkpatch.pl.
>> >   it seems better to provide additional patch for beautifying code.
> If it complains about long lines, just ignore it. I wouldn't worry too
> much about checkpatch.pl and coding style warnings ;)
> 

  ok, I can understand.

  :-)

-- 
Chen Gang

Asianux Corporation
