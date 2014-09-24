Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaIXLiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:38:22 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52079 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaIXLiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:38:19 -0400
Message-ID: <5422AD27.30101@gmail.com>
Date: Wed, 24 Sep 2014 07:38:15 -0400
From: nick <yocto6@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>, linux@arm.linux.org.uk
CC: steve.capper@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
        steve.capper@linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: FIX Me in pgtable.h
References: <54216FC9.5060605@gmail.com> <542238CF.30505@codeaurora.org>
In-Reply-To: <542238CF.30505@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14-09-23 11:21 PM, Laura Abbott wrote:
> On 9/23/2014 6:04 AM, nick wrote:
>> Greetings Arm Maintainers,
>> I am wondering about the fix me in pgtable.h for define kern_addr_valid and how to set it to a correct
>> value as you state that this needs to be fixed as the defined macro is still 1. This is probably incorrect
>> and should be changed.
>> Thanks,
>> Nick
>>
> 
> It's not clear to me how valuable fixing kern_addr_valid would actually
> be for arm. It seems to be used in exactly one place, fs/proc/kcore.c
> and the associated Kconfig is explicitly marked if !ARM. Nearly all
> other archs minus x86, arm64 and sparc are in the same boat as well.
> 
> Thanks,
> Laura
> 
Laura,
Can we remove it then as it seems that it's not needed at all.
Cheers Nick 
