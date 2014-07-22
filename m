Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaGVMMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:12:17 -0400
Received: from wolff.to ([98.103.208.27]:57113 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751755AbaGVMMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:12:15 -0400
Date: Tue, 22 Jul 2014 07:10:01 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140722121001.GA30631@wolff.to>
References: <20140718053449.GA2039@wolff.to>
 <20140718101633.GP9918@twins.programming.kicks-ass.net>
 <20140718130126.GA2401@wolff.to>
 <20140718141648.GE20603@laptop.programming.kicks-ass.net>
 <20140718145040.GG12054@laptop.lan>
 <20140718161602.GH12054@laptop.lan>
 <20140721163528.GA10433@wolff.to>
 <20140721165212.GO3935@laptop>
 <20140722094740.GJ12054@laptop.lan>
 <20140722103857.GK12054@laptop.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20140722103857.GK12054@laptop.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Tue, Jul 22, 2014 at 12:38:57 +0200,
  Peter Zijlstra <peterz@infradead.org> wrote:
>
>Could you provide the output of cpuid and cpuid -r for your machine?
>This code is magic and I've no idea what your machine is telling it to
>do :/

I am attaching both sets of output. (I also added copies to the bug report.)

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cpuid.out"

CPU 0:
   vendor_id = "GenuineIntel"
   version information (1/eax):
      processor type  = primary processor (0)
      family          = Intel Pentium 4/Pentium D/Pentium Extreme Edition/Celeron/Xeon/Xeon MP/Itanium2, AMD Athlon 64/Athlon XP-M/Opteron/Sempron/Turion (15)
      model           = 0x2 (2)
      stepping id     = 0x9 (9)
      extended family = 0x0 (0)
      extended model  = 0x0 (0)
      (simple synth)  = Intel Pentium 4 (Northwood D1) / Xeon (Prestonia D1) / Mobile Pentium 4 (Northwood D1) / Mobile Pentium 4 Processor-M (Northwood D1) / Celeron 478-pin (Northwood D1), .13um
   miscellaneous (1/ebx):
      process local APIC physical ID = 0x0 (0)
      cpu count                      = 0x2 (2)
      CLFLUSH line size              = 0x8 (8)
      brand index                    = 0xb (11)
   brand id = 0x0b (11): Intel Xeon, .13um
   feature information (1/edx):
      x87 FPU on chip                        = true
      virtual-8086 mode enhancement          = true
      debugging extensions                   = true
      page size extensions                   = true
      time stamp counter                     = true
      RDMSR and WRMSR support                = true
      physical address extensions            = true
      machine check exception                = true
      CMPXCHG8B inst.                        = true
      APIC on chip                           = true
      SYSENTER and SYSEXIT                   = true
      memory type range registers            = true
      PTE global bit                         = true
      machine check architecture             = true
      conditional move/compare instruction   = true
      page attribute table                   = true
      page size extension                    = true
      processor serial number                = false
      CLFLUSH instruction                    = true
      debug store                            = true
      thermal monitor and clock ctrl         = true
      MMX Technology                         = true
      FXSAVE/FXRSTOR                         = true
      SSE extensions                         = true
      SSE2 extensions                        = true
      self snoop                             = true
      hyper-threading / multi-core supported = true
      therm. monitor                         = true
      IA64                                   = false
      pending break event                    = true
   feature information (1/ecx):
      PNI/SSE3: Prescott New Instructions     = false
      PCLMULDQ instruction                    = false
      64-bit debug store                      = false
      MONITOR/MWAIT                           = false
      CPL-qualified debug store               = false
      VMX: virtual machine extensions         = false
      SMX: safer mode extensions              = false
      Enhanced Intel SpeedStep Technology     = false
      thermal monitor 2                       = false
      SSSE3 extensions                        = false
      context ID: adaptive or shared L1 data  = true
      FMA instruction                         = false
      CMPXCHG16B instruction                  = false
      xTPR disable                            = true
      perfmon and debug                       = false
      process context identifiers             = false
      direct cache access                     = false
      SSE4.1 extensions                       = false
      SSE4.2 extensions                       = false
      extended xAPIC support                  = false
      MOVBE instruction                       = false
      POPCNT instruction                      = false
      time stamp counter deadline             = false
      AES instruction                         = false
      XSAVE/XSTOR states                      = false
      OS-enabled XSAVE/XSTOR                  = false
      AVX: advanced vector extensions         = false
      F16C half-precision convert instruction = false
      RDRAND instruction                      = false
      hypervisor guest status                 = false
   cache and TLB information (2):
      0x50: instruction TLB: 4K & 2M/4M pages, 64 entries
      0x5b: data TLB: 4K & 4M pages, 64 entries
      0x66: L1 data cache: 8K, 4-way, 64 byte lines
      0x40: No L3 cache
      0x70: Trace cache: 12K-uop, 8-way
      0x7b: L2 cache: 512K, 8-way, sectored, 64 byte lines
   extended feature flags (0x80000001/edx):
      SYSCALL and SYSRET instructions        = false
      execution disable                      = false
      1-GB large page support                = false
      RDTSCP                                 = false
      64-bit extensions technology available = false
   Intel feature flags (0x80000001/ecx):
      LAHF/SAHF supported in 64-bit mode     = false
      LZCNT advanced bit manipulation        = false
      3DNow! PREFETCH/PREFETCHW instructions = false
   brand = "                  Intel(R) Xeon(TM) CPU 2.66GHz"
   (multi-processing synth): hyper-threaded (t=2)
   (multi-processing method): Intel leaf 1
   (synth) = Intel Xeon (Prestonia D1), .13um
CPU 1:
   vendor_id = "GenuineIntel"
   version information (1/eax):
      processor type  = primary processor (0)
      family          = Intel Pentium 4/Pentium D/Pentium Extreme Edition/Celeron/Xeon/Xeon MP/Itanium2, AMD Athlon 64/Athlon XP-M/Opteron/Sempron/Turion (15)
      model           = 0x2 (2)
      stepping id     = 0x9 (9)
      extended family = 0x0 (0)
      extended model  = 0x0 (0)
      (simple synth)  = Intel Pentium 4 (Northwood D1) / Xeon (Prestonia D1) / Mobile Pentium 4 (Northwood D1) / Mobile Pentium 4 Processor-M (Northwood D1) / Celeron 478-pin (Northwood D1), .13um
   miscellaneous (1/ebx):
      process local APIC physical ID = 0x6 (6)
      cpu count                      = 0x2 (2)
      CLFLUSH line size              = 0x8 (8)
      brand index                    = 0xb (11)
   brand id = 0x0b (11): Intel Xeon, .13um
   feature information (1/edx):
      x87 FPU on chip                        = true
      virtual-8086 mode enhancement          = true
      debugging extensions                   = true
      page size extensions                   = true
      time stamp counter                     = true
      RDMSR and WRMSR support                = true
      physical address extensions            = true
      machine check exception                = true
      CMPXCHG8B inst.                        = true
      APIC on chip                           = true
      SYSENTER and SYSEXIT                   = true
      memory type range registers            = true
      PTE global bit                         = true
      machine check architecture             = true
      conditional move/compare instruction   = true
      page attribute table                   = true
      page size extension                    = true
      processor serial number                = false
      CLFLUSH instruction                    = true
      debug store                            = true
      thermal monitor and clock ctrl         = true
      MMX Technology                         = true
      FXSAVE/FXRSTOR                         = true
      SSE extensions                         = true
      SSE2 extensions                        = true
      self snoop                             = true
      hyper-threading / multi-core supported = true
      therm. monitor                         = true
      IA64                                   = false
      pending break event                    = true
   feature information (1/ecx):
      PNI/SSE3: Prescott New Instructions     = false
      PCLMULDQ instruction                    = false
      64-bit debug store                      = false
      MONITOR/MWAIT                           = false
      CPL-qualified debug store               = false
      VMX: virtual machine extensions         = false
      SMX: safer mode extensions              = false
      Enhanced Intel SpeedStep Technology     = false
      thermal monitor 2                       = false
      SSSE3 extensions                        = false
      context ID: adaptive or shared L1 data  = true
      FMA instruction                         = false
      CMPXCHG16B instruction                  = false
      xTPR disable                            = true
      perfmon and debug                       = false
      process context identifiers             = false
      direct cache access                     = false
      SSE4.1 extensions                       = false
      SSE4.2 extensions                       = false
      extended xAPIC support                  = false
      MOVBE instruction                       = false
      POPCNT instruction                      = false
      time stamp counter deadline             = false
      AES instruction                         = false
      XSAVE/XSTOR states                      = false
      OS-enabled XSAVE/XSTOR                  = false
      AVX: advanced vector extensions         = false
      F16C half-precision convert instruction = false
      RDRAND instruction                      = false
      hypervisor guest status                 = false
   cache and TLB information (2):
      0x50: instruction TLB: 4K & 2M/4M pages, 64 entries
      0x5b: data TLB: 4K & 4M pages, 64 entries
      0x66: L1 data cache: 8K, 4-way, 64 byte lines
      0x40: No L3 cache
      0x70: Trace cache: 12K-uop, 8-way
      0x7b: L2 cache: 512K, 8-way, sectored, 64 byte lines
   extended feature flags (0x80000001/edx):
      SYSCALL and SYSRET instructions        = false
      execution disable                      = false
      1-GB large page support                = false
      RDTSCP                                 = false
      64-bit extensions technology available = false
   Intel feature flags (0x80000001/ecx):
      LAHF/SAHF supported in 64-bit mode     = false
      LZCNT advanced bit manipulation        = false
      3DNow! PREFETCH/PREFETCHW instructions = false
   brand = "                  Intel(R) Xeon(TM) CPU 2.66GHz"
   (multi-processing synth): hyper-threaded (t=2)
   (multi-processing method): Intel leaf 1
   (synth) = Intel Xeon (Prestonia D1), .13um
CPU 2:
   vendor_id = "GenuineIntel"
   version information (1/eax):
      processor type  = primary processor (0)
      family          = Intel Pentium 4/Pentium D/Pentium Extreme Edition/Celeron/Xeon/Xeon MP/Itanium2, AMD Athlon 64/Athlon XP-M/Opteron/Sempron/Turion (15)
      model           = 0x2 (2)
      stepping id     = 0x9 (9)
      extended family = 0x0 (0)
      extended model  = 0x0 (0)
      (simple synth)  = Intel Pentium 4 (Northwood D1) / Xeon (Prestonia D1) / Mobile Pentium 4 (Northwood D1) / Mobile Pentium 4 Processor-M (Northwood D1) / Celeron 478-pin (Northwood D1), .13um
   miscellaneous (1/ebx):
      process local APIC physical ID = 0x1 (1)
      cpu count                      = 0x2 (2)
      CLFLUSH line size              = 0x8 (8)
      brand index                    = 0xb (11)
   brand id = 0x0b (11): Intel Xeon, .13um
   feature information (1/edx):
      x87 FPU on chip                        = true
      virtual-8086 mode enhancement          = true
      debugging extensions                   = true
      page size extensions                   = true
      time stamp counter                     = true
      RDMSR and WRMSR support                = true
      physical address extensions            = true
      machine check exception                = true
      CMPXCHG8B inst.                        = true
      APIC on chip                           = true
      SYSENTER and SYSEXIT                   = true
      memory type range registers            = true
      PTE global bit                         = true
      machine check architecture             = true
      conditional move/compare instruction   = true
      page attribute table                   = true
      page size extension                    = true
      processor serial number                = false
      CLFLUSH instruction                    = true
      debug store                            = true
      thermal monitor and clock ctrl         = true
      MMX Technology                         = true
      FXSAVE/FXRSTOR                         = true
      SSE extensions                         = true
      SSE2 extensions                        = true
      self snoop                             = true
      hyper-threading / multi-core supported = true
      therm. monitor                         = true
      IA64                                   = false
      pending break event                    = true
   feature information (1/ecx):
      PNI/SSE3: Prescott New Instructions     = false
      PCLMULDQ instruction                    = false
      64-bit debug store                      = false
      MONITOR/MWAIT                           = false
      CPL-qualified debug store               = false
      VMX: virtual machine extensions         = false
      SMX: safer mode extensions              = false
      Enhanced Intel SpeedStep Technology     = false
      thermal monitor 2                       = false
      SSSE3 extensions                        = false
      context ID: adaptive or shared L1 data  = true
      FMA instruction                         = false
      CMPXCHG16B instruction                  = false
      xTPR disable                            = true
      perfmon and debug                       = false
      process context identifiers             = false
      direct cache access                     = false
      SSE4.1 extensions                       = false
      SSE4.2 extensions                       = false
      extended xAPIC support                  = false
      MOVBE instruction                       = false
      POPCNT instruction                      = false
      time stamp counter deadline             = false
      AES instruction                         = false
      XSAVE/XSTOR states                      = false
      OS-enabled XSAVE/XSTOR                  = false
      AVX: advanced vector extensions         = false
      F16C half-precision convert instruction = false
      RDRAND instruction                      = false
      hypervisor guest status                 = false
   cache and TLB information (2):
      0x50: instruction TLB: 4K & 2M/4M pages, 64 entries
      0x5b: data TLB: 4K & 4M pages, 64 entries
      0x66: L1 data cache: 8K, 4-way, 64 byte lines
      0x40: No L3 cache
      0x70: Trace cache: 12K-uop, 8-way
      0x7b: L2 cache: 512K, 8-way, sectored, 64 byte lines
   extended feature flags (0x80000001/edx):
      SYSCALL and SYSRET instructions        = false
      execution disable                      = false
      1-GB large page support                = false
      RDTSCP                                 = false
      64-bit extensions technology available = false
   Intel feature flags (0x80000001/ecx):
      LAHF/SAHF supported in 64-bit mode     = false
      LZCNT advanced bit manipulation        = false
      3DNow! PREFETCH/PREFETCHW instructions = false
   brand = "                  Intel(R) Xeon(TM) CPU 2.66GHz"
   (multi-processing synth): hyper-threaded (t=2)
   (multi-processing method): Intel leaf 1
   (synth) = Intel Xeon (Prestonia D1), .13um
CPU 3:
   vendor_id = "GenuineIntel"
   version information (1/eax):
      processor type  = primary processor (0)
      family          = Intel Pentium 4/Pentium D/Pentium Extreme Edition/Celeron/Xeon/Xeon MP/Itanium2, AMD Athlon 64/Athlon XP-M/Opteron/Sempron/Turion (15)
      model           = 0x2 (2)
      stepping id     = 0x9 (9)
      extended family = 0x0 (0)
      extended model  = 0x0 (0)
      (simple synth)  = Intel Pentium 4 (Northwood D1) / Xeon (Prestonia D1) / Mobile Pentium 4 (Northwood D1) / Mobile Pentium 4 Processor-M (Northwood D1) / Celeron 478-pin (Northwood D1), .13um
   miscellaneous (1/ebx):
      process local APIC physical ID = 0x7 (7)
      cpu count                      = 0x2 (2)
      CLFLUSH line size              = 0x8 (8)
      brand index                    = 0xb (11)
   brand id = 0x0b (11): Intel Xeon, .13um
   feature information (1/edx):
      x87 FPU on chip                        = true
      virtual-8086 mode enhancement          = true
      debugging extensions                   = true
      page size extensions                   = true
      time stamp counter                     = true
      RDMSR and WRMSR support                = true
      physical address extensions            = true
      machine check exception                = true
      CMPXCHG8B inst.                        = true
      APIC on chip                           = true
      SYSENTER and SYSEXIT                   = true
      memory type range registers            = true
      PTE global bit                         = true
      machine check architecture             = true
      conditional move/compare instruction   = true
      page attribute table                   = true
      page size extension                    = true
      processor serial number                = false
      CLFLUSH instruction                    = true
      debug store                            = true
      thermal monitor and clock ctrl         = true
      MMX Technology                         = true
      FXSAVE/FXRSTOR                         = true
      SSE extensions                         = true
      SSE2 extensions                        = true
      self snoop                             = true
      hyper-threading / multi-core supported = true
      therm. monitor                         = true
      IA64                                   = false
      pending break event                    = true
   feature information (1/ecx):
      PNI/SSE3: Prescott New Instructions     = false
      PCLMULDQ instruction                    = false
      64-bit debug store                      = false
      MONITOR/MWAIT                           = false
      CPL-qualified debug store               = false
      VMX: virtual machine extensions         = false
      SMX: safer mode extensions              = false
      Enhanced Intel SpeedStep Technology     = false
      thermal monitor 2                       = false
      SSSE3 extensions                        = false
      context ID: adaptive or shared L1 data  = true
      FMA instruction                         = false
      CMPXCHG16B instruction                  = false
      xTPR disable                            = true
      perfmon and debug                       = false
      process context identifiers             = false
      direct cache access                     = false
      SSE4.1 extensions                       = false
      SSE4.2 extensions                       = false
      extended xAPIC support                  = false
      MOVBE instruction                       = false
      POPCNT instruction                      = false
      time stamp counter deadline             = false
      AES instruction                         = false
      XSAVE/XSTOR states                      = false
      OS-enabled XSAVE/XSTOR                  = false
      AVX: advanced vector extensions         = false
      F16C half-precision convert instruction = false
      RDRAND instruction                      = false
      hypervisor guest status                 = false
   cache and TLB information (2):
      0x50: instruction TLB: 4K & 2M/4M pages, 64 entries
      0x5b: data TLB: 4K & 4M pages, 64 entries
      0x66: L1 data cache: 8K, 4-way, 64 byte lines
      0x40: No L3 cache
      0x70: Trace cache: 12K-uop, 8-way
      0x7b: L2 cache: 512K, 8-way, sectored, 64 byte lines
   extended feature flags (0x80000001/edx):
      SYSCALL and SYSRET instructions        = false
      execution disable                      = false
      1-GB large page support                = false
      RDTSCP                                 = false
      64-bit extensions technology available = false
   Intel feature flags (0x80000001/ecx):
      LAHF/SAHF supported in 64-bit mode     = false
      LZCNT advanced bit manipulation        = false
      3DNow! PREFETCH/PREFETCHW instructions = false
   brand = "                  Intel(R) Xeon(TM) CPU 2.66GHz"
   (multi-processing synth): hyper-threaded (t=2)
   (multi-processing method): Intel leaf 1
   (synth) = Intel Xeon (Prestonia D1), .13um

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cpuidr.out"

CPU 0:
   0x00000000 0x00: eax=0x00000002 ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
   0x00000001 0x00: eax=0x00000f29 ebx=0x0002080b ecx=0x00004400 edx=0xbfebfbff
   0x00000002 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
   0x80000000 0x00: eax=0x80000004 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x80000001 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x80000002 0x00: eax=0x20202020 ebx=0x20202020 ecx=0x20202020 edx=0x20202020
   0x80000003 0x00: eax=0x6e492020 ebx=0x286c6574 ecx=0x58202952 edx=0x286e6f65
   0x80000004 0x00: eax=0x20294d54 ebx=0x20555043 ecx=0x36362e32 edx=0x007a4847
   0x80860000 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
   0xc0000000 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
CPU 1:
   0x00000000 0x00: eax=0x00000002 ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
   0x00000001 0x00: eax=0x00000f29 ebx=0x0602080b ecx=0x00004400 edx=0xbfebfbff
   0x00000002 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
   0x80000000 0x00: eax=0x80000004 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x80000001 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x80000002 0x00: eax=0x20202020 ebx=0x20202020 ecx=0x20202020 edx=0x20202020
   0x80000003 0x00: eax=0x6e492020 ebx=0x286c6574 ecx=0x58202952 edx=0x286e6f65
   0x80000004 0x00: eax=0x20294d54 ebx=0x20555043 ecx=0x36362e32 edx=0x007a4847
   0x80860000 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
   0xc0000000 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
CPU 2:
   0x00000000 0x00: eax=0x00000002 ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
   0x00000001 0x00: eax=0x00000f29 ebx=0x0102080b ecx=0x00004400 edx=0xbfebfbff
   0x00000002 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
   0x80000000 0x00: eax=0x80000004 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x80000001 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x80000002 0x00: eax=0x20202020 ebx=0x20202020 ecx=0x20202020 edx=0x20202020
   0x80000003 0x00: eax=0x6e492020 ebx=0x286c6574 ecx=0x58202952 edx=0x286e6f65
   0x80000004 0x00: eax=0x20294d54 ebx=0x20555043 ecx=0x36362e32 edx=0x007a4847
   0x80860000 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
   0xc0000000 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
CPU 3:
   0x00000000 0x00: eax=0x00000002 ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
   0x00000001 0x00: eax=0x00000f29 ebx=0x0702080b ecx=0x00004400 edx=0xbfebfbff
   0x00000002 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
   0x80000000 0x00: eax=0x80000004 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x80000001 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
   0x80000002 0x00: eax=0x20202020 ebx=0x20202020 ecx=0x20202020 edx=0x20202020
   0x80000003 0x00: eax=0x6e492020 ebx=0x286c6574 ecx=0x58202952 edx=0x286e6f65
   0x80000004 0x00: eax=0x20294d54 ebx=0x20555043 ecx=0x36362e32 edx=0x007a4847
   0x80860000 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040
   0xc0000000 0x00: eax=0x665b5001 ebx=0x00000000 ecx=0x00000000 edx=0x007b7040

--0OAP2g/MAC+5xKAE--
