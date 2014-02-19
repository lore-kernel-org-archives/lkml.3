Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaBSMvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:51:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:65276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaBSMvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:51:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="scan'208";a="477631469"
Date: Wed, 19 Feb 2014 20:51:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [workqueue] BUG: unable to handle kernel paging request at
 ffff880000798f60
Message-ID: <20140219125114.GA8210@localhost>
References: <20140219124122.GH7735@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20140219124122.GH7735@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Peter,

Attached are several more dmesgs that show different call traces.

Thanks,
Fengguang

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-xian-64:20140212205052:x86_64-randconfig-c4-0212:3.14.0-rc1-00001-g8460434:27"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00001-g8460434 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #27 SMP Wed Feb 12 20:27:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036e86e85c=
4055a1c7ea5529-20140212202932-1-xian branch=3Dwq/for-3.14-fixes BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea55=
29/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03191000, 0x03191fff] PGTABLE
[    0.000000] BRK [0x03192000, 0x03192fff] PGTABLE
[    0.000000] BRK [0x03193000, 0x03193fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x03194000, 0x03194fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x03195000, 0x03195fff] PGTABLE
[    0.000000] BRK [0x03196000, 0x03196fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffa000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ee0000=
0-ffff88000f1fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff88000f600000 s1914960 r0=
 d22448 u2097152
[    0.000000] pcpu-alloc: s1914960 r0 d22448 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f60cb80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036=
e86e85c4055a1c7ea5529-20140212202932-1-xian branch=3Dwq/for-3.14-fixes BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1=
c7ea5529/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 215372K/261744K available (9482K kernel code, 5601K =
rwdata, 5956K rodata, 2816K init, 9544K bss, 46372K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00001-g8460434 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #27 SMP Wed Feb 12 20:27:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036e86e85c=
4055a1c7ea5529-20140212202932-1-xian branch=3Dwq/for-3.14-fixes BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea55=
29/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03191000, 0x03191fff] PGTABLE
[    0.000000] BRK [0x03192000, 0x03192fff] PGTABLE
[    0.000000] BRK [0x03193000, 0x03193fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x03194000, 0x03194fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x03195000, 0x03195fff] PGTABLE
[    0.000000] BRK [0x03196000, 0x03196fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffa000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ee0000=
0-ffff88000f1fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff88000f600000 s1914960 r0=
 d22448 u2097152
[    0.000000] pcpu-alloc: s1914960 r0 d22448 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f60cb80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036=
e86e85c4055a1c7ea5529-20140212202932-1-xian branch=3Dwq/for-3.14-fixes BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1=
c7ea5529/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 215372K/261744K available (9482K kernel code, 5601K =
rwdata, 5956K rodata, 2816K init, 9544K bss, 46372K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.048 MHz processor
[    0.000000] tsc: Detected 2893.048 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 5786.09 Bogo=
MIPS (lpj=3D2893048)
5786.09 BogoMIPS (lpj=3D2893048)
[    0.004014] pid_max: default: 32768 minimum: 301
[    0.004014] pid_max: default: 32768 minimum: 301
[    0.006743] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.006743] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.007804] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.007804] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.008602] Mount-cache hash table entries: 256
[    0.008602] Mount-cache hash table entries: 256
[    0.010392] Initializing cgroup subsys devices
[    0.010392] Initializing cgroup subsys devices
[    0.011070] Initializing cgroup subsys net_cls
[    0.011070] Initializing cgroup subsys net_cls
[    0.012051] Initializing cgroup subsys perf_event
[    0.012051] Initializing cgroup subsys perf_event
[    0.013351] numa_add_cpu cpu 0 node 0: mask now 0
[    0.013351] numa_add_cpu cpu 0 node 0: mask now 0
[    0.014023] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014023] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.014023] tlb_flushall_shift: 6
[    0.014023] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014023] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.014023] tlb_flushall_shift: 6
[    0.015096] debug: unmapping init [mem 0xffffffff8283a000-0xffffffff8283=
efff]
[    0.015096] debug: unmapping init [mem 0xffffffff8283a000-0xffffffff8283=
efff]
[    0.023057] Getting VERSION: 50014
[    0.023057] Getting VERSION: 50014
[    0.023954] Getting VERSION: 50014
[    0.023954] Getting VERSION: 50014
[    0.024022] Getting ID: 0
[    0.024022] Getting ID: 0
[    0.025018] Getting ID: ff000000
[    0.025018] Getting ID: ff000000
[    0.026023] Getting LVT0: 8700
[    0.026023] Getting LVT0: 8700
[    0.027017] Getting LVT1: 8400
[    0.027017] Getting LVT1: 8400
[    0.028092] enabled ExtINT on CPU#0
[    0.028092] enabled ExtINT on CPU#0
[    0.030652] ENABLING IO-APIC IRQs
[    0.030652] ENABLING IO-APIC IRQs
[    0.031015] init IO_APIC IRQs
[    0.031015] init IO_APIC IRQs
[    0.032010]  apic 0 pin 0 not connected
[    0.032010]  apic 0 pin 0 not connected
[    0.032831] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.032831] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.034078] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.034078] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.035036] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.035036] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.036033] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.036033] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.037032] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.037032] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.038031] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.038031] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.039033] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.039033] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.040035] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.040035] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.041030] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.041030] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.042030] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.042030] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.043030] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.043030] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.044036] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.044036] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.045035] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.045035] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.046030] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.046030] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.047029] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.047029] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.048023]  apic 0 pin 16 not connected
[    0.048023]  apic 0 pin 16 not connected
[    0.048795]  apic 0 pin 17 not connected
[    0.048795]  apic 0 pin 17 not connected
[    0.049007]  apic 0 pin 18 not connected
[    0.049007]  apic 0 pin 18 not connected
[    0.050007]  apic 0 pin 19 not connected
[    0.050007]  apic 0 pin 19 not connected
[    0.051006]  apic 0 pin 20 not connected
[    0.051006]  apic 0 pin 20 not connected
[    0.052006]  apic 0 pin 21 not connected
[    0.052006]  apic 0 pin 21 not connected
[    0.052779]  apic 0 pin 22 not connected
[    0.052779]  apic 0 pin 22 not connected
[    0.053006]  apic 0 pin 23 not connected
[    0.053006]  apic 0 pin 23 not connected
[    0.054156] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.054156] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.055007] smpboot: CPU0:=20
[    0.055007] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.057006] Using local APIC timer interrupts.
[    0.057006] calibrating APIC timer ...
[    0.057006] Using local APIC timer interrupts.
[    0.057006] calibrating APIC timer ...
[    0.059000] ... lapic delta =3D 6253628
[    0.059000] ... lapic delta =3D 6253628
[    0.059000] ... PM-Timer delta =3D 358188
[    0.059000] ... PM-Timer delta =3D 358188
[    0.059000] ... PM-Timer result ok
[    0.059000] ... PM-Timer result ok
[    0.059000] ..... delta 6253628
[    0.059000] ..... delta 6253628
[    0.059000] ..... mult: 268591277
[    0.059000] ..... mult: 268591277
[    0.059000] ..... calibration result: 1000580
[    0.059000] ..... calibration result: 1000580
[    0.059000] ..... CPU clock speed is 2894.0678 MHz.
[    0.059000] ..... CPU clock speed is 2894.0678 MHz.
[    0.059000] ..... host bus clock speed is 1000.0580 MHz.
[    0.059000] ..... host bus clock speed is 1000.0580 MHz.
[    0.059122] Performance Events:=20
[    0.059122] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.064979] ftrace: Allocated trace_printk buffers
[    0.064979] ftrace: Allocated trace_printk buffers
[    0.089897] x86: Booting SMP configuration:
[    0.089897] x86: Booting SMP configuration:
[    0.090011] .... node  #0, CPUs: =20
[    0.090011] .... node  #0, CPUs:         #1 #1
[    0.076500] kvm-clock: cpu 1, msr 0:fff9041, secondary cpu clock
[    0.076500] masked ExtINT on CPU#1
[    0.076500] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.105256] KVM setup async PF for cpu 1
[    0.105256] KVM setup async PF for cpu 1
[    0.105367] x86: Booted up 1 node, 2 CPUs
[    0.105367] x86: Booted up 1 node, 2 CPUs
[    0.105378] ----------------
[    0.105378] ----------------
[    0.105379] | NMI testsuite:
[    0.105379] | NMI testsuite:
[    0.105380] --------------------
[    0.105380] --------------------
[    0.106000]   remote IPI:
[    0.106000]   remote IPI:
[    0.106000] kvm-stealtime: cpu 1, msr f80cb80
[    0.106000] kvm-stealtime: cpu 1, msr f80cb80
[    0.114665]   ok  |
[    0.114665]   ok  |

[    0.115082]    local IPI:
[    0.115082]    local IPI:  ok  |  ok  |

[    0.118648] --------------------
[    0.118648] --------------------
[    0.119010] Good, all   2 testcases passed! |
[    0.119010] Good, all   2 testcases passed! |
[    0.120009] ---------------------------------
[    0.120009] ---------------------------------
[    0.121009] smpboot: Total of 2 processors activated (11572.19 BogoMIPS)
[    0.121009] smpboot: Total of 2 processors activated (11572.19 BogoMIPS)
[    0.125377] devtmpfs: initialized
[    0.125377] devtmpfs: initialized
[    0.134259] prandom: seed boundary self test passed
[    0.134259] prandom: seed boundary self test passed
[    0.136497] prandom: 100 self tests passed
[    0.136497] prandom: 100 self tests passed
[    0.137014] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.137014] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.139814] regulator-dummy: no parameters
[    0.139814] regulator-dummy: no parameters
[    0.142245] NET: Registered protocol family 16
[    0.142245] NET: Registered protocol family 16
[    0.145382] cpuidle: using governor menu
[    0.145382] cpuidle: using governor menu
[    0.147196] ACPI: bus type PCI registered
[    0.147196] ACPI: bus type PCI registered
[    0.148351] PCI: Using configuration type 1 for base access
[    0.148351] PCI: Using configuration type 1 for base access
[    0.152587] ACPI: Added _OSI(Module Device)
[    0.152587] ACPI: Added _OSI(Module Device)
[    0.153010] ACPI: Added _OSI(Processor Device)
[    0.153010] ACPI: Added _OSI(Processor Device)
[    0.154011] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.154011] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.155010] ACPI: Added _OSI(Processor Aggregator Device)
[    0.155010] ACPI: Added _OSI(Processor Aggregator Device)
[    0.191859] ACPI: Interpreter enabled
[    0.191859] ACPI: Interpreter enabled
[    0.192013] ACPI Exception: AE_NOT_FOUND,=20
[    0.192013] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.195022] ACPI Exception: AE_NOT_FOUND,=20
[    0.195022] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.197100] ACPI: (supports S0 S3 S5)
[    0.197100] ACPI: (supports S0 S3 S5)
[    0.198008] ACPI: Using IOAPIC for interrupt routing
[    0.198008] ACPI: Using IOAPIC for interrupt routing
[    0.199104] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.199104] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.234396] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.234396] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.235026] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.235026] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.236105] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.236105] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.239607] PCI host bridge to bus 0000:00
[    0.239607] PCI host bridge to bus 0000:00
[    0.240025] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.240025] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.241014] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.241014] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.242015] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.242015] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.243021] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.243021] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.244013] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.244013] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.245134] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.245134] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.247944] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.247944] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.249962] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.249962] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.253970] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.253970] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.256732] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.256732] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.257597] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.257597] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.258028] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.258028] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.260732] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.260732] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.263076] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.263076] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.266067] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.266067] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.276899] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.276899] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.279244] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.279244] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.282012] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.282012] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.284020] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.284020] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.292016] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.292016] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.293824] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.293824] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.296018] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.296018] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.298017] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.298017] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.306915] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.306915] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.308011] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.308011] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.310507] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.310507] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.317680] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.317680] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.319531] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.319531] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.321011] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.321011] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.329909] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.329909] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.331678] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.331678] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.334018] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.334018] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.343308] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.343308] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.345721] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.345721] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.348016] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.348016] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.357622] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.357622] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.360017] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.360017] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.362017] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.362017] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.372086] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.372086] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.375025] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.375025] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.385628] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.385628] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.387534] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.387534] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.390282] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.390282] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.393029] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.393029] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.395217] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.395217] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.400355] ACPI:=20
[    0.400355] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.404557] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.404557] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.406022] vgaarb: loaded
[    0.406022] vgaarb: loaded
[    0.407009] vgaarb: bridge control possible 0000:00:02.0
[    0.407009] vgaarb: bridge control possible 0000:00:02.0
[    0.410354] pps_core: LinuxPPS API ver. 1 registered
[    0.410354] pps_core: LinuxPPS API ver. 1 registered
[    0.412009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.412009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.414092] PTP clock support registered
[    0.414092] PTP clock support registered
[    0.415216] EDAC MC: Ver: 3.0.0
[    0.415216] EDAC MC: Ver: 3.0.0
[    0.418489] Advanced Linux Sound Architecture Driver Initialized.
[    0.418489] Advanced Linux Sound Architecture Driver Initialized.
[    0.420017] PCI: Using ACPI for IRQ routing
[    0.420017] PCI: Using ACPI for IRQ routing
[    0.421015] PCI: pci_cache_line_size set to 64 bytes
[    0.421015] PCI: pci_cache_line_size set to 64 bytes
[    0.423351] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.423351] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.425028] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.425028] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.427204] NET: Registered protocol family 8
[    0.427204] NET: Registered protocol family 8
[    0.428010] NET: Registered protocol family 20
[    0.428010] NET: Registered protocol family 20
[    0.429284] nfc: nfc_init: NFC Core ver 0.1
[    0.429284] nfc: nfc_init: NFC Core ver 0.1
[    0.431184] NET: Registered protocol family 39
[    0.431184] NET: Registered protocol family 39
[    0.433513] Switched to clocksource kvm-clock
[    0.433513] Switched to clocksource kvm-clock
[    0.439439] Warning: could not register all branches stats
[    0.439439] Warning: could not register all branches stats
[    0.441389] Warning: could not register annotated branches stats
[    0.441389] Warning: could not register annotated branches stats
[    0.562675] FS-Cache: Loaded
[    0.562675] FS-Cache: Loaded
[    0.563931] pnp: PnP ACPI init
[    0.563931] pnp: PnP ACPI init
[    0.564837] ACPI: bus type PNP registered
[    0.564837] ACPI: bus type PNP registered
[    0.566331] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.566331] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.568744] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.568744] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.570833] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.570833] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.573107] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.573107] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.575074] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.575074] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.577338] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.577338] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.579519] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.579519] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.581720] pnp 00:03: [dma 2]
[    0.581720] pnp 00:03: [dma 2]
[    0.582645] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.582645] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.584700] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.584700] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.586936] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.586936] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.589003] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.589003] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.591258] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.591258] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.594655] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.594655] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.597728] pnp: PnP ACPI: found 7 devices
[    0.597728] pnp: PnP ACPI: found 7 devices
[    0.598904] ACPI: bus type PNP unregistered
[    0.598904] ACPI: bus type PNP unregistered
[    0.607233] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.607233] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.608755] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.608755] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.610260] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.610260] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.611952] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.611952] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.614672] NET: Registered protocol family 2
[    0.614672] NET: Registered protocol family 2
[    0.618482] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.618482] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.620757] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.620757] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.622940] TCP: Hash tables configured (established 2048 bind 2048)
[    0.622940] TCP: Hash tables configured (established 2048 bind 2048)
[    0.625590] TCP: reno registered
[    0.625590] TCP: reno registered
[    0.626584] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.626584] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.628331] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.628331] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.630893] NET: Registered protocol family 1
[    0.630893] NET: Registered protocol family 1
[    0.632135] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.632135] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.633782] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.633782] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.635404] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.635404] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.637127] pci 0000:00:02.0: Boot video device
[    0.637127] pci 0000:00:02.0: Boot video device
[    0.638523] PCI: CLS 0 bytes, default 64
[    0.638523] PCI: CLS 0 bytes, default 64
[    0.640867] Unpacking initramfs...
[    0.640867] Unpacking initramfs...
[    0.879782] debug: unmapping init [mem 0xffff88000fce6000-0xffff88000ffe=
ffff]
[    0.879782] debug: unmapping init [mem 0xffff88000fce6000-0xffff88000ffe=
ffff]
[    0.881617] has_svm: not amd
[    0.881617] has_svm: not amd
[    0.882207] kvm: no hardware support
[    0.882207] kvm: no hardware support
[    0.883237] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.883237] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.884404] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.884404] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.886367] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.886367] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.891175] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.891175] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.893787] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.893787] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.897351] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.897351] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.904990] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.904990] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.909608] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.909608] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.913917] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.913917] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.916321] AVX or AES-NI instructions are not detected.
[    0.916321] AVX or AES-NI instructions are not detected.
[    0.918266] AVX instructions are not detected.
[    0.918266] AVX instructions are not detected.
[    0.920123] AVX instructions are not detected.
[    0.920123] AVX instructions are not detected.
[    0.921947] AVX instructions are not detected.
[    0.921947] AVX instructions are not detected.
[    0.923632] AVX2 instructions are not detected.
[    0.923632] AVX2 instructions are not detected.
[    0.929486] Initializing RT-Tester: OK
[    0.929486] Initializing RT-Tester: OK
[    0.931247] futex hash table entries: 512 (order: 4, 65536 bytes)
[    0.931247] futex hash table entries: 512 (order: 4, 65536 bytes)
[    0.949969] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.949969] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.954440] fuse init (API version 7.22)
[    0.954440] fuse init (API version 7.22)
[    1.369819] alg: No test for crc32 (crc32-table)
[    1.369819] alg: No test for crc32 (crc32-table)
[    1.372985] alg: No test for lz4 (lz4-generic)
[    1.372985] alg: No test for lz4 (lz4-generic)
[    1.376178] alg: No test for stdrng (krng)
[    1.376178] alg: No test for stdrng (krng)
[    1.414408] NET: Registered protocol family 38
[    1.414408] NET: Registered protocol family 38
[    1.415926] Key type asymmetric registered
[    1.415926] Key type asymmetric registered
[    1.417387] Asymmetric key parser 'x509' registered
[    1.417387] Asymmetric key parser 'x509' registered
[    1.428957] list_sort_test: start testing list_sort()
[    1.428957] list_sort_test: start testing list_sort()
[    1.434761] no IO addresses supplied
[    1.434761] no IO addresses supplied
[    1.436368] hgafb: HGA card not detected.
[    1.436368] hgafb: HGA card not detected.
[    1.438767] hgafb: probe of hgafb.0 failed with error -22
[    1.438767] hgafb: probe of hgafb.0 failed with error -22
[    1.441002] ipmi message handler version 39.2
[    1.441002] ipmi message handler version 39.2
[    1.442386] ipmi device interface
[    1.442386] ipmi device interface
[    1.443679] IPMI System Interface driver.
[    1.443679] IPMI System Interface driver.
[    1.444988] ipmi_si: Adding default-specified kcs state machine
[    1.444988] ipmi_si: Adding default-specified kcs state machine

[    1.446738] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.446738] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.450346] ipmi_si: Interface detection failed
[    1.450346] ipmi_si: Interface detection failed
[    1.884211] tsc: Refined TSC clocksource calibration: 2892.672 MHz
[    1.884211] tsc: Refined TSC clocksource calibration: 2892.672 MHz
[   10.810192] ipmi_si: Adding default-specified smic state machine
[   10.810192] ipmi_si: Adding default-specified smic state machine

[   10.812050] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   10.812050] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   10.814981] ipmi_si: Interface detection failed
[   10.814981] ipmi_si: Interface detection failed
[   10.820188] ipmi_si: Adding default-specified bt state machine
[   10.820188] ipmi_si: Adding default-specified bt state machine

