Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3HLULR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:11:17 -0400
Received: from hotel311.server4you.de ([85.25.146.15]:57290 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HLULM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:11:12 -0400
Message-ID: <52094156.7010905@monom.org>
Date: Mon, 12 Aug 2013 22:11:02 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: brcsmac kernel panic
References: <5207BA00.3030709@monom.org> <5208BB2D.2000705@broadcom.com>
In-Reply-To: <5208BB2D.2000705@broadcom.com>
Content-Type: multipart/mixed;
 boundary="------------020604090007000001030203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020604090007000001030203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Arend,

On 08/12/2013 12:38 PM, Arend van Spriel wrote:
> On 08/11/2013 06:21 PM, Daniel Wagner wrote:
>> I just updated my laptop (MacBook Air 2012) from 3.11-rc3+ to 3.11-rc4+
>> and since then brcsmac crashes short after enabling it. Unfortunately, I
>> did also change some config flags in the area of cpufreq (enabling
>> p-state driver) so the configuration is not exactly the same. Before I
>> try to figure out what I have changed, I am posting the picture of the
>> crash. Maybe it is something obvious.
>>
>> v3.11-rc4-197-gd92581f
>> http://www.monom.org/misc/brcmsmac/v3.11-rc4.config
>> http://www.monom.org/misc/brcmsmac/IMAG0064.jpg
>
> Thanks, Daniel
>
> I was looking at this issue two weeks ago and just got back from my
> vacation. Can you apply the patch and send me a kernel log?

Sure, the patch does the trick, the panic is gone.

> Sharing pictures, huh. What about this one :-p

No no, that isn't me, that is someone else! :P

cheers,
daniel



--------------020604090007000001030203
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.0-rc4+ (wagi@helium) (gcc version 4.8.1 20130603 (Red Hat 4.8.1-1) (GCC) ) #38 SMP Sun Aug 11 17:46:03 CEST 2013
[    0.000000] Command line: initrd=\initramfs-3.11.0-rc4+.img root=UUID=5ba0be6c-1f3f-45c4-8047-7dfed933d5ba ro
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008e000-0x000000000008ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000a0000-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x000000008ad11fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ad12000-0x000000008ad52fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008ad53000-0x000000008ad68fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ad69000-0x000000008ad8efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008ad8f000-0x000000008ae3afff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ae3b000-0x000000008ae8efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008ae8f000-0x000000008aecdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000008aece000-0x000000008aefefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008aeff000-0x000000008af91fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008af92000-0x000000008affefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008afff000-0x000000008affffff] usable
[    0.000000] BIOS-e820: [mem 0x000000008b000000-0x000000008f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe70000-0x00000000ffe9ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000026f5fffff] usable
[    0.000000] e820: update [mem 0x87d74190-0x87d841cf] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000008dfff] usable
[    0.000000] reserve setup_data: [mem 0x000000000008e000-0x000000000008ffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000090000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000000a0000-0x00000000000bffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000040005000-0x0000000087d7418f] usable
[    0.000000] reserve setup_data: [mem 0x0000000087d74190-0x0000000087d841cf] usable
[    0.000000] reserve setup_data: [mem 0x0000000087d841d0-0x000000008ad11fff] usable
[    0.000000] reserve setup_data: [mem 0x000000008ad12000-0x000000008ad52fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000008ad53000-0x000000008ad68fff] usable
[    0.000000] reserve setup_data: [mem 0x000000008ad69000-0x000000008ad8efff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000008ad8f000-0x000000008ae3afff] usable
[    0.000000] reserve setup_data: [mem 0x000000008ae3b000-0x000000008ae8efff] reserved
[    0.000000] reserve setup_data: [mem 0x000000008ae8f000-0x000000008aecdfff] usable
[    0.000000] reserve setup_data: [mem 0x000000008aece000-0x000000008aefefff] reserved
[    0.000000] reserve setup_data: [mem 0x000000008aeff000-0x000000008af91fff] usable
[    0.000000] reserve setup_data: [mem 0x000000008af92000-0x000000008affefff] reserved
[    0.000000] reserve setup_data: [mem 0x000000008afff000-0x000000008affffff] usable
[    0.000000] reserve setup_data: [mem 0x000000008b000000-0x000000008f9fffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ffe70000-0x00000000ffe9ffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000026f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v1.10 by Apple
[    0.000000] efi:  ACPI=0x8ad8e000  ACPI 2.0=0x8ad8e014  SMBIOS=0x8ad19000 
[    0.000000] efi: mem00: type=7, attr=0x80000000000000f, range=[0x0000000000000000-0x000000000008e000) (0MB)
[    0.000000] efi: mem01: type=0, attr=0x80000000000000f, range=[0x000000000008e000-0x0000000000090000) (0MB)
[    0.000000] efi: mem02: type=2, attr=0x80000000000000f, range=[0x0000000000090000-0x000000000009a000) (0MB)
[    0.000000] efi: mem03: type=7, attr=0x80000000000000f, range=[0x000000000009a000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000001000000-0x000000000226f000) (18MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x000000000226f000-0x0000000020000000) (477MB)
[    0.000000] efi: mem07: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020200000) (2MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000020200000-0x0000000040004000) (510MB)
[    0.000000] efi: mem09: type=0, attr=0xf, range=[0x0000000040004000-0x0000000040005000) (0MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000040005000-0x000000007de6c000) (990MB)
[    0.000000] efi: mem11: type=2, attr=0xf, range=[0x000000007de6c000-0x000000007eefb000) (16MB)
[    0.000000] efi: mem12: type=1, attr=0xf, range=[0x000000007eefb000-0x000000007f3c4000) (4MB)
[    0.000000] efi: mem13: type=7, attr=0xf, range=[0x000000007f3c4000-0x000000007f88d000) (4MB)
[    0.000000] efi: mem14: type=4, attr=0xf, range=[0x000000007f88d000-0x0000000087d24000) (132MB)
[    0.000000] efi: mem15: type=7, attr=0xf, range=[0x0000000087d24000-0x0000000087d74000) (0MB)
[    0.000000] efi: mem16: type=2, attr=0xf, range=[0x0000000087d74000-0x0000000087d86000) (0MB)
[    0.000000] efi: mem17: type=7, attr=0xf, range=[0x0000000087d86000-0x0000000087d8b000) (0MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x0000000087d8b000-0x0000000087d8c000) (0MB)
[    0.000000] efi: mem19: type=1, attr=0xf, range=[0x0000000087d8c000-0x0000000087da2000) (0MB)
[    0.000000] efi: mem20: type=4, attr=0xf, range=[0x0000000087da2000-0x0000000087dae000) (0MB)
[    0.000000] efi: mem21: type=2, attr=0xf, range=[0x0000000087dae000-0x0000000087db6000) (0MB)
[    0.000000] efi: mem22: type=4, attr=0xf, range=[0x0000000087db6000-0x00000000880ef000) (3MB)
[    0.000000] efi: mem23: type=3, attr=0xf, range=[0x00000000880ef000-0x0000000088206000) (1MB)
[    0.000000] efi: mem24: type=4, attr=0xf, range=[0x0000000088206000-0x00000000882ef000) (0MB)
[    0.000000] efi: mem25: type=3, attr=0xf, range=[0x00000000882ef000-0x0000000088312000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x0000000088312000-0x0000000088346000) (0MB)
[    0.000000] efi: mem27: type=3, attr=0xf, range=[0x0000000088346000-0x000000008837b000) (0MB)
[    0.000000] efi: mem28: type=4, attr=0xf, range=[0x000000008837b000-0x000000008841b000) (0MB)
[    0.000000] efi: mem29: type=3, attr=0xf, range=[0x000000008841b000-0x0000000088420000) (0MB)
[    0.000000] efi: mem30: type=4, attr=0xf, range=[0x0000000088420000-0x0000000088423000) (0MB)
[    0.000000] efi: mem31: type=2, attr=0xf, range=[0x0000000088423000-0x0000000088424000) (0MB)
[    0.000000] efi: mem32: type=4, attr=0xf, range=[0x0000000088424000-0x0000000088426000) (0MB)
[    0.000000] efi: mem33: type=3, attr=0xf, range=[0x0000000088426000-0x0000000088427000) (0MB)
[    0.000000] efi: mem34: type=4, attr=0xf, range=[0x0000000088427000-0x0000000088428000) (0MB)
[    0.000000] efi: mem35: type=3, attr=0xf, range=[0x0000000088428000-0x000000008842b000) (0MB)
[    0.000000] efi: mem36: type=4, attr=0xf, range=[0x000000008842b000-0x000000008842c000) (0MB)
[    0.000000] efi: mem37: type=3, attr=0xf, range=[0x000000008842c000-0x0000000088432000) (0MB)
[    0.000000] efi: mem38: type=4, attr=0xf, range=[0x0000000088432000-0x0000000088438000) (0MB)
[    0.000000] efi: mem39: type=3, attr=0xf, range=[0x0000000088438000-0x000000008843c000) (0MB)
[    0.000000] efi: mem40: type=2, attr=0xf, range=[0x000000008843c000-0x000000008843d000) (0MB)
[    0.000000] efi: mem41: type=3, attr=0xf, range=[0x000000008843d000-0x000000008843e000) (0MB)
[    0.000000] efi: mem42: type=4, attr=0xf, range=[0x000000008843e000-0x0000000088442000) (0MB)
[    0.000000] efi: mem43: type=3, attr=0xf, range=[0x0000000088442000-0x0000000088444000) (0MB)
[    0.000000] efi: mem44: type=4, attr=0xf, range=[0x0000000088444000-0x0000000088446000) (0MB)
[    0.000000] efi: mem45: type=2, attr=0xf, range=[0x0000000088446000-0x0000000088447000) (0MB)
[    0.000000] efi: mem46: type=3, attr=0xf, range=[0x0000000088447000-0x0000000088466000) (0MB)
[    0.000000] efi: mem47: type=4, attr=0xf, range=[0x0000000088466000-0x0000000088467000) (0MB)
[    0.000000] efi: mem48: type=3, attr=0xf, range=[0x0000000088467000-0x000000008846c000) (0MB)
[    0.000000] efi: mem49: type=4, attr=0xf, range=[0x000000008846c000-0x000000008846f000) (0MB)
[    0.000000] efi: mem50: type=3, attr=0xf, range=[0x000000008846f000-0x0000000088473000) (0MB)
[    0.000000] efi: mem51: type=4, attr=0xf, range=[0x0000000088473000-0x000000008847b000) (0MB)
[    0.000000] efi: mem52: type=3, attr=0xf, range=[0x000000008847b000-0x000000008848f000) (0MB)
[    0.000000] efi: mem53: type=4, attr=0xf, range=[0x000000008848f000-0x0000000088490000) (0MB)
[    0.000000] efi: mem54: type=3, attr=0xf, range=[0x0000000088490000-0x000000008849b000) (0MB)
[    0.000000] efi: mem55: type=2, attr=0xf, range=[0x000000008849b000-0x000000008849c000) (0MB)
[    0.000000] efi: mem56: type=4, attr=0xf, range=[0x000000008849c000-0x00000000884a2000) (0MB)
[    0.000000] efi: mem57: type=3, attr=0xf, range=[0x00000000884a2000-0x00000000884ad000) (0MB)
[    0.000000] efi: mem58: type=4, attr=0xf, range=[0x00000000884ad000-0x00000000884ae000) (0MB)
[    0.000000] efi: mem59: type=3, attr=0xf, range=[0x00000000884ae000-0x00000000884b3000) (0MB)
[    0.000000] efi: mem60: type=4, attr=0xf, range=[0x00000000884b3000-0x00000000884f9000) (0MB)
[    0.000000] efi: mem61: type=3, attr=0xf, range=[0x00000000884f9000-0x00000000884fa000) (0MB)
[    0.000000] efi: mem62: type=4, attr=0xf, range=[0x00000000884fa000-0x00000000884fb000) (0MB)
[    0.000000] efi: mem63: type=2, attr=0xf, range=[0x00000000884fb000-0x00000000884fc000) (0MB)
[    0.000000] efi: mem64: type=4, attr=0xf, range=[0x00000000884fc000-0x0000000089542000) (16MB)
[    0.000000] efi: mem65: type=3, attr=0xf, range=[0x0000000089542000-0x0000000089547000) (0MB)
[    0.000000] efi: mem66: type=4, attr=0xf, range=[0x0000000089547000-0x000000008967d000) (1MB)
[    0.000000] efi: mem67: type=2, attr=0xf, range=[0x000000008967d000-0x000000008967e000) (0MB)
[    0.000000] efi: mem68: type=4, attr=0xf, range=[0x000000008967e000-0x0000000089696000) (0MB)
[    0.000000] efi: mem69: type=3, attr=0xf, range=[0x0000000089696000-0x000000008969f000) (0MB)
[    0.000000] efi: mem70: type=4, attr=0xf, range=[0x000000008969f000-0x00000000896bb000) (0MB)
[    0.000000] efi: mem71: type=3, attr=0xf, range=[0x00000000896bb000-0x00000000896bd000) (0MB)
[    0.000000] efi: mem72: type=2, attr=0xf, range=[0x00000000896bd000-0x00000000896be000) (0MB)
[    0.000000] efi: mem73: type=4, attr=0xf, range=[0x00000000896be000-0x00000000896c2000) (0MB)
[    0.000000] efi: mem74: type=3, attr=0xf, range=[0x00000000896c2000-0x00000000896c9000) (0MB)
[    0.000000] efi: mem75: type=4, attr=0xf, range=[0x00000000896c9000-0x00000000896cc000) (0MB)
[    0.000000] efi: mem76: type=3, attr=0xf, range=[0x00000000896cc000-0x00000000896cd000) (0MB)
[    0.000000] efi: mem77: type=4, attr=0xf, range=[0x00000000896cd000-0x00000000896ce000) (0MB)
[    0.000000] efi: mem78: type=3, attr=0xf, range=[0x00000000896ce000-0x00000000896cf000) (0MB)
[    0.000000] efi: mem79: type=4, attr=0xf, range=[0x00000000896cf000-0x00000000896d3000) (0MB)
[    0.000000] efi: mem80: type=3, attr=0xf, range=[0x00000000896d3000-0x00000000896d8000) (0MB)
[    0.000000] efi: mem81: type=4, attr=0xf, range=[0x00000000896d8000-0x00000000896e0000) (0MB)
[    0.000000] efi: mem82: type=2, attr=0xf, range=[0x00000000896e0000-0x00000000896e1000) (0MB)
[    0.000000] efi: mem83: type=4, attr=0xf, range=[0x00000000896e1000-0x00000000896ed000) (0MB)
[    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000896ed000-0x00000000896f1000) (0MB)
[    0.000000] efi: mem85: type=4, attr=0xf, range=[0x00000000896f1000-0x00000000896f7000) (0MB)
[    0.000000] efi: mem86: type=3, attr=0xf, range=[0x00000000896f7000-0x0000000089703000) (0MB)
[    0.000000] efi: mem87: type=4, attr=0xf, range=[0x0000000089703000-0x0000000089706000) (0MB)
[    0.000000] efi: mem88: type=3, attr=0xf, range=[0x0000000089706000-0x0000000089707000) (0MB)
[    0.000000] efi: mem89: type=4, attr=0xf, range=[0x0000000089707000-0x0000000089708000) (0MB)
[    0.000000] efi: mem90: type=2, attr=0xf, range=[0x0000000089708000-0x0000000089709000) (0MB)
[    0.000000] efi: mem91: type=4, attr=0xf, range=[0x0000000089709000-0x000000008970c000) (0MB)
[    0.000000] efi: mem92: type=3, attr=0xf, range=[0x000000008970c000-0x000000008970e000) (0MB)
[    0.000000] efi: mem93: type=4, attr=0xf, range=[0x000000008970e000-0x000000008973c000) (0MB)
[    0.000000] efi: mem94: type=3, attr=0xf, range=[0x000000008973c000-0x000000008973f000) (0MB)
[    0.000000] efi: mem95: type=4, attr=0xf, range=[0x000000008973f000-0x0000000089743000) (0MB)
[    0.000000] efi: mem96: type=2, attr=0xf, range=[0x0000000089743000-0x0000000089744000) (0MB)
[    0.000000] efi: mem97: type=4, attr=0xf, range=[0x0000000089744000-0x0000000089773000) (0MB)
[    0.000000] efi: mem98: type=3, attr=0xf, range=[0x0000000089773000-0x0000000089782000) (0MB)
[    0.000000] efi: mem99: type=4, attr=0xf, range=[0x0000000089782000-0x0000000089791000) (0MB)
[    0.000000] efi: mem100: type=3, attr=0xf, range=[0x0000000089791000-0x000000008979b000) (0MB)
[    0.000000] efi: mem101: type=4, attr=0xf, range=[0x000000008979b000-0x000000008979c000) (0MB)
[    0.000000] efi: mem102: type=3, attr=0xf, range=[0x000000008979c000-0x00000000897a6000) (0MB)
[    0.000000] efi: mem103: type=4, attr=0xf, range=[0x00000000897a6000-0x00000000897aa000) (0MB)
[    0.000000] efi: mem104: type=3, attr=0xf, range=[0x00000000897aa000-0x00000000897bb000) (0MB)
[    0.000000] efi: mem105: type=4, attr=0xf, range=[0x00000000897bb000-0x00000000897bc000) (0MB)
[    0.000000] efi: mem106: type=2, attr=0xf, range=[0x00000000897bc000-0x00000000897bd000) (0MB)
[    0.000000] efi: mem107: type=4, attr=0xf, range=[0x00000000897bd000-0x00000000897c0000) (0MB)
[    0.000000] efi: mem108: type=3, attr=0xf, range=[0x00000000897c0000-0x00000000897c4000) (0MB)
[    0.000000] efi: mem109: type=4, attr=0xf, range=[0x00000000897c4000-0x00000000897c5000) (0MB)
[    0.000000] efi: mem110: type=3, attr=0xf, range=[0x00000000897c5000-0x00000000897c6000) (0MB)
[    0.000000] efi: mem111: type=4, attr=0xf, range=[0x00000000897c6000-0x00000000897ca000) (0MB)
[    0.000000] efi: mem112: type=3, attr=0xf, range=[0x00000000897ca000-0x00000000897cb000) (0MB)
[    0.000000] efi: mem113: type=2, attr=0xf, range=[0x00000000897cb000-0x00000000897cc000) (0MB)
[    0.000000] efi: mem114: type=4, attr=0xf, range=[0x00000000897cc000-0x00000000897cd000) (0MB)
[    0.000000] efi: mem115: type=3, attr=0xf, range=[0x00000000897cd000-0x00000000897cf000) (0MB)
[    0.000000] efi: mem116: type=4, attr=0xf, range=[0x00000000897cf000-0x00000000897d0000) (0MB)
[    0.000000] efi: mem117: type=3, attr=0xf, range=[0x00000000897d0000-0x00000000897d5000) (0MB)
[    0.000000] efi: mem118: type=4, attr=0xf, range=[0x00000000897d5000-0x00000000897d8000) (0MB)
[    0.000000] efi: mem119: type=2, attr=0xf, range=[0x00000000897d8000-0x00000000897d9000) (0MB)
[    0.000000] efi: mem120: type=4, attr=0xf, range=[0x00000000897d9000-0x00000000897da000) (0MB)
[    0.000000] efi: mem121: type=3, attr=0xf, range=[0x00000000897da000-0x00000000897db000) (0MB)
[    0.000000] efi: mem122: type=4, attr=0xf, range=[0x00000000897db000-0x00000000897dc000) (0MB)
[    0.000000] efi: mem123: type=3, attr=0xf, range=[0x00000000897dc000-0x00000000897df000) (0MB)
[    0.000000] efi: mem124: type=4, attr=0xf, range=[0x00000000897df000-0x00000000897e3000) (0MB)
[    0.000000] efi: mem125: type=3, attr=0xf, range=[0x00000000897e3000-0x00000000897e4000) (0MB)
[    0.000000] efi: mem126: type=4, attr=0xf, range=[0x00000000897e4000-0x00000000897e5000) (0MB)
[    0.000000] efi: mem127: type=2, attr=0xf, range=[0x00000000897e5000-0x00000000897e6000) (0MB)
[    0.000000] efi: mem128: type=4, attr=0xf, range=[0x00000000897e6000-0x00000000897e7000) (0MB)
[    0.000000] efi: mem129: type=3, attr=0xf, range=[0x00000000897e7000-0x00000000897e8000) (0MB)
[    0.000000] efi: mem130: type=4, attr=0xf, range=[0x00000000897e8000-0x00000000897e9000) (0MB)
[    0.000000] efi: mem131: type=3, attr=0xf, range=[0x00000000897e9000-0x00000000897f7000) (0MB)
[    0.000000] efi: mem132: type=4, attr=0xf, range=[0x00000000897f7000-0x00000000897f8000) (0MB)
[    0.000000] efi: mem133: type=3, attr=0xf, range=[0x00000000897f8000-0x00000000897f9000) (0MB)
[    0.000000] efi: mem134: type=4, attr=0xf, range=[0x00000000897f9000-0x00000000897fa000) (0MB)
[    0.000000] efi: mem135: type=3, attr=0xf, range=[0x00000000897fa000-0x0000000089801000) (0MB)
[    0.000000] efi: mem136: type=4, attr=0xf, range=[0x0000000089801000-0x0000000089805000) (0MB)
[    0.000000] efi: mem137: type=3, attr=0xf, range=[0x0000000089805000-0x000000008980b000) (0MB)
[    0.000000] efi: mem138: type=4, attr=0xf, range=[0x000000008980b000-0x000000008980e000) (0MB)
[    0.000000] efi: mem139: type=2, attr=0xf, range=[0x000000008980e000-0x000000008980f000) (0MB)
[    0.000000] efi: mem140: type=4, attr=0xf, range=[0x000000008980f000-0x0000000089817000) (0MB)
[    0.000000] efi: mem141: type=3, attr=0xf, range=[0x0000000089817000-0x000000008981c000) (0MB)
[    0.000000] efi: mem142: type=4, attr=0xf, range=[0x000000008981c000-0x0000000089825000) (0MB)
[    0.000000] efi: mem143: type=3, attr=0xf, range=[0x0000000089825000-0x000000008983e000) (0MB)
[    0.000000] efi: mem144: type=4, attr=0xf, range=[0x000000008983e000-0x0000000089840000) (0MB)
[    0.000000] efi: mem145: type=3, attr=0xf, range=[0x0000000089840000-0x000000008984e000) (0MB)
[    0.000000] efi: mem146: type=4, attr=0xf, range=[0x000000008984e000-0x000000008984f000) (0MB)
[    0.000000] efi: mem147: type=3, attr=0xf, range=[0x000000008984f000-0x0000000089852000) (0MB)
[    0.000000] efi: mem148: type=4, attr=0xf, range=[0x0000000089852000-0x0000000089855000) (0MB)
[    0.000000] efi: mem149: type=3, attr=0xf, range=[0x0000000089855000-0x0000000089864000) (0MB)
[    0.000000] efi: mem150: type=4, attr=0xf, range=[0x0000000089864000-0x0000000089866000) (0MB)
[    0.000000] efi: mem151: type=3, attr=0xf, range=[0x0000000089866000-0x000000008986a000) (0MB)
[    0.000000] efi: mem152: type=4, attr=0xf, range=[0x000000008986a000-0x000000008986c000) (0MB)
[    0.000000] efi: mem153: type=2, attr=0xf, range=[0x000000008986c000-0x000000008986d000) (0MB)
[    0.000000] efi: mem154: type=4, attr=0xf, range=[0x000000008986d000-0x000000008986e000) (0MB)
[    0.000000] efi: mem155: type=3, attr=0xf, range=[0x000000008986e000-0x0000000089872000) (0MB)
[    0.000000] efi: mem156: type=4, attr=0xf, range=[0x0000000089872000-0x0000000089873000) (0MB)
[    0.000000] efi: mem157: type=2, attr=0xf, range=[0x0000000089873000-0x0000000089874000) (0MB)
[    0.000000] efi: mem158: type=4, attr=0xf, range=[0x0000000089874000-0x000000008987b000) (0MB)
[    0.000000] efi: mem159: type=3, attr=0xf, range=[0x000000008987b000-0x000000008988a000) (0MB)
[    0.000000] efi: mem160: type=4, attr=0xf, range=[0x000000008988a000-0x0000000089891000) (0MB)
[    0.000000] efi: mem161: type=3, attr=0xf, range=[0x0000000089891000-0x00000000898bc000) (0MB)
[    0.000000] efi: mem162: type=4, attr=0xf, range=[0x00000000898bc000-0x00000000898c1000) (0MB)
[    0.000000] efi: mem163: type=3, attr=0xf, range=[0x00000000898c1000-0x00000000898c5000) (0MB)
[    0.000000] efi: mem164: type=4, attr=0xf, range=[0x00000000898c5000-0x00000000898c7000) (0MB)
[    0.000000] efi: mem165: type=2, attr=0xf, range=[0x00000000898c7000-0x00000000898c8000) (0MB)
[    0.000000] efi: mem166: type=4, attr=0xf, range=[0x00000000898c8000-0x00000000898c9000) (0MB)
[    0.000000] efi: mem167: type=3, attr=0xf, range=[0x00000000898c9000-0x00000000898d3000) (0MB)
[    0.000000] efi: mem168: type=4, attr=0xf, range=[0x00000000898d3000-0x00000000898d4000) (0MB)
[    0.000000] efi: mem169: type=3, attr=0xf, range=[0x00000000898d4000-0x00000000898d7000) (0MB)
[    0.000000] efi: mem170: type=4, attr=0xf, range=[0x00000000898d7000-0x00000000898db000) (0MB)
[    0.000000] efi: mem171: type=2, attr=0xf, range=[0x00000000898db000-0x00000000898dc000) (0MB)
[    0.000000] efi: mem172: type=4, attr=0xf, range=[0x00000000898dc000-0x00000000898de000) (0MB)
[    0.000000] efi: mem173: type=3, attr=0xf, range=[0x00000000898de000-0x00000000898e5000) (0MB)
[    0.000000] efi: mem174: type=4, attr=0xf, range=[0x00000000898e5000-0x00000000898e9000) (0MB)
[    0.000000] efi: mem175: type=3, attr=0xf, range=[0x00000000898e9000-0x00000000898ea000) (0MB)
[    0.000000] efi: mem176: type=4, attr=0xf, range=[0x00000000898ea000-0x00000000898eb000) (0MB)
[    0.000000] efi: mem177: type=2, attr=0xf, range=[0x00000000898eb000-0x00000000898ec000) (0MB)
[    0.000000] efi: mem178: type=4, attr=0xf, range=[0x00000000898ec000-0x00000000898ee000) (0MB)
[    0.000000] efi: mem179: type=3, attr=0xf, range=[0x00000000898ee000-0x00000000898f0000) (0MB)
[    0.000000] efi: mem180: type=4, attr=0xf, range=[0x00000000898f0000-0x00000000898f2000) (0MB)
[    0.000000] efi: mem181: type=2, attr=0xf, range=[0x00000000898f2000-0x00000000898f3000) (0MB)
[    0.000000] efi: mem182: type=4, attr=0xf, range=[0x00000000898f3000-0x00000000898f4000) (0MB)
[    0.000000] efi: mem183: type=3, attr=0xf, range=[0x00000000898f4000-0x00000000898f5000) (0MB)
[    0.000000] efi: mem184: type=4, attr=0xf, range=[0x00000000898f5000-0x00000000898f9000) (0MB)
[    0.000000] efi: mem185: type=3, attr=0xf, range=[0x00000000898f9000-0x00000000898fa000) (0MB)
[    0.000000] efi: mem186: type=4, attr=0xf, range=[0x00000000898fa000-0x00000000898fc000) (0MB)
[    0.000000] efi: mem187: type=3, attr=0xf, range=[0x00000000898fc000-0x000000008990b000) (0MB)
[    0.000000] efi: mem188: type=4, attr=0xf, range=[0x000000008990b000-0x000000008990f000) (0MB)
[    0.000000] efi: mem189: type=3, attr=0xf, range=[0x000000008990f000-0x0000000089910000) (0MB)
[    0.000000] efi: mem190: type=4, attr=0xf, range=[0x0000000089910000-0x0000000089911000) (0MB)
[    0.000000] efi: mem191: type=2, attr=0xf, range=[0x0000000089911000-0x0000000089912000) (0MB)
[    0.000000] efi: mem192: type=4, attr=0xf, range=[0x0000000089912000-0x0000000089914000) (0MB)
[    0.000000] efi: mem193: type=3, attr=0xf, range=[0x0000000089914000-0x0000000089915000) (0MB)
[    0.000000] efi: mem194: type=4, attr=0xf, range=[0x0000000089915000-0x000000008991c000) (0MB)
[    0.000000] efi: mem195: type=3, attr=0xf, range=[0x000000008991c000-0x000000008991e000) (0MB)
[    0.000000] efi: mem196: type=4, attr=0xf, range=[0x000000008991e000-0x0000000089923000) (0MB)
[    0.000000] efi: mem197: type=2, attr=0xf, range=[0x0000000089923000-0x0000000089924000) (0MB)
[    0.000000] efi: mem198: type=3, attr=0xf, range=[0x0000000089924000-0x0000000089925000) (0MB)
[    0.000000] efi: mem199: type=4, attr=0xf, range=[0x0000000089925000-0x0000000089928000) (0MB)
[    0.000000] efi: mem200: type=3, attr=0xf, range=[0x0000000089928000-0x0000000089929000) (0MB)
[    0.000000] efi: mem201: type=4, attr=0xf, range=[0x0000000089929000-0x000000008992d000) (0MB)
[    0.000000] efi: mem202: type=3, attr=0xf, range=[0x000000008992d000-0x0000000089932000) (0MB)
[    0.000000] efi: mem203: type=4, attr=0xf, range=[0x0000000089932000-0x0000000089961000) (0MB)
[    0.000000] efi: mem204: type=3, attr=0xf, range=[0x0000000089961000-0x0000000089974000) (0MB)
[    0.000000] efi: mem205: type=4, attr=0xf, range=[0x0000000089974000-0x000000008998f000) (0MB)
[    0.000000] efi: mem206: type=3, attr=0xf, range=[0x000000008998f000-0x0000000089992000) (0MB)
[    0.000000] efi: mem207: type=4, attr=0xf, range=[0x0000000089992000-0x0000000089993000) (0MB)
[    0.000000] efi: mem208: type=2, attr=0xf, range=[0x0000000089993000-0x0000000089994000) (0MB)
[    0.000000] efi: mem209: type=4, attr=0xf, range=[0x0000000089994000-0x00000000899be000) (0MB)
[    0.000000] efi: mem210: type=3, attr=0xf, range=[0x00000000899be000-0x00000000899d2000) (0MB)
[    0.000000] efi: mem211: type=4, attr=0xf, range=[0x00000000899d2000-0x00000000899ea000) (0MB)
[    0.000000] efi: mem212: type=2, attr=0xf, range=[0x00000000899ea000-0x00000000899eb000) (0MB)
[    0.000000] efi: mem213: type=4, attr=0xf, range=[0x00000000899eb000-0x00000000899ef000) (0MB)
[    0.000000] efi: mem214: type=3, attr=0xf, range=[0x00000000899ef000-0x00000000899f4000) (0MB)
[    0.000000] efi: mem215: type=4, attr=0xf, range=[0x00000000899f4000-0x00000000899fc000) (0MB)
[    0.000000] efi: mem216: type=2, attr=0xf, range=[0x00000000899fc000-0x00000000899fd000) (0MB)
[    0.000000] efi: mem217: type=4, attr=0xf, range=[0x00000000899fd000-0x00000000899fe000) (0MB)
[    0.000000] efi: mem218: type=3, attr=0xf, range=[0x00000000899fe000-0x00000000899ff000) (0MB)
[    0.000000] efi: mem219: type=4, attr=0xf, range=[0x00000000899ff000-0x0000000089a00000) (0MB)
[    0.000000] efi: mem220: type=3, attr=0xf, range=[0x0000000089a00000-0x0000000089a01000) (0MB)
[    0.000000] efi: mem221: type=4, attr=0xf, range=[0x0000000089a01000-0x0000000089a02000) (0MB)
[    0.000000] efi: mem222: type=3, attr=0xf, range=[0x0000000089a02000-0x0000000089a03000) (0MB)
[    0.000000] efi: mem223: type=4, attr=0xf, range=[0x0000000089a03000-0x0000000089a14000) (0MB)
[    0.000000] efi: mem224: type=3, attr=0xf, range=[0x0000000089a14000-0x0000000089a19000) (0MB)
[    0.000000] efi: mem225: type=4, attr=0xf, range=[0x0000000089a19000-0x0000000089a1a000) (0MB)
[    0.000000] efi: mem226: type=3, attr=0xf, range=[0x0000000089a1a000-0x0000000089a1c000) (0MB)
[    0.000000] efi: mem227: type=4, attr=0xf, range=[0x0000000089a1c000-0x0000000089a1e000) (0MB)
[    0.000000] efi: mem228: type=3, attr=0xf, range=[0x0000000089a1e000-0x0000000089a2f000) (0MB)
[    0.000000] efi: mem229: type=4, attr=0xf, range=[0x0000000089a2f000-0x0000000089a32000) (0MB)
[    0.000000] efi: mem230: type=3, attr=0xf, range=[0x0000000089a32000-0x0000000089a3e000) (0MB)
[    0.000000] efi: mem231: type=2, attr=0xf, range=[0x0000000089a3e000-0x0000000089a3f000) (0MB)
[    0.000000] efi: mem232: type=3, attr=0xf, range=[0x0000000089a3f000-0x0000000089a40000) (0MB)
[    0.000000] efi: mem233: type=4, attr=0xf, range=[0x0000000089a40000-0x0000000089a42000) (0MB)
[    0.000000] efi: mem234: type=3, attr=0xf, range=[0x0000000089a42000-0x0000000089a44000) (0MB)
[    0.000000] efi: mem235: type=4, attr=0xf, range=[0x0000000089a44000-0x0000000089a45000) (0MB)
[    0.000000] efi: mem236: type=3, attr=0xf, range=[0x0000000089a45000-0x0000000089a46000) (0MB)
[    0.000000] efi: mem237: type=2, attr=0xf, range=[0x0000000089a46000-0x0000000089a47000) (0MB)
[    0.000000] efi: mem238: type=3, attr=0xf, range=[0x0000000089a47000-0x0000000089a49000) (0MB)
[    0.000000] efi: mem239: type=4, attr=0xf, range=[0x0000000089a49000-0x0000000089e6a000) (4MB)
[    0.000000] efi: mem240: type=3, attr=0xf, range=[0x0000000089e6a000-0x0000000089e6f000) (0MB)
[    0.000000] efi: mem241: type=2, attr=0xf, range=[0x0000000089e6f000-0x0000000089e70000) (0MB)
[    0.000000] efi: mem242: type=3, attr=0xf, range=[0x0000000089e70000-0x0000000089e78000) (0MB)
[    0.000000] efi: mem243: type=4, attr=0xf, range=[0x0000000089e78000-0x0000000089e7a000) (0MB)
[    0.000000] efi: mem244: type=2, attr=0xf, range=[0x0000000089e7a000-0x0000000089e7b000) (0MB)
[    0.000000] efi: mem245: type=4, attr=0xf, range=[0x0000000089e7b000-0x0000000089e7c000) (0MB)
[    0.000000] efi: mem246: type=3, attr=0xf, range=[0x0000000089e7c000-0x0000000089e81000) (0MB)
[    0.000000] efi: mem247: type=4, attr=0xf, range=[0x0000000089e81000-0x0000000089e82000) (0MB)
[    0.000000] efi: mem248: type=3, attr=0xf, range=[0x0000000089e82000-0x0000000089e85000) (0MB)
[    0.000000] efi: mem249: type=4, attr=0xf, range=[0x0000000089e85000-0x0000000089eaa000) (0MB)
[    0.000000] efi: mem250: type=3, attr=0xf, range=[0x0000000089eaa000-0x0000000089eab000) (0MB)
[    0.000000] efi: mem251: type=4, attr=0xf, range=[0x0000000089eab000-0x0000000089eae000) (0MB)
[    0.000000] efi: mem252: type=3, attr=0xf, range=[0x0000000089eae000-0x0000000089eaf000) (0MB)
[    0.000000] efi: mem253: type=4, attr=0xf, range=[0x0000000089eaf000-0x000000008a0db000) (2MB)
[    0.000000] efi: mem254: type=2, attr=0xf, range=[0x000000008a0db000-0x000000008a0dc000) (0MB)
[    0.000000] efi: mem255: type=4, attr=0xf, range=[0x000000008a0dc000-0x000000008acfa000) (12MB)
[    0.000000] efi: mem256: type=2, attr=0xf, range=[0x000000008acfa000-0x000000008acfb000) (0MB)
[    0.000000] efi: mem257: type=4, attr=0xf, range=[0x000000008acfb000-0x000000008ad03000) (0MB)
[    0.000000] efi: mem258: type=7, attr=0xf, range=[0x000000008ad03000-0x000000008ad12000) (0MB)
[    0.000000] efi: mem259: type=10, attr=0xf, range=[0x000000008ad12000-0x000000008ad53000) (0MB)
[    0.000000] efi: mem260: type=7, attr=0xf, range=[0x000000008ad53000-0x000000008ad69000) (0MB)
[    0.000000] efi: mem261: type=9, attr=0xf, range=[0x000000008ad69000-0x000000008ad8f000) (0MB)
[    0.000000] efi: mem262: type=7, attr=0xf, range=[0x000000008ad8f000-0x000000008ae3b000) (0MB)
[    0.000000] efi: mem263: type=6, attr=0x800000000000000f, range=[0x000000008ae3b000-0x000000008ae8f000) (0MB)
[    0.000000] efi: mem264: type=7, attr=0xf, range=[0x000000008ae8f000-0x000000008aece000) (0MB)
[    0.000000] efi: mem265: type=5, attr=0x800000000000000f, range=[0x000000008aece000-0x000000008aeff000) (0MB)
[    0.000000] efi: mem266: type=7, attr=0xf, range=[0x000000008aeff000-0x000000008af92000) (0MB)
[    0.000000] efi: mem267: type=0, attr=0xf, range=[0x000000008af92000-0x000000008afff000) (0MB)
[    0.000000] efi: mem268: type=2, attr=0xf, range=[0x000000008afff000-0x000000008b000000) (0MB)
[    0.000000] efi: mem269: type=7, attr=0xf, range=[0x0000000100000000-0x000000026f600000) (5878MB)
[    0.000000] efi: mem270: type=0, attr=0x8000000000000000, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
[    0.000000] efi: mem271: type=0, attr=0x8000000000000000, range=[0x000000008b000000-0x000000008fa00000) (74MB)
[    0.000000] efi: mem272: type=11, attr=0x8000000000000000, range=[0x00000000e00f8000-0x00000000e00f9000) (0MB)
[    0.000000] efi: mem273: type=11, attr=0x8000000000000000, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem274: type=11, attr=0x8000000000000000, range=[0x00000000ffe70000-0x00000000ffea0000) (0MB)
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookAir5,2/Mac-2E6FAB96566FE58C, BIOS MBA51.88Z.00EF.B02.1211271028 11/27/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x26f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
[    0.000000]   2 base 090000000 mask FF0000000 uncachable
[    0.000000]   3 base 08C000000 mask FFC000000 uncachable
[    0.000000]   4 base 08B000000 mask FFF000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x8b000 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000090000] 90000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fc2000, 0x02fc2fff] PGTABLE
[    0.000000] BRK [0x02fc3000, 0x02fc3fff] PGTABLE
[    0.000000] BRK [0x02fc4000, 0x02fc4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x26f400000-0x26f5fffff]
[    0.000000]  [mem 0x26f400000-0x26f5fffff] page 2M
[    0.000000] BRK [0x02fc5000, 0x02fc5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x26c000000-0x26f3fffff]
[    0.000000]  [mem 0x26c000000-0x26f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x26bffffff]
[    0.000000]  [mem 0x200000000-0x26bffffff] page 2M
[    0.000000] BRK [0x02fc6000, 0x02fc6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x40005000-0x8ad11fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0x8abfffff] page 2M
[    0.000000]  [mem 0x8ac00000-0x8ad11fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8ad53000-0x8ad68fff]
[    0.000000]  [mem 0x8ad53000-0x8ad68fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8ad8f000-0x8ae3afff]
[    0.000000]  [mem 0x8ad8f000-0x8ae3afff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8ae8f000-0x8aecdfff]
[    0.000000]  [mem 0x8ae8f000-0x8aecdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8aeff000-0x8af91fff]
[    0.000000]  [mem 0x8aeff000-0x8af91fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8afff000-0x8affffff]
[    0.000000]  [mem 0x8afff000-0x8affffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x7de6c000-0x7eefafff]
[    0.000000] ACPI: RSDP 000000008ad8e014 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000008ad8e1c0 000B4 (v01 APPLE   Apple00 00000000      01000013)
[    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000000 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000008ad82000 04708 (v01 APPLE  MacBookA 00050001 INTL 20100915)
[    0.000000] ACPI: FACS 000000008ad1c000 00040
[    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad7f000 001EE (v01 APPLE  SataAhci 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7e000 00024 (v01 APPLE   SmcDppt 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad78000 00D74 (v01 APPLE  UsbSdPpt 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad75000 00032 (v01 APPLE    SsdtS3 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad72000 00FAA (v01 APPLE   PcieTbt 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6d000 00615 (v01  PmRef  Cpu0Ist 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6c000 00B3D (v01  PmRef    CpuPm 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6b000 00315 (v01  PmRef  Cpu0Tst 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6a000 0037A (v01  PmRef    ApTst 00003000 INTL 20100915)
[    0.000000] ACPI: DMAR 000000008ad69000 00088 (v01 APPLE      IVB  00000001 AAPL 00000001)
[    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000026f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x26f5fffff]
[    0.000000]   NODE_DATA [mem 0x26f5e3000-0x26f5f6fff]
[    0.000000]  [ffffea0000000000-ffffea0009bfffff] PMD -> [ffff880266c00000-ffff88026ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x26f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008dfff]
[    0.000000]   node   0: [mem 0x00090000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0x8ad11fff]
[    0.000000]   node   0: [mem 0x8ad53000-0x8ad68fff]
[    0.000000]   node   0: [mem 0x8ad8f000-0x8ae3afff]
[    0.000000]   node   0: [mem 0x8ae8f000-0x8aecdfff]
[    0.000000]   node   0: [mem 0x8aeff000-0x8af91fff]
[    0.000000]   node   0: [mem 0x8afff000-0x8affffff]
[    0.000000]   node   0: [mem 0x100000000-0x26f5fffff]
[    0.000000] On node 0 totalpages: 2073155
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 26 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8819 pages used for memmap
[    0.000000]   DMA32 zone: 564390 pages, LIFO batch:31
[    0.000000]   Normal zone: 23512 pages used for memmap
[    0.000000]   Normal zone: 1504768 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0008e000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000bffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000c0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0x87d74000-0x87d74fff]
[    0.000000] PM: Registered nosave memory: [mem 0x87d84000-0x87d84fff]
[    0.000000] PM: Registered nosave memory: [mem 0x8ad12000-0x8ad52fff]
[    0.000000] PM: Registered nosave memory: [mem 0x8ad69000-0x8ad8efff]
[    0.000000] PM: Registered nosave memory: [mem 0x8ae3b000-0x8ae8efff]
[    0.000000] PM: Registered nosave memory: [mem 0x8aece000-0x8aefefff]
[    0.000000] PM: Registered nosave memory: [mem 0x8af92000-0x8affefff]
[    0.000000] PM: Registered nosave memory: [mem 0x8b000000-0x8f9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x8fa00000-0xe00f7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xe00f8000-0xe00f8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xe00f9000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xffe6ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffe70000-0xffe9ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffea0000-0xffffffff]
[    0.000000] e820: [mem 0x8fa00000-0xe00f7fff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88026f200000 s81216 r8192 d21184 u262144
[    0.000000] pcpu-alloc: s81216 r8192 d21184 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2040734
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=\initramfs-3.11.0-rc4+.img root=UUID=5ba0be6c-1f3f-45c4-8047-7dfed933d5ba ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 7876940K/8292620K available (6337K kernel code, 959K rwdata, 2796K rodata, 1320K init, 1532K bss, 415680K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=8.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-127.
[    0.000000] NR_IRQS:8448 nr_irqs:744 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 2494.212 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4988.42 BogoMIPS (lpj=2494212)
[    0.000008] pid_max: default: 32768 minimum: 301
[    0.000044] init_memory_mapping: [mem 0x8ae3b000-0x8ae8efff]
[    0.000048]  [mem 0x8ae3b000-0x8ae8efff] page 4k
[    0.000062] init_memory_mapping: [mem 0x8aece000-0x8aefefff]
[    0.000065]  [mem 0x8aece000-0x8aefefff] page 4k
[    0.000109] init_memory_mapping: [mem 0x8b000000-0x8f9fffff]
[    0.000112]  [mem 0x8b000000-0x8f9fffff] page 2M
[    0.031098] Security Framework initialized
[    0.031106] SELinux:  Initializing.
[    0.031117] SELinux:  Starting in permissive mode
[    0.031794] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.034424] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.035572] Mount-cache hash table entries: 256
[    0.035779] Initializing cgroup subsys memory
[    0.035790] Initializing cgroup subsys devices
[    0.035793] Initializing cgroup subsys freezer
[    0.035796] Initializing cgroup subsys net_cls
[    0.035801] Initializing cgroup subsys blkio
[    0.035804] Initializing cgroup subsys perf_event
[    0.035831] CPU: Physical Processor ID: 0
[    0.035834] CPU: Processor Core ID: 0
[    0.036317] mce: CPU supports 7 MCE banks
[    0.036331] CPU0: Thermal monitoring enabled (TM1)
[    0.036342] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 1
[    0.036484] Freeing SMP alternatives memory: 24K (ffffffff81e3b000 - ffffffff81e41000)
[    0.036489] ACPI: Core revision 20130517
[    0.043718] ACPI: All ACPI Tables successfully acquired
[    0.053090] ftrace: allocating 24495 entries in 96 pages
[    0.067295] dmar: Host address width 36
[    0.067299] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.067311] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.067314] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.067321] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.067324] dmar: RMRR base: 0x0000008b800000 end: 0x0000008f9fffff
[    0.067397] IOAPIC id 0 under DRHD base  0xfed91000 IOMMU 1
[    0.067399] HPET id 0 under DRHD base 0xfed91000
[    0.067401] [Firmware Bug]: ioapic 2 has no mapping iommu, interrupt remapping will be disabled
[    0.067404] Not enable interrupt remapping
[    0.067406] Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.
[    0.067861] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.077875] smpboot: CPU0: Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz (fam: 06, model: 3a, stepping: 09)
[    0.077886] TSC deadline timer enabled
[    0.077898] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.077908] ... version:                3
[    0.077910] ... bit width:              48
[    0.077911] ... generic registers:      4
[    0.077913] ... value mask:             0000ffffffffffff
[    0.077915] ... max period:             0000ffffffffffff
[    0.077917] ... fixed-purpose events:   3
[    0.077919] ... event mask:             000000070000000f
[    0.093289] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.079558] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.121145] Brought up 4 CPUs
[    0.121151] smpboot: Total of 4 processors activated (19953.69 BogoMIPS)
[    0.125420] devtmpfs: initialized
[    0.125592] PM: Registering ACPI NVS region [mem 0x8ad12000-0x8ad52fff] (266240 bytes)
[    0.126505] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.126535] RTC time: 22:01:33, date: 08/12/13
[    0.126582] NET: Registered protocol family 16
[    0.126686] ACPI: bus type PCI registered
[    0.126690] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.126757] PCI: MMCONFIG for domain 0000 [bus 00-99] at [mem 0xe0000000-0xe99fffff] (base 0xe0000000)
[    0.126761] PCI: not using MMCONFIG
[    0.126764] PCI: Using configuration type 1 for base access
[    0.127648] bio: create slab <bio-0> at 0
[    0.127778] ACPI: Added _OSI(Module Device)
[    0.127781] ACPI: Added _OSI(Processor Device)
[    0.127783] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.127786] ACPI: Added _OSI(Processor Aggregator Device)
[    0.129163] ACPI: EC: EC description table is found, configuring boot EC
[    0.133932] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    2.142091] ACPI: SSDT 000000008ad17190 008AD (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    2.142456] ACPI: Dynamic OEM Table Load:
[    2.142460] ACPI: SSDT           (null) 008AD (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    2.144092] ACPI: SSDT 000000008ad18710 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    2.144498] ACPI: Dynamic OEM Table Load:
[    2.144501] ACPI: SSDT           (null) 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    2.145944] ACPI: SSDT 000000008ad16d90 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    2.146299] ACPI: Dynamic OEM Table Load:
[    2.146302] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    2.148425] ACPI: Interpreter enabled
[    2.148432] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130517/hwxface-571)
[    2.148439] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[    2.148455] ACPI: (supports S0 S3 S4 S5)
[    2.148457] ACPI: Using IOAPIC for interrupt routing
[    2.148479] PCI: MMCONFIG for domain 0000 [bus 00-99] at [mem 0xe0000000-0xe99fffff] (base 0xe0000000)
[    2.151073] PCI: MMCONFIG at [mem 0xe0000000-0xe99fffff] reserved in ACPI motherboard resources
[    2.179861] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.179995] ACPI: No dock devices found.
[    2.691117] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.691415] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-99] only partially covers this bridge
[    2.691499] PCI host bridge to bus 0000:00
[    2.691504] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.691507] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.691510] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.691513] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.691516] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    2.691519] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    2.691522] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    2.691524] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    2.691527] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    2.691530] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    2.691533] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    2.691536] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    2.691539] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    2.691542] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    2.691545] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    2.691547] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    2.691550] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    2.691553] pci_bus 0000:00: root bus resource [mem 0x8fa00000-0xfeafffff]
[    2.691556] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    2.691567] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    2.691671] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    2.691684] pci 0000:00:02.0: reg 0x10: [mem 0xa0000000-0xa03fffff 64bit]
[    2.691691] pci 0000:00:02.0: reg 0x18: [mem 0x90000000-0x9fffffff 64bit pref]
[    2.691696] pci 0000:00:02.0: reg 0x20: [io  0x2000-0x203f]
[    2.691805] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    2.691831] pci 0000:00:14.0: reg 0x10: [mem 0xa0600000-0xa060ffff 64bit]
[    2.691909] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    2.691950] pci 0000:00:14.0: System wakeup disabled by ACPI
[    2.691994] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    2.692020] pci 0000:00:16.0: reg 0x10: [mem 0xa0617100-0xa061710f 64bit]
[    2.692104] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    2.692189] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    2.692213] pci 0000:00:1a.0: reg 0x10: [mem 0xa0616c00-0xa0616fff]
[    2.692311] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    2.692351] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    2.692394] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    2.692413] pci 0000:00:1b.0: reg 0x10: [mem 0xa0610000-0xa0613fff 64bit]
[    2.692489] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    2.692528] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    2.692575] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    2.692710] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.692795] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    2.692926] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    2.692977] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    2.693019] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    2.693150] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.693204] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    2.693249] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    2.693274] pci 0000:00:1d.0: reg 0x10: [mem 0xa0616800-0xa0616bff]
[    2.693372] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    2.693413] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    2.693450] pci 0000:00:1f.0: [8086:1e56] type 00 class 0x060100
[    2.693631] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    2.693653] pci 0000:00:1f.2: reg 0x10: [io  0x2098-0x209f]
[    2.693664] pci 0000:00:1f.2: reg 0x14: [io  0x20bc-0x20bf]
[    2.693674] pci 0000:00:1f.2: reg 0x18: [io  0x2090-0x2097]
[    2.693682] pci 0000:00:1f.2: reg 0x1c: [io  0x20b8-0x20bb]
[    2.693691] pci 0000:00:1f.2: reg 0x20: [io  0x2060-0x207f]
[    2.693702] pci 0000:00:1f.2: reg 0x24: [mem 0xa0616000-0xa06167ff]
[    2.693753] pci 0000:00:1f.2: PME# supported from D3hot
[    2.693820] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    2.693838] pci 0000:00:1f.3: reg 0x10: [mem 0xa0617000-0xa06170ff 64bit]
[    2.693861] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    2.694022] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    2.694033] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    2.694201] pci 0000:02:00.0: [14e4:4353] type 00 class 0x028000
[    2.694232] pci 0000:02:00.0: reg 0x10: [mem 0xa0400000-0xa0403fff 64bit]
[    2.694392] pci 0000:02:00.0: supports D1 D2
[    2.694393] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    2.694438] pci 0000:02:00.0: System wakeup disabled by ACPI
[    2.696702] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    2.696710] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    2.696817] pci 0000:00:1c.4: PCI bridge to [bus 03-99]
[    2.696825] pci 0000:00:1c.4:   bridge window [io  0x3000-0x5fff]
[    2.696831] pci 0000:00:1c.4:   bridge window [mem 0xa0700000-0xac9fffff]
[    2.696839] pci 0000:00:1c.4:   bridge window [mem 0xaca00000-0xb89fffff 64bit pref]
[    2.696931] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    2.697050] acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
[    2.697520] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    2.697589] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    2.697659] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    2.697727] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    2.697791] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    2.697851] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    2.697913] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    2.697972] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    2.699214] ACPI: Enabled 3 GPEs in block 00 to 3F
[    2.699224] ACPI: \_SB_.PCI0: notify handler is installed
[    2.699278] Found 1 acpi root devices
[    2.699300] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    2.699384] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.699389] vgaarb: loaded
[    2.699390] vgaarb: bridge control possible 0000:00:02.0
[    2.699475] SCSI subsystem initialized
[    2.699478] ACPI: bus type ATA registered
[    2.699521] libata version 3.00 loaded.
[    2.699542] ACPI: bus type USB registered
[    2.699558] usbcore: registered new interface driver usbfs
[    2.699567] usbcore: registered new interface driver hub
[    2.699592] usbcore: registered new device driver usb
[    2.699668] PCI: Using ACPI for IRQ routing
[    2.707954] PCI: pci_cache_line_size set to 64 bytes
[    2.708044] e820: reserve RAM buffer [mem 0x0008e000-0x0008ffff]
[    2.708046] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    2.708048] e820: reserve RAM buffer [mem 0x87d74190-0x87ffffff]
[    2.708049] e820: reserve RAM buffer [mem 0x8ad12000-0x8bffffff]
[    2.708052] e820: reserve RAM buffer [mem 0x8ad69000-0x8bffffff]
[    2.708054] e820: reserve RAM buffer [mem 0x8ae3b000-0x8bffffff]
[    2.708057] e820: reserve RAM buffer [mem 0x8aece000-0x8bffffff]
[    2.708059] e820: reserve RAM buffer [mem 0x8af92000-0x8bffffff]
[    2.708060] e820: reserve RAM buffer [mem 0x8b000000-0x8bffffff]
[    2.708062] e820: reserve RAM buffer [mem 0x26f600000-0x26fffffff]
[    2.708146] NetLabel: Initializing
[    2.708149] NetLabel:  domain hash size = 128
[    2.708151] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.708161] NetLabel:  unlabeled traffic allowed by default
[    2.708186] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.708193] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.710231] Switched to clocksource hpet
[    2.715484] pnp: PnP ACPI init
[    2.715499] ACPI: bus type PNP registered
[    2.715556] pnp 00:00: [dma 4]
[    2.715580] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.715602] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    2.715745] system 00:02: [mem 0xfed00000-0xfed003ff] has been reserved
[    2.715750] system 00:02: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    2.715780] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.715817] system 00:04: [io  0x1000-0x100f] has been reserved
[    2.715821] system 00:04: [io  0x0400-0x047f] could not be reserved
[    2.715824] system 00:04: [io  0x0500-0x057f] has been reserved
[    2.715828] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.715850] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.715881] pnp 00:06: Plug and Play ACPI device, IDs APP0001 (active)
[    2.716130] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.716134] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    2.716137] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.716140] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.716144] system 00:07: [mem 0xe0000000-0xefffffff] could not be reserved
[    2.716147] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.716150] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
[    2.716153] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    2.716157] system 00:07: [mem 0xff000000-0xffffffff] could not be reserved
[    2.716160] system 00:07: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.716164] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.718362] system 00:08: [mem 0x20000000-0x201fffff] has been reserved
[    2.718368] system 00:08: [mem 0x40000000-0x401fffff] could not be reserved
[    2.718373] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.718384] pnp: PnP ACPI: found 9 devices
[    2.718388] ACPI: bus type PNP unregistered
[    2.725147] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    2.725159] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    2.725173] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    2.725180] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    2.725194] pci 0000:00:1c.4: PCI bridge to [bus 03-99]
[    2.725199] pci 0000:00:1c.4:   bridge window [io  0x3000-0x5fff]
[    2.725207] pci 0000:00:1c.4:   bridge window [mem 0xa0700000-0xac9fffff]
[    2.725214] pci 0000:00:1c.4:   bridge window [mem 0xaca00000-0xb89fffff 64bit pref]
[    2.725230] pci 0000:00:1c.0: enabling device (0000 -> 0002)
[    2.725455] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.725458] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.725460] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.725462] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    2.725464] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    2.725466] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    2.725468] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    2.725469] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    2.725471] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    2.725473] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    2.725475] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    2.725477] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    2.725479] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    2.725481] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    2.725483] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    2.725484] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
[    2.725486] pci_bus 0000:00: resource 20 [mem 0x8fa00000-0xfeafffff]
[    2.725488] pci_bus 0000:00: resource 21 [mem 0xfed40000-0xfed44fff]
[    2.725490] pci_bus 0000:01: resource 1 [mem 0xa0500000-0xa05fffff]
[    2.725493] pci_bus 0000:02: resource 1 [mem 0xa0400000-0xa04fffff]
[    2.725495] pci_bus 0000:03: resource 0 [io  0x3000-0x5fff]
[    2.725496] pci_bus 0000:03: resource 1 [mem 0xa0700000-0xac9fffff]
[    2.725498] pci_bus 0000:03: resource 2 [mem 0xaca00000-0xb89fffff 64bit pref]
[    2.725536] NET: Registered protocol family 2
[    2.725762] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.725996] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.726130] TCP: Hash tables configured (established 65536 bind 65536)
[    2.726151] TCP: reno registered
[    2.726169] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    2.726205] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.726306] NET: Registered protocol family 1
[    2.726318] pci 0000:00:02.0: Boot video device
[    2.726329] pci 0000:00:14.0: enabling device (0000 -> 0002)
[    2.726394] pci 0000:00:14.0: can't derive routing for PCI INT A
[    2.726397] pci 0000:00:14.0: PCI INT A: no GSI
[    2.726508] pci 0000:00:14.0: can't derive routing for PCI INT A
[    2.726859] PCI: CLS 256 bytes, default 64
[    2.726916] Unpacking initramfs...
[    3.072326] Freeing initrd memory: 16956K (ffff88007de6c000 - ffff88007eefb000)
[    3.072339] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.072344] software IO TLB [mem 0x79e6c000-0x7de6c000] (64MB) mapped at [ffff880079e6c000-ffff88007de6bfff]
[    3.075663] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    3.076135] Initialise module verification
[    3.076183] audit: initializing netlink socket (disabled)
[    3.076199] type=2000 audit(1376344895.049:1): initialized
[    3.111579] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.113021] VFS: Disk quotas dquot_6.5.2
[    3.113065] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.113495] msgmni has been set to 15777
[    3.113556] SELinux:  Registering netfilter hooks
[    3.114330] alg: No test for stdrng (krng)
[    3.114343] NET: Registered protocol family 38
[    3.114349] Key type asymmetric registered
[    3.114352] Asymmetric key parser 'x509' registered
[    3.114386] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    3.114429] io scheduler noop registered
[    3.114433] io scheduler deadline registered
[    3.114465] io scheduler cfq registered (default)
[    3.114589] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    3.114720] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    3.114834] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    3.114958] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    3.114968] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    3.114993] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    3.114996] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    3.115005] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    3.115029] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    3.115038] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    3.115049] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.115064] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.115131] efifb: probing for efifb
[    3.116208] efifb: framebuffer at 0x90000000, mapped to 0xffffc9000a980000, using 5400k, total 5400k
[    3.116212] efifb: mode is 1440x900x32, linelength=6144, pages=1
[    3.116214] efifb: scrolling: redraw
[    3.116217] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    3.120011] Console: switching to colour frame buffer device 180x56
[    3.123466] fb0: EFI VGA frame buffer device
[    3.123492] intel_idle: MWAIT substates: 0x21120
[    3.123494] intel_idle: v0.4 model 0x3A
[    3.123495] intel_idle: lapic_timer_reliable_states 0xffffffff
[    3.123598] ACPI: AC Adapter [ADP1] (on-line)
[    3.123731] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    3.123786] ACPI: Lid Switch [LID0]
[    3.123836] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    3.123876] ACPI: Power Button [PWRB]
[    3.123924] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    3.123964] ACPI: Sleep Button [SLPB]
[    3.124009] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    3.124045] ACPI: Power Button [PWRF]
[    3.124100] ACPI: Requesting acpi_cpufreq
[    3.126002] GHES: HEST is not enabled!
[    3.126089] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.127516] Non-volatile memory driver v1.3
[    3.127539] Linux agpgart interface v0.103
[    3.128364] loop: module loaded
[    3.128481] mei_me 0000:00:16.0: setting latency timer to 64
[    3.128520] mei_me 0000:00:16.0: irq 43 for MSI/MSI-X
[    3.131527] ahci 0000:00:1f.2: version 3.0
[    3.131697] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    3.131797] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    3.131841] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    3.131888] ahci 0000:00:1f.2: setting latency timer to 64
[    3.132291] scsi0 : ahci
[    3.132387] scsi1 : ahci
[    3.132463] scsi2 : ahci
[    3.132562] scsi3 : ahci
[    3.132703] scsi4 : ahci
[    3.132870] scsi5 : ahci
[    3.132961] ata1: SATA max UDMA/133 abar m2048@0xa0616000 port 0xa0616100 irq 44
[    3.133011] ata2: DUMMY
[    3.134204] ata3: DUMMY
[    3.135418] ata4: DUMMY
[    3.136539] ata5: DUMMY
[    3.137656] ata6: DUMMY
[    3.138949] libphy: Fixed MDIO Bus: probed
[    3.140159] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.141292] ehci-pci: EHCI PCI platform driver
[    3.142619] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    3.142628] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    3.143810] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.144944] ehci-pci 0000:00:1a.0: debug port 2
[    3.150083] ehci-pci 0000:00:1a.0: cache line size of 256 is not supported
[    3.150102] ehci-pci 0000:00:1a.0: irq 23, io mem 0xa0616c00
[    3.156760] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.157903] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.159039] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.160272] usb usb1: Product: EHCI Host Controller
[    3.161361] usb usb1: Manufacturer: Linux 3.11.0-rc4+ ehci_hcd
[    3.162610] usb usb1: SerialNumber: 0000:00:1a.0
[    3.163887] hub 1-0:1.0: USB hub found
[    3.164990] hub 1-0:1.0: 2 ports detected
[    3.166356] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    3.166363] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    3.167342] ACPI: Battery Slot [BAT0] (battery present)
[    3.168634] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.169702] ehci-pci 0000:00:1d.0: debug port 2
[    3.174676] ehci-pci 0000:00:1d.0: cache line size of 256 is not supported
[    3.174691] ehci-pci 0000:00:1d.0: irq 22, io mem 0xa0616800
[    3.180782] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.181830] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.182876] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.183913] usb usb2: Product: EHCI Host Controller
[    3.184934] usb usb2: Manufacturer: Linux 3.11.0-rc4+ ehci_hcd
[    3.185949] usb usb2: SerialNumber: 0000:00:1d.0
[    3.187052] hub 2-0:1.0: USB hub found
[    3.188040] hub 2-0:1.0: 2 ports detected
[    3.189092] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.190076] ohci-pci: OHCI PCI platform driver
[    3.191044] uhci_hcd: USB Universal Host Controller Interface driver
[    3.192123] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    3.193124] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
[    3.194130] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    3.194134] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.195144] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    3.196233] xhci_hcd 0000:00:14.0: cache line size of 256 is not supported
[    3.196257] xhci_hcd 0000:00:14.0: irq 45 for MSI/MSI-X
[    3.196310] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    3.197303] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.198282] usb usb3: Product: xHCI Host Controller
[    3.199252] usb usb3: Manufacturer: Linux 3.11.0-rc4+ xhci_hcd
[    3.200213] usb usb3: SerialNumber: 0000:00:14.0
[    3.201265] xHCI xhci_add_endpoint called for root hub
[    3.201266] xHCI xhci_check_bandwidth called for root hub
[    3.201288] hub 3-0:1.0: USB hub found
[    3.202278] hub 3-0:1.0: 4 ports detected
[    3.203427] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.204486] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    3.205549] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    3.206581] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.207605] usb usb4: Product: xHCI Host Controller
[    3.208637] usb usb4: Manufacturer: Linux 3.11.0-rc4+ xhci_hcd
[    3.209688] usb usb4: SerialNumber: 0000:00:14.0
[    3.210831] xHCI xhci_add_endpoint called for root hub
[    3.210832] xHCI xhci_check_bandwidth called for root hub
[    3.210851] hub 4-0:1.0: USB hub found
[    3.211926] hub 4-0:1.0: 4 ports detected
[    3.218870] usbcore: registered new interface driver usbserial
[    3.219947] usbcore: registered new interface driver usbserial_generic
[    3.221007] usbserial: USB Serial support registered for generic
[    3.222089] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.444087] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.445673] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.447226] ata1.00: ATA-8: APPLE SSD SM256E, CXM09A1Q, max UDMA/133
[    3.448684] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.450425] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.451996] ata1.00: configured for UDMA/133
[    3.453570] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD SM256E CXM0 PQ: 0 ANSI: 5
[    3.454812] sd 0:0:0:0: [sda] 490234752 512-byte logical blocks: (251 GB/233 GiB)
[    3.454829] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.457813] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    3.459390] sd 0:0:0:0: [sda] Write Protect is off
[    3.460883] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.460906] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.464348]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8
[    3.466498] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.074812] tsc: Refined TSC clocksource calibration: 2494.340 MHz
[    4.325290] i8042: No controller found
[    4.326519] mousedev: PS/2 mouse device common for all mice
[    4.327939] rtc_cmos 00:05: RTC can wake from S4
[    4.329232] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    4.330413] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    4.331662] device-mapper: uevent: version 1.0.3
[    4.332907] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
[    4.334138] Intel P-state driver initializing.
[    4.335339] Intel pstate controlling: cpu 0
[    4.336148] Intel pstate controlling: cpu 1
[    4.336898] Intel pstate controlling: cpu 2
[    4.337645] Intel pstate controlling: cpu 3
[    4.338435] cpuidle: using governor ladder
[    4.339226] cpuidle: using governor menu
[    4.340178] EFI Variables Facility v0.08 2004-May-17
[    4.528338] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    4.642854] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    4.644115] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.645618] hub 1-1:1.0: USB hub found
[    4.646855] hub 1-1:1.0: 6 ports detected
[    4.669476] hidraw: raw HID events driver (C) Jiri Kosina
[    4.670190] usbcore: registered new interface driver usbhid
[    4.670891] usbhid: USB HID core driver
[    4.671580] drop_monitor: Initializing network drop monitor service
[    4.672310] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.673041] TCP: cubic registered
[    4.673756] Initializing XFRM netlink socket
[    4.674515] NET: Registered protocol family 10
[    4.675299] mip6: Mobile IPv6
[    4.675968] NET: Registered protocol family 17
[    4.676950] PM: Hibernation image not present or could not be loaded.
[    4.676953] Loading module verification certificates
[    4.678283] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: ae70c02fcc230b8be0e192a6571672ddcbf92a93'
[    4.678985] registered taskstats version 1
[    4.680288]   Magic number: 9:210:47
[    4.681090] rtc_cmos 00:05: setting system clock to 2013-08-12 22:01:37 UTC (1376344897)
[    4.682546] Freeing unused kernel memory: 1320K (ffffffff81cf1000 - ffffffff81e3b000)
[    4.683251] Write protecting the kernel read-only data: 12288k
[    4.686787] Freeing unused kernel memory: 1844K (ffff880002633000 - ffff880002800000)
[    4.689418] Freeing unused kernel memory: 1300K (ffff880002abb000 - ffff880002c00000)
[    4.692024] systemd[1]: RTC configured in localtime, applying delta of 120 minutes to system time.
[    4.750589] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    4.867131] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    4.867894] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.868907] hub 2-1:1.0: USB hub found
[    4.869762] hub 2-1:1.0: 8 ports detected
[    4.944974] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[    5.052974] usb 1-1.1: New USB device found, idVendor=05ac, idProduct=8510
[    5.053724] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.054470] usb 1-1.1: Product: FaceTime HD Camera (Built-in)
[    5.055215] usb 1-1.1: Manufacturer: Apple Inc.
[    5.055951] usb 1-1.1: SerialNumber: CCGC6H0EB0DWC8C0
[    5.077794] Switched to clocksource tsc
[    5.147189] usb 2-1.8: new high-speed USB device number 3 using ehci-pci
[    5.234541] usb 2-1.8: New USB device found, idVendor=0424, idProduct=2513
[    5.235280] usb 2-1.8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.236187] hub 2-1.8:1.0: USB hub found
[    5.237043] hub 2-1.8:1.0: 3 ports detected
[    5.273096] systemd[1]: systemd 204 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    5.273926] systemd[1]: Running in initial RAM disk.
[    5.276998] systemd[1]: Set hostname to <helium>.
[    5.281872] systemd[1]: Expecting device dev-disk-by\x2duuid-5ba0be6c\x2d1f3f\x2d45c4\x2d8047\x2d7dfed933d5ba.device...
[    5.283531] systemd[1]: Expecting device dev-disk-by\x2duuid-1b190b67\x2dc50a\x2d41e3\x2dbbd7\x2d23b1bcd04daf.device...
[    5.285209] systemd[1]: Expecting device dev-disk-by\x2duuid-3e316c7d\x2d0409\x2d4d25\x2d9041\x2ddc1bcbac9543.device...
[    5.286943] systemd[1]: Starting Timers.
[    5.288685] systemd[1]: Reached target Timers.
[    5.289559] systemd[1]: Starting udev Kernel Socket.
[    5.291317] systemd[1]: Listening on udev Kernel Socket.
[    5.292182] systemd[1]: Starting udev Control Socket.
[    5.293936] systemd[1]: Listening on udev Control Socket.
[    5.294779] systemd[1]: Starting Journal Socket.
[    5.296559] systemd[1]: Listening on Journal Socket.
[    5.297516] systemd[1]: Started dracut cmdline hook.
[    5.298461] systemd[1]: Starting dracut pre-udev hook...
[    5.300561] systemd[1]: Started Load Kernel Modules.
[    5.301429] systemd[1]: Starting Sockets.
[    5.303166] systemd[1]: Reached target Sockets.
[    5.304005] systemd[1]: Starting Setup Virtual Console...
[    5.305971] systemd[1]: Starting Journal Service...
[    5.309491] systemd[1]: Started Journal Service.
[    5.314909] systemd[1]: Starting Swap.
[    5.317525] systemd[1]: Reached target Swap.
[    5.318482] systemd[1]: Starting Local File Systems.
[    5.320334] systemd[1]: Reached target Local File Systems.
[    5.322404] systemd[1]: Started Setup Virtual Console.
[    5.329301] systemd-udevd[134]: starting version 204
[    5.414004] [drm] Initialized drm 1.1.0 20060810
[    5.508638] [drm] Memory usable by graphics device = 2048M
[    5.509466] checking generic (90000000 546000) vs hw (90000000 10000000)
[    5.509467] fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing generic driver
[    5.510282] Console: switching to colour dummy device 80x25
[    5.510373] i915 0000:00:02.0: setting latency timer to 64
[    5.511606] usb 2-1.8.1: new full-speed USB device number 4 using ehci-pci
[    5.542578] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    5.542584] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    5.542586] [drm] Driver supports precise vblank timestamp query.
[    5.542597] ACPI Warning: \_SB_.PCI0.IGPU._DSM: Argument #4 type mismatch - Found [Integer], ACPI requires [Package] (20130517/nsarguments-95)
[    5.542625] ACPI Warning: \_SB_.PCI0.IGPU._DSM: Argument #4 type mismatch - Found [Integer], ACPI requires [Package] (20130517/nsarguments-95)
[    5.542663] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    5.598671] usb 2-1.8.1: New USB device found, idVendor=0a5c, idProduct=4500
[    5.598676] usb 2-1.8.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.598679] usb 2-1.8.1: Product: BRCM20702 Hub
[    5.598681] usb 2-1.8.1: Manufacturer: Apple Inc.
[    5.598955] hub 2-1.8.1:1.0: USB hub found
[    5.599042] hub 2-1.8.1:1.0: 3 ports detected
[    5.652691] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    5.663410] fbcon: inteldrmfb (fb0) is primary device
[    5.672835] usb 2-1.8.2: new full-speed USB device number 5 using ehci-pci
[    5.765908] usb 2-1.8.2: New USB device found, idVendor=05ac, idProduct=024c
[    5.765911] usb 2-1.8.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.765914] usb 2-1.8.2: Product: Apple Internal Keyboard / Trackpad
[    5.765916] usb 2-1.8.2: Manufacturer: Apple Inc.
[    5.771973] input: Apple Inc. Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.8/2-1.8.2/2-1.8.2:1.0/input/input4
[    5.772283] apple 0003:05AC:024C.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-1.8.2/input0
[    5.912440] apple 0003:05AC:024C.0002: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-1.8.2/input1
[    5.986160] usb 2-1.8.3: new high-speed USB device number 6 using ehci-pci
[    6.078236] usb 2-1.8.3: New USB device found, idVendor=05ac, idProduct=8404
[    6.078241] usb 2-1.8.3: New USB device strings: Mfr=3, Product=4, SerialNumber=2
[    6.078244] usb 2-1.8.3: Product: Card Reader
[    6.078246] usb 2-1.8.3: Manufacturer: Apple
[    6.078249] usb 2-1.8.3: SerialNumber: 000000000310
[    6.097796] usb-storage 2-1.8.3:1.0: USB Mass Storage device detected
[    6.097844] scsi6 : usb-storage 2-1.8.3:1.0
[    6.097909] usbcore: registered new interface driver usb-storage
[    6.152539] usb 2-1.8.1.1: new full-speed USB device number 7 using ehci-pci
[    6.241312] usb 2-1.8.1.1: New USB device found, idVendor=05ac, idProduct=820a
[    6.241316] usb 2-1.8.1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.243383] input: HID 05ac:820a as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.8/2-1.8.1/2-1.8.1.1/2-1.8.1.1:1.0/input/input5
[    6.243463] hid-generic 0003:05AC:820A.0003: input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1d.0-1.8.1.1/input0
[    6.316717] usb 2-1.8.1.2: new full-speed USB device number 8 using ehci-pci
[    6.394846] usb 2-1.8.1.2: New USB device found, idVendor=05ac, idProduct=820b
[    6.394849] usb 2-1.8.1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.397248] input: HID 05ac:820b as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.8/2-1.8.1/2-1.8.1.2/2-1.8.1.2:1.0/input/input6
[    6.397559] hid-generic 0003:05AC:820B.0004: input,hidraw3: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:1d.0-1.8.1.2/input0
[    6.470894] usb 2-1.8.1.3: new full-speed USB device number 9 using ehci-pci
[    6.550491] usb 2-1.8.1.3: New USB device found, idVendor=05ac, idProduct=821f
[    6.550495] usb 2-1.8.1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.550498] usb 2-1.8.1.3: Product: Bluetooth USB Host Controller
[    6.550500] usb 2-1.8.1.3: Manufacturer: Apple Inc.
[    6.738160] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    7.122812] scsi 6:0:0:0: Direct-Access     APPLE    SD Card Reader   2.00 PQ: 0 ANSI: 0
[    7.123705] sd 6:0:0:0: Attached scsi generic sg1 type 0
[    7.125352] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    8.124551] Console: switching to colour frame buffer device 180x56
[    8.142603] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    8.142605] i915 0000:00:02.0: registered panic notifier
[    8.147872] acpi device:07: registered as cooling_device5
[    8.149848] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[    8.151513] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
[    8.153276] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    8.171626] EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
[    8.223021] systemd-journald[118]: Received SIGTERM
[    8.469441] SELinux: 2048 avtab hash slots, 94592 rules.
[    8.479665] SELinux: 2048 avtab hash slots, 94592 rules.
[    8.675181] SELinux:  8 users, 82 roles, 4527 types, 254 bools, 1 sens, 1024 cats
[    8.675184] SELinux:  83 classes, 94592 rules
[    8.678814] SELinux:  Completing initialization.
[    8.678816] SELinux:  Setting up existing superblocks.
[    8.678821] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    8.678824] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    8.678830] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    8.678834] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    8.678839] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    8.678868] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    8.679503] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    8.679506] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    8.679916] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    8.679920] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    8.679922] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    8.679933] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    8.679937] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    8.679947] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    8.679955] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    8.680145] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    8.680147] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    8.680158] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    8.680210] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    8.680239] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.680243] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    8.680245] SELinux: initialized (dev efivarfs, type efivarfs), uses genfs_contexts
[    8.680253] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.680256] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.680267] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.680271] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.680273] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.680276] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.680278] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.680282] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.680288] SELinux: initialized (dev sda8, type ext4), uses xattr
[    8.690240] type=1403 audit(1376337701.504:2): policy loaded auid=4294967295 ses=4294967295
[    8.696294] systemd[1]: Successfully loaded SELinux policy in 347.015ms.
[    8.706811] systemd[1]: RTC configured in localtime, applying delta of 120 minutes to system time.
[    8.725398] systemd[1]: Relabelled /dev and /run in 12.876ms.
[    8.774107] LVM: Logical Volume autoactivation enabled.
[    8.774111] LVM: Activation generator successfully completed.
[    8.850009] systemd-readahead[213]: Bumped block_nr parameter of 8:0 to 20480. This is a temporary hack and should be removed one day.
[    8.857229] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    8.865920] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    8.871691] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    8.875066] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    8.897126] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    8.899224] systemd-udevd[230]: starting version 204
[    8.930961] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[    8.979767] EXT4-fs (sda8): re-mounted. Opts: (null)
[    9.055414] bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x08
[    9.056371] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
[    9.057257] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
[    9.058122] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
[    9.058138] input: PC Speaker as /devices/platform/pcspkr/input/input8
[    9.068670] i801_smbus 0000:00:1f.3: enabling device (0000 -> 0003)
[    9.071039] ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130517/utaddress-251)
[    9.072693] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.104658] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130517/utaddress-251)
[    9.105913] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.107290] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130517/utaddress-251)
[    9.108664] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.112868] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130517/utaddress-251)
[    9.114035] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.115410] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    9.119061] bcma: bus0: Bus registered
[    9.133681] input: bcm5974 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.8/2-1.8.2/2-1.8.2:1.2/input/input9
[    9.135363] usbcore: registered new interface driver bcm5974
[    9.137814] media: Linux media interface: v0.10
[    9.172539] Linux video capture interface: v2.00
[    9.223395] applesmc: key=424 fan=1 temp=31 index=30 acc=0 lux=2 kbd=1
[    9.244254] Bluetooth: Core ver 2.16
[    9.245883] NET: Registered protocol family 31
[    9.247428] Bluetooth: HCI device and connection manager initialized
[    9.249137] Bluetooth: HCI socket layer initialized
[    9.250951] Bluetooth: L2CAP socket layer initialized
[    9.252674] Bluetooth: SCO socket layer initialized
[    9.276162] iTCO_vendor_support: vendor-support=0
[    9.286595] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    9.287731] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[    9.294755] usbcore: registered new interface driver btusb
[    9.339751] usb 2-1.8.1.1: USB disconnect, device number 7
[    9.352359] uvcvideo: Found UVC 1.00 device FaceTime HD Camera (Built-in) (05ac:8510)
[    9.364068] input: FaceTime HD Camera (Built-in) as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input10
[    9.391651] Adding 10190844k swap on /dev/sda6.  Priority:-1 extents:1 across:10190844k SSFS
[    9.422178] cfg80211: Calling CRDA to update world regulatory domain
[    9.425715] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    9.427286] cfg80211: World regulatory domain updated:
[    9.427286] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    9.427288] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.427289] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.427290] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    9.427291] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.427292] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.436486] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[    9.465872] usbcore: registered new interface driver uvcvideo
[    9.467080] USB Video Class driver (1.1.1)
[    9.474489] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=1 (0xb/0x0/0x0/0x0/0x0) type:speaker
[    9.474493] ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    9.474495] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=1 (0x9/0x0/0x0/0x0/0x0)
[    9.474496] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
[    9.474497] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
[    9.474499] ALSA sound/pci/hda/hda_auto_parser.c:410      Mic=0xd
[    9.481658] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    9.482943] SELinux: initialized (dev sda5, type ext4), uses xattr
[    9.490904] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[    9.491093] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    9.491199] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    9.491269] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    9.491335] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    9.496184] SELinux: initialized (dev sda7, type ext4), uses xattr
[    9.584445] usb 2-1.8.1.2: USB disconnect, device number 8
[    9.628454] SELinux: initialized (dev sda4, type hfsplus), uses genfs_contexts
[    9.654581] type=1305 audit(1376337702.467:3): audit_pid=364 old=0 auid=4294967295 ses=4294967295
 subj=system_u:system_r:auditd_t:s0 res=1
