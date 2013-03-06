Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3CFRvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:51:37 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:52423 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab3CFRve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:51:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130306100743.GA407@polaris.bitmath.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
	<20130306080642.GA535@polaris.bitmath.org>
	<51370990.5040508@linux.intel.com>
	<20130306100743.GA407@polaris.bitmath.org>
Date: Wed, 6 Mar 2013 09:51:34 -0800
X-Google-Sender-Auth: f2GQ2K3nJtblwgVhOk_BYvx-RXo
Message-ID: <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
Subject: Re: Linux 3.9-rc1
From: Yinghai Lu <yinghai@kernel.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 2:07 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> Can you get a boot log with "debug memblock=debug" from the last
>> successful commit point?  Are you booting EFI or BootCamp?
>
> Attached the dmesg log, booting from f763ad1 which is on top of
> 3.7-rc6. I am booting with EFI_STUB, straight into the kernel.
> The command line and modules are built in.

will check that EFI_STUB path.

Can you check bootloader like grub.efi ?


> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.7.0-rc6+ (rydberg@polaris) (gcc version 4.7.2 (GCC) ) #1 SMP PREEMPT Wed Mar 6 10:52:49 CET 2013
> [    0.000000] Command line:
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006effffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000006f000000-0x000000007effffff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007f000000-0x000000007f718fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007f719000-0x000000007f938fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007f939000-0x000000007f953fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007f954000-0x000000007f96afff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000007f96b000-0x000000007f96efff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007f96f000-0x000000007f99afff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007f99b000-0x000000007f9b1fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007f9b2000-0x000000007f9dafff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007f9db000-0x000000007fef8fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007fef9000-0x000000007fefffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000093200000-0x0000000093200fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] efi: EFI v1.10 by Apple
> [    0.000000] efi:  ACPI=0x7f96a000  ACPI 2.0=0x7f96a014  SMBIOS=0x7f71a000
> [    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000008f000) (0MB)
> [    0.000000] efi: mem01: type=10, attr=0xf, range=[0x000000000008f000-0x0000000000090000) (0MB)
> [    0.000000] efi: mem02: type=2, attr=0xf, range=[0x0000000000090000-0x0000000000096000) (0MB)
> [    0.000000] efi: mem03: type=7, attr=0xf, range=[0x0000000000096000-0x00000000000a0000) (0MB)
> [    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
> [    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001db0000) (13MB)
> [    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000001db0000-0x000000006d0d6000) (1715MB)
> [    0.000000] efi: mem07: type=1, attr=0xf, range=[0x000000006d0d6000-0x000000006d546000) (4MB)
> [    0.000000] efi: mem08: type=7, attr=0xf, range=[0x000000006d546000-0x000000006d9b6000) (4MB)
> [    0.000000] efi: mem09: type=4, attr=0xf, range=[0x000000006d9b6000-0x000000006e615000) (12MB)
> [    0.000000] efi: mem10: type=7, attr=0xf, range=[0x000000006e615000-0x000000006e616000) (0MB)
> [    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000006e616000-0x000000006e7ac000) (1MB)
> [    0.000000] efi: mem12: type=7, attr=0xf, range=[0x000000006e7ac000-0x000000006ea6e000) (2MB)
> [    0.000000] efi: mem13: type=2, attr=0xf, range=[0x000000006ea6e000-0x000000006ea6f000) (0MB)
> [    0.000000] efi: mem14: type=4, attr=0xf, range=[0x000000006ea6f000-0x000000006f000000) (5MB)
> [    0.000000] efi: mem15: type=4, attr=0xf, range=[0x000000007f000000-0x000000007f6af000) (6MB)
> [    0.000000] efi: mem16: type=7, attr=0xf, range=[0x000000007f6af000-0x000000007f719000) (0MB)
> [    0.000000] efi: mem17: type=10, attr=0xf, range=[0x000000007f719000-0x000000007f939000) (2MB)
> [    0.000000] efi: mem18: type=7, attr=0xf, range=[0x000000007f939000-0x000000007f954000) (0MB)
> [    0.000000] efi: mem19: type=9, attr=0xf, range=[0x000000007f954000-0x000000007f96b000) (0MB)
> [    0.000000] efi: mem20: type=7, attr=0xf, range=[0x000000007f96b000-0x000000007f96f000) (0MB)
> [    0.000000] efi: mem21: type=6, attr=0x800000000000000f, range=[0x000000007f96f000-0x000000007f99b000) (0MB)
> [    0.000000] efi: mem22: type=7, attr=0xf, range=[0x000000007f99b000-0x000000007f9b2000) (0MB)
> [    0.000000] efi: mem23: type=5, attr=0x800000000000000f, range=[0x000000007f9b2000-0x000000007f9db000) (0MB)
> [    0.000000] efi: mem24: type=7, attr=0xf, range=[0x000000007f9db000-0x000000007fc2c000) (2MB)
> [    0.000000] efi: mem25: type=3, attr=0xf, range=[0x000000007fc2c000-0x000000007fd5f000) (1MB)
> [    0.000000] efi: mem26: type=7, attr=0xf, range=[0x000000007fd5f000-0x000000007fef9000) (1MB)
> [    0.000000] efi: mem27: type=0, attr=0xf, range=[0x000000007fef9000-0x000000007feff000) (0MB)
> [    0.000000] efi: mem28: type=6, attr=0x800000000000000f, range=[0x000000007feff000-0x000000007ff00000) (0MB)
> [    0.000000] efi: mem29: type=0, attr=0x8000000000000000, range=[0x000000006f000000-0x000000007f000000) (256MB)
> [    0.000000] efi: mem30: type=11, attr=0x8000000000000000, range=[0x0000000093200000-0x0000000093201000) (0MB)
> [    0.000000] efi: mem31: type=11, attr=0x8000000000000000, range=[0x00000000ffc00000-0x00000000ffc80000) (0MB)
> [    0.000000] efi: mem32: type=11, attr=0x8000000000000000, range=[0x00000000ffc80000-0x00000000ffca8000) (0MB)
> [    0.000000] efi: mem33: type=11, attr=0x8000000000000000, range=[0x00000000ffca8000-0x00000000ffcca000) (0MB)
> [    0.000000] efi: mem34: type=11, attr=0x8000000000000000, range=[0x00000000ffcca000-0x00000000ffffc000) (3MB)
> [    0.000000] efi: mem35: type=11, attr=0x8000000000000000, range=[0x00000000ffffc000-0x0000000100000000) (0MB)
> [    0.000000] DMI 2.4 present.
> [    0.000000] DMI: Apple Inc. MacBookAir3,1/Mac-942452F5819B1C1B, BIOS    MBA31.88Z.0061.B00.1009101530 09/10/10
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x7fef9 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 080000000 mask F80000000 uncachable
> [    0.000000]   1 base 07FF00000 mask FFFF00000 uncachable
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] memblock_reserve: [0x000000029fa000-0x000000029fa219] setup_arch+0x62b/0x7e9
> [    0.000000] MEMBLOCK configuration:
> [    0.000000]  memory size = 0x6fbfc000 reserved size = 0xa5b8d9
> [    0.000000]  memory.cnt  = 0x8
> [    0.000000]  memory[0x0]     [0x00000000010000-0x0000000008efff], 0x7f000 bytes
> [    0.000000]  memory[0x1]     [0x00000000090000-0x0000000009ffff], 0x10000 bytes
> [    0.000000]  memory[0x2]     [0x00000000100000-0x0000006effffff], 0x6ef00000 bytes
> [    0.000000]  memory[0x3]     [0x0000007f000000-0x0000007f718fff], 0x719000 bytes
> [    0.000000]  memory[0x4]     [0x0000007f939000-0x0000007f953fff], 0x1b000 bytes
> [    0.000000]  memory[0x5]     [0x0000007f96b000-0x0000007f96efff], 0x4000 bytes
> [    0.000000]  memory[0x6]     [0x0000007f99b000-0x0000007f9b1fff], 0x17000 bytes
> [    0.000000]  memory[0x7]     [0x0000007f9db000-0x0000007fef8fff], 0x51e000 bytes
> [    0.000000]  reserved.cnt  = 0x3
> [    0.000000]  reserved[0x0]   [0x00000000095000-0x000000000956bf], 0x6c0 bytes
> [    0.000000]  reserved[0x1]   [0x0000000009f000-0x000000000fffff], 0x61000 bytes
> [    0.000000]  reserved[0x2]   [0x00000002000000-0x000000029fa218], 0x9fa219 bytes
> [    0.000000] memblock_reserve: [0x0000006d9b6000-0x0000006e615000] efi_reserve_boot_services+0xb4/0xd0
> [    0.000000] memblock_reserve: [0x0000006e616000-0x0000006e7ac000] efi_reserve_boot_services+0xb4/0xd0
> [    0.000000] memblock_reserve: [0x0000006ea6f000-0x0000006f000000] efi_reserve_boot_services+0xb4/0xd0
> [    0.000000] memblock_reserve: [0x0000007f000000-0x0000007f6af000] efi_reserve_boot_services+0xb4/0xd0
> [    0.000000] memblock_reserve: [0x0000007fc2c000-0x0000007fd5f000] efi_reserve_boot_services+0xb4/0xd0
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] memblock_reserve: [0x00000000099000-0x0000000009f000] setup_real_mode+0x62/0x17b
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x6effffff] page 2M
> [    0.000000]  [mem 0x7f000000-0x7f5fffff] page 2M
> [    0.000000]  [mem 0x7f600000-0x7f718fff] page 4k
> [    0.000000]  [mem 0x7f939000-0x7f953fff] page 4k
> [    0.000000]  [mem 0x7f96b000-0x7f96efff] page 4k
> [    0.000000]  [mem 0x7f99b000-0x7f9b1fff] page 4k
> [    0.000000]  [mem 0x7f9db000-0x7f9fffff] page 4k
> [    0.000000]  [mem 0x7fa00000-0x7fdfffff] page 2M
> [    0.000000]  [mem 0x7fe00000-0x7fef8fff] page 4k
> [    0.000000] kernel direct mapping tables up to 0x7fef8fff @ [mem 0x7fee3000-0x7fef8fff] prealloc
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x6effffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x6effffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x7f000000-0x7f718fff]
> [    0.000000]  [mem 0x7f000000-0x7f5fffff] page 2M
> [    0.000000]  [mem 0x7f600000-0x7f718fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x7f939000-0x7f953fff]
> [    0.000000]  [mem 0x7f939000-0x7f953fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x7f96b000-0x7f96efff]
> [    0.000000]  [mem 0x7f96b000-0x7f96efff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x7f99b000-0x7f9b1fff]
> [    0.000000]  [mem 0x7f99b000-0x7f9b1fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x7f9db000-0x7fef8fff]
> [    0.000000]  [mem 0x7f9db000-0x7f9fffff] page 4k
> [    0.000000]  [mem 0x7fa00000-0x7fdfffff] page 2M
> [    0.000000]  [mem 0x7fe00000-0x7fef8fff] page 4k
> [    0.000000] kernel direct mapping tables up to 0x7fef8fff @ [mem 0x7fee3000-0x7fee7fff] final
> [    0.000000] memblock_reserve: [0x0000007fee3000-0x0000007fee8000] init_mem_mapping+0x296/0x2b0

The code should handle this memory layout without problem.

Thanks

Yinghai