[   10.821771] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   10.821771] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   10.824920] ipmi_si: Interface detection failed
[   10.824920] ipmi_si: Interface detection failed
[   10.829309] ipmi_si: Unable to find any System Interface(s)
[   10.829309] ipmi_si: Unable to find any System Interface(s)
[   10.831082] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   10.831082] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   10.832961] ACPI: Power Button [PWRF]
[   10.832961] ACPI: Power Button [PWRF]
[   10.989286] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   10.989286] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   11.026306] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   11.026306] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   11.030576] Non-volatile memory driver v1.3
[   11.030576] Non-volatile memory driver v1.3
[   11.032575] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   11.032575] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   11.034088] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   11.034088] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   11.036599] Hangcheck: Using getrawmonotonic().
[   11.036599] Hangcheck: Using getrawmonotonic().
[   11.038337] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   11.038337] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   11.040171] c2port c2port0: C2 port uc added
[   11.040171] c2port c2port0: C2 port uc added
[   11.041142] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   11.041142] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   11.043183] mic_init not running on X100 ret -19
[   11.043183] mic_init not running on X100 ret -19
[   11.045803] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   11.045803] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   11.047818] Could not find PAR responsible for SC520CDP Flash Bank #0
[   11.047818] Could not find PAR responsible for SC520CDP Flash Bank #0
[   11.049737] Trying default address 0x8400000
[   11.049737] Trying default address 0x8400000
[   11.050985] Could not find PAR responsible for SC520CDP Flash Bank #1
[   11.050985] Could not find PAR responsible for SC520CDP Flash Bank #1
[   11.052892] Trying default address 0x8c00000
[   11.052892] Trying default address 0x8c00000
[   11.054168] Could not find PAR responsible for SC520CDP DIL Flash
[   11.054168] Could not find PAR responsible for SC520CDP DIL Flash
[   11.055955] Trying default address 0x9400000
[   11.055955] Trying default address 0x9400000
[   11.057318] SC520 CDP flash device: 0x800000 at 0x8400000
[   11.057318] SC520 CDP flash device: 0x800000 at 0x8400000
[   11.058899] Failed to ioremap_nocache
[   11.058899] Failed to ioremap_nocache
[   11.060036] Failed to ioremap_nocache
[   11.060036] Failed to ioremap_nocache
[   11.061327] slram: not enough parameters.
[   11.061327] slram: not enough parameters.
[   11.077950] No valid DiskOnChip devices found
[   11.077950] No valid DiskOnChip devices found
[   11.082332] libphy: Fixed MDIO Bus: probed
[   11.082332] libphy: Fixed MDIO Bus: probed
[   11.083878] vcan: Virtual CAN interface driver
[   11.083878] vcan: Virtual CAN interface driver
[   11.085254] CAN device driver interface
[   11.085254] CAN device driver interface
[   11.086468] sja1000 CAN netdevice driver
[   11.086468] sja1000 CAN netdevice driver
[   11.087630] sja1000_isa: insufficient parameters supplied
[   11.087630] sja1000_isa: insufficient parameters supplied
[   11.089321] cc770: CAN netdevice driver
[   11.089321] cc770: CAN netdevice driver
[   11.091078] YAM driver version 0.8 by F1OAT/F6FBB
[   11.091078] YAM driver version 0.8 by F1OAT/F6FBB
[   11.093455] AX.25: bpqether driver version 004
[   11.093455] AX.25: bpqether driver version 004
[   11.094755] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   11.094755] baycom_ser_fdx: version 0.10
[   11.094755] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   11.094755] baycom_ser_fdx: version 0.10
[   11.098634] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   11.098634] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   11.100321] hdlcdrv: version 0.8
[   11.100321] hdlcdrv: version 0.8
[   11.101287] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   11.101287] baycom_ser_hdx: version 0.10
[   11.101287] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   11.101287] baycom_ser_hdx: version 0.10
[   11.105266] PPP generic driver version 2.4.2
[   11.105266] PPP generic driver version 2.4.2
[   11.107315] PPP BSD Compression module registered
[   11.107315] PPP BSD Compression module registered
[   11.108700] NET: Registered protocol family 24
[   11.108700] NET: Registered protocol family 24
[   11.110048] adummy: version 1.0
[   11.110048] adummy: version 1.0
[   11.111349] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   11.111349] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   11.119166] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.119166] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.120649] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.120649] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.123863] mousedev: PS/2 mouse device common for all mice
[   11.123863] mousedev: PS/2 mouse device common for all mice
[   11.127207] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   11.127207] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   11.150176] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   11.150176] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   11.152856] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   11.152856] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   11.155420] i2c-parport-light: adapter type unspecified
[   11.155420] i2c-parport-light: adapter type unspecified
[   11.157365] smssdio: Siano SMS1xxx SDIO driver
[   11.157365] smssdio: Siano SMS1xxx SDIO driver
[   11.158762] smssdio: Copyright Pierre Ossman
[   11.158762] smssdio: Copyright Pierre Ossman
[   11.160689] pps pps0: new PPS source ktimer
[   11.160689] pps pps0: new PPS source ktimer
[   11.162207] pps pps0: ktimer PPS source registered
[   11.162207] pps pps0: ktimer PPS source registered
[   11.163778] Driver for 1-wire Dallas network protocol.
[   11.163778] Driver for 1-wire Dallas network protocol.
[   11.166003] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   11.166003] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   11.168296] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   11.168296] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   11.175577] pc87360: PC8736x not detected, module not inserted
[   11.175577] pc87360: PC8736x not detected, module not inserted
[   11.178366] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   11.178366] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   11.180854] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   11.180854] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   11.184530] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   11.184530] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   11.186841] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[   11.186841] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[   11.189093] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   11.189093] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   11.191982] ib700wdt: START method I/O 443 is not available
[   11.191982] ib700wdt: START method I/O 443 is not available
[   11.193904] ib700wdt: probe of ib700wdt failed with error -5
[   11.193904] ib700wdt: probe of ib700wdt failed with error -5
[   11.195951] it87_wdt: no device
[   11.195951] it87_wdt: no device
[   11.197129] sc1200wdt: build 20020303
[   11.197129] sc1200wdt: build 20020303
[   11.198382] sc1200wdt: io parameter must be specified
[   11.198382] sc1200wdt: io parameter must be specified
[   11.200079] pc87413_wdt: Version 1.1 at io 0x2E
[   11.200079] pc87413_wdt: Version 1.1 at io 0x2E
[   11.201731] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   11.201731] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   11.203791] sbc60xxwdt: I/O address 0x0443 already in use
[   11.203791] sbc60xxwdt: I/O address 0x0443 already in use
[   11.205993] sbc8360: failed to register misc device
[   11.205993] sbc8360: failed to register misc device
[   11.207453] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   11.207453] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   11.211311] smsc37b787_wdt: Unable to register miscdev on minor 130
[   11.211311] smsc37b787_wdt: Unable to register miscdev on minor 130
[   11.213685] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   11.213685] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   11.215571] w83697hf_wdt: watchdog not found at address 0x2e
[   11.215571] w83697hf_wdt: watchdog not found at address 0x2e
[   11.217560] w83697hf_wdt: No W83697HF/HG could be found
[   11.217560] w83697hf_wdt: No W83697HF/HG could be found
[   11.219490] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   11.219490] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   11.222658] w83697ug_wdt: No W83697UG/UF could be found
[   11.222658] w83697ug_wdt: No W83697UG/UF could be found
[   11.224327] w83877f_wdt: I/O address 0x0443 already in use
[   11.224327] w83877f_wdt: I/O address 0x0443 already in use
[   11.226195] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   11.226195] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   11.227973] machzwd: no ZF-Logic found
[   11.227973] machzwd: no ZF-Logic found
[   11.229281] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   11.229281] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   11.230936] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   11.230936] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   11.233060] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   11.233060] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   11.236248] sdhci: Secure Digital Host Controller Interface driver
[   11.236248] sdhci: Secure Digital Host Controller Interface driver
[   11.237965] sdhci: Copyright(c) Pierre Ossman
[   11.237965] sdhci: Copyright(c) Pierre Ossman
[   11.239165] sdhci-pltfm: SDHCI platform and OF driver helper
[   11.239165] sdhci-pltfm: SDHCI platform and OF driver helper
[   11.242056] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   11.242056] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   11.248667] NET: Registered protocol family 26
[   11.248667] NET: Registered protocol family 26
[   11.249972] Netfilter messages via NETLINK v0.30.
[   11.249972] Netfilter messages via NETLINK v0.30.
[   11.251357] nfnl_acct: registering with nfnetlink.
[   11.251357] nfnl_acct: registering with nfnetlink.
[   11.256243] xt_time: kernel timezone is -0000
[   11.256243] xt_time: kernel timezone is -0000
[   11.257211] IPVS: Registered protocols (TCP, UDP, ESP)
[   11.257211] IPVS: Registered protocols (TCP, UDP, ESP)
[   11.258457] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[   11.258457] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[   11.259989] IPVS: Each connection entry needs 416 bytes at least
[   11.259989] IPVS: Each connection entry needs 416 bytes at least
[   11.261407] IPVS: Creating netns size=3D2120 id=3D0
[   11.261407] IPVS: Creating netns size=3D2120 id=3D0
[   11.262507] IPVS: ipvs loaded.
[   11.262507] IPVS: ipvs loaded.
[   11.263143] IPVS: [rr] scheduler registered.
[   11.263143] IPVS: [rr] scheduler registered.
[   11.263961] IPVS: [wlc] scheduler registered.
[   11.263961] IPVS: [wlc] scheduler registered.
[   11.264937] IPVS: [lblc] scheduler registered.
[   11.264937] IPVS: [lblc] scheduler registered.
[   11.266049] IPVS: [sh] scheduler registered.
[   11.266049] IPVS: [sh] scheduler registered.
[   11.266926] IPVS: [nq] scheduler registered.
[   11.266926] IPVS: [nq] scheduler registered.
[   11.267802] ipip: IPv4 over IPv4 tunneling driver
[   11.267802] ipip: IPv4 over IPv4 tunneling driver
[   11.269239] IPv4 over IPSec tunneling driver
[   11.269239] IPv4 over IPSec tunneling driver
[   11.270403] TCP: cubic registered
[   11.270403] TCP: cubic registered
[   11.271096] NET: Registered protocol family 17
[   11.271096] NET: Registered protocol family 17
[   11.275174] NET: Registered protocol family 15
[   11.275174] NET: Registered protocol family 15
[   11.276625] Bridge firewalling registered
[   11.276625] Bridge firewalling registered
[   11.278061] Ebtables v2.0 registered
[   11.278061] Ebtables v2.0 registered
[   11.279828] NET: Registered protocol family 4
[   11.279828] NET: Registered protocol family 4
[   11.280890] NET: Registered protocol family 5
[   11.280890] NET: Registered protocol family 5
[   11.282053] NET: Registered protocol family 9
[   11.282053] NET: Registered protocol family 9
[   11.282965] X25: Linux Version 0.2
[   11.282965] X25: Linux Version 0.2
[   11.283665] NET: Registered protocol family 3
[   11.283665] NET: Registered protocol family 3
[   11.284578] can: controller area network core (rev 20120528 abi 9)
[   11.284578] can: controller area network core (rev 20120528 abi 9)
[   11.286140] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   11.286140] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   11.287527] NET: Registered protocol family 29
[   11.287527] NET: Registered protocol family 29
[   11.288516] can: raw protocol (rev 20120528)
[   11.288516] can: raw protocol (rev 20120528)
[   11.289673] can: netlink gateway (rev 20130117) max_hops=3D1
[   11.289673] can: netlink gateway (rev 20130117) max_hops=3D1
[   11.291333] NET: Registered protocol family 33
[   11.291333] NET: Registered protocol family 33
[   11.292362] Key type rxrpc registered
[   11.292362] Key type rxrpc registered
[   11.293191] Key type rxrpc_s registered
[   11.293191] Key type rxrpc_s registered
[   11.294052] lec:lane_module_init: lec.c: initialized
[   11.294052] lec:lane_module_init: lec.c: initialized
[   11.295106] mpoa:atm_mpoa_init: mpc.c: initialized
[   11.295106] mpoa:atm_mpoa_init: mpc.c: initialized
[   11.296161] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   11.296161] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   11.298486] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[   11.298486] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[   11.299944] NET: Registered protocol family 12
[   11.299944] NET: Registered protocol family 12
[   11.301533] 8021q: 802.1Q VLAN Support v1.8
[   11.301533] 8021q: 802.1Q VLAN Support v1.8
[   11.304182] DCCP: Activated CCID 2 (TCP-like)
[   11.304182] DCCP: Activated CCID 2 (TCP-like)
[   11.306571] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   11.306571] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   11.308633] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   11.308633] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   11.310430] Registered RDS/tcp transport
[   11.310430] Registered RDS/tcp transport
[   11.311728] lib80211: common routines for IEEE802.11 drivers
[   11.311728] lib80211: common routines for IEEE802.11 drivers
[   11.315037] BUG: unable to handle kernel=20
[   11.315037] BUG: unable to handle kernel paging requestpaging request at=
 ffff88000a737f60
 at ffff88000a737f60
[   11.315933] IP:
[   11.315933] IP: [<ffffffff813534f2>] strcmp+0x6/0x55
 [<ffffffff813534f2>] strcmp+0x6/0x55
[   11.315933] PGD 3191067=20
[   11.315933] PGD 3191067 PUD 3192067 PUD 3192067 PMD fb92067 PMD fb92067 =
PTE 800000000a737060PTE 800000000a737060

[   11.315933] Oops: 0000 [#1]=20
[   11.315933] Oops: 0000 [#1] SMP SMP DEBUG_PAGEALLOCDEBUG_PAGEALLOC

[   11.315933] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1-00001-g=
8460434 #27
[   11.315933] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1-00001-g=
8460434 #27
[   11.315933] task: ffff88000e590010 ti: ffff88000e592000 task.ti: ffff880=
00e592000
[   11.315933] task: ffff88000e590010 ti: ffff88000e592000 task.ti: ffff880=
00e592000
[   11.315933] RIP: 0010:[<ffffffff813534f2>]=20
[   11.315933] RIP: 0010:[<ffffffff813534f2>]  [<ffffffff813534f2>] strcmp+=
0x6/0x55
 [<ffffffff813534f2>] strcmp+0x6/0x55
[   11.315933] RSP: 0000:ffff88000e593cc8  EFLAGS: 00010046
[   11.315933] RSP: 0000:ffff88000e593cc8  EFLAGS: 00010046
[   11.315933] RAX: 0000000000000000 RBX: ffffffff82c8cde0 RCX: 00000000000=
0006c
[   11.315933] RAX: 0000000000000000 RBX: ffffffff82c8cde0 RCX: 00000000000=
0006c
[   11.315933] RDX: 0000000000000000 RSI: ffffffff81fb76e2 RDI: ffff88000a7=
37f60
[   11.315933] RDX: 0000000000000000 RSI: ffffffff81fb76e2 RDI: ffff88000a7=
37f60
[   11.315933] RBP: ffff88000e593cc8 R08: ffffffff82c8e501 R09: 00000000000=
00003
[   11.315933] RBP: ffff88000e593cc8 R08: ffffffff82c8e501 R09: 00000000000=
00003
[   11.315933] R10: 0000000000000046 R11: 0000000000000046 R12: 00000000000=
00000
[   11.315933] R10: 0000000000000046 R11: 0000000000000046 R12: 00000000000=
00000
[   11.315933] R13: ffffffff82c8e520 R14: ffffffff81fb76e2 R15: ffffffff820=
e4a98
[   11.315933] R13: ffffffff82c8e520 R14: ffffffff81fb76e2 R15: ffffffff820=
e4a98
[   11.315933] FS:  0000000000000000(0000) GS:ffff88000f600000(0000) knlGS:=
0000000000000000
[   11.315933] FS:  0000000000000000(0000) GS:ffff88000f600000(0000) knlGS:=
0000000000000000
[   11.315933] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   11.315933] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   11.315933] CR2: ffff88000a737f60 CR3: 000000000200f000 CR4: 00000000000=
006b0
[   11.315933] CR2: ffff88000a737f60 CR3: 000000000200f000 CR4: 00000000000=
006b0
[   11.315933] Stack:
[   11.315933] Stack:
[   11.315933]  ffff88000e593cf8
[   11.315933]  ffff88000e593cf8 ffffffff8192bf5a ffffffff8192bf5a 00000000=
00000000 0000000000000000 0000000000000002 0000000000000002

[   11.315933]  ffffffff82c8e520
[   11.315933]  ffffffff82c8e520 ffff88000e590010 ffff88000e590010 ffff8800=
0e593dc0 ffff88000e593dc0 ffffffff81181909 ffffffff81181909

[   11.315933]  0000000000002140
[   11.315933]  0000000000002140 ffffffff82c8e530 ffffffff82c8e530 00000000=
0006db60 000000000006db60 000000010e592000 000000010e592000

[   11.315933] Call Trace:
[   11.315933] Call Trace:
[   11.315933]  [<ffffffff8192bf5a>] count_matching_names+0x61/0x8e
[   11.315933]  [<ffffffff8192bf5a>] count_matching_names+0x61/0x8e
[   11.315933]  [<ffffffff81181909>] __lock_acquire+0x375/0x1850
[   11.315933]  [<ffffffff81181909>] __lock_acquire+0x375/0x1850
[   11.315933]  [<ffffffff8117cae5>] ? up+0x14/0x6b
[   11.315933]  [<ffffffff8117cae5>] ? up+0x14/0x6b
[   11.315933]  [<ffffffff811840bb>] lock_acquire+0xd8/0x1bd
[   11.315933]  [<ffffffff811840bb>] lock_acquire+0xd8/0x1bd
[   11.315933]  [<ffffffff81898277>] ? lib80211_register_crypto_ops+0x56/0x=
99
[   11.315933]  [<ffffffff81898277>] ? lib80211_register_crypto_ops+0x56/0x=
99
[   11.315933]  [<ffffffff8193da79>] _raw_spin_lock_irqsave+0x4f/0x9d
[   11.315933]  [<ffffffff8193da79>] _raw_spin_lock_irqsave+0x4f/0x9d
[   11.315933]  [<ffffffff81898277>] ? lib80211_register_crypto_ops+0x56/0x=
99
[   11.315933]  [<ffffffff81898277>] ? lib80211_register_crypto_ops+0x56/0x=
99
[   11.315933]  [<ffffffff81898277>] lib80211_register_crypto_ops+0x56/0x99
[   11.315933]  [<ffffffff81898277>] lib80211_register_crypto_ops+0x56/0x99
[   11.315933]  [<ffffffff827b3c29>] ? dccp_diag_init+0x12/0x12
[   11.315933]  [<ffffffff827b3c29>] ? dccp_diag_init+0x12/0x12
[   11.315933]  [<ffffffff827b3c47>] lib80211_init+0x1e/0x20
[   11.315933]  [<ffffffff827b3c47>] lib80211_init+0x1e/0x20
[   11.315933]  [<ffffffff8274f209>] do_one_initcall+0x9a/0x1b1
[   11.315933]  [<ffffffff8274f209>] do_one_initcall+0x9a/0x1b1
[   11.315933]  [<ffffffff811406ec>] ? parameq+0x1d/0x1f
[   11.315933]  [<ffffffff811406ec>] ? parameq+0x1d/0x1f
[   11.315933]  [<ffffffff811409e2>] ? parse_args+0x2f4/0x3cb
[   11.315933]  [<ffffffff811409e2>] ? parse_args+0x2f4/0x3cb
[   11.315933]  [<ffffffff8274f42b>] kernel_init_freeable+0x10b/0x1c9
[   11.315933]  [<ffffffff8274f42b>] kernel_init_freeable+0x10b/0x1c9
[   11.315933]  [<ffffffff8274e8d5>] ? do_early_param+0xc1/0xc1
[   11.315933]  [<ffffffff8274e8d5>] ? do_early_param+0xc1/0xc1
[   11.315933]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   11.315933]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   11.315933]  [<ffffffff8191eec7>] kernel_init+0x9/0x17e
[   11.315933]  [<ffffffff8191eec7>] kernel_init+0x9/0x17e
[   11.315933]  [<ffffffff8193f44c>] ret_from_fork+0x7c/0xb0
[   11.315933]  [<ffffffff8193f44c>] ret_from_fork+0x7c/0xb0
[   11.315933]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   11.315933]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   11.315933] Code:=20
[   11.315933] Code: 49 49 39 39 d0 d0 40 40 0f 0f 94 94 c7 c7 4c 4c 63 63 =
cf cf 49 49 83 83 c1 c1 02 02 4a 4a ff ff 04 04 cd cd d8 d8 6d 6d 2b 2b 82 =
82 85 85 ff ff 75 75 05 05 4c 4c 89 89 c1 c1 eb eb cb cb c6 c6 41 41 01 01 =
00 00 5d 5d c3 c3 55 55 31 31 c0 c0 48 48 89 89 e5 e5 <8a> <8a> 14 14 07 07=
 8a 8a 0c 0c 06 06 38 38 ca ca 41 41 0f 0f 95 95 c0 c0 4d 4d 89 89 c1 c1 41=
 41 83 83 e1 e1 01 01 49 49 83 83=20