[    9.803255] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
[    9.829096] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    9.836347] systemd-logind[401]: Watching system buttons on /dev/input/event3 (Power Button)
[    9.836423] systemd-logind[401]: Watching system buttons on /dev/input/event7 (Video Bus)
[    9.836488] systemd-logind[401]: Watching system buttons on /dev/input/event1 (Power Button)
[    9.836582] systemd-logind[401]: Watching system buttons on /dev/input/event0 (Lid Switch)
[    9.836675] systemd-logind[401]: Watching system buttons on /dev/input/event2 (Sleep Button)
[    9.861578] cfg80211: Calling CRDA for country: DE
[    9.861609] systemd-udevd[259]: renamed network interface wlan0 to wlp2s0
[    9.865372] cfg80211: Regulatory domain changed to country: DE
[    9.866027] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    9.866710] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    9.867395] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    9.868048] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    9.868714] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[    9.869355] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
[    9.941044] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    9.974753] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   10.030316] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   10.031351] Bluetooth: BNEP filters: protocol multicast
[   10.032384] Bluetooth: BNEP socket layer initialized
[   10.108081] Bluetooth: RFCOMM TTY layer initialized
[   10.109120] Bluetooth: RFCOMM socket layer initialized
[   10.110107] Bluetooth: RFCOMM ver 1.11
[   10.149938] Netfilter messages via NETLINK v0.30.
[   10.283807] nfnl_acct: registering with nfnetlink.
[   10.284975] netlink: 20 bytes leftover after parsing attributes.
[   10.310702] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   10.310716] brcmsmac bcma0:0: brcms_ops_config: change power-save mode: false (implement)
[   10.312867] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[   14.607019] wlp2s0: authenticate with 24:65:11:b9:d8:b1
[   14.618187] wlp2s0: send auth to 24:65:11:b9:d8:b1 (try 1/3)
[   14.620147] wlp2s0: authenticated
[   14.620984] wlp2s0: associate with 24:65:11:b9:d8:b1 (try 1/3)
[   14.623476] wlp2s0: RX AssocResp from 24:65:11:b9:d8:b1 (capab=0x431 status=0 aid=2)
[   14.624001] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[   14.624004] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   14.624013] wlp2s0: associated
[   14.624023] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
[   15.668236] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[   20.047431] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[   20.047435] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   20.052604] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[   20.052608] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   20.060881] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[   20.060885] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   55.693944] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[   55.693973] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   65.045849] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   65.045854] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   65.045855] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   65.045856] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   65.049597] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[   65.049606] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   67.371909] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   67.371944] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   67.375192] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   67.375202] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   68.655417] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.655422] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.655424] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   68.655426] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.656073] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[   68.656084] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   68.656123] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.656124] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.656126] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   68.656127] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.659322] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[   68.659355] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   68.659367] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.659369] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.659371] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   68.659373] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.662517] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[   68.662526] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   68.662541] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.662544] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.662547] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   68.662550] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.665234] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.665242] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.665246] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   68.665248] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.667681] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.667689] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   68.667692] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   68.667695] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.654618] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.654621] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.654623] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   69.654624] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.655034] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   69.655036] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   69.655045] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.655046] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.655048] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   69.655049] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.655626] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   69.655630] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   69.655643] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.655645] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.655646] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   69.655648] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.656640] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   69.656644] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   69.659266] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.659269] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.659270] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   69.659271] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.659709] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.659711] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   69.659712] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   69.659713] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   70.338378] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[   70.338389] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   71.100021] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   71.100030] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   71.100033] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   71.100035] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   71.100561] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[   71.100564] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   71.100577] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   71.100579] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   71.100580] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   71.100582] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   71.104846] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[   71.104849] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   71.104861] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   71.104862] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   71.104863] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   71.104864] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   71.116964] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[   71.116977] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   71.693295] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   71.693307] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   71.694194] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   71.694203] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   71.695304] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   71.695314] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   72.047690] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   72.047702] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   72.048526] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   72.048534] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   72.049094] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   72.049101] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   74.875934] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   74.875938] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   74.876634] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   74.876637] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   74.877349] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   74.877351] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   84.114683] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.114698] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.114702] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.114705] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.115295] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   84.115304] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   84.115325] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.115328] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.115331] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.115333] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.115947] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   84.115954] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   84.115975] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.115977] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.115980] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.115983] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.116664] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   84.116667] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   84.116676] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.116678] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.116680] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.116682] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.117187] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.117192] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.117195] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.117198] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.117714] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.117720] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.117723] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.117725] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.442483] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.442496] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.442500] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.442503] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.442900] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   84.442907] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   84.442920] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.442923] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.442926] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.442928] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.443386] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   84.443393] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   84.443406] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.443409] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.443412] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.443414] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.443933] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   84.443939] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   84.443949] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.443952] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.443955] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.443957] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.444336] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.444342] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.444345] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.444347] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.444765] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.444771] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.444773] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   84.444776] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   84.599227] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   84.599260] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   84.600908] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   84.600936] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   85.884821] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   85.884832] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   85.884834] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   85.884836] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   85.885271] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   85.885277] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   85.885290] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   85.885292] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   85.885293] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   85.885295] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   85.886779] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   85.886806] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   85.886831] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   85.886833] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   85.886835] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   85.886838] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   85.889394] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   85.889420] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   86.368373] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   86.368377] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   86.369291] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   86.369294] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   86.370567] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   86.370569] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   88.062441] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   88.062477] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   88.063571] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   88.063598] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   88.293587] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.293597] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.293599] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   88.293601] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.294023] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   88.294027] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   88.294037] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.294039] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.294040] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   88.294042] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.294470] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   88.294474] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   88.294486] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.294488] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.294489] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   88.294491] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.295081] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   88.295099] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   88.295118] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.295131] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.295133] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   88.295134] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.298015] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.298043] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.298058] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   88.298060] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   88.519081] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   88.519093] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   88.521113] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   88.521122] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   90.222368] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   90.222382] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   90.223616] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   90.223624] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   90.224150] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   90.224157] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   91.265996] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   91.266005] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   91.266007] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   91.266009] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   91.266447] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   91.266453] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   91.266465] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   91.266467] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   91.266469] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   91.266470] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   91.270901] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   91.270935] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   91.633002] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   91.633013] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   91.634597] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   91.634604] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   91.972511] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   91.972520] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   91.973208] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   91.973236] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   91.976329] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   91.976362] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   92.622446] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[   92.622458] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   92.626425] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[   92.626434] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   92.630246] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[   92.630255] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   94.300194] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   94.300212] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   94.300215] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   94.300217] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   94.300892] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   94.300921] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   94.300934] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   94.300936] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   94.300938] brcmsmac bcma0:0: wl0: invalid mcs: 110
[   94.300940] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[   94.301660] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[   94.301688] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   94.589704] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[   94.589709] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   94.675435] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   94.675444] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   94.675994] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   94.675999] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   94.676863] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[   94.676868] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[   98.222237] brcmsmac bcma0:0: phyerr 0x10, rate 0xa0a
[   98.222251] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   98.227080] brcmsmac bcma0:0: phyerr 0x10, rate 0xa0a
[   98.227087] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[   98.234612] brcmsmac bcma0:0: phyerr 0x10, rate 0xa0a
[   98.234620] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[  100.252756] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.252765] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.252767] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  100.252769] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.253161] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  100.253165] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  100.253177] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.253179] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.253181] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  100.253182] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.253746] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  100.253750] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  100.253762] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.253764] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.253765] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  100.253767] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.254306] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  100.254310] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  100.254317] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.254318] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.254320] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  100.254322] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.254919] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.254921] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.254922] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  100.254923] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.255406] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.255407] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  100.255409] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  100.255410] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  105.862454] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  105.862458] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  105.863614] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  105.863616] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  105.864632] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  105.864635] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  113.664396] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.664400] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.664401] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  113.664402] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.664953] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[  113.664955] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[  113.664964] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.664965] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.664966] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  113.664967] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.667733] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[  113.667769] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[  113.667781] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.667783] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.667785] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  113.667787] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.674128] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e6e
[  113.674161] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[  113.674187] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.674190] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.674192] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  113.674194] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.679303] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.679327] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.679330] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  113.679332] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.680555] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.680580] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  113.680582] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  113.680584] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  120.544498] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  120.544527] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  120.545461] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  120.545488] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  120.546547] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  120.546564] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  169.922332] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  169.922367] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  169.923230] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  169.923263] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  170.500260] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.500273] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.500277] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  170.500279] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.500717] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  170.500727] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  170.500738] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.500740] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.500742] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  170.500744] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.501449] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  170.501452] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  170.501462] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.501463] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.501464] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  170.501465] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.501936] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  170.501938] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  170.501946] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.501947] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  170.501948] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  170.501949] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  171.469294] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  171.469334] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  171.470312] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  171.470345] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  171.471546] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  171.471579] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  172.028852] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.028865] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.028869] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  172.028871] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.029332] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  172.029338] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  172.029350] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.029353] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.029356] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  172.029358] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.029842] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  172.029848] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  172.029861] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.029864] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.029866] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  172.029869] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.030960] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  172.030968] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  172.030981] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.030984] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  172.030987] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  172.030990] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  173.924741] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  173.924746] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  173.925318] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  173.925324] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  173.925957] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  173.925984] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  174.915637] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  174.915648] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  174.915652] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  174.915654] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  174.916232] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  174.916239] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  174.916252] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  174.916255] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  174.916258] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  174.916261] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  174.918468] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  174.918475] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  175.695446] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  175.695459] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  175.702047] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  175.702071] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  178.334594] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[  178.334625] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[  178.337995] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[  178.338026] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[  178.342781] brcmsmac bcma0:0: phyerr 0x10, rate 0x1414
[  178.342809] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[  181.591018] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  181.591031] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  184.286560] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  184.286579] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  184.286585] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  184.286589] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  184.306942] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  184.306956] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  188.757767] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  188.757777] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  188.759566] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  188.759599] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  189.083797] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  189.083809] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  189.088675] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  189.088683] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  189.784658] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  189.784673] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  189.784677] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  189.784682] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  189.785097] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  189.785104] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  189.785119] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  189.785121] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  189.785124] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  189.785126] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  189.785999] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  189.786007] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  189.786021] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  189.786025] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  189.786027] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  189.786030] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  189.787000] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  189.787003] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  197.362481] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  197.362508] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  197.366589] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  197.366600] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  197.835236] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  197.835250] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  197.840771] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  197.840781] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  198.339768] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  198.339782] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  198.339785] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  198.339787] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  198.340187] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  198.340193] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  198.340206] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  198.340208] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  198.340210] brcmsmac bcma0:0: wl0: invalid mcs: 110
[  198.340213] brcmsmac bcma0:0: wl0: WAR: using rate of 1 mbps
[  198.342052] brcmsmac bcma0:0: phyerr 0x1, rate 0x6e6e
[  198.342063] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  199.067537] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  199.067547] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  199.069192] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  199.069227] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  199.070524] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  199.070558] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  199.859393] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  199.859405] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  199.862268] brcmsmac bcma0:0: phyerr 0x1, rate 0xa0a
[  199.862278] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  458.912193] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  458.912221] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  458.913029] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  458.913054] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  458.913887] brcmsmac bcma0:0: phyerr 0x1, rate 0x1414
[  458.913919] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)

--------------020604090007000001030203--
