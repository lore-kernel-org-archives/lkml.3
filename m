Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaHLBIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 21:08:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56787 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaHLBI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 21:08:28 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E9690A.5070107@roeck-us.net>
Date: Mon, 11 Aug 2014 18:08:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 11
References: <20140811155213.0aa083ce@canb.auug.org.au>	<20140811170510.GA19750@roeck-us.net> <20140812105953.3284db9c@canb.auug.org.au>
In-Reply-To: <20140812105953.3284db9c@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 05:59 PM, Stephen Rothwell wrote:
> Hi Guenter,
>
> On Mon, 11 Aug 2014 10:05:10 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> New build failures:
>>
>> Building arm:s5pv210_defconfig ... failed
>> --------------
>> Error log:
>> arch/arm/mach-s5pv210/pm.c:150:12: error: 'suspend_valid_only_mem' undeclared
>> here (not in a function)
>> make[1]: *** [arch/arm/mach-s5pv210/pm.o] Error 1
>>
>> Building arm:pxa910_defconfig ... failed
>> --------------
>> Error log:
>> arch/arm/mach-mmp/pm-pxa910.c: In function 'pxa910_pm_valid':
>> arch/arm/mach-mmp/pm-pxa910.c:243:65: error: expected ')' before ';' token
>> arch/arm/mach-mmp/pm-pxa910.c:244:1: error: expected ';' before '}' token
>> make[1]: *** [arch/arm/mach-mmp/pm-pxa910.o] Error 1
>
> The patch that caused this has been removed from linux-next.
>

Great.

Wonder if we should send notifications like that on a regular basis. The summaries
and build results are all available on http://kisskb.ellerman.id.au/linux-next,
and now on my test results page as well, but judging from the errors moving from
-next into mainline, hardly anyone seems to care and/or notice.

Guenter