[   11.315933] RIP=20
[   11.315933] RIP  [<ffffffff813534f2>] strcmp+0x6/0x55
 [<ffffffff813534f2>] strcmp+0x6/0x55
[   11.315933]  RSP <ffff88000e593cc8>
[   11.315933]  RSP <ffff88000e593cc8>
[   11.315933] CR2: ffff88000a737f60
[   11.315933] CR2: ffff88000a737f60
[   11.315933] ---[ end trace ee1b45831add9036 ]---
[   11.315933] ---[ end trace ee1b45831add9036 ]---
[   11.315933] Kernel panic - not syncing: Fatal exception
[   11.315933] Kernel panic - not syncing: Fatal exception
[   11.315933] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   11.315933] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   11.315933] Rebooting in 10 seconds..
[   11.315933] Rebooting in 10 seconds..
Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-3.14.0-rc1-00001-=
g8460434 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dno=
rmal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randcon=
fig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036e86e85c4055a1c7ea=
5529-20140212202932-1-xian branch=3Dwq/for-3.14-fixes BOOT_IMAGE=3D/kernel/=
x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-=
3.14.0-rc1-00001-g8460434'  -initrd /kernel-tests/initrd/yocto-minimal-x86_=
64.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,ho=
stfwd=3Dtcp::20492-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc =
base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-xian-64,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto-xian-64,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-xian-64,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-xian-64,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-xian-64,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-xian-64,media=3D=
disk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-xian-64 -serial file:/de=
v/shm/kboot/serial-yocto-xian-64 -daemonize -display none -monitor null=20

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-bens-5:20140212211130:x86_64-randconfig-c4-0212:3.14.0-rc1-00001-g8460434:27"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00001-g8460434 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #27 SMP Wed Feb 12 20:27:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036e86e85c=
4055a1c7ea5529-20140212202932-5-bens branch=3Dwq/for-3.14-fixes BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea55=
29/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03191000, 0x03191fff] PGTABLE
[    0.000000] BRK [0x03192000, 0x03192fff] PGTABLE
[    0.000000] BRK [0x03193000, 0x03193fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x03194000, 0x03194fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x03195000, 0x03195fff] PGTABLE
[    0.000000] BRK [0x03196000, 0x03196fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffa000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ee0000=
0-ffff88000f1fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff88000f600000 s1914960 r0=
 d22448 u2097152
[    0.000000] pcpu-alloc: s1914960 r0 d22448 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f60cb80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036=
e86e85c4055a1c7ea5529-20140212202932-5-bens branch=3Dwq/for-3.14-fixes BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1=
c7ea5529/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 215372K/261744K available (9482K kernel code, 5601K =
rwdata, 5956K rodata, 2816K init, 9544K bss, 46372K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00001-g8460434 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #27 SMP Wed Feb 12 20:27:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036e86e85c=
4055a1c7ea5529-20140212202932-5-bens branch=3Dwq/for-3.14-fixes BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea55=
29/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03191000, 0x03191fff] PGTABLE
[    0.000000] BRK [0x03192000, 0x03192fff] PGTABLE
[    0.000000] BRK [0x03193000, 0x03193fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x03194000, 0x03194fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x03195000, 0x03195fff] PGTABLE
[    0.000000] BRK [0x03196000, 0x03196fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffa000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ee0000=
0-ffff88000f1fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff88000f600000 s1914960 r0=
 d22448 u2097152
[    0.000000] pcpu-alloc: s1914960 r0 d22448 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f60cb80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036=
e86e85c4055a1c7ea5529-20140212202932-5-bens branch=3Dwq/for-3.14-fixes BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1=
c7ea5529/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 215372K/261744K available (9482K kernel code, 5601K =
rwdata, 5956K rodata, 2816K init, 9544K bss, 46372K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.476 MHz processor
[    0.000000] tsc: Detected 2666.476 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 5332.95 Bogo=
MIPS (lpj=3D2666476)
5332.95 BogoMIPS (lpj=3D2666476)
[    0.005024] pid_max: default: 32768 minimum: 301
[    0.005024] pid_max: default: 32768 minimum: 301
[    0.015090] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.015090] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.019055] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.019055] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.021847] Mount-cache hash table entries: 256
[    0.021847] Mount-cache hash table entries: 256
[    0.027128] Initializing cgroup subsys devices
[    0.027128] Initializing cgroup subsys devices
[    0.029029] Initializing cgroup subsys net_cls
[    0.029029] Initializing cgroup subsys net_cls
[    0.030112] Initializing cgroup subsys perf_event
[    0.030112] Initializing cgroup subsys perf_event
[    0.033117] numa_add_cpu cpu 0 node 0: mask now 0
[    0.033117] numa_add_cpu cpu 0 node 0: mask now 0
[    0.034034] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.034034] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.034034] tlb_flushall_shift: 6
[    0.034034] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.034034] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.034034] tlb_flushall_shift: 6
[    0.035222] debug: unmapping init [mem 0xffffffff8283a000-0xffffffff8283=
efff]
[    0.035222] debug: unmapping init [mem 0xffffffff8283a000-0xffffffff8283=
efff]
[    0.051099] Getting VERSION: 50014
[    0.051099] Getting VERSION: 50014
[    0.052035] Getting VERSION: 50014
[    0.052035] Getting VERSION: 50014
[    0.053019] Getting ID: 0
[    0.053019] Getting ID: 0
[    0.054025] Getting ID: ff000000
[    0.054025] Getting ID: ff000000
[    0.055075] Getting LVT0: 8700
[    0.055075] Getting LVT0: 8700
[    0.056016] Getting LVT1: 8400
[    0.056016] Getting LVT1: 8400
[    0.057235] enabled ExtINT on CPU#0
[    0.057235] enabled ExtINT on CPU#0
[    0.059540] ENABLING IO-APIC IRQs
[    0.059540] ENABLING IO-APIC IRQs
[    0.060016] init IO_APIC IRQs
[    0.060016] init IO_APIC IRQs
[    0.061013]  apic 0 pin 0 not connected
[    0.061013]  apic 0 pin 0 not connected
[    0.062108] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.062108] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.063072] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.063072] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.064054] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.064054] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.065046] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.065046] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.066049] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.066049] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.067044] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.067044] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.068048] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.068048] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.069042] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.069042] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.070049] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.070049] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.071042] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.071042] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.072046] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.072046] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.073078] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.073078] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.074071] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.074071] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.075111] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.075111] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.076045] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.076045] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.077034]  apic 0 pin 16 not connected
[    0.077034]  apic 0 pin 16 not connected
[    0.078015]  apic 0 pin 17 not connected
[    0.078015]  apic 0 pin 17 not connected
[    0.079008]  apic 0 pin 18 not connected
[    0.079008]  apic 0 pin 18 not connected
[    0.080008]  apic 0 pin 19 not connected
[    0.080008]  apic 0 pin 19 not connected
[    0.081015]  apic 0 pin 20 not connected
[    0.081015]  apic 0 pin 20 not connected
[    0.082015]  apic 0 pin 21 not connected
[    0.082015]  apic 0 pin 21 not connected
[    0.084014]  apic 0 pin 22 not connected
[    0.084014]  apic 0 pin 22 not connected
[    0.085015]  apic 0 pin 23 not connected
[    0.085015]  apic 0 pin 23 not connected
[    0.086197] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.086197] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.088020] smpboot: CPU0:=20
[    0.088020] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.092022] Using local APIC timer interrupts.
[    0.092022] calibrating APIC timer ...
[    0.092022] Using local APIC timer interrupts.
[    0.092022] calibrating APIC timer ...
[    0.094000] ... lapic delta =3D 6319300
[    0.094000] ... lapic delta =3D 6319300
[    0.094000] ... PM-Timer delta =3D 361970
[    0.094000] ... PM-Timer delta =3D 361970
[    0.094000] APIC calibration not consistent with PM-Timer: 101ms instead=
 of 100ms
[    0.094000] APIC calibration not consistent with PM-Timer: 101ms instead=
 of 100ms
[    0.094000] APIC delta adjusted to PM-Timer: 6249188 (6319300)
[    0.094000] APIC delta adjusted to PM-Timer: 6249188 (6319300)
[    0.094000] TSC delta adjusted to PM-Timer: 266732467 (269725024)
[    0.094000] TSC delta adjusted to PM-Timer: 266732467 (269725024)
[    0.094000] ..... delta 6249188
[    0.094000] ..... delta 6249188
[    0.094000] ..... mult: 268400580
[    0.094000] ..... mult: 268400580
[    0.094000] ..... calibration result: 999870
[    0.094000] ..... calibration result: 999870
[    0.094000] ..... CPU clock speed is 2667.0324 MHz.
[    0.094000] ..... CPU clock speed is 2667.0324 MHz.
[    0.094000] ..... host bus clock speed is 999.0870 MHz.
[    0.094000] ..... host bus clock speed is 999.0870 MHz.
[    0.094343] Performance Events:=20
[    0.094343] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.116121] ftrace: Allocated trace_printk buffers
[    0.116121] ftrace: Allocated trace_printk buffers
[    0.283918] x86: Booting SMP configuration:
[    0.283918] x86: Booting SMP configuration:
[    0.284020] .... node  #0, CPUs: =20
[    0.284020] .... node  #0, CPUs:         #1 #1
[    0.186171] kvm-clock: cpu 1, msr 0:fff9041, secondary cpu clock
[    0.186171] masked ExtINT on CPU#1
[    0.186171] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.305561] KVM setup async PF for cpu 1
[    0.305561] KVM setup async PF for cpu 1
[    0.306038] x86: Booted up 1 node, 2 CPUs
[    0.306038] x86: Booted up 1 node, 2 CPUs
[    0.306075] ----------------
[    0.306075] ----------------
[    0.306136] | NMI testsuite:
[    0.306136] | NMI testsuite:
[    0.306137] --------------------
[    0.306137] --------------------
[    0.306000]   remote IPI:
[    0.306000]   remote IPI:
[    0.306000] kvm-stealtime: cpu 1, msr f80cb80
[    0.306000] kvm-stealtime: cpu 1, msr f80cb80
[    0.318078]   ok  |
[    0.318078]   ok  |

[    0.318851]    local IPI:
[    0.318851]    local IPI:  ok  |  ok  |

[    0.323088] --------------------
[    0.323088] --------------------
[    0.324006] Good, all   2 testcases passed! |
[    0.324006] Good, all   2 testcases passed! |
[    0.325006] ---------------------------------
[    0.325006] ---------------------------------
[    0.326017] smpboot: Total of 2 processors activated (10665.90 BogoMIPS)
[    0.326017] smpboot: Total of 2 processors activated (10665.90 BogoMIPS)
[    0.338871] devtmpfs: initialized
[    0.338871] devtmpfs: initialized
[    0.365189] prandom: seed boundary self test passed
[    0.365189] prandom: seed boundary self test passed
[    0.366490] prandom: 100 self tests passed
[    0.366490] prandom: 100 self tests passed
[    0.367016] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.367016] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.372292] regulator-dummy: no parameters
[    0.372292] regulator-dummy: no parameters
[    0.376908] NET: Registered protocol family 16
[    0.376908] NET: Registered protocol family 16
[    0.384697] cpuidle: using governor menu
[    0.384697] cpuidle: using governor menu
[    0.386596] ACPI: bus type PCI registered
[    0.386596] ACPI: bus type PCI registered
[    0.388459] PCI: Using configuration type 1 for base access
[    0.388459] PCI: Using configuration type 1 for base access
[    0.402798] ACPI: Added _OSI(Module Device)
[    0.402798] ACPI: Added _OSI(Module Device)
[    0.403009] ACPI: Added _OSI(Processor Device)
[    0.403009] ACPI: Added _OSI(Processor Device)
[    0.404009] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.404009] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.405009] ACPI: Added _OSI(Processor Aggregator Device)
[    0.405009] ACPI: Added _OSI(Processor Aggregator Device)
[    0.767484] ACPI: Interpreter enabled
[    0.767484] ACPI: Interpreter enabled
[    0.768031] ACPI Exception: AE_NOT_FOUND,=20
[    0.768031] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.771062] ACPI Exception: AE_NOT_FOUND,=20
[    0.771062] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.774171] ACPI: (supports S0 S3 S5)
[    0.774171] ACPI: (supports S0 S3 S5)
[    0.775008] ACPI: Using IOAPIC for interrupt routing
[    0.775008] ACPI: Using IOAPIC for interrupt routing
[    0.777271] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.777271] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.982070] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.982070] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.983026] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.983026] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.985056] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.985056] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.008256] PCI host bridge to bus 0000:00
[    1.008256] PCI host bridge to bus 0000:00
[    1.009065] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.009065] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.010015] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.010015] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.011012] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.011012] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.012012] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.012012] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.014010] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.014010] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.015305] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.015305] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.017908] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.017908] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.020632] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.020632] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.025648] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.025648] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.028806] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.028806] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.029750] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.029750] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.030030] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.030030] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.032836] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.032836] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.035908] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.035908] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.038094] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.038094] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.049158] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.049158] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.052836] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.052836] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.054639] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.054639] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.057023] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.057023] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.065015] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.065015] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.068097] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.068097] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.071012] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.071012] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.073013] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.073013] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.082083] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.082083] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.084615] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.084615] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.086012] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.086012] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.095463] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.095463] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.098011] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.098011] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.101013] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.101013] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.110423] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.110423] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.113012] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.113012] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.115656] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.115656] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.123649] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.123649] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.125013] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.125013] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.127613] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.127613] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.136115] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.136115] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.138707] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.138707] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.140011] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.140011] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.149672] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.149672] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.150760] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.150760] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.175731] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.175731] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.183261] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.183261] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.190686] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.190686] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.198043] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.198043] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.202607] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.202607] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.223000] ACPI:=20
[    1.223000] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.231335] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.231335] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.232034] vgaarb: loaded
[    1.232034] vgaarb: loaded
[    1.233008] vgaarb: bridge control possible 0000:00:02.0
[    1.233008] vgaarb: bridge control possible 0000:00:02.0
[    1.244188] pps_core: LinuxPPS API ver. 1 registered
[    1.244188] pps_core: LinuxPPS API ver. 1 registered
[    1.245009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.245009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.247253] PTP clock support registered
[    1.247253] PTP clock support registered
[    1.249921] EDAC MC: Ver: 3.0.0
[    1.249921] EDAC MC: Ver: 3.0.0
[    1.258403] Advanced Linux Sound Architecture Driver Initialized.
[    1.258403] Advanced Linux Sound Architecture Driver Initialized.
[    1.260015] PCI: Using ACPI for IRQ routing
[    1.260015] PCI: Using ACPI for IRQ routing
[    1.261018] PCI: pci_cache_line_size set to 64 bytes
[    1.261018] PCI: pci_cache_line_size set to 64 bytes
[    1.263150] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.263150] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.264035] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.264035] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.268719] NET: Registered protocol family 8
[    1.268719] NET: Registered protocol family 8
[    1.269010] NET: Registered protocol family 20
[    1.269010] NET: Registered protocol family 20
[    1.272262] nfc: nfc_init: NFC Core ver 0.1
[    1.272262] nfc: nfc_init: NFC Core ver 0.1
[    1.275140] NET: Registered protocol family 39
[    1.275140] NET: Registered protocol family 39
[    1.281436] Switched to clocksource kvm-clock
[    1.281436] Switched to clocksource kvm-clock
[    1.297119] Warning: could not register all branches stats
[    1.297119] Warning: could not register all branches stats
[    1.299649] Warning: could not register annotated branches stats
[    1.299649] Warning: could not register annotated branches stats
[    1.988265] FS-Cache: Loaded
[    1.988265] FS-Cache: Loaded
[    1.990246] pnp: PnP ACPI init
[    1.990246] pnp: PnP ACPI init
[    1.991532] ACPI: bus type PNP registered
[    1.991532] ACPI: bus type PNP registered
[    1.993418] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.993418] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    2.003410] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.003410] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.010444] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    2.010444] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    2.017676] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.017676] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.024888] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    2.024888] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    2.032168] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.032168] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.042747] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    2.042747] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    2.048691] pnp 00:03: [dma 2]
[    2.048691] pnp 00:03: [dma 2]
[    2.051228] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.051228] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.061714] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    2.061714] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    2.067702] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.067702] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.079104] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    2.079104] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    2.085579] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.085579] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.109423] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.109423] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.124716] pnp: PnP ACPI: found 7 devices
[    2.124716] pnp: PnP ACPI: found 7 devices
[    2.126357] ACPI: bus type PNP unregistered
[    2.126357] ACPI: bus type PNP unregistered
[    2.144531] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.144531] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.146712] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.146712] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.148756] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.148756] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.151148] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    2.151148] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    2.156398] NET: Registered protocol family 2
[    2.156398] NET: Registered protocol family 2
[    2.175276] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    2.175276] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    2.180813] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    2.180813] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    2.183710] TCP: Hash tables configured (established 2048 bind 2048)
[    2.183710] TCP: Hash tables configured (established 2048 bind 2048)
[    2.188118] TCP: reno registered
[    2.188118] TCP: reno registered
[    2.190250] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    2.190250] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    2.193881] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    2.193881] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    2.201684] NET: Registered protocol family 1
[    2.201684] NET: Registered protocol family 1
[    2.209065] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.209065] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.211490] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.211490] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.213985] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.213985] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.218447] pci 0000:00:02.0: Boot video device
[    2.218447] pci 0000:00:02.0: Boot video device
[    2.220327] PCI: CLS 0 bytes, default 64
[    2.220327] PCI: CLS 0 bytes, default 64
[    2.236719] Unpacking initramfs...
[    2.236719] Unpacking initramfs...
[    3.342882] debug: unmapping init [mem 0xffff88000fce6000-0xffff88000ffe=
ffff]
[    3.342882] debug: unmapping init [mem 0xffff88000fce6000-0xffff88000ffe=
ffff]
[    3.346342] has_svm: not amd
[    3.346342] has_svm: not amd
[    3.347379] kvm: no hardware support
[    3.347379] kvm: no hardware support
[    3.349395] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.349395] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.351350] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.351350] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.354118] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    3.354118] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    3.367775] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    3.367775] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    3.371305] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    3.371305] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    3.377153] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    3.377153] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    3.400860] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.400860] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.403609] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.403609] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.406029] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.406029] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.408353] AVX or AES-NI instructions are not detected.
[    3.408353] AVX or AES-NI instructions are not detected.
[    3.410398] AVX instructions are not detected.
[    3.410398] AVX instructions are not detected.
[    3.412137] AVX instructions are not detected.
[    3.412137] AVX instructions are not detected.
[    3.414073] AVX instructions are not detected.
[    3.414073] AVX instructions are not detected.
[    3.415703] AVX2 instructions are not detected.
[    3.415703] AVX2 instructions are not detected.
[    3.438135] Initializing RT-Tester: OK
[    3.438135] Initializing RT-Tester: OK
[    3.451481] futex hash table entries: 512 (order: 4, 65536 bytes)
[    3.451481] futex hash table entries: 512 (order: 4, 65536 bytes)
[    3.562744] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.562744] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.575215] fuse init (API version 7.22)
[    3.575215] fuse init (API version 7.22)
[    4.691449] tsc: Refined TSC clocksource calibration: 2666.608 MHz
[    4.691449] tsc: Refined TSC clocksource calibration: 2666.608 MHz
[    4.702427] alg: No test for crc32 (crc32-table)
[    4.702427] alg: No test for crc32 (crc32-table)
[    4.721639] alg: No test for lz4 (lz4-generic)
[    4.721639] alg: No test for lz4 (lz4-generic)
[    4.724305] alg: No test for stdrng (krng)
[    4.724305] alg: No test for stdrng (krng)
[    4.943479] NET: Registered protocol family 38
[    4.943479] NET: Registered protocol family 38
[    4.945216] Key type asymmetric registered
[    4.945216] Key type asymmetric registered
[    4.946693] Asymmetric key parser 'x509' registered
[    4.946693] Asymmetric key parser 'x509' registered
[    4.964759] list_sort_test: start testing list_sort()
[    4.964759] list_sort_test: start testing list_sort()
[    4.981389] no IO addresses supplied
[    4.981389] no IO addresses supplied
[    4.983303] hgafb: HGA card not detected.
[    4.983303] hgafb: HGA card not detected.
[    4.984736] hgafb: probe of hgafb.0 failed with error -22
[    4.984736] hgafb: probe of hgafb.0 failed with error -22
[    4.987852] ipmi message handler version 39.2
[    4.987852] ipmi message handler version 39.2
[    4.989423] ipmi device interface
[    4.989423] ipmi device interface
[    5.010340] IPMI System Interface driver.
[    5.010340] IPMI System Interface driver.
[    5.012382] ipmi_si: Adding default-specified kcs state machine
[    5.012382] ipmi_si: Adding default-specified kcs state machine

