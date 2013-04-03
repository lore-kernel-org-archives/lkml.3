Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841Ab3DCPln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:41:43 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:42609 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760450Ab3DCPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:41:42 -0400
Message-ID: <515C4DB6.3060004@googlemail.com>
Date: Wed, 03 Apr 2013 16:41:42 +0100
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-3.9.0-rc1+: Output from "make kernelrelease"contains incorrect
 data
References: <513B8FA7.9040200@googlemail.com> <5159534A.1070500@googlemail.com> <515C3D98.7080203@suse.cz>
In-Reply-To: <515C3D98.7080203@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/03/13 15:32, Michal Marek wrote:
> On 1.4.2013 11:28, Chris Clayton wrote:
>> Ping!
>>
>> This is still happening with 3.9-rc5.
>>
>> [chris:~/kernel/linux]$ make bzImage
>> ...
>> Kernel: arch/x86/boot/bzImage is ready  (#14)
>> [chris:~/kernel/linux]$ make kernelrelease
>> scripts/kconfig/conf --silentoldconfig Kconfig
>> 3.9.0-rc5
>> [chris:~/kernel/linux]$ make kernelrelease
>> 3.9.0-rc5
>
> You need to run make -s kernelrelease.
>

Ah, right. I didn't see that announcement. The -s argument was not 
necessary with earlier releases.

Sorry for the noise.

Chris

> Michal
>
