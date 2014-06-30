Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaF3Uck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:32:40 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:61575 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaF3Ucj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:32:39 -0400
Message-ID: <53B1C965.6090904@gmail.com>
Date: Mon, 30 Jun 2014 13:32:37 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/3] MIPS: OCTEON: Minimal support for D-Link DSR-1000N
References: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi> <53B19B0E.8000702@gmail.com> <20140630191742.GA681@drone.musicnaut.iki.fi>
In-Reply-To: <20140630191742.GA681@drone.musicnaut.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 12:17 PM, Aaro Koskinen wrote:
> Hi,
>
> On Mon, Jun 30, 2014 at 10:14:54AM -0700, David Daney wrote:
>> On 06/28/2014 01:34 PM, Aaro Koskinen wrote:
>>> The following patches add minimal support for D-Link DSR-1000N router.
>>
>> Which OCTEON chip does this device contain?
>
> [    0.000000] CPU0 revision is: 000d0601 (Cavium Octeon+)
>
> # cat /proc/cpuinfo
> system type             : CUST_DSR1000N (CN5010p1.1-500-SCP)
> machine                 : Unknown
> processor               : 0
> cpu model               : Cavium Octeon+ V0.1
> BogoMIPS                : 1000.00
> wait instruction        : yes
> microsecond timers      : yes
> tlb_entries             : 64
> extra interrupt vector  : yes
> hardware watchpoint     : yes, count: 2, address/irw mask: [0x0ffc, 0x0ffb]
> isa                     : mips1 mips2 mips3 mips4 mips5 mips64r2
> ASEs implemented        :
> shadow register sets    : 1
> kscratch registers      : 0
> core                    : 0
> VCED exceptions         : not available
> VCEI exceptions         : not available
>
>> Also what is the bootloader version on the board?
>
> D-Link DSR-1000N bootloader# version
>
> U-Boot 1.1.1 (Development build, svnversion: exported) (Build time: Mar 22 2010
> - 12:14:14)
>
> BTW, .notes segment from kernel needs to be removed for this bootloader
> with "strip -R .notes".
>

Too bad it doesn't have a modern bootloader that passes a device tree.

The whole series: Acked-by: David Daney <david.daney@cavium.com>