[    5.014504] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    5.014504] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    5.018143] ipmi_si: Interface detection failed
[    5.018143] ipmi_si: Interface detection failed
[   13.140092] ipmi_si: Adding default-specified smic state machine
[   13.140092] ipmi_si: Adding default-specified smic state machine

[   13.142575] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   13.142575] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   13.146806] ipmi_si: Interface detection failed
[   13.146806] ipmi_si: Interface detection failed
[   13.154285] ipmi_si: Adding default-specified bt state machine
[   13.154285] ipmi_si: Adding default-specified bt state machine

[   13.161918] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   13.161918] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   13.173667] ipmi_si: Interface detection failed
[   13.173667] ipmi_si: Interface detection failed
[   13.182862] ipmi_si: Unable to find any System Interface(s)
[   13.182862] ipmi_si: Unable to find any System Interface(s)
[   13.192859] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   13.192859] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   13.201496] ACPI: Power Button [PWRF]
[   13.201496] ACPI: Power Button [PWRF]
[   14.079100] hrtimer: interrupt took 2811379 ns
[   14.079100] hrtimer: interrupt took 2811379 ns
[   14.218824] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   14.218824] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   14.269718] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   14.269718] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   14.287474] Non-volatile memory driver v1.3
[   14.287474] Non-volatile memory driver v1.3
[   14.294061] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   14.294061] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   14.297395] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   14.297395] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   14.304931] Hangcheck: Using getrawmonotonic().
[   14.304931] Hangcheck: Using getrawmonotonic().
[   14.313322] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   14.313322] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   14.321068] c2port c2port0: C2 port uc added
[   14.321068] c2port c2port0: C2 port uc added
[   14.325654] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   14.325654] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   14.333667] mic_init not running on X100 ret -19
[   14.333667] mic_init not running on X100 ret -19
[   14.352717] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   14.352717] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   14.359496] Could not find PAR responsible for SC520CDP Flash Bank #0
[   14.359496] Could not find PAR responsible for SC520CDP Flash Bank #0
[   14.364123] Trying default address 0x8400000
[   14.364123] Trying default address 0x8400000
[   14.365637] Could not find PAR responsible for SC520CDP Flash Bank #1
[   14.365637] Could not find PAR responsible for SC520CDP Flash Bank #1
[   14.372302] Trying default address 0x8c00000
[   14.372302] Trying default address 0x8c00000
[   14.373814] Could not find PAR responsible for SC520CDP DIL Flash
[   14.373814] Could not find PAR responsible for SC520CDP DIL Flash
[   14.380041] Trying default address 0x9400000
[   14.380041] Trying default address 0x9400000
[   14.385090] SC520 CDP flash device: 0x800000 at 0x8400000
[   14.385090] SC520 CDP flash device: 0x800000 at 0x8400000
[   14.388849] Failed to ioremap_nocache
[   14.388849] Failed to ioremap_nocache
[   14.390160] Failed to ioremap_nocache
[   14.390160] Failed to ioremap_nocache
[   14.396572] slram: not enough parameters.
[   14.396572] slram: not enough parameters.
[   14.477825] No valid DiskOnChip devices found
[   14.477825] No valid DiskOnChip devices found
[   14.505420] libphy: Fixed MDIO Bus: probed
[   14.505420] libphy: Fixed MDIO Bus: probed
[   14.512803] vcan: Virtual CAN interface driver
[   14.512803] vcan: Virtual CAN interface driver
[   14.518069] CAN device driver interface
[   14.518069] CAN device driver interface
[   14.520487] sja1000 CAN netdevice driver
[   14.520487] sja1000 CAN netdevice driver
[   14.524194] sja1000_isa: insufficient parameters supplied
[   14.524194] sja1000_isa: insufficient parameters supplied
[   14.526322] cc770: CAN netdevice driver
[   14.526322] cc770: CAN netdevice driver
[   14.537693] YAM driver version 0.8 by F1OAT/F6FBB
[   14.537693] YAM driver version 0.8 by F1OAT/F6FBB
[   14.545524] AX.25: bpqether driver version 004
[   14.545524] AX.25: bpqether driver version 004
[   14.552029] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   14.552029] baycom_ser_fdx: version 0.10
[   14.552029] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   14.552029] baycom_ser_fdx: version 0.10
[   14.568221] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   14.568221] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   14.578310] hdlcdrv: version 0.8
[   14.578310] hdlcdrv: version 0.8
[   14.580340] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   14.580340] baycom_ser_hdx: version 0.10
[   14.580340] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   14.580340] baycom_ser_hdx: version 0.10
[   14.595171] PPP generic driver version 2.4.2
[   14.595171] PPP generic driver version 2.4.2
[   14.603813] PPP BSD Compression module registered
[   14.603813] PPP BSD Compression module registered
[   14.605529] NET: Registered protocol family 24
[   14.605529] NET: Registered protocol family 24
[   14.607450] adummy: version 1.0
[   14.607450] adummy: version 1.0
[   14.610003] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   14.610003] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   14.619144] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.619144] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.621251] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.621251] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.629600] mousedev: PS/2 mouse device common for all mice
[   14.629600] mousedev: PS/2 mouse device common for all mice
[   14.638084] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   14.638084] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   14.692370] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   14.692370] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   14.700176] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   14.700176] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   14.716440] i2c-parport-light: adapter type unspecified
[   14.716440] i2c-parport-light: adapter type unspecified
[   14.718351] smssdio: Siano SMS1xxx SDIO driver
[   14.718351] smssdio: Siano SMS1xxx SDIO driver
[   14.728165] smssdio: Copyright Pierre Ossman
[   14.728165] smssdio: Copyright Pierre Ossman
[   14.739237] pps pps0: new PPS source ktimer
[   14.739237] pps pps0: new PPS source ktimer
[   14.740735] pps pps0: ktimer PPS source registered
[   14.740735] pps pps0: ktimer PPS source registered
[   14.751224] Driver for 1-wire Dallas network protocol.
[   14.751224] Driver for 1-wire Dallas network protocol.
[   14.753791] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   14.753791] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   14.764361] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   14.764361] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   14.803476] pc87360: PC8736x not detected, module not inserted
[   14.803476] pc87360: PC8736x not detected, module not inserted
[   14.809759] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   14.809759] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   14.813676] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   14.813676] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   14.820117] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   14.820117] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   14.823755] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[   14.823755] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[   14.826944] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   14.826944] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   14.832155] ib700wdt: START method I/O 443 is not available
[   14.832155] ib700wdt: START method I/O 443 is not available
[   14.834796] ib700wdt: probe of ib700wdt failed with error -5
[   14.834796] ib700wdt: probe of ib700wdt failed with error -5
[   14.837768] it87_wdt: no device
[   14.837768] it87_wdt: no device
[   14.839848] sc1200wdt: build 20020303
[   14.839848] sc1200wdt: build 20020303
[   14.842158] sc1200wdt: io parameter must be specified
[   14.842158] sc1200wdt: io parameter must be specified
[   14.844798] pc87413_wdt: Version 1.1 at io 0x2E
[   14.844798] pc87413_wdt: Version 1.1 at io 0x2E
[   14.847444] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   14.847444] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   14.850453] sbc60xxwdt: I/O address 0x0443 already in use
[   14.850453] sbc60xxwdt: I/O address 0x0443 already in use
[   14.853094] sbc8360: failed to register misc device
[   14.853094] sbc8360: failed to register misc device
[   14.855794] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   14.855794] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   14.862327] smsc37b787_wdt: Unable to register miscdev on minor 130
[   14.862327] smsc37b787_wdt: Unable to register miscdev on minor 130
[   14.865535] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   14.865535] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   14.869071] w83697hf_wdt: watchdog not found at address 0x2e
[   14.869071] w83697hf_wdt: watchdog not found at address 0x2e
[   14.873892] w83697hf_wdt: No W83697HF/HG could be found
[   14.873892] w83697hf_wdt: No W83697HF/HG could be found
[   14.876599] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   14.876599] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   14.881229] w83697ug_wdt: No W83697UG/UF could be found
[   14.881229] w83697ug_wdt: No W83697UG/UF could be found
[   14.883964] w83877f_wdt: I/O address 0x0443 already in use
[   14.883964] w83877f_wdt: I/O address 0x0443 already in use
[   14.886713] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   14.886713] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   14.889803] machzwd: no ZF-Logic found
[   14.889803] machzwd: no ZF-Logic found
[   14.894465] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   14.894465] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   14.898639] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   14.898639] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   14.904324] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   14.904324] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   14.909901] sdhci: Secure Digital Host Controller Interface driver
[   14.909901] sdhci: Secure Digital Host Controller Interface driver
[   14.913135] sdhci: Copyright(c) Pierre Ossman
[   14.913135] sdhci: Copyright(c) Pierre Ossman
[   14.916544] sdhci-pltfm: SDHCI platform and OF driver helper
[   14.916544] sdhci-pltfm: SDHCI platform and OF driver helper
[   14.927403] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   14.927403] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   15.029816] NET: Registered protocol family 26
[   15.029816] NET: Registered protocol family 26
[   15.031846] Netfilter messages via NETLINK v0.30.
[   15.031846] Netfilter messages via NETLINK v0.30.
[   15.043306] nfnl_acct: registering with nfnetlink.
[   15.043306] nfnl_acct: registering with nfnetlink.
[   15.050278] xt_time: kernel timezone is -0000
[   15.050278] xt_time: kernel timezone is -0000
[   15.051991] IPVS: Registered protocols (TCP, UDP, ESP)
[   15.051991] IPVS: Registered protocols (TCP, UDP, ESP)
[   15.055393] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[   15.055393] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[   15.058062] IPVS: Each connection entry needs 416 bytes at least
[   15.058062] IPVS: Each connection entry needs 416 bytes at least
[   15.061869] IPVS: Creating netns size=3D2120 id=3D0
[   15.061869] IPVS: Creating netns size=3D2120 id=3D0
[   15.064582] IPVS: ipvs loaded.
[   15.064582] IPVS: ipvs loaded.
[   15.065985] IPVS: [rr] scheduler registered.
[   15.065985] IPVS: [rr] scheduler registered.
[   15.067906] IPVS: [wlc] scheduler registered.
[   15.067906] IPVS: [wlc] scheduler registered.
[   15.069602] IPVS: [lblc] scheduler registered.
[   15.069602] IPVS: [lblc] scheduler registered.
[   15.071441] IPVS: [sh] scheduler registered.
[   15.071441] IPVS: [sh] scheduler registered.
[   15.073186] IPVS: [nq] scheduler registered.
[   15.073186] IPVS: [nq] scheduler registered.
[   15.074815] ipip: IPv4 over IPv4 tunneling driver
[   15.074815] ipip: IPv4 over IPv4 tunneling driver
[   15.078639] IPv4 over IPSec tunneling driver
[   15.078639] IPv4 over IPSec tunneling driver
[   15.082400] TCP: cubic registered
[   15.082400] TCP: cubic registered
[   15.083816] NET: Registered protocol family 17
[   15.083816] NET: Registered protocol family 17
[   15.089493] NET: Registered protocol family 15
[   15.089493] NET: Registered protocol family 15
[   15.093166] Bridge firewalling registered
[   15.093166] Bridge firewalling registered
[   15.098922] Ebtables v2.0 registered
[   15.098922] Ebtables v2.0 registered
[   15.109521] NET: Registered protocol family 4
[   15.109521] NET: Registered protocol family 4
[   15.111538] NET: Registered protocol family 5
[   15.111538] NET: Registered protocol family 5
[   15.113755] NET: Registered protocol family 9
[   15.113755] NET: Registered protocol family 9
[   15.115371] X25: Linux Version 0.2
[   15.115371] X25: Linux Version 0.2
[   15.117143] NET: Registered protocol family 3
[   15.117143] NET: Registered protocol family 3
[   15.119285] can: controller area network core (rev 20120528 abi 9)
[   15.119285] can: controller area network core (rev 20120528 abi 9)
[   15.122494] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   15.122494] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   15.125459] NET: Registered protocol family 29
[   15.125459] NET: Registered protocol family 29
[   15.127111] can: raw protocol (rev 20120528)
[   15.127111] can: raw protocol (rev 20120528)
[   15.128794] can: netlink gateway (rev 20130117) max_hops=3D1
[   15.128794] can: netlink gateway (rev 20130117) max_hops=3D1
[   15.174926] NET: Registered protocol family 33
[   15.174926] NET: Registered protocol family 33
[   15.176526] Key type rxrpc registered
[   15.176526] Key type rxrpc registered
[   15.177826] Key type rxrpc_s registered
[   15.177826] Key type rxrpc_s registered
[   15.183331] lec:lane_module_init: lec.c: initialized
[   15.183331] lec:lane_module_init: lec.c: initialized
[   15.185080] mpoa:atm_mpoa_init: mpc.c: initialized
[   15.185080] mpoa:atm_mpoa_init: mpc.c: initialized
[   15.190821] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   15.190821] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   15.222744] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[   15.222744] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[   15.227627] NET: Registered protocol family 12
[   15.227627] NET: Registered protocol family 12
[   15.229495] 8021q: 802.1Q VLAN Support v1.8
[   15.229495] 8021q: 802.1Q VLAN Support v1.8
[   15.239955] DCCP: Activated CCID 2 (TCP-like)
[   15.239955] DCCP: Activated CCID 2 (TCP-like)
[   15.265352] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   15.265352] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   15.279248] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   15.279248] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   15.281288] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   15.281288] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   15.284092] Registered RDS/tcp transport
[   15.284092] Registered RDS/tcp transport
[   15.286186] lib80211: common routines for IEEE802.11 drivers
[   15.286186] lib80211: common routines for IEEE802.11 drivers
[   15.288301] lib80211_crypt: registered algorithm 'NULL'
[   15.288301] lib80211_crypt: registered algorithm 'NULL'
[   15.290243] lib80211_crypt: registered algorithm 'WEP'
[   15.290243] lib80211_crypt: registered algorithm 'WEP'
[   15.292163] lib80211_crypt: registered algorithm 'CCMP'
[   15.292163] lib80211_crypt: registered algorithm 'CCMP'
[   15.294003] lib80211_crypt: registered algorithm 'TKIP'
[   15.294003] lib80211_crypt: registered algorithm 'TKIP'
[   15.295962] tipc: Activated (version 2.0.0)
[   15.295962] tipc: Activated (version 2.0.0)
[   15.307882] NET: Registered protocol family 30
[   15.307882] NET: Registered protocol family 30
[   15.329269] tipc: Started in single node mode
[   15.329269] tipc: Started in single node mode
[   15.331540] NET: Registered protocol family 37
[   15.331540] NET: Registered protocol family 37
[   15.334635] NET: Registered protocol family 36
[   15.334635] NET: Registered protocol family 36
[   15.337563] Key type dns_resolver registered
[   15.337563] Key type dns_resolver registered
[   15.351295] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   15.351295] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   15.354140] openvswitch: Open vSwitch switching datapath
[   15.354140] openvswitch: Open vSwitch switching datapath
[   15.365079] mpls_gso: MPLS GSO support
[   15.365079] mpls_gso: MPLS GSO support
[   15.371304]=20
[   15.371304] printing PIC contents
[   15.371304]=20
[   15.371304] printing PIC contents
[   15.373984] ... PIC  IMR: ffff
[   15.373984] ... PIC  IMR: ffff
[   15.373984] ... PIC  IRR: 1013
[   15.373984] ... PIC  IRR: 1013
[   15.378899] ... PIC  ISR: 0000
[   15.378899] ... PIC  ISR: 0000
[   15.382105] ... PIC ELCR: 0c00
[   15.382105] ... PIC ELCR: 0c00
[   15.383246] printing local APIC contents on CPU#0/0:
[   15.383246] printing local APIC contents on CPU#0/0:
[   15.384217] ... APIC ID:      00000000 (0)
[   15.384217] ... APIC ID:      00000000 (0)
[   15.384217] ... APIC VERSION: 00050014
[   15.384217] ... APIC VERSION: 00050014
[   15.384217] ... APIC TASKPRI: 00000000 (00)
[   15.384217] ... APIC TASKPRI: 00000000 (00)
[   15.384217] ... APIC PROCPRI: 00000000
[   15.384217] ... APIC PROCPRI: 00000000
[   15.384217] ... APIC LDR: 01000000
[   15.384217] ... APIC LDR: 01000000
[   15.384217] ... APIC DFR: ffffffff
[   15.384217] ... APIC DFR: ffffffff
[   15.384217] ... APIC SPIV: 000001ff
[   15.384217] ... APIC SPIV: 000001ff
[   15.384217] ... APIC ISR field:
[   15.384217] ... APIC ISR field:
[   15.384217] 00000000
[   15.384217] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   15.384217] ... APIC TMR field:
[   15.384217] ... APIC TMR field:
[   15.384217] 00000000
[   15.384217] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   15.384217] ... APIC IRR field:
[   15.384217] ... APIC IRR field:
[   15.384217] 00000000
[   15.384217] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[   15.384217] ... APIC ESR: 00000000
[   15.384217] ... APIC ESR: 00000000
[   15.384217] ... APIC ICR: 000008fb
[   15.384217] ... APIC ICR: 000008fb
[   15.384217] ... APIC ICR2: 02000000
[   15.384217] ... APIC ICR2: 02000000
[   15.384217] ... APIC LVTT: 000000ef
[   15.384217] ... APIC LVTT: 000000ef
[   15.384217] ... APIC LVTPC: 00010000
[   15.384217] ... APIC LVTPC: 00010000
[   15.384217] ... APIC LVT0: 00010700
[   15.384217] ... APIC LVT0: 00010700
[   15.384217] ... APIC LVT1: 00000400
[   15.384217] ... APIC LVT1: 00000400
[   15.384217] ... APIC LVTERR: 000000fe
[   15.384217] ... APIC LVTERR: 000000fe
[   15.384217] ... APIC TMICT: 0000bd9b
[   15.384217] ... APIC TMICT: 0000bd9b
[   15.384217] ... APIC TMCCT: 00000000
[   15.384217] ... APIC TMCCT: 00000000
[   15.384217] ... APIC TDCR: 00000003
[   15.384217] ... APIC TDCR: 00000003
[   15.384217]=20
[   15.384217]=20
[   15.462118] number of MP IRQ sources: 15.
[   15.462118] number of MP IRQ sources: 15.
[   15.465112] number of IO-APIC #0 registers: 24.
[   15.465112] number of IO-APIC #0 registers: 24.
[   15.468310] testing the IO APIC.......................
[   15.468310] testing the IO APIC.......................
[   15.472302] IO APIC #0......
[   15.472302] IO APIC #0......
[   15.474635] .... register #00: 00000000
[   15.474635] .... register #00: 00000000
[   15.478152] .......    : physical APIC id: 00
[   15.478152] .......    : physical APIC id: 00
[   15.481156] .......    : Delivery Type: 0
[   15.481156] .......    : Delivery Type: 0
[   15.484111] .......    : LTS          : 0
[   15.484111] .......    : LTS          : 0
[   15.487266] .... register #01: 00170011
[   15.487266] .... register #01: 00170011
[   15.490216] .......     : max redirection entries: 17
[   15.490216] .......     : max redirection entries: 17
[   15.494679] .......     : PRQ implemented: 0
[   15.494679] .......     : PRQ implemented: 0
[   15.498808] .......     : IO APIC version: 11
[   15.498808] .......     : IO APIC version: 11
[   15.502174] .... register #02: 00000000
[   15.502174] .... register #02: 00000000
[   15.504123] .......     : arbitration: 00
[   15.504123] .......     : arbitration: 00
[   15.507219] .... IRQ redirection table:
[   15.507219] .... IRQ redirection table:
[   15.511397] 1    0    0   0   0    0    0    00
[   15.511397] 1    0    0   0   0    0    0    00
[   15.514171] 0    0    0   0   0    1    1    31
[   15.514171] 0    0    0   0   0    1    1    31
[   15.519512] 0    0    0   0   0    1    1    30
[   15.519512] 0    0    0   0   0    1    1    30
[   15.522669] 0    0    0   0   0    1    1    33
[   15.522669] 0    0    0   0   0    1    1    33
[   15.527345] 1    0    0   0   0    1    1    34
[   15.527345] 1    0    0   0   0    1    1    34
[   15.546795] 1    1    0   0   0    1    1    35
[   15.546795] 1    1    0   0   0    1    1    35
[   15.548471] 0    0    0   0   0    1    1    36
[   15.548471] 0    0    0   0   0    1    1    36
[   15.550112] 0    0    0   0   0    1    1    37
[   15.550112] 0    0    0   0   0    1    1    37
[   15.556199] 0    0    0   0   0    1    1    38
[   15.556199] 0    0    0   0   0    1    1    38
[   15.557827] 0    1    0   0   0    1    1    39
[   15.557827] 0    1    0   0   0    1    1    39
[   15.564276] 1    1    0   0   0    1    1    3A
[   15.564276] 1    1    0   0   0    1    1    3A
[   15.570192] 1    1    0   0   0    1    1    3B
[   15.570192] 1    1    0   0   0    1    1    3B
[   15.572008] 0    0    0   0   0    1    1    3C
[   15.572008] 0    0    0   0   0    1    1    3C
[   15.576188] 0    0    0   0   0    1    1    3D
[   15.576188] 0    0    0   0   0    1    1    3D
[   15.580126] 0    0    0   0   0    1    1    3E
[   15.580126] 0    0    0   0   0    1    1    3E
[   15.584336] 0    0    0   0   0    1    1    3F
[   15.584336] 0    0    0   0   0    1    1    3F
[   15.588209] 1    0    0   0   0    0    0    00
[   15.588209] 1    0    0   0   0    0    0    00
[   15.594175] 1    0    0   0   0    0    0    00
[   15.594175] 1    0    0   0   0    0    0    00
[   15.595905] 1    0    0   0   0    0    0    00
[   15.595905] 1    0    0   0   0    0    0    00
[   15.599194] 1    0    0   0   0    0    0    00
[   15.599194] 1    0    0   0   0    0    0    00
[   15.603616] 1    0    0   0   0    0    0    00
[   15.603616] 1    0    0   0   0    0    0    00
[   15.607398] 1    0    0   0   0    0    0    00
[   15.607398] 1    0    0   0   0    0    0    00
[   15.613201] 1    0    0   0   0    0    0    00
[   15.613201] 1    0    0   0   0    0    0    00
[   15.618610] 1    0    0   0   0    0    0    00
[   15.618610] 1    0    0   0   0    0    0    00
[   15.620394] IRQ to pin mappings:
[   15.620394] IRQ to pin mappings:
[   15.623518] IRQ0=20
[   15.623518] IRQ0 -> 0:2-> 0:2

