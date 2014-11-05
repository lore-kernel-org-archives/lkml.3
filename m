Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaKEJ7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:59:06 -0500
Received: from 8bytes.org ([81.169.241.247]:40034 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbaKEJ6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:58:53 -0500
Date: Wed, 5 Nov 2014 10:58:50 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch Part2 v4 00/31] Enable hierarchy irqdomian on x86
 platforms
Message-ID: <20141105095850.GH10744@8bytes.org>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
 <20141104144730.GE14512@8bytes.org>
 <5458ECF3.4040308@linux.intel.com>
 <20141105085154.GG10744@8bytes.org>
 <5459F0DE.6000307@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <5459F0DE.6000307@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 05, 2014 at 05:41:50PM +0800, Jiang Liu wrote:
> 	Could you please help to apply the attached patch and send me
> console outputs?

Sure, here it is.


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kv-boot.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.0-rc3+ (joro@kv) (gcc version 4.8.1 20130909 [gcc-4_8-branch revision 202388] (SUSE Linux) ) #5 SMP PREEMPT Wed Nov 5 10:52:24 CET 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc3+ root=UUID=fb121574-ea39-49a2-a896-0750eff9d30d resume=/dev/disk/by-id/ata-KINGSTON_SV300S37A120G_50026B773C03A9A5-part1 showopts amd_iommu_dump console=ttyS0,115200 console=tty0
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007cb72fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007cb73000-0x000000007cba2fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007cba3000-0x000000007ce65fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ce66000-0x000000007cf33fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007cf34000-0x000000007e1c8fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007e1c9000-0x000000007e1c9fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007e1ca000-0x000000007e3cffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007e3d0000-0x000000007e850fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007e851000-0x000000007efe1fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007efe2000-0x000000007effffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x43f000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7f000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd6c0-0x000fd6cf] mapped at [ffff8800000fd6c0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x43ee00000-0x43effffff]
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43edfffff]
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7cb72fff]
[    0.000000] init_memory_mapping: [mem 0x7cba3000-0x7ce65fff]
[    0.000000] init_memory_mapping: [mem 0x7e1c9000-0x7e1c9fff]
[    0.000000] init_memory_mapping: [mem 0x7e3d0000-0x7e850fff]
[    0.000000] init_memory_mapping: [mem 0x7efe2000-0x7effffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000] RAMDISK: [mem 0x3322a000-0x3590cfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x000000007CEEA080 000084 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000007CEF0340 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20140926/tbfadt-649)
[    0.000000] ACPI: DSDT 0x000000007CEEA1A0 0061A0 (v02 ALASKA A M I    00000088 INTL 20051117)
[    0.000000] ACPI: FACS 0x000000007CF29080 000040
[    0.000000] ACPI: APIC 0x000000007CEF0450 00007E (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000007CEF04D0 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x000000007CEF0518 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 0x000000007CEF0558 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.000000] ACPI: WDRT 0x000000007CEF0590 000047 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.000000] ACPI: IVRS 0x000000007CEF05D8 000078 (v02 AMD    BANTRY   00000001 AMD  00000000)
[    0.000000] ACPI: SSDT 0x000000007CEF0650 000B9C (v01 AMD    BANTRY   00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 0x000000007CEF11F0 00033B (v02 AMD    BANTRY   00000002 MSFT 04000000)
[    0.000000] ACPI: CRAT 0x000000007CEF1530 0005A0 (v01 AMD    BANTRY   00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 0x000000007CEF1AD0 001457 (v01 AMD    CPMDFIGP 00000001 INTL 20051117)
[    0.000000] ACPI: SSDT 0x000000007CEF2F28 00122C (v01 AMD    CPMCMN   00000001 INTL 20051117)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000043effffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x43efe7000-0x43effafff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x7cb72fff]
[    0.000000]   node   0: [mem 0x7cba3000-0x7ce65fff]
[    0.000000]   node   0: [mem 0x7e1c9000-0x7e1c9fff]
[    0.000000]   node   0: [mem 0x7e3d0000-0x7e850fff]
[    0.000000]   node   0: [mem 0x7efe2000-0x7effffff]
[    0.000000]   node   0: [mem 0x100000000-0x43effffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x43effffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 1, version 33, address 0xfec01000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7cb73000-0x7cba2fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ce66000-0x7cf33fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7cf34000-0x7e1c8fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7e1ca000-0x7e3cffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7e851000-0x7efe1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec02000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x7f000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff88043ec00000 s83648 r8192 d31040 u524288
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 3862836
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc3+ root=UUID=fb121574-ea39-49a2-a896-0750eff9d30d resume=/dev/disk/by-id/ata-KINGSTON_SV300S37A120G_50026B773C03A9A5-part1 showopts amd_iommu_dump console=ttyS0,115200 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] AGP: Node 0: aperture [bus addr 0x00000000-0x01ffffff] (32MB)
[    0.000000] AGP: Your BIOS doesn't leave a aperture memory hole
[    0.000000] AGP: Please enable the IOMMU option in the BIOS setup
[    0.000000] AGP: This costs you 64MB of RAM
[    0.000000] AGP: Mapping aperture over RAM [mem 0x74000000-0x77ffffff] (65536KB)
[    0.000000] PM: Registered nosave memory: [mem 0x74000000-0x77ffffff]
[    0.000000] Memory: 15262208K/15665612K available (6243K kernel code, 830K rwdata, 2848K rodata, 1328K init, 1528K bss, 403404K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:33024 nr_irqs:1000 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3693.331 MHz processor
[    0.000022] Calibrating delay loop (skipped), value calculated using timer frequency.. 7386.66 BogoMIPS (lpj=3693331)
[    0.010762] pid_max: default: 32768 minimum: 301
[    0.015447] ACPI: Core revision 20140926
[    0.024757] ACPI: All ACPI Tables successfully acquired
[    0.031767] Security Framework initialized
[    0.035966] AppArmor: AppArmor initialized
[    0.041012] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.052731] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.062030] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.069018] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.076706] Initializing cgroup subsys memory
[    0.081226] Initializing cgroup subsys devices
[    0.085730] Initializing cgroup subsys freezer
[    0.090231] Initializing cgroup subsys net_cls
[    0.094734] Initializing cgroup subsys blkio
[    0.099063] Initializing cgroup subsys perf_event
[    0.103824] Initializing cgroup subsys hugetlb
[    0.108346] CPU: Physical Processor ID: 0
[    0.112413] CPU: Processor Core ID: 0
[    0.116136] mce: CPU supports 7 MCE banks
[    0.120210] LVT offset 1 assigned for vector 0xf9
[    0.124972] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.124972] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
[    0.138536] Freeing SMP alternatives memory: 24K (ffffffff81e1d000 - ffffffff81e23000)
[    0.147712] AMD-Vi: device: 00:00.2 cap: 0040 seg: 0 flags: b8 info 0000
[    0.154537] AMD-Vi:        mmio-addr: 00000000feb80000
[    0.159749] AMD-Vi:   DEV_SELECT_RANGE_START	 devid: 00:01.0 flags: 00
[    0.166331] AMD-Vi:   DEV_RANGE_END		 devid: ff:1f.6
[    0.171909] AMD-Vi:   DEV_ALIAS_RANGE		 devid: 02:00.0 flags: 00 devid_to: 00:14.4
[    0.179570] AMD-Vi:   DEV_RANGE_END		 devid: 02:1f.7
[    0.184595] AMD-Vi:   DEV_SPECIAL(HPET[0])		devid: 00:14.0
[    0.190133] AMD-Vi:   DEV_SPECIAL(IOAPIC[0])		devid: 00:14.0
[    0.195882] AMD-Vi:   DEV_SPECIAL(IOAPIC[1])		devid: 00:00.0
[    0.281157] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.297248] smpboot: CPU0: AMD A10-7850K Radeon R7, 12 Compute Cores 4C+8G (fam: 15, model: 30, stepping: 01)
[    0.408654] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.415209] ... version:                0
[    0.419277] ... bit width:              48
[    0.423424] ... generic registers:      6
[    0.427495] ... value mask:             0000ffffffffffff
[    0.432863] ... max period:             00007fffffffffff
[    0.438231] ... fixed-purpose events:   0
[    0.442300] ... event mask:             000000000000003f
[    0.455818] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.465881] x86: Booting SMP configuration:
[    0.470161] .... node  #0, CPUs:      #1 #2 #3
[    0.517125] x86: Booted up 1 node, 4 CPUs
[    0.521511] smpboot: Total of 4 processors activated (29546.64 BogoMIPS)
[    0.529044] devtmpfs: initialized
[    0.535817] PM: Registering ACPI NVS region [mem 0x7ce66000-0x7cf33fff] (843776 bytes)
[    0.543897] PM: Registering ACPI NVS region [mem 0x7e1ca000-0x7e3cffff] (2121728 bytes)
[    0.552409] RTC time:  9:54:55, date: 11/05/14
[    0.557072] NET: Registered protocol family 16
[    0.564563] cpuidle: using governor ladder
[    0.571554] cpuidle: using governor menu
[    0.575733] ACPI: bus type PCI registered
[    0.579835] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.586410] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.595818] PCI: not using MMCONFIG
[    0.599368] PCI: Using configuration type 1 for base access
[    0.604995] PCI: Using configuration type 1 for extended access
[    0.611441] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.617791] mtrr: probably your BIOS does not setup all CPUs.
[    0.623592] mtrr: corrected configuration.
[    0.632001] ACPI: Added _OSI(Module Device)
[    0.636307] ACPI: Added _OSI(Processor Device)
[    0.640809] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.645569] ACPI: Added _OSI(Processor Aggregator Device)
[    0.652898] ACPI: Executed 1 blocks of module-level executable AML code
[    0.663767] ACPI: Interpreter enabled
[    0.667523] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.676966] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.686380] ACPI: (supports S0 S3 S4 S5)
[    0.690361] ACPI: Using IOAPIC for interrupt routing
[    0.695534] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.704980] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.714154] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.723910] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.732044] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.740140] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.780225] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.786502] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.795058] acpi PNP0A03:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.803458] acpi PNP0A03:00: host bridge window [0x0-0x0] (ignored, not CPU addressable)
[    0.811926] PCI host bridge to bus 0000:00
[    0.816084] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.821622] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.827893] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.834126] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.840359] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.846593] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.853522] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.860482] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
[    0.868258] pci 0000:00:03.1: System wakeup disabled by ACPI
[    0.874286] pci 0000:00:10.0: System wakeup disabled by ACPI
[    0.880248] pci 0000:00:10.1: System wakeup disabled by ACPI
[    0.886258] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.892178] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.898058] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.903931] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.909983] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.915976] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.921832] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.930037] pci 0000:00:03.1: PCI bridge to [bus 01]
[    0.935168] pci 0000:00:14.4: PCI bridge to [bus 02] (subtractive decode)
[    0.942834] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
[    0.950040] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
[    0.957262] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
[    0.964463] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
[    0.971696] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
[    0.978888] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
[    0.986099] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
[    0.993303] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
[    1.000829] vgaarb: setting as boot device: PCI:0000:00:01.0
[    1.006603] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    1.014793] vgaarb: loaded
[    1.017556] vgaarb: bridge control possible 0000:00:01.0
[    1.023081] SCSI subsystem initialized
[    1.026983] ACPI: bus type USB registered
[    1.031067] usbcore: registered new interface driver usbfs
[    1.036614] usbcore: registered new interface driver hub
[    1.042039] usbcore: registered new device driver usb
[    1.047276] PCI: Using ACPI for IRQ routing
[    1.058253] NetLabel: Initializing
[    1.061715] NetLabel:  domain hash size = 128
[    1.066121] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.071145] NetLabel:  unlabeled traffic allowed by default
[    1.076802] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.081924] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    1.089926] Switched to clocksource hpet
[    1.096389] AppArmor: AppArmor Filesystem Enabled
[    1.101253] pnp: PnP ACPI init
[    1.104510] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    1.111335] system 00:01: [mem 0x80000000-0xbfffffff] has been reserved
[    1.118078] system 00:02: [mem 0xfeb80000-0xfebfffff] could not be reserved
[    1.125346] system 00:03: [io  0x0220-0x0227] has been reserved
[    1.131395] system 00:03: [io  0x0228-0x0237] has been reserved
[    1.137368] system 00:03: [io  0x0a20-0x0a2f] has been reserved
[    1.144382] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    1.150687] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    1.156728] system 00:09: [io  0x040b] has been reserved
[    1.162132] system 00:09: [io  0x04d6] has been reserved
[    1.167500] system 00:09: [io  0x0c00-0x0c01] has been reserved
[    1.173511] system 00:09: [io  0x0c14] has been reserved
[    1.178912] system 00:09: [io  0x0c50-0x0c51] has been reserved
[    1.184885] system 00:09: [io  0x0c52] has been reserved
[    1.190290] system 00:09: [io  0x0c6c] has been reserved
[    1.195691] system 00:09: [io  0x0c6f] has been reserved
[    1.201060] system 00:09: [io  0x0cd0-0x0cd1] has been reserved
[    1.207069] system 00:09: [io  0x0cd2-0x0cd3] has been reserved
[    1.213078] system 00:09: [io  0x0cd4-0x0cd5] has been reserved
[    1.219054] system 00:09: [io  0x0cd6-0x0cd7] has been reserved
[    1.225061] system 00:09: [io  0x0cd8-0x0cdf] has been reserved
[    1.231072] system 00:09: [io  0x0800-0x089f] could not be reserved
[    1.237390] system 00:09: [io  0x0b20-0x0b3f] has been reserved
[    1.243402] system 00:09: [io  0x0900-0x090f] has been reserved
[    1.249376] system 00:09: [io  0x0910-0x091f] has been reserved
[    1.255350] system 00:09: [io  0xfe00-0xfefe] has been reserved
[    1.261359] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.268372] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.275074] system 00:09: [mem 0xfed80000-0xfed8ffff] has been reserved
[    1.281776] system 00:09: [mem 0xfed61000-0xfed70fff] has been reserved
[    1.288442] system 00:09: [mem 0xfec10000-0xfec10fff] has been reserved
[    1.295144] system 00:09: [mem 0xfed00000-0xfed00fff] could not be reserved
[    1.302158] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    1.309038] pnp: PnP ACPI: found 10 devices
[    1.320395] pci 0000:00:03.1: PCI bridge to [bus 01]
[    1.325425] pci 0000:00:03.1:   bridge window [io  0xe000-0xefff]
[    1.331573] pci 0000:00:03.1:   bridge window [mem 0xfea00000-0xfeafffff]
[    1.338413] pci 0000:00:03.1:   bridge window [mem 0xd0800000-0xd08fffff 64bit pref]
[    1.346247] pci 0000:00:14.4: PCI bridge to [bus 02]
[    1.351420] NET: Registered protocol family 2
[    1.356165] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.363956] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.370906] TCP: Hash tables configured (established 131072 bind 65536)
[    1.377661] TCP: reno registered
[    1.380966] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    1.387189] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    1.394053] NET: Registered protocol family 1
[    1.789712] Unpacking initramfs...
[    2.214547] Freeing initrd memory: 39820K (ffff88003322a000 - ffff88003590d000)
[    2.223483] AMD-Vi: IOMMU performance counters supported
[    2.228978] pci 0000:00:00.2: can't derive routing for PCI INT A
[    2.235113] pci 0000:00:00.2: PCI INT A: no GSI
[    2.240159] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    2.245590] AMD-Vi:  Extended features:  PPR GT IA PC
[    2.250933] AMD-Vi: Interrupt remapping enabled
[    2.255526] pci 0000:00:00.2: irqdomain: try allocate 1 MSI IRQs
[    2.261598] pci 0000:00:00.2: allocated IRQ24 for MSI
[    2.267467] AMD-Vi: Using passthrough domain for device 0000:00:01.0
[    2.280548] AMD-Vi: Lazy IO/TLB flushing enabled
[    2.285741] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.292337] software IO TLB [mem 0x78b73000-0x7cb73000] (64MB) mapped at [ffff880078b73000-ffff88007cb72fff]
[    2.302677] perf: AMD NB counters detected
[    2.306959] perf: amd_iommu: Detected. (2 banks, 4 counters/bank)
[    2.313139] microcode: CPU0: patch_level=0x06003104
[    2.318112] microcode: CPU1: patch_level=0x06003104
[    2.323193] microcode: CPU2: patch_level=0x06003104
[    2.328136] microcode: CPU3: patch_level=0x06003104
[    2.333163] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.342070] LVT offset 0 assigned for vector 0x400
[    2.347037] perf: AMD IBS detected (0x000001ff)
[    2.352010] Scanning for low memory corruption every 60 seconds
[    2.358368] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    2.364766] audit: initializing netlink subsys (disabled)
[    2.370276] audit: type=2000 audit(1415181294.621:1): initialized
[    2.377009] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.383450] zpool: loaded
[    2.386139] zbud: loaded
[    2.389009] VFS: Disk quotas dquot_6.5.2
[    2.393136] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.399936] msgmni has been set to 29886
[    2.404477] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.412051] io scheduler noop registered
[    2.416044] io scheduler deadline registered
[    2.420483] io scheduler cfq registered (default)
[    2.425434] pcieport 0000:00:03.1: irqdomain: try allocate 1 MSI IRQs
[    2.431952] pcieport 0000:00:03.1: allocated IRQ25 for MSI
[    2.437603] pcieport 0000:00:03.1: Signaling PME through PCIe PME interrupt
[    2.444645] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    2.451273] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.456953] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.463694] GHES: HEST is not enabled!
[    2.467715] Serial: 8250/16550 driver, 32 ports, IRQ sharing disabled
[    2.494801] serial 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.504654] Non-volatile memory driver v1.3
[    2.508900] Linux agpgart interface v0.103
[    2.513260] irqdomain: AHCI 8 ports, 8 MSI
[    2.517456] ahci 0000:00:11.0: irqdomain: try allocate 8 MSI IRQs
[    2.523643] ahci 0000:00:11.0: try to alloc nvec 8
[    2.528510] ahci 0000:00:11.0: allocated IRQ26 for MSI
[    2.533713] ------------[ cut here ]------------
[    2.538420] kernel BUG at drivers/pci/msi.c:1219!
[    2.543173] invalid opcode: 0000 [#1] PREEMPT SMP 
[    2.548161] Modules linked in:
[    2.551321] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc3+ #5
[    2.557762] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A88XM-HD3, BIOS F6 05/28/2014
[    2.567953] task: ffff88042b54c010 ti: ffff88042b550000 task.ti: ffff88042b550000
[    2.575548] RIP: 0010:[<ffffffff81369429>]  [<ffffffff81369429>] msi_irq_domain_alloc_irqs+0x1e9/0x220
[    2.585012] RSP: 0000:ffff88042b553ab8  EFLAGS: 00010282
[    2.590413] RAX: 00000000ffffffea RBX: ffff8804253e27c0 RCX: 0000000000000000
[    2.597591] RDX: 0000000000000000 RSI: 0000000000000022 RDI: 0000000000000026
[    2.604814] RBP: ffff88042b553b08 R08: 0000000000000001 R09: ffff88043dc00008
[    2.611999] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000001a
[    2.619222] R13: ffff88042ad54000 R14: ffff88042b553b20 R15: 0000000000000004
[    2.626442] FS:  0000000000000000(0000) GS:ffff88043ec00000(0000) knlGS:0000000000000000
[    2.634641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.640477] CR2: 0000000000000000 CR3: 0000000001c16000 CR4: 00000000000407f0
[    2.647654] Stack:
[    2.649726]  ffff88042b5104c0 00000005ffffffff ffff88042ad54098 ffff88042ad54880
[    2.657378]  ffff88042b553ae8 ffff88042ad54000 0000000000000005 0000000000000008
[    2.665050]  00000000000000ff ffff88042ad54880 ffff88042b553b68 ffffffff81037aa2
[    2.672713] Call Trace:
[    2.675217]  [<ffffffff81037aa2>] native_setup_msi_irqs+0x52/0xa0
[    2.681365]  [<ffffffff8100770a>] arch_setup_msi_irqs+0xa/0x10
[    2.687288]  [<ffffffff81368315>] pci_enable_msi_range+0x105/0x220
[    2.693520]  [<ffffffff8146060a>] ahci_init_one+0xa6a/0xb30
[    2.699184]  [<ffffffff8134e760>] local_pci_probe+0x40/0xa0
[    2.704813]  [<ffffffff8134f9b5>] ? pci_match_device+0xe5/0x110
[    2.710784]  [<ffffffff8134faf1>] pci_device_probe+0xd1/0x130
[    2.716613]  [<ffffffff81413e4b>] driver_probe_device+0x8b/0x3d0
[    2.722707]  [<ffffffff81414263>] __driver_attach+0x93/0xa0
[    2.728335]  [<ffffffff814141d0>] ? __device_attach+0x40/0x40
[    2.734172]  [<ffffffff81411ec3>] bus_for_each_dev+0x63/0xa0
[    2.739920]  [<ffffffff814138c9>] driver_attach+0x19/0x20
[    2.745369]  [<ffffffff814134e0>] bus_add_driver+0x180/0x250
[    2.751082]  [<ffffffff81d2fd60>] ? ata_sff_init+0x33/0x33
[    2.756657]  [<ffffffff81414abf>] driver_register+0x5f/0xf0
[    2.762277]  [<ffffffff8134e107>] __pci_register_driver+0x47/0x50
[    2.768459]  [<ffffffff81d2fd79>] ahci_pci_driver_init+0x19/0x1b
[    2.774556]  [<ffffffff810002f4>] do_one_initcall+0xb4/0x1f0
[    2.780271]  [<ffffffff81095e23>] ? __wake_up+0x43/0x60
[    2.785587]  [<ffffffff81ce7248>] kernel_init_freeable+0x197/0x21f
[    2.791821]  [<ffffffff81ce6983>] ? initcall_blacklist+0xc0/0xc0
[    2.797884]  [<ffffffff815fe760>] ? rest_init+0x90/0x90
[    2.803199]  [<ffffffff815fe769>] kernel_init+0x9/0xf0
[    2.808393]  [<ffffffff816143fc>] ret_from_fork+0x7c/0xb0
[    2.813839]  [<ffffffff815fe760>] ? rest_init+0x90/0x90
[    2.819154] Code: 83 c4 28 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 83 7b 10 02 19 c0 48 83 c4 28 5b 41 5c 41 5d 41 5e 83 e0 e3 41 5f 83 c0 01 5d c3 <0f> 0b 48 8b 75 c0 46 8d 44 20 ff 44 89 e1 48 c7 c2 a1 9f a2 81 
[    2.841251] RIP  [<ffffffff81369429>] msi_irq_domain_alloc_irqs+0x1e9/0x220
[    2.848351]  RSP <ffff88042b553ab8>
[    2.851916] ---[ end trace a98410f04540cfbe ]---
[    2.856595] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    2.856595] 
[    2.865976] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    2.876257] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    2.876257] 

--Pd0ReVV5GZGQvF3a--
