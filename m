Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3KNTsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:48:45 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48930 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab3KNTsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:48:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAEPRUYqV-9P6spmxGsqOS6JGbZW79L7m4SO66Jbkyq4Kam=bRQ@mail.gmail.com>
References: <1380987809-4886-1-git-send-email-bcm@fixthebug.org>
	<CAEPRUYqnc0C_fEG97sFVs6uAtPyZCzXuJ09Hsb3unjAZtc5shA@mail.gmail.com>
	<CAEPRUYqV-9P6spmxGsqOS6JGbZW79L7m4SO66Jbkyq4Kam=bRQ@mail.gmail.com>
Date: Thu, 14 Nov 2013 11:48:37 -0800
Message-ID: <CAPdLdqnvHGxkXzT02rDg6knBHmzG+Ebu1V0L80L7SGGQN80uzw@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: bcm: Add DEBUG_LL console support
From: Markus Mayer <markus.mayer@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Chris Ball <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2013 23:30, Christian Daudt <bcm@fixthebug.org> wrote:
> On Wed, Oct 16, 2013 at 11:12 PM, Christian Daudt <bcm@fixthebug.org> wrote:
>> On Sat, Oct 5, 2013 at 8:43 AM, Christian Daudt <bcm@fixthebug.org> wrote:
>>> This patch adds low level debug uart support to Broadcom
>>>  mobile based SOCs.
>>>
>>> Signed-off-by: Christian Daudt <bcm@fixthebug.org>
>>>
>>> Changes from V2:
>>>  - Changed to follow hex ordering on entries
>>>  - Dropped defconfig changes
>>>
>>> Changes from V1:
>>>  - Switched to use the common 8250 debug introduced in 3.12-rc1
>>>
>>
>> Hi Russell,
>>  Does V3 look ok ?
>>
>>  Thanks,
>>    csd
> Hi,
>  Can anyone provide an ack on this mod ?
>
>  Thanks,
>    csd

Tested-by: Markus Mayer <markus.mayer@linaro.org>

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.12.0+ (mmayer@lbrmn-lnxub70.ric.broadcom.com)
[    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
instruction cache
[    0.000000] Machine: BCM281xx Broadcom Application Processor,
model: BCM28155 AP board
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Truncating RAM at 90000000-bfffffff to -bf7fffff
(vmalloc region overlap).
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 193040
[    0.000000] Kernel command line: console=ttyS0,115200n8
root=/dev/mmcblk0p8 rootwait rootfstype=ext4 earlyprintk
[...]
[    0.200000] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.210000] 3e000000.uart: ttyS0 at MMIO 0x3e000000 (irq = 99,
base_baud = 812500) is a 16550A
[    0.220000] console [ttyS0] enabled, bootconsole disabled
[    0.220000] console [ttyS0] enabled, bootconsole disabled
[    0.230000] mousedev: PS/2 mouse device common for all mice
[...]

-- 
Markus Mayer
Broadcom Landing Team