[   15.625642] IRQ1=20
[   15.625642] IRQ1 -> 0:1-> 0:1

[   15.631908] IRQ3=20
[   15.631908] IRQ3 -> 0:3-> 0:3

[   15.632910] IRQ4=20
[   15.632910] IRQ4 -> 0:4-> 0:4

[   15.634462] IRQ5=20
[   15.634462] IRQ5 -> 0:5-> 0:5

[   15.638073] IRQ6=20
[   15.638073] IRQ6 -> 0:6-> 0:6

[   15.639106] IRQ7=20
[   15.639106] IRQ7 -> 0:7-> 0:7

[   15.642672] IRQ8=20
[   15.642672] IRQ8 -> 0:8-> 0:8

[   15.644407] IRQ9=20
[   15.644407] IRQ9 -> 0:9-> 0:9

[   15.645447] IRQ10=20
[   15.645447] IRQ10 -> 0:10-> 0:10

[   15.649608] IRQ11=20
[   15.649608] IRQ11 -> 0:11-> 0:11

[   15.650695] IRQ12=20
[   15.650695] IRQ12 -> 0:12-> 0:12

[   15.652539] IRQ13=20
[   15.652539] IRQ13 -> 0:13-> 0:13

[   15.655196] IRQ14=20
[   15.655196] IRQ14 -> 0:14-> 0:14

[   15.658349] IRQ15=20
[   15.658349] IRQ15 -> 0:15-> 0:15

[   15.659438] .................................... done.
[   15.659438] .................................... done.
[   15.677540] bootconsole [earlyser0] disabled
[   15.677540] bootconsole [earlyser0] disabled
[   15.683762] registered taskstats version 1
[   15.708937] Key type trusted registered
[   15.735095] Key type encrypted registered
[   15.797630] rtc-test rtc-test.0: setting system clock to 2014-02-12 13:1=
1:22 UTC (1392210682)
[   15.802767] Unregister pv shared memory for cpu 0
[   15.830283] numa_remove_cpu cpu 0 node 0: mask now 1
[   15.876357] BUG: unable to handle kernel paging request at ffff88000a698=
f60
[   15.877032] IP: [<ffffffff813534f2>] strcmp+0x6/0x55
[   15.877032] PGD 3191067 PUD 3192067 PMD fb92067 PTE 800000000a698060
[   15.877032] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   15.877032] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1-00001-g=
8460434 #27
[   15.877032] task: ffff88000e590010 ti: ffff88000e592000 task.ti: ffff880=
00e592000
[   15.877032] RIP: 0010:[<ffffffff813534f2>]  [<ffffffff813534f2>] strcmp+=
0x6/0x55
[   15.877032] RSP: 0000:ffff88000e593a88  EFLAGS: 00010046
[   15.877032] RAX: 0000000000000000 RBX: ffffffff82c8cde0 RCX: 00000000000=
00064
[   15.877032] RDX: 0000000000000000 RSI: ffffffff81f62d7a RDI: ffff88000a6=
98f60
[   15.877032] RBP: ffff88000e593a88 R08: ffffffff82c92901 R09: 00000000000=
00003
[   15.877032] R10: 0000000000000046 R11: 0000000000000046 R12: 00000000000=
00000
[   15.877032] R13: ffffffff82c928f0 R14: ffffffff81f62d7a R15: ffffffff820=
85338
[   15.877032] FS:  0000000000000000(0000) GS:ffff88000f800000(0000) knlGS:=
0000000000000000
[   15.877032] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   15.877032] CR2: ffff88000a698f60 CR3: 000000000200f000 CR4: 00000000000=
006a0
[   15.877032] Stack:
[   15.877032]  ffff88000e593ab8 ffffffff8192bf5a 0000000000000000 00000000=
00000002
[   15.877032]  ffffffff82c928f0 ffff88000e590010 ffff88000e593b80 ffffffff=
81181909
[   15.877032]  000000000000c440 ffffffff82c92900 0000000000071f30 00000000=
00000000
[   15.877032] Call Trace:
[   15.877032]  [<ffffffff8192bf5a>] count_matching_names+0x61/0x8e
[   15.877032]  [<ffffffff81181909>] __lock_acquire+0x375/0x1850
[   15.877032]  [<ffffffff810900b3>] ? pvclock_clocksource_read+0x9b/0x141
[   15.877032]  [<ffffffff811840bb>] lock_acquire+0xd8/0x1bd
[   15.877032]  [<ffffffff8147c06a>] ? dev_pm_qos_constraints_destroy+0x1e/=
0x143
[   15.877032]  [<ffffffff8147c06a>] ? dev_pm_qos_constraints_destroy+0x1e/=
0x143
[   15.877032]  [<ffffffff81938c0c>] mutex_lock_nested+0x70/0x5dd
[   15.877032]  [<ffffffff8147c06a>] ? dev_pm_qos_constraints_destroy+0x1e/=
0x143
[   15.877032]  [<ffffffff8118714f>] ? do_raw_spin_unlock+0xf7/0x131
[   15.877032]  [<ffffffff8147c06a>] dev_pm_qos_constraints_destroy+0x1e/0x=
143
[   15.877032]  [<ffffffff8147b7c0>] dpm_sysfs_remove+0x9/0xb
[   15.877032]  [<ffffffff81472569>] device_del+0x54/0x209
[   15.877032]  [<ffffffff81472741>] device_unregister+0x23/0x2e
[   15.877032]  [<ffffffff814731d4>] device_destroy+0x49/0x4d
[   15.877032]  [<ffffffff810821dc>] msr_device_destroy+0x18/0x1a
[   15.877032]  [<ffffffff8108220b>] msr_class_cpu_callback+0x2d/0x58
[   15.877032]  [<ffffffff8114a15b>] notifier_call_chain+0x197/0x1f5
[   15.877032]  [<ffffffff8114a60d>] __raw_notifier_call_chain+0x9/0xb
[   15.877032]  [<ffffffff8110f281>] __cpu_notify+0x1b/0x32
[   15.877032]  [<ffffffff8110f2a6>] cpu_notify+0xe/0x10
[   15.877032]  [<ffffffff8110f2b4>] cpu_notify_nofail+0xc/0x39
[   15.877032]  [<ffffffff8191ff4c>] _cpu_down+0x2cb/0x521
[   15.877032]  [<ffffffff8117eb00>] ? lock_release_holdtime.part.9+0xcc/0x=
d9
[   15.877032]  [<ffffffff81920229>] cpu_down+0x37/0x4b
[   15.877032]  [<ffffffff8191f090>] _debug_hotplug_cpu+0x54/0xee
[   15.877032]  [<ffffffff8275935e>] ? pci_iommu_alloc+0xb0/0xb0
[   15.877032]  [<ffffffff8275936b>] debug_hotplug_cpu+0xd/0x11
[   15.877032]  [<ffffffff8274f209>] do_one_initcall+0x9a/0x1b1
[   15.877032]  [<ffffffff811406ec>] ? parameq+0x1d/0x1f
[   15.877032]  [<ffffffff811409e2>] ? parse_args+0x2f4/0x3cb
[   15.877032]  [<ffffffff8274f42b>] kernel_init_freeable+0x10b/0x1c9
[   15.877032]  [<ffffffff8274e8d5>] ? do_early_param+0xc1/0xc1
[   15.877032]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   15.877032]  [<ffffffff8191eec7>] kernel_init+0x9/0x17e
[   15.877032]  [<ffffffff8193f44c>] ret_from_fork+0x7c/0xb0
[   15.877032]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   15.877032] Code: 49 39 d0 40 0f 94 c7 4c 63 cf 49 83 c1 02 4a ff 04 cd =
d8 6d 2b 82 85 ff 75 05 4c 89 c1 eb cb c6 41 01 00 5d c3 55 31 c0 48 89 e5 =
<8a> 14 07 8a 0c 06 38 ca 41 0f 95 c0 4d 89 c1 41 83 e1 01 49 83=20
[   15.877032] RIP  [<ffffffff813534f2>] strcmp+0x6/0x55
[   15.877032]  RSP <ffff88000e593a88>
[   15.877032] CR2: ffff88000a698f60
[   15.877032] ---[ end trace 608d9d3f105c2a13 ]---
[   15.877032] Kernel panic - not syncing: Fatal exception
[   15.877032] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   15.877032] Rebooting in 10 seconds..
Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-3.14.0-rc1-00001-=
g8460434 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dno=
rmal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randcon=
fig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036e86e85c4055a1c7ea=
5529-20140212202932-5-bens branch=3Dwq/for-3.14-fixes BOOT_IMAGE=3D/kernel/=
x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-=
3.14.0-rc1-00001-g8460434'  -initrd /kernel-tests/initrd/yocto-minimal-x86_=
64.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,ho=
stfwd=3Dtcp::9532-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc b=
ase=3Dlocaltime -drive file=3D/fs/sda7/disk0-yocto-bens-5,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/sda7/disk1-yocto-bens-5,media=3Ddisk,if=3Dvirti=
o -drive file=3D/fs/sda7/disk2-yocto-bens-5,media=3Ddisk,if=3Dvirtio -drive=
 file=3D/fs/sda7/disk3-yocto-bens-5,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/sda7/disk4-yocto-bens-5,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7=
/disk5-yocto-bens-5,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yo=
cto-bens-5 -serial file:/dev/shm/kboot/serial-yocto-bens-5 -daemonize -disp=
lay none -monitor null=20

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-waimea-2:20140216080818:x86_64-randconfig-c4-0212:3.14.0-rc1-00001-g8460434:27"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00001-g8460434 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #27 SMP Wed Feb 12 20:27:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c4-0212/wq:for-3.14-fixes:84604340d034a074036e86e85c4055a1c7e=
a5529:bisect-net/.vmlinuz-84604340d034a074036e86e85c4055a1c7ea5529-20140216=
075356-10-waimea branch=3Dwq/for-3.14-fixes BOOT_IMAGE=3D/kernel/x86_64-ran=
dconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-3.14.0-rc1=
-00001-g8460434
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03191000, 0x03191fff] PGTABLE
[    0.000000] BRK [0x03192000, 0x03192fff] PGTABLE
[    0.000000] BRK [0x03193000, 0x03193fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x03194000, 0x03194fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x03195000, 0x03195fff] PGTABLE
[    0.000000] BRK [0x03196000, 0x03196fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd920 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013ffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013ffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013ffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000013ffff40 000040
[    0.000000] ACPI: SSDT 0000000013fff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ffa000-0x13ffdfff]
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001180000=
0-ffff880011dfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff880012200000 s1914960 r0=
 d22448 u2097152
[    0.000000] pcpu-alloc: s1914960 r0 d22448 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes:84604340d034a074036e86e85c40=
55a1c7ea5529:bisect-net/.vmlinuz-84604340d034a074036e86e85c4055a1c7ea5529-2=
0140216075356-10-waimea branch=3Dwq/for-3.14-fixes BOOT_IMAGE=3D/kernel/x86=
_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-3.1=
4.0-rc1-00001-g8460434
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 258596K/327280K available (9482K kernel code, 5601K =
rwdata, 5956K rodata, 2816K init, 9544K bss, 68684K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00001-g8460434 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #27 SMP Wed Feb 12 20:27:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c4-0212/wq:for-3.14-fixes:84604340d034a074036e86e85c4055a1c7e=
a5529:bisect-net/.vmlinuz-84604340d034a074036e86e85c4055a1c7ea5529-20140216=
075356-10-waimea branch=3Dwq/for-3.14-fixes BOOT_IMAGE=3D/kernel/x86_64-ran=
dconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-3.14.0-rc1=
-00001-g8460434
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03191000, 0x03191fff] PGTABLE
[    0.000000] BRK [0x03192000, 0x03192fff] PGTABLE
[    0.000000] BRK [0x03193000, 0x03193fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x03194000, 0x03194fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x03195000, 0x03195fff] PGTABLE
[    0.000000] BRK [0x03196000, 0x03196fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd920 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013ffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013ffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013ffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000013ffff40 000040
[    0.000000] ACPI: SSDT 0000000013fff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ffa000-0x13ffdfff]
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001180000=
0-ffff880011dfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff880012200000 s1914960 r0=
 d22448 u2097152
[    0.000000] pcpu-alloc: s1914960 r0 d22448 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes:84604340d034a074036e86e85c40=
55a1c7ea5529:bisect-net/.vmlinuz-84604340d034a074036e86e85c4055a1c7ea5529-2=
0140216075356-10-waimea branch=3Dwq/for-3.14-fixes BOOT_IMAGE=3D/kernel/x86=
_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-3.1=
4.0-rc1-00001-g8460434
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 258596K/327280K available (9482K kernel code, 5601K =
rwdata, 5956K rodata, 2816K init, 9544K bss, 68684K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3300.123 MHz processor
[    0.000000] tsc: Detected 3300.123 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped), value calculated using tim=
er frequency..=20
[    0.020000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6600.24 BogoMIPS (lpj=3D3300123)
6600.24 BogoMIPS (lpj=3D3300123)
[    0.023252] pid_max: default: 32768 minimum: 301
[    0.023252] pid_max: default: 32768 minimum: 301
[    0.325000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.325000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.418379] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.418379] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.510864] Mount-cache hash table entries: 256
[    0.510864] Mount-cache hash table entries: 256
[    0.939252] Initializing cgroup subsys devices
[    0.939252] Initializing cgroup subsys devices
[    0.964806] Initializing cgroup subsys net_cls
[    0.964806] Initializing cgroup subsys net_cls
[    0.970183] Initializing cgroup subsys perf_event
[    0.970183] Initializing cgroup subsys perf_event
[    1.110000] numa_add_cpu cpu 0 node 0: mask now 0
[    1.110000] numa_add_cpu cpu 0 node 0: mask now 0
[    1.111419] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    1.111419] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    1.111419] tlb_flushall_shift: -1
[    1.111419] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    1.111419] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    1.111419] tlb_flushall_shift: -1
[    1.118712] debug: unmapping init [mem 0xffffffff8283a000-0xffffffff8283=
efff]
[    1.118712] debug: unmapping init [mem 0xffffffff8283a000-0xffffffff8283=
efff]
[    1.243324] Getting VERSION: 50011
[    1.243324] Getting VERSION: 50011
[    1.245258] Getting VERSION: 50011
[    1.245258] Getting VERSION: 50011
[    1.245700] Getting ID: 0
[    1.245700] Getting ID: 0
[    1.246192] Getting ID: ff000000
[    1.246192] Getting ID: ff000000
[    1.246507] Getting LVT0: 8700
[    1.246507] Getting LVT0: 8700
[    1.247193] Getting LVT1: 8400
[    1.247193] Getting LVT1: 8400
[    1.250595] enabled ExtINT on CPU#0
[    1.250595] enabled ExtINT on CPU#0
[    1.258828] ENABLING IO-APIC IRQs
[    1.258828] ENABLING IO-APIC IRQs
[    1.259000] Synchronizing Arb IDs.
[    1.259000] Synchronizing Arb IDs.
[    1.259000] init IO_APIC IRQs
[    1.259000] init IO_APIC IRQs
[    1.259000]  apic 0 pin 0 not connected
[    1.259000]  apic 0 pin 0 not connected
[    1.259414] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.259414] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.262000] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    1.262000] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    1.262000] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.262000] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.262000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.262000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.263161] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    1.263161] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    1.264401] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.264401] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.265000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.265000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.265000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.265000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.265455] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    1.265455] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    1.266000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    1.266000]  apic 0 pin 16 not connected
[    1.266000]  apic 0 pin 16 not connected
[    1.266000]  apic 0 pin 17 not connected
[    1.266000]  apic 0 pin 17 not connected
[    1.266000]  apic 0 pin 18 not connected
[    1.266000]  apic 0 pin 18 not connected
[    1.266000]  apic 0 pin 19 not connected
[    1.266000]  apic 0 pin 19 not connected
[    1.266000]  apic 0 pin 20 not connected
[    1.266000]  apic 0 pin 20 not connected
[    1.266000]  apic 0 pin 21 not connected
[    1.266000]  apic 0 pin 21 not connected
[    1.266000]  apic 0 pin 22 not connected
[    1.266000]  apic 0 pin 22 not connected
[    1.266000]  apic 0 pin 23 not connected
[    1.266000]  apic 0 pin 23 not connected
[    1.267000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    1.267000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    1.277589] smpboot: CPU0:=20
[    1.277589] smpboot: CPU0: AuthenticAMD AuthenticAMD QEMU Virtual CPU ve=
rsion 1.6.0QEMU Virtual CPU version 1.6.0 (fam: 06, model: 02 (fam: 06, mod=
el: 02, stepping: 03)
, stepping: 03)
[    1.281727] Using local APIC timer interrupts.
[    1.281727] calibrating APIC timer ...
[    1.281727] Using local APIC timer interrupts.
[    1.281727] calibrating APIC timer ...
[    1.284000] ... lapic delta =3D 6750668
[    1.284000] ... lapic delta =3D 6750668
[    1.284000] ... PM-Timer delta =3D 386632
[    1.284000] ... PM-Timer delta =3D 386632
[    1.284000] APIC calibration not consistent with PM-Timer: 108ms instead=
 of 100ms
[    1.284000] APIC calibration not consistent with PM-Timer: 108ms instead=
 of 100ms
[    1.284000] APIC delta adjusted to PM-Timer: 6249944 (6750668)
[    1.284000] APIC delta adjusted to PM-Timer: 6249944 (6750668)
[    1.284000] TSC delta adjusted to PM-Timer: 560930522 (605870279)
[    1.284000] TSC delta adjusted to PM-Timer: 560930522 (605870279)
[    1.284000] ..... delta 6249944
[    1.284000] ..... delta 6249944
[    1.284000] ..... mult: 268433050
[    1.284000] ..... mult: 268433050
[    1.284000] ..... calibration result: 999991
[    1.284000] ..... calibration result: 999991
[    1.284000] ..... CPU clock speed is 5609.0305 MHz.
[    1.284000] ..... CPU clock speed is 5609.0305 MHz.
[    1.284000] ..... host bus clock speed is 999.0991 MHz.
[    1.284000] ..... host bus clock speed is 999.0991 MHz.
[    1.287715] Performance Events:=20
[    1.287715] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    1.398495] ftrace: Allocated trace_printk buffers
[    1.398495] ftrace: Allocated trace_printk buffers
[    1.645376] x86: Booting SMP configuration:
[    1.645376] x86: Booting SMP configuration:
[    1.646254] .... node  #0, CPUs: =20
[    1.646254] .... node  #0, CPUs:         #1 #1
[    1.489508] masked ExtINT on CPU#1
[    1.489508] numa_add_cpu cpu 1 node 0: mask now 0-1
[    1.764334] x86: Booted up 1 node, 2 CPUs
[    1.764334] x86: Booted up 1 node, 2 CPUs
[    1.766120] ----------------
[    1.766120] ----------------
[    1.767095] | NMI testsuite:
[    1.767095] | NMI testsuite:
[    1.767351] --------------------
[    1.767351] --------------------
[    1.768116]   remote IPI:
[    1.768116]   remote IPI:  ok  |  ok  |

[    1.790247]    local IPI:
[    1.790247]    local IPI:  ok  |  ok  |

[    1.808365] --------------------
[    1.808365] --------------------
[    1.808708] Good, all   2 testcases passed! |
[    1.808708] Good, all   2 testcases passed! |
[    1.809135] ---------------------------------
[    1.809135] ---------------------------------
[    1.810310] smpboot: Total of 2 processors activated (20519.73 BogoMIPS)
[    1.810310] smpboot: Total of 2 processors activated (20519.73 BogoMIPS)
[    1.960280] devtmpfs: initialized
[    1.960280] devtmpfs: initialized
[    2.819221] prandom: seed boundary self test passed
[    2.819221] prandom: seed boundary self test passed
[    2.839309] prandom: 100 self tests passed
[    2.839309] prandom: 100 self tests passed
[    2.843145] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    2.843145] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    2.905298] regulator-dummy: no parameters
[    2.905298] regulator-dummy: no parameters
[    2.963238] NET: Registered protocol family 16
[    2.963238] NET: Registered protocol family 16
[    3.044205] cpuidle: using governor menu
[    3.044205] cpuidle: using governor menu
[    3.063176] ACPI: bus type PCI registered
[    3.063176] ACPI: bus type PCI registered
[    3.079203] PCI: Using configuration type 1 for base access
[    3.079203] PCI: Using configuration type 1 for base access
[    3.169399] ACPI: Added _OSI(Module Device)
[    3.169399] ACPI: Added _OSI(Module Device)
[    3.170175] ACPI: Added _OSI(Processor Device)
[    3.170175] ACPI: Added _OSI(Processor Device)
[    3.171142] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.171142] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.171478] ACPI: Added _OSI(Processor Aggregator Device)
[    3.171478] ACPI: Added _OSI(Processor Aggregator Device)
[    5.769412] ACPI: Interpreter enabled
[    5.769412] ACPI: Interpreter enabled
[    5.771508] ACPI Exception: AE_NOT_FOUND,=20
[    5.771508] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    5.775137] ACPI Exception: AE_NOT_FOUND,=20
[    5.775137] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    5.781294] ACPI: (supports S0 S3 S5)
[    5.781294] ACPI: (supports S0 S3 S5)
[    5.782211] ACPI: Using IOAPIC for interrupt routing
[    5.782211] ACPI: Using IOAPIC for interrupt routing
[    5.787201] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    5.787201] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[   11.265000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   11.265000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   11.269000] acpi PNP0A03:00: _OSC: OS supports [Segments]
[   11.269000] acpi PNP0A03:00: _OSC: OS supports [Segments]
[   11.289213] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[   11.289213] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[   11.619000] PCI host bridge to bus 0000:00
[   11.619000] PCI host bridge to bus 0000:00
[   11.624373] pci_bus 0000:00: root bus resource [bus 00-ff]
[   11.624373] pci_bus 0000:00: root bus resource [bus 00-ff]
[   11.625394] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   11.625394] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   11.626231] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   11.626231] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   11.629274] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[   11.629274] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[   11.630000] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[   11.630000] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[   11.641310] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   11.641310] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   11.720282] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   11.720282] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   11.796177] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   11.796177] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   11.810319] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[   11.810319] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[   11.880196] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   11.880196] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   11.888749] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[   11.888749] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[   11.889000] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[   11.889000] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[   11.949791] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   11.949791] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   11.954000] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[   11.954000] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[   11.956329] pci 0000:00:02.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[   11.956329] pci 0000:00:02.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[   11.968300] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[   11.968300] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[   12.016374] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[   12.016374] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[   12.022333] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[   12.022333] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[   12.026214] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[   12.026214] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[   12.046300] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[   12.046300] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[   12.100445] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[   12.100445] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[   12.104788] pci 0000:00:04.0: reg 0x10: [mem 0xfebf0000-0xfebf3fff]
[   12.104788] pci 0000:00:04.0: reg 0x10: [mem 0xfebf0000-0xfebf3fff]
[   12.163301] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   12.163301] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   12.170189] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[   12.170189] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[   12.176258] pci 0000:00:05.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[   12.176258] pci 0000:00:05.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[   12.255222] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   12.255222] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   12.258276] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[   12.258276] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[   12.262172] pci 0000:00:06.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[   12.262172] pci 0000:00:06.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[   12.352000] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   12.352000] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   12.358303] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[   12.358303] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[   12.361293] pci 0000:00:07.0: reg 0x14: [mem 0xfebf7000-0xfebf7fff]
[   12.361293] pci 0000:00:07.0: reg 0x14: [mem 0xfebf7000-0xfebf7fff]
[   12.441453] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   12.441453] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   12.446198] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[   12.446198] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[   12.453330] pci 0000:00:08.0: reg 0x14: [mem 0xfebf8000-0xfebf8fff]
[   12.453330] pci 0000:00:08.0: reg 0x14: [mem 0xfebf8000-0xfebf8fff]
[   12.520000] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   12.520000] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   12.525198] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[   12.525198] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[   12.531194] pci 0000:00:09.0: reg 0x14: [mem 0xfebf9000-0xfebf9fff]
[   12.531194] pci 0000:00:09.0: reg 0x14: [mem 0xfebf9000-0xfebf9fff]
[   12.597429] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[   12.597429] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[   12.602334] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[   12.602334] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[   12.605253] pci 0000:00:0a.0: reg 0x14: [mem 0xfebfa000-0xfebfafff]
[   12.605253] pci 0000:00:0a.0: reg 0x14: [mem 0xfebfa000-0xfebfafff]
[   12.673380] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[   12.673380] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[   12.680222] pci 0000:00:0b.0: reg 0x10: [mem 0xfebfb000-0xfebfb00f]
[   12.680222] pci 0000:00:0b.0: reg 0x10: [mem 0xfebfb000-0xfebfb00f]
[   13.773180] ACPI: PCI Interrupt Link [LNKA] (IRQs
[   13.773180] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[   14.159215] ACPI: PCI Interrupt Link [LNKB] (IRQs
[   14.159215] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[   14.240324] ACPI: PCI Interrupt Link [LNKC] (IRQs
[   14.240324] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[   14.338203] ACPI: PCI Interrupt Link [LNKD] (IRQs
[   14.338203] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[   14.408155] ACPI: PCI Interrupt Link [LNKS] (IRQs
[   14.408155] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[   14.720000] ACPI:=20
[   14.720000] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[   14.897000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[   14.897000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[   14.907165] vgaarb: loaded
[   14.907165] vgaarb: loaded
[   14.912144] vgaarb: bridge control possible 0000:00:02.0
[   14.912144] vgaarb: bridge control possible 0000:00:02.0
[   15.295000] pps_core: LinuxPPS API ver. 1 registered
[   15.295000] pps_core: LinuxPPS API ver. 1 registered
[   15.295000] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   15.295000] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   15.302382] PTP clock support registered
[   15.302382] PTP clock support registered
[   15.317219] EDAC MC: Ver: 3.0.0
[   15.317219] EDAC MC: Ver: 3.0.0
[   15.510920] Advanced Linux Sound Architecture Driver Initialized.
[   15.510920] Advanced Linux Sound Architecture Driver Initialized.
[   15.511145] PCI: Using ACPI for IRQ routing
[   15.511145] PCI: Using ACPI for IRQ routing
[   15.513239] PCI: pci_cache_line_size set to 64 bytes
[   15.513239] PCI: pci_cache_line_size set to 64 bytes
[   15.521271] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[   15.521271] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[   15.524890] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[   15.524890] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[   15.796816] NET: Registered protocol family 8
[   15.796816] NET: Registered protocol family 8
[   15.805309] NET: Registered protocol family 20
[   15.805309] NET: Registered protocol family 20
[   16.027000] nfc: nfc_init: NFC Core ver 0.1
[   16.027000] nfc: nfc_init: NFC Core ver 0.1
[   16.054895] NET: Registered protocol family 39
[   16.054895] NET: Registered protocol family 39
[   16.090799] Switched to clocksource hpet
[   16.090799] Switched to clocksource hpet
[   18.540360] hrtimer: interrupt took 3760240 ns
[   18.540360] hrtimer: interrupt took 3760240 ns
[   18.809984] Warning: could not register all branches stats
[   18.809984] Warning: could not register all branches stats
[   18.821857] Warning: could not register annotated branches stats
[   18.821857] Warning: could not register annotated branches stats
[   31.692781] FS-Cache: Loaded
[   31.692781] FS-Cache: Loaded
[   31.705740] pnp: PnP ACPI init
[   31.705740] pnp: PnP ACPI init
[   31.710097] ACPI: bus type PNP registered
[   31.710097] ACPI: bus type PNP registered
[   31.726968] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[   31.726968] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[   31.744504] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   31.744504] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   31.758274] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[   31.758274] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[   31.767094] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   31.767094] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   31.782903] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[   31.782903] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[   31.789115] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   31.789115] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   31.815879] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[   31.815879] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[   31.819625] pnp 00:03: [dma 2]
[   31.819625] pnp 00:03: [dma 2]
[   31.829556] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   31.829556] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   31.852924] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[   31.852924] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[   31.858100] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   31.858100] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   31.879745] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[   31.879745] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[   31.889920] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   31.889920] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   31.994649] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   31.994649] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   32.086879] pnp: PnP ACPI: found 7 devices
[   32.086879] pnp: PnP ACPI: found 7 devices
[   32.091863] ACPI: bus type PNP unregistered
[   32.091863] ACPI: bus type PNP unregistered
[   32.309492] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   32.309492] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   32.309995] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   32.309995] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   32.310919] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   32.310919] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   32.311853] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[   32.311853] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[   32.363770] NET: Registered protocol family 2
[   32.363770] NET: Registered protocol family 2
[   32.478703] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[   32.478703] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[   32.503869] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[   32.503869] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[   32.526955] TCP: Hash tables configured (established 4096 bind 4096)
[   32.526955] TCP: Hash tables configured (established 4096 bind 4096)
[   32.539786] TCP: reno registered
[   32.539786] TCP: reno registered
[   32.544648] UDP hash table entries: 256 (order: 3, 49152 bytes)
[   32.544648] UDP hash table entries: 256 (order: 3, 49152 bytes)
[   32.556747] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[   32.556747] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[   32.609927] NET: Registered protocol family 1
[   32.609927] NET: Registered protocol family 1
[   32.611805] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   32.611805] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   32.612952] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   32.612952] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   32.614932] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   32.614932] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   32.621101] pci 0000:00:02.0: Boot video device
[   32.621101] pci 0000:00:02.0: Boot video device
[   32.623854] PCI: CLS 0 bytes, default 64
[   32.623854] PCI: CLS 0 bytes, default 64
[   33.781796] Unpacking initramfs...
[   33.781796] Unpacking initramfs...
[  378.992816] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[  378.992816] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[  379.011997] has_svm: not amd
[  379.011997] has_svm: not amd
[  379.012761] kvm: no hardware support
[  379.012761] kvm: no hardware support
[  379.015817] microcode: no support for this CPU vendor
[  379.015817] microcode: no support for this CPU vendor
[  391.330552] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[  391.330552] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[  391.333421] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[  391.333421] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[  391.333934] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[  391.333934] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[  391.335765] AVX or AES-NI instructions are not detected.
[  391.335765] AVX or AES-NI instructions are not detected.
[  391.337686] AVX instructions are not detected.
[  391.337686] AVX instructions are not detected.
[  391.339413] AVX instructions are not detected.
[  391.339413] AVX instructions are not detected.
[  391.339794] AVX instructions are not detected.
[  391.339794] AVX instructions are not detected.
[  391.341530] AVX2 instructions are not detected.
[  391.341530] AVX2 instructions are not detected.
[  391.453903] Initializing RT-Tester: OK
[  391.453903] Initializing RT-Tester: OK
[  391.486077] futex hash table entries: 512 (order: 4, 65536 bytes)
[  391.486077] futex hash table entries: 512 (order: 4, 65536 bytes)
[  392.695624] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[  392.695624] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[  392.787619] fuse init (API version 7.22)
[  392.787619] fuse init (API version 7.22)
[  409.613976] alg: No test for crc32 (crc32-table)
[  409.613976] alg: No test for crc32 (crc32-table)
[  409.832989] alg: No test for lz4 (lz4-generic)
[  409.832989] alg: No test for lz4 (lz4-generic)
[  410.892025] alg: No test for stdrng (krng)
[  410.892025] alg: No test for stdrng (krng)
[  415.349661] NET: Registered protocol family 38
[  415.349661] NET: Registered protocol family 38
[  415.355543] Key type asymmetric registered
[  415.355543] Key type asymmetric registered
[  415.357781] Asymmetric key parser 'x509' registered
[  415.357781] Asymmetric key parser 'x509' registered
[  415.759425] list_sort_test: start testing list_sort()
[  415.759425] list_sort_test: start testing list_sort()
[  417.034602] no IO addresses supplied
[  417.034602] no IO addresses supplied
[  417.056799] hgafb: HGA card not detected.
[  417.056799] hgafb: HGA card not detected.
[  417.060778] hgafb: probe of hgafb.0 failed with error -22
[  417.060778] hgafb: probe of hgafb.0 failed with error -22
[  417.098744] ipmi message handler version 39.2
[  417.098744] ipmi message handler version 39.2
[  417.101439] ipmi device interface
[  417.101439] ipmi device interface
[  417.124959] IPMI System Interface driver.
[  417.124959] IPMI System Interface driver.
[  417.237938] ipmi_si: Adding default-specified kcs state machine
[  417.237938] ipmi_si: Adding default-specified kcs state machine

[  417.241399] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[  417.241399] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[  417.251651] ipmi_si: Interface detection failed
[  417.251651] ipmi_si: Interface detection failed
[  418.322307] INFO: rcu_sched self-detected stall on CPU
[  418.322307] INFO: rcu_sched self-detected stall on CPU

[  418.322307]=20
[  418.322307]=20
[  418.322307]=20
 (t=3D26395 jiffies g=3D2776 c=3D2775 q=3D91)
[  418.322307] sending NMI to all CPUs:
[  418.322307] sending NMI to all CPUs:
[  418.322307] NMI backtrace for cpu 0
[  418.322307] NMI backtrace for cpu 0
[  418.322307] CPU: 0 PID: 63 Comm: rb_consumer Not tainted 3.14.0-rc1-0000=
1-g8460434 #27
[  418.322307] CPU: 0 PID: 63 Comm: rb_consumer Not tainted 3.14.0-rc1-0000=
1-g8460434 #27
[  418.322307] task: ffff880007f64950 ti: ffff880007f66000 task.ti: ffff880=
007f66000
[  418.322307] task: ffff880007f64950 ti: ffff880007f66000 task.ti: ffff880=
007f66000
[  418.322307] RIP: 0010:[<ffffffff8108d7a3>]=20
[  418.322307] RIP: 0010:[<ffffffff8108d7a3>]  [<ffffffff8108d7a3>] flat_se=
nd_IPI_mask+0xcd/0xf8
 [<ffffffff8108d7a3>] flat_send_IPI_mask+0xcd/0xf8
[  418.322307] RSP: 0000:ffff880012203db8  EFLAGS: 00000002
[  418.322307] RSP: 0000:ffff880012203db8  EFLAGS: 00000002
[  418.322307] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 00000000000=
00003
[  418.322307] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 00000000000=
00003
[  418.322307] RDX: 0000000000000003 RSI: 0000000000000001 RDI: 00000000000=
00300
[  418.322307] RDX: 0000000000000003 RSI: 0000000000000001 RDI: 00000000000=
00300
[  418.322307] RBP: ffff880012203de0 R08: 0000000000000002 R09: ffffffff811=
8d1b6
[  418.322307] RBP: ffff880012203de0 R08: 0000000000000002 R09: ffffffff811=
8d1b6
[  418.322307] R10: 0000000000000046 R11: ffffffff8117cae5 R12: 00000000000=
00002
[  418.322307] R10: 0000000000000046 R11: ffffffff8117cae5 R12: 00000000000=
00002
[  418.322307] R13: 0000000000000001 R14: 0000000000000c00 R15: 00000000000=
00003
[  418.322307] R13: 0000000000000001 R14: 0000000000000c00 R15: 00000000000=
00003
[  418.322307] FS:  0000000000000000(0000) GS:ffff880012200000(0000) knlGS:=
0000000000000000
[  418.322307] FS:  0000000000000000(0000) GS:ffff880012200000(0000) knlGS:=
0000000000000000
[  418.322307] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  418.322307] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  418.322307] CR2: ffff8800127ff000 CR3: 000000000200f000 CR4: 00000000003=
006b0
[  418.322307] CR2: ffff8800127ff000 CR3: 000000000200f000 CR4: 00000000003=
006b0
[  418.322307] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  418.322307] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  418.322307] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000
[  418.322307] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000
[  418.322307] Stack:
[  418.322307] Stack:
[  418.322307]  0000000000002710
[  418.322307]  0000000000002710 ffff8800123cd230 ffff8800123cd230 00000000=
00000000 0000000000000000 0000000000000002 0000000000000002

[  418.322307]  0000000000000000
[  418.322307]  0000000000000000 ffff880012203df0 ffff880012203df0 ffffffff=
8108d7fc ffffffff8108d7fc ffff880012203e08 ffff880012203e08

[  418.322307]  ffffffff8108a130
[  418.322307]  ffffffff8108a130 ffffffff820460c0 ffffffff820460c0 ffff8800=
12203e70 ffff880012203e70 ffffffff811a63e2 ffffffff811a63e2

[  418.322307] Call Trace:
[  418.322307] Call Trace:
[  418.322307]  <IRQ>=20
[  418.322307]  <IRQ>=20

[  418.322307]=20
[  418.322307]  [<ffffffff8108d7fc>] flat_send_IPI_all+0x2e/0x67
 [<ffffffff8108d7fc>] flat_send_IPI_all+0x2e/0x67
[  418.322307]  [<ffffffff8108a130>] arch_trigger_all_cpu_backtrace+0x82/0x=
d3
[  418.322307]  [<ffffffff8108a130>] arch_trigger_all_cpu_backtrace+0x82/0x=
d3
[  418.322307]  [<ffffffff811a63e2>] rcu_check_callbacks+0x504/0xc14
[  418.322307]  [<ffffffff811a63e2>] rcu_check_callbacks+0x504/0xc14
[  418.322307]  [<ffffffff811b94c1>] ? tick_sched_handle+0x6c/0x6c
[  418.322307]  [<ffffffff811b94c1>] ? tick_sched_handle+0x6c/0x6c
[  418.322307]  [<ffffffff81122e2e>] update_process_times+0x38/0x77
[  418.322307]  [<ffffffff81122e2e>] update_process_times+0x38/0x77
[  418.322307]  [<ffffffff811b94b5>] tick_sched_handle+0x60/0x6c
[  418.322307]  [<ffffffff811b94b5>] tick_sched_handle+0x60/0x6c
[  418.322307]  [<ffffffff811b950c>] tick_sched_timer+0x4b/0x69
[  418.322307]  [<ffffffff811b950c>] tick_sched_timer+0x4b/0x69
[  418.322307]  [<ffffffff8114751b>] __run_hrtimer+0x3bd/0x690
[  418.322307]  [<ffffffff8114751b>] __run_hrtimer+0x3bd/0x690
[  418.322307]  [<ffffffff811489bc>] hrtimer_interrupt+0x17f/0x2dd
[  418.322307]  [<ffffffff811489bc>] hrtimer_interrupt+0x17f/0x2dd
[  418.322307]  [<ffffffff81087561>] local_apic_timer_interrupt+0x66/0x69
[  418.322307]  [<ffffffff81087561>] local_apic_timer_interrupt+0x66/0x69
[  418.322307]  [<ffffffff81087b50>] smp_apic_timer_interrupt+0x3a/0x4b
[  418.322307]  [<ffffffff81087b50>] smp_apic_timer_interrupt+0x3a/0x4b
[  418.322307]  [<ffffffff81940272>] apic_timer_interrupt+0x72/0x80
[  418.322307]  [<ffffffff81940272>] apic_timer_interrupt+0x72/0x80
[  418.322307]  <EOI>=20
[  418.322307]  <EOI>=20

[  418.322307]=20
[  418.322307]  [<ffffffff81161dcd>] ? local_clock+0x31/0x3a
 [<ffffffff81161dcd>] ? local_clock+0x31/0x3a
[  418.322307]  [<ffffffff811d9144>] ? ring_buffer_consume+0x130/0x161
[  418.322307]  [<ffffffff811d9144>] ? ring_buffer_consume+0x130/0x161
[  418.322307]  [<ffffffff811da62d>] ring_buffer_consumer_thread+0x14d/0x414
[  418.322307]  [<ffffffff811da62d>] ring_buffer_consumer_thread+0x14d/0x414
[  418.322307]  [<ffffffff81180445>] ? trace_hardirqs_on+0xd/0xf
[  418.322307]  [<ffffffff81180445>] ? trace_hardirqs_on+0xd/0xf
[  418.322307]  [<ffffffff811da4e0>] ? ring_buffer_producer_thread+0x52b/0x=
52b
[  418.322307]  [<ffffffff811da4e0>] ? ring_buffer_producer_thread+0x52b/0x=
52b
[  418.322307]  [<ffffffff81142f54>] kthread+0x12f/0x137
[  418.322307]  [<ffffffff81142f54>] kthread+0x12f/0x137
[  418.322307]  [<ffffffff81142e25>] ? insert_kthread_work+0xca/0xca
[  418.322307]  [<ffffffff81142e25>] ? insert_kthread_work+0xca/0xca
[  418.322307]  [<ffffffff8193f44c>] ret_from_fork+0x7c/0xb0
[  418.322307]  [<ffffffff8193f44c>] ret_from_fork+0x7c/0xb0
[  418.322307]  [<ffffffff81142e25>] ? insert_kthread_work+0xca/0xca
[  418.322307]  [<ffffffff81142e25>] ? insert_kthread_work+0xca/0xca
[  418.322307] Code:=20
[  418.322307] Code: 0f 0f 44 44 c6 c6 89 89 04 04 25 25 00 00 a3 a3 5f 5f =
ff ff 48 48 89 89 d8 d8 48 48 c1 c1 e8 e8 09 09 48 48 83 83 f0 f0 01 01 83 =
83 e0 e0 01 01 48 48 63 63 d0 d0 48 48 83 83 c2 c2 02 02 48 48 ff ff 04 04 =
d5 d5 a0 a0 b1 b1 1a 1a 82 82 85 85 c0 c0 74 74 11 11 <48> <48> 89 89 df df=
 57 57 9d 9d 66 66 66 66 90 90 66 66 90 90 e8 e8 47 47 2d 2d 0f 0f 00 00 eb=
 eb 0f 0f e8 e8 7f 7f 2c 2c 0f 0f=20

[  418.322307] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 30.115 msecs
[  418.322307] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 30.115 msecs
[  419.322862] NMI backtrace for cpu 1
[  419.322862] NMI backtrace for cpu 1
[  419.322862] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc1-00001-g=
8460434 #27
[  419.322862] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc1-00001-g=
8460434 #27
[  419.322862] task: ffff8800113f42d0 ti: ffff8800113f6000 task.ti: ffff880=
0113f6000
[  419.322862] task: ffff8800113f42d0 ti: ffff8800113f6000 task.ti: ffff880=
0113f6000
[  419.322862] RIP: 0010:[<ffffffff811803e5>]=20
[  419.322862] RIP: 0010:[<ffffffff811803e5>]  [<ffffffff811803e5>] trace_h=
ardirqs_on_caller+0x148/0x19b
 [<ffffffff811803e5>] trace_hardirqs_on_caller+0x148/0x19b
[  419.322862] RSP: 0000:ffff8800113f7cd8  EFLAGS: 00000046
[  419.322862] RSP: 0000:ffff8800113f7cd8  EFLAGS: 00000046
[  419.322862] RAX: 0000000000000001 RBX: ffff8800113f42d0 RCX: 00000061a18=
dbdcb
[  419.322862] RAX: 0000000000000001 RBX: ffff8800113f42d0 RCX: 00000061a18=
dbdcb
[  419.322862] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800113=
f42d0
[  419.322862] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800113=
f42d0
[  419.322862] RBP: ffff8800113f7ce8 R08: 0000000000000002 R09: 00000003000=
00046
[  419.322862] RBP: ffff8800113f7ce8 R08: 0000000000000002 R09: 00000003000=
00046
[  419.322862] R10: 0000000000000046 R11: 0000000000000046 R12: ffffffff819=
3dca3
[  419.322862] R10: 0000000000000046 R11: 0000000000000046 R12: ffffffff819=
3dca3
[  419.322862] R13: ffffffff8204e380 R14: 0000000000000000 R15: ffff8800113=
f42d0
[  419.322862] R13: ffffffff8204e380 R14: 0000000000000000 R15: ffff8800113=
f42d0
[  419.322862] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:=
0000000000000000
[  419.322862] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:=
0000000000000000
[  419.322862] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  419.322862] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  419.322862] CR2: 0000000000000000 CR3: 000000000200f000 CR4: 00000000003=
006a0
[  419.322862] CR2: 0000000000000000 CR3: 000000000200f000 CR4: 00000000003=
006a0
[  419.322862] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  419.322862] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  419.322862] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000
[  419.322862] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 00000000000=
00000
[  419.322862] Stack:
[  419.322862] Stack:
[  419.322862]  ffff8800125d29c0
[  419.322862]  ffff8800125d29c0 ffff8800125d29c0 ffff8800125d29c0 ffff8800=
113f7cf8 ffff8800113f7cf8 ffffffff81180445 ffffffff81180445

[  419.322862]  ffff8800113f7d10
[  419.322862]  ffff8800113f7d10 ffffffff8193dca3 ffffffff8193dca3 ffff8800=
11252190 ffff880011252190 ffff8800113f7d58 ffff8800113f7d58

[  419.322862]  ffffffff8115243e
[  419.322862]  ffffffff8115243e ffffffff81152400 ffffffff81152400 00000000=
00000001 0000000000000001 0000000000000000 0000000000000000

[  419.322862] Call Trace:
[  419.322862] Call Trace:
[  419.322862]  [<ffffffff81180445>] trace_hardirqs_on+0xd/0xf
[  419.322862]  [<ffffffff81180445>] trace_hardirqs_on+0xd/0xf
[  419.322862]  [<ffffffff8193dca3>] _raw_spin_unlock_irq+0x27/0x39
[  419.322862]  [<ffffffff8193dca3>] _raw_spin_unlock_irq+0x27/0x39
[  419.322862]  [<ffffffff8115243e>] finish_task_switch+0x129/0x248
[  419.322862]  [<ffffffff8115243e>] finish_task_switch+0x129/0x248
[  419.322862]  [<ffffffff81152400>] ? finish_task_switch+0xeb/0x248
[  419.322862]  [<ffffffff81152400>] ? finish_task_switch+0xeb/0x248
[  419.322862]  [<ffffffff8193773f>] __schedule+0xfb6/0x13eb
[  419.322862]  [<ffffffff8193773f>] __schedule+0xfb6/0x13eb
[  419.322862]  [<ffffffff8118041c>] ? trace_hardirqs_on_caller+0x17f/0x19b
[  419.322862]  [<ffffffff8118041c>] ? trace_hardirqs_on_caller+0x17f/0x19b
[  419.322862]  [<ffffffff811a730d>] ? rcu_is_nocb_cpu+0xd5/0xed
[  419.322862]  [<ffffffff811a730d>] ? rcu_is_nocb_cpu+0xd5/0xed
[  419.322862]  [<ffffffff811b9bb0>] ? tick_nohz_idle_exit+0x2da/0x2ec
[  419.322862]  [<ffffffff811b9bb0>] ? tick_nohz_idle_exit+0x2da/0x2ec
[  419.322862]  [<ffffffff8118041c>] ? trace_hardirqs_on_caller+0x17f/0x19b
[  419.322862]  [<ffffffff8118041c>] ? trace_hardirqs_on_caller+0x17f/0x19b
[  419.322862]  [<ffffffff81937bba>] schedule+0x46/0x48
[  419.322862]  [<ffffffff81937bba>] schedule+0x46/0x48
[  419.322862]  [<ffffffff81937c54>] schedule_preempt_disabled+0x11/0x1b
[  419.322862]  [<ffffffff81937c54>] schedule_preempt_disabled+0x11/0x1b
[  419.322862]  [<ffffffff8118f98c>] cpu_startup_entry+0x133/0x6a0
[  419.322862]  [<ffffffff8118f98c>] cpu_startup_entry+0x133/0x6a0
[  419.322862]  [<ffffffff81085036>] start_secondary+0x4b4/0x4c3
[  419.322862]  [<ffffffff81085036>] start_secondary+0x4b4/0x4c3
[  419.322862] Code:=20
[  419.322862] Code: 00 00 00 00 eb eb ac ac 65 65 48 48 8b 8b 1c 1c 25 25 =
00 00 b9 b9 00 00 00 00 31 31 f6 f6 c7 c7 83 83 5c 5c 07 07 00 00 00 00 01 =
01 00 00 00 00 00 00 c7 c7 83 83 28 28 07 07 00 00 00 00 01 01 00 00 00 00 =
00 00 48 48 89 89 df df e8 e8 ca ca fd fd ff ff ff ff <85> <85> c0 c0 74 74=
 37 37 83 83 bb bb 48 48 07 07 00 00 00 00 00 00 75 75 1d 1d 8b 8b 83 83 08=
 08 07 07 00 00 00 00 4c 4c 89 89=20

[  419.322862] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 38.495 msecs
[  419.322862] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 38.495 msecs
[  419.322862] INFO: rcu_sched detected stalls on CPUs/tasks:
[  419.322862] INFO: rcu_sched detected stalls on CPUs/tasks:

[  419.322862]=20
[  419.322862]=20
[  419.322862]=20
(detected by 1, t=3D26395 jiffies, g=3D2776, c=3D2775, q=3D91)
[  444.843808] ipmi_si: Adding default-specified smic state machine
[  444.843808] ipmi_si: Adding default-specified smic state machine

[  444.850487] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[  444.850487] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[  444.855974] ipmi_si: Interface detection failed
[  444.855974] ipmi_si: Interface detection failed
[  444.865035] ipmi_si: Adding default-specified bt state machine
[  444.865035] ipmi_si: Adding default-specified bt state machine

[  444.867568] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[  444.867568] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[  444.870010] ipmi_si: Interface detection failed
[  444.870010] ipmi_si: Interface detection failed
[  444.883886] ipmi_si: Unable to find any System Interface(s)
[  444.883886] ipmi_si: Unable to find any System Interface(s)
[  444.897989] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[  444.897989] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[  444.900860] ACPI: Power Button [PWRF]
[  444.900860] ACPI: Power Button [PWRF]
[  450.593544] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[  450.593544] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[  450.627563] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[  450.627563] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[  450.684502] Non-volatile memory driver v1.3
[  450.684502] Non-volatile memory driver v1.3
[  450.710874] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[  450.710874] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[  450.712795] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[  450.712795] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[  450.713880] Hangcheck: Using getrawmonotonic().
[  450.713880] Hangcheck: Using getrawmonotonic().
[  450.727635] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[  450.727635] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[  450.733883] c2port c2port0: C2 port uc added
[  450.733883] c2port c2port0: C2 port uc added
[  450.734478] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[  450.734478] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[  450.738680] mic_init not running on X100 ret -19
[  450.738680] mic_init not running on X100 ret -19
[  450.779537] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[  450.779537] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[  450.783894] Could not find PAR responsible for SC520CDP Flash Bank #0
[  450.783894] Could not find PAR responsible for SC520CDP Flash Bank #0
[  450.784825] Trying default address 0x8400000
[  450.784825] Trying default address 0x8400000
[  450.786059] Could not find PAR responsible for SC520CDP Flash Bank #1
[  450.786059] Could not find PAR responsible for SC520CDP Flash Bank #1
[  450.786945] Trying default address 0x8c00000
[  450.786945] Trying default address 0x8c00000
[  450.787713] Could not find PAR responsible for SC520CDP DIL Flash
[  450.787713] Could not find PAR responsible for SC520CDP DIL Flash
[  450.788323] Trying default address 0x9400000
[  450.788323] Trying default address 0x9400000
[  450.789697] SC520 CDP flash device: 0x800000 at 0x8400000
[  450.789697] SC520 CDP flash device: 0x800000 at 0x8400000
[  450.790522] Failed to ioremap_nocache
[  450.790522] Failed to ioremap_nocache
[  450.790799] Failed to ioremap_nocache
[  450.790799] Failed to ioremap_nocache
[  450.794828] slram: not enough parameters.
[  450.794828] slram: not enough parameters.
[  451.099457] No valid DiskOnChip devices found
[  451.099457] No valid DiskOnChip devices found
[  451.178648] libphy: Fixed MDIO Bus: probed
[  451.178648] libphy: Fixed MDIO Bus: probed
[  451.186778] vcan: Virtual CAN interface driver
[  451.186778] vcan: Virtual CAN interface driver
[  451.187885] CAN device driver interface
[  451.187885] CAN device driver interface
[  451.189697] sja1000 CAN netdevice driver
[  451.189697] sja1000 CAN netdevice driver
[  451.190417] sja1000_isa: insufficient parameters supplied
[  451.190417] sja1000_isa: insufficient parameters supplied
[  451.192482] cc770: CAN netdevice driver
[  451.192482] cc770: CAN netdevice driver
[  451.206777] YAM driver version 0.8 by F1OAT/F6FBB
[  451.206777] YAM driver version 0.8 by F1OAT/F6FBB
[  451.230679] AX.25: bpqether driver version 004
[  451.230679] AX.25: bpqether driver version 004
[  451.231316] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[  451.231316] baycom_ser_fdx: version 0.10
[  451.231316] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[  451.231316] baycom_ser_fdx: version 0.10
[  451.268705] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[  451.268705] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[  451.269639] hdlcdrv: version 0.8
[  451.269639] hdlcdrv: version 0.8
[  451.269930] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[  451.269930] baycom_ser_hdx: version 0.10
[  451.269930] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[  451.269930] baycom_ser_hdx: version 0.10
[  451.286787] PPP generic driver version 2.4.2
[  451.286787] PPP generic driver version 2.4.2
[  451.300837] PPP BSD Compression module registered
[  451.300837] PPP BSD Compression module registered
[  451.301484] NET: Registered protocol family 24
[  451.301484] NET: Registered protocol family 24
[  451.302968] adummy: version 1.0
[  451.302968] adummy: version 1.0
[  451.311163] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[  451.311163] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[  451.328425] serio: i8042 KBD port at 0x60,0x64 irq 1
[  451.328425] serio: i8042 KBD port at 0x60,0x64 irq 1
[  451.330475] serio: i8042 AUX port at 0x60,0x64 irq 12
[  451.330475] serio: i8042 AUX port at 0x60,0x64 irq 12
[  451.374766] mousedev: PS/2 mouse device common for all mice
[  451.374766] mousedev: PS/2 mouse device common for all mice
[  451.413911] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[  451.413911] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[  451.552477] rtc-test rtc-test.0: rtc core: registered test as rtc0
[  451.552477] rtc-test rtc-test.0: rtc core: registered test as rtc0
[  451.572645] rtc-test rtc-test.1: rtc core: registered test as rtc1
[  451.572645] rtc-test rtc-test.1: rtc core: registered test as rtc1
[  451.588910] i2c-parport-light: adapter type unspecified
[  451.588910] i2c-parport-light: adapter type unspecified
[  451.590771] smssdio: Siano SMS1xxx SDIO driver
[  451.590771] smssdio: Siano SMS1xxx SDIO driver
[  451.591437] smssdio: Copyright Pierre Ossman
[  451.591437] smssdio: Copyright Pierre Ossman
[  451.607883] pps pps0: new PPS source ktimer
[  451.607883] pps pps0: new PPS source ktimer
[  451.608735] pps pps0: ktimer PPS source registered
[  451.608735] pps pps0: ktimer PPS source registered
[  451.611767] Driver for 1-wire Dallas network protocol.
[  451.611767] Driver for 1-wire Dallas network protocol.
[  451.618863] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[  451.618863] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[  451.623898] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[  451.623898] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[  451.807643] pc87360: PC8736x not detected, module not inserted
[  451.807643] pc87360: PC8736x not detected, module not inserted
[  451.824908] intel_powerclamp: Intel powerclamp does not run on family 6 =
model 2
[  451.824908] intel_powerclamp: Intel powerclamp does not run on family 6 =
model 2
[  451.827861] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[  451.827861] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[  451.844533] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[  451.844533] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[  451.847868] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[  451.847868] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[  451.849862] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[  451.849862] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[  451.859994] ib700wdt: START method I/O 443 is not available
[  451.859994] ib700wdt: START method I/O 443 is not available
[  451.860868] ib700wdt: probe of ib700wdt failed with error -5
[  451.860868] ib700wdt: probe of ib700wdt failed with error -5
[  451.862699] it87_wdt: no device
[  451.862699] it87_wdt: no device
[  451.864783] sc1200wdt: build 20020303
[  451.864783] sc1200wdt: build 20020303
[  451.866496] sc1200wdt: io parameter must be specified
[  451.866496] sc1200wdt: io parameter must be specified
[  451.867798] pc87413_wdt: Version 1.1 at io 0x2E
[  451.867798] pc87413_wdt: Version 1.1 at io 0x2E
[  451.868514] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[  451.868514] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[  451.869015] sbc60xxwdt: I/O address 0x0443 already in use
[  451.869015] sbc60xxwdt: I/O address 0x0443 already in use
[  451.869793] sbc8360: failed to register misc device
[  451.869793] sbc8360: failed to register misc device
[  451.870453] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[  451.870453] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[  451.872499] smsc37b787_wdt: Unable to register miscdev on minor 130
[  451.872499] smsc37b787_wdt: Unable to register miscdev on minor 130
[  451.873568] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[  451.873568] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[  451.874020] w83697hf_wdt: watchdog not found at address 0x2e
[  451.874020] w83697hf_wdt: watchdog not found at address 0x2e
[  451.874754] w83697hf_wdt: No W83697HF/HG could be found
[  451.874754] w83697hf_wdt: No W83697HF/HG could be found
[  451.875321] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[  451.875321] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[  451.875949] w83697ug_wdt: No W83697UG/UF could be found
[  451.875949] w83697ug_wdt: No W83697UG/UF could be found
[  451.876736] w83877f_wdt: I/O address 0x0443 already in use
[  451.876736] w83877f_wdt: I/O address 0x0443 already in use
[  451.877607] machzwd: MachZ ZF-Logic Watchdog driver initializing
[  451.877607] machzwd: MachZ ZF-Logic Watchdog driver initializing
[  451.877905] machzwd: no ZF-Logic found
[  451.877905] machzwd: no ZF-Logic found
[  451.884999] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[  451.884999] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[  451.885970] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[  451.885970] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[  451.896114] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[  451.896114] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[  451.898109] sdhci: Secure Digital Host Controller Interface driver
[  451.898109] sdhci: Secure Digital Host Controller Interface driver
[  451.899508] sdhci: Copyright(c) Pierre Ossman
[  451.899508] sdhci: Copyright(c) Pierre Ossman
[  451.901780] sdhci-pltfm: SDHCI platform and OF driver helper
[  451.901780] sdhci-pltfm: SDHCI platform and OF driver helper
[  451.933911] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[  451.933911] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[  461.114680] NET: Registered protocol family 26
[  461.114680] NET: Registered protocol family 26
[  461.119162] Netfilter messages via NETLINK v0.30.
[  461.119162] Netfilter messages via NETLINK v0.30.
[  461.124819] nfnl_acct: registering with nfnetlink.
[  461.124819] nfnl_acct: registering with nfnetlink.
[  462.133703] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[  462.133703] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[  463.203351] xt_time: kernel timezone is -0000
[  463.203351] xt_time: kernel timezone is -0000
[  463.205412] IPVS: Registered protocols (TCP, UDP, ESP)
[  463.205412] IPVS: Registered protocols (TCP, UDP, ESP)
[  463.213871] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[  463.213871] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[  463.215887] IPVS: Each connection entry needs 416 bytes at least
[  463.215887] IPVS: Each connection entry needs 416 bytes at least
[  463.221801] IPVS: Creating netns size=3D2120 id=3D0
[  463.221801] IPVS: Creating netns size=3D2120 id=3D0
[  463.229463] IPVS: ipvs loaded.
[  463.229463] IPVS: ipvs loaded.
[  463.231301] IPVS: [rr] scheduler registered.
[  463.231301] IPVS: [rr] scheduler registered.
[  463.231698] IPVS: [wlc] scheduler registered.
[  463.231698] IPVS: [wlc] scheduler registered.
[  463.233327] IPVS: [lblc] scheduler registered.
[  463.233327] IPVS: [lblc] scheduler registered.
[  463.233718] IPVS: [sh] scheduler registered.
[  463.233718] IPVS: [sh] scheduler registered.
[  463.234175] IPVS: [nq] scheduler registered.
[  463.234175] IPVS: [nq] scheduler registered.
[  463.235641] ipip: IPv4 over IPv4 tunneling driver
[  463.235641] ipip: IPv4 over IPv4 tunneling driver
[  463.253450] IPv4 over IPSec tunneling driver
[  463.253450] IPv4 over IPSec tunneling driver
[  463.275966] TCP: cubic registered
[  463.275966] TCP: cubic registered
[  463.277884] NET: Registered protocol family 17
[  463.277884] NET: Registered protocol family 17
[  464.290728] NET: Registered protocol family 15
[  464.290728] NET: Registered protocol family 15
[  464.306780] Bridge firewalling registered
[  464.306780] Bridge firewalling registered
[  464.310688] Ebtables v2.0 registered
[  464.310688] Ebtables v2.0 registered
[  464.356572] NET: Registered protocol family 4
[  464.356572] NET: Registered protocol family 4
[  464.362678] NET: Registered protocol family 5
[  464.362678] NET: Registered protocol family 5
[  464.366468] NET: Registered protocol family 9
[  464.366468] NET: Registered protocol family 9
[  464.367225] X25: Linux Version 0.2
[  464.367225] X25: Linux Version 0.2
[  464.368813] NET: Registered protocol family 3
[  464.368813] NET: Registered protocol family 3
[  464.370749] can: controller area network core (rev 20120528 abi 9)
[  464.370749] can: controller area network core (rev 20120528 abi 9)
[  464.380662] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[  464.380662] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[  464.382544] NET: Registered protocol family 29
[  464.382544] NET: Registered protocol family 29
[  464.384518] can: raw protocol (rev 20120528)
[  464.384518] can: raw protocol (rev 20120528)
[  464.386864] can: netlink gateway (rev 20130117) max_hops=3D1
[  464.386864] can: netlink gateway (rev 20130117) max_hops=3D1
[  464.414692] NET: Registered protocol family 33
[  464.414692] NET: Registered protocol family 33
[  464.416491] Key type rxrpc registered
[  464.416491] Key type rxrpc registered
[  464.416893] Key type rxrpc_s registered
[  464.416893] Key type rxrpc_s registered
[  464.420971] lec:lane_module_init: lec.c: initialized
[  464.420971] lec:lane_module_init: lec.c: initialized
[  464.422834] mpoa:atm_mpoa_init: mpc.c: initialized
[  464.422834] mpoa:atm_mpoa_init: mpc.c: initialized
[  464.424698] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[  464.424698] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[  464.452466] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[  464.452466] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[  464.454753] NET: Registered protocol family 12
[  464.454753] NET: Registered protocol family 12
[  464.462503] 8021q: 802.1Q VLAN Support v1.8
[  464.462503] 8021q: 802.1Q VLAN Support v1.8
[  464.509011] DCCP: Activated CCID 2 (TCP-like)
[  464.509011] DCCP: Activated CCID 2 (TCP-like)
[  464.570938] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[  464.570938] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[  464.572839] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[  464.572839] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[  464.584650] Registered RDS/tcp transport
[  464.584650] Registered RDS/tcp transport
[  464.600796] lib80211: common routines for IEEE802.11 drivers
[  464.600796] lib80211: common routines for IEEE802.11 drivers
[  464.602732] lib80211_crypt: registered algorithm 'NULL'
[  464.602732] lib80211_crypt: registered algorithm 'NULL'
[  464.604429] lib80211_crypt: registered algorithm 'WEP'
[  464.604429] lib80211_crypt: registered algorithm 'WEP'
[  464.604775] lib80211_crypt: registered algorithm 'CCMP'
[  464.604775] lib80211_crypt: registered algorithm 'CCMP'
[  464.606409] lib80211_crypt: registered algorithm 'TKIP'
[  464.606409] lib80211_crypt: registered algorithm 'TKIP'
[  464.606735] tipc: Activated (version 2.0.0)
[  464.606735] tipc: Activated (version 2.0.0)
[  464.660451] NET: Registered protocol family 30
[  464.660451] NET: Registered protocol family 30
[  464.708432] tipc: Started in single node mode
[  464.708432] tipc: Started in single node mode
[  464.718620] NET: Registered protocol family 37
[  464.718620] NET: Registered protocol family 37
[  464.728526] NET: Registered protocol family 36
[  464.728526] NET: Registered protocol family 36
[  464.744662] Key type dns_resolver registered
[  464.744662] Key type dns_resolver registered
[  464.766626] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[  464.766626] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[  464.768570] openvswitch: Open vSwitch switching datapath
[  464.768570] openvswitch: Open vSwitch switching datapath
[  464.798442] mpls_gso: MPLS GSO support
[  464.798442] mpls_gso: MPLS GSO support
[  464.812472]=20
[  464.812472] printing PIC contents
[  464.812472]=20
[  464.812472] printing PIC contents
[  464.812921] ... PIC  IMR: ffff
[  464.812921] ... PIC  IMR: ffff
[  464.813216] ... PIC  IRR: 1013
[  464.813216] ... PIC  IRR: 1013
[  464.814855] ... PIC  ISR: 0000
[  464.814855] ... PIC  ISR: 0000
[  464.816433] ... PIC ELCR: 0c00
[  464.816433] ... PIC ELCR: 0c00
[  464.816333] printing local APIC contents on CPU#0/0:
[  464.816333] printing local APIC contents on CPU#0/0:
[  464.816333] ... APIC ID:      00000000 (0)
[  464.816333] ... APIC ID:      00000000 (0)
[  464.816333] ... APIC VERSION: 00050011
[  464.816333] ... APIC VERSION: 00050011
[  464.816333] ... APIC TASKPRI: 00000000 (00)
[  464.816333] ... APIC TASKPRI: 00000000 (00)
[  464.816333] ... APIC ARBPRI: 00000000 (00)
[  464.816333] ... APIC ARBPRI: 00000000 (00)
[  464.816333] ... APIC PROCPRI: 00000000
[  464.816333] ... APIC PROCPRI: 00000000
[  464.816333] ... APIC LDR: 01000000
[  464.816333] ... APIC LDR: 01000000
[  464.816333] ... APIC DFR: f0000000
[  464.816333] ... APIC DFR: f0000000
[  464.816333] ... APIC SPIV: 000001ff
[  464.816333] ... APIC SPIV: 000001ff
[  464.816333] ... APIC ISR field:
[  464.816333] ... APIC ISR field:
[  464.816333] 00000000
[  464.816333] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[  464.816333] ... APIC TMR field:
[  464.816333] ... APIC TMR field:
[  464.816333] 00000000
[  464.816333] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[  464.816333] ... APIC IRR field:
[  464.816333] ... APIC IRR field:
[  464.816333] 00000000
[  464.816333] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[  464.816333] ... APIC ESR: 00000000
[  464.816333] ... APIC ESR: 00000000
[  464.816333] ... APIC ICR: 000400f6
[  464.816333] ... APIC ICR: 000400f6
[  464.816333] ... APIC ICR2: 02000000
[  464.816333] ... APIC ICR2: 02000000
[  464.816333] ... APIC LVTT: 000000ef
[  464.816333] ... APIC LVTT: 000000ef
[  464.816333] ... APIC LVTPC: 00010000
[  464.816333] ... APIC LVTPC: 00010000
[  464.816333] ... APIC LVT0: 00010700
[  464.816333] ... APIC LVT0: 00010700
[  464.816333] ... APIC LVT1: 00000400
[  464.816333] ... APIC LVT1: 00000400
[  464.816333] ... APIC LVTERR: 000000fe
[  464.816333] ... APIC LVTERR: 000000fe
[  464.816333] ... APIC TMICT: 000085f4
[  464.816333] ... APIC TMICT: 000085f4
[  464.816333] ... APIC TMCCT: 00000000
[  464.816333] ... APIC TMCCT: 00000000
[  464.816333] ... APIC TDCR: 00000003
[  464.816333] ... APIC TDCR: 00000003
[  464.816333]=20
[  464.816333]=20
[  464.828705] number of MP IRQ sources: 15.
[  464.828705] number of MP IRQ sources: 15.
[  464.829426] number of IO-APIC #0 registers: 24.
[  464.829426] number of IO-APIC #0 registers: 24.
[  464.830727] testing the IO APIC.......................
[  464.830727] testing the IO APIC.......................
[  464.832528] IO APIC #0......
[  464.832528] IO APIC #0......
[  464.832800] .... register #00: 00000000
[  464.832800] .... register #00: 00000000
[  464.834446] .......    : physical APIC id: 00
[  464.834446] .......    : physical APIC id: 00
[  464.834823] .......    : Delivery Type: 0
[  464.834823] .......    : Delivery Type: 0
[  464.836459] .......    : LTS          : 0
[  464.836459] .......    : LTS          : 0
[  464.836816] .... register #01: 00170011
[  464.836816] .... register #01: 00170011
[  464.838409] .......     : max redirection entries: 17
[  464.838409] .......     : max redirection entries: 17
[  464.838847] .......     : PRQ implemented: 0
[  464.838847] .......     : PRQ implemented: 0
[  464.840476] .......     : IO APIC version: 11
[  464.840476] .......     : IO APIC version: 11
[  464.840868] .... register #02: 00000000
[  464.840868] .... register #02: 00000000
[  464.842494] .......     : arbitration: 00
[  464.842494] .......     : arbitration: 00
[  464.842848] .... IRQ redirection table:
[  464.842848] .... IRQ redirection table:
[  464.844619] 1    0    0   0   0    0    0    00
[  464.844619] 1    0    0   0   0    0    0    00
[  464.844983] 0    0    0   0   0    1    1    31
[  464.844983] 0    0    0   0   0    1    1    31
[  464.846689] 0    0    0   0   0    1    1    30
[  464.846689] 0    0    0   0   0    1    1    30
[  464.847476] 0    0    0   0   0    1    1    33
[  464.847476] 0    0    0   0   0    1    1    33
[  464.848718] 1    0    0   0   0    1    1    34
[  464.848718] 1    0    0   0   0    1    1    34
[  464.850399] 1    1    0   0   0    1    1    35
[  464.850399] 1    1    0   0   0    1    1    35
[  464.850785] 0    0    0   0   0    1    1    36
[  464.850785] 0    0    0   0   0    1    1    36
[  464.852444] 0    0    0   0   0    1    1    37
[  464.852444] 0    0    0   0   0    1    1    37
[  464.852884] 0    0    0   0   0    1    1    38
[  464.852884] 0    0    0   0   0    1    1    38
[  464.854574] 0    1    0   0   0    1    1    39
[  464.854574] 0    1    0   0   0    1    1    39
[  464.854962] 1    1    0   0   0    1    1    3A
[  464.854962] 1    1    0   0   0    1    1    3A
[  464.856665] 1    1    0   0   0    1    1    3B
[  464.856665] 1    1    0   0   0    1    1    3B
[  464.857007] 0    0    0   0   0    1    1    3C
[  464.857007] 0    0    0   0   0    1    1    3C
[  464.858705] 0    0    0   0   0    1    1    3D
[  464.858705] 0    0    0   0   0    1    1    3D
[  464.860369] 0    0    0   0   0    1    1    3E
[  464.860369] 0    0    0   0   0    1    1    3E
[  464.860764] 0    0    0   0   0    1    1    3F
[  464.860764] 0    0    0   0   0    1    1    3F
[  464.862428] 1    0    0   0   0    0    0    00
[  464.862428] 1    0    0   0   0    0    0    00
[  464.862822] 1    0    0   0   0    0    0    00
[  464.862822] 1    0    0   0   0    0    0    00
[  464.864494] 1    0    0   0   0    0    0    00
[  464.864494] 1    0    0   0   0    0    0    00
[  464.864898] 1    0    0   0   0    0    0    00
[  464.864898] 1    0    0   0   0    0    0    00
[  464.866566] 1    0    0   0   0    0    0    00
[  464.866566] 1    0    0   0   0    0    0    00
[  464.866977] 1    0    0   0   0    0    0    00
[  464.866977] 1    0    0   0   0    0    0    00
[  464.868682] 1    0    0   0   0    0    0    00
[  464.868682] 1    0    0   0   0    0    0    00
[  464.870338] 1    0    0   0   0    0    0    00
[  464.870338] 1    0    0   0   0    0    0    00
[  464.870726] IRQ to pin mappings:
[  464.870726] IRQ to pin mappings:
[  464.872424] IRQ0=20
[  464.872424] IRQ0 -> 0:2-> 0:2

[  464.872806] IRQ1=20
[  464.872806] IRQ1 -> 0:1-> 0:1

[  464.874442] IRQ3=20
[  464.874442] IRQ3 -> 0:3-> 0:3

[  464.874744] IRQ4=20
[  464.874744] IRQ4 -> 0:4-> 0:4

[  464.876340] IRQ5=20
[  464.876340] IRQ5 -> 0:5-> 0:5

[  464.876651] IRQ6=20
[  464.876651] IRQ6 -> 0:6-> 0:6

[  464.876937] IRQ7=20
[  464.876937] IRQ7 -> 0:7-> 0:7

[  464.878648] IRQ8=20
[  464.878648] IRQ8 -> 0:8-> 0:8

[  464.878948] IRQ9=20
[  464.878948] IRQ9 -> 0:9-> 0:9

[  464.880536] IRQ10=20
[  464.880536] IRQ10 -> 0:10-> 0:10

[  464.880866] IRQ11=20
[  464.880866] IRQ11 -> 0:11-> 0:11

[  464.882464] IRQ12=20
[  464.882464] IRQ12 -> 0:12-> 0:12

[  464.882799] IRQ13=20
[  464.882799] IRQ13 -> 0:13-> 0:13

[  464.884395] IRQ14=20
[  464.884395] IRQ14 -> 0:14-> 0:14

[  464.884713] IRQ15=20
[  464.884713] IRQ15 -> 0:15-> 0:15

[  464.885007] .................................... done.
[  464.885007] .................................... done.
[  466.956486] bootconsole [earlyser0] disabled
[  466.956486] bootconsole [earlyser0] disabled
[  466.964629] registered taskstats version 1
[  467.055746] Key type trusted registered
[  467.113914] Key type encrypted registered
[  475.305938] rtc-test rtc-test.0: setting system clock to 2014-02-16 08:0=
4:53 UTC (1392537893)
[  475.308495] ALSA device list:
[  475.308722]   No soundcards found.
[  475.354626] debug: unmapping init [mem 0xffffffff8257a000-0xffffffff8283=
9fff]
[  475.369450] Write protecting the kernel read-only data: 16384k
[  475.407706] debug: unmapping init [mem 0xffff880001945000-0xffff8800019f=
ffff]
[  475.415487] debug: unmapping init [mem 0xffff880001fd1000-0xffff880001ff=
ffff]
[  483.758193] random: init urandom read with 28 bits of entropy available
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[  538.835704] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertio=
n `loop->epoll_fd >=3D 0' failed.
/etc/lsb-base-logging.sh: line 5:   164 Aborted                 plymouth --=
ping > /dev/null 2>&1
 * Asking all remaining processes to terminate...      =20
killall5[167]: mount returned non-zero exit status
killall5[167]: /proc not mounted, failed to mount.
/etc/lsb-base-logging.sh: line 5:   169 Aborted                 plymouth --=
ping > /dev/null 2>&1

mount: proc has wrong device number or fs type proc not supported
killall5[175]: mount returned non-zero exit status
killall5[175]: /proc not mounted, failed to mount.
/etc/lsb-base-logging.sh: line 5:   185 Aborted                 plymouth --=
ping > /dev/null 2>&1
 * All processes ended within 1 seconds....      =20

/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
mount: / is busy
 * Will now restart
[  660.438240] reboot: Restarting system
[  660.441272] reboot: machine restart
Elapsed time: 720
qemu-system-x86_64 -cpu qemu64,+smep,+smap -kernel /kernel/x86_64-randconfi=
g-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-3.14.0-rc1-00001=
-g8460434 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug api=
c=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dno=
rmal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randcon=
fig-c4-0212/wq:for-3.14-fixes:84604340d034a074036e86e85c4055a1c7ea5529:bise=
ct-net/.vmlinuz-84604340d034a074036e86e85c4055a1c7ea5529-20140216075356-10-=
waimea branch=3Dwq/for-3.14-fixes BOOT_IMAGE=3D/kernel/x86_64-randconfig-c4=
-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-3.14.0-rc1-00001-g84=
60434'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 =
-net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::31168-:22=
 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -soun=
dhw hda -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-waimea-2,media=3Ddisk,i=
f=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-waimea-2,media=3Ddis=
k,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-waimea-2,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-waimea-2,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-waimea-2,me=
dia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-waimea-2=
,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-waimea-2 -ser=
ial file:/dev/shm/kboot/serial-quantal-waimea-2 -daemonize -display none -m=
onitor null=20

--9jxsPFA5p3P2qPhR--
