Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3GXStS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:49:18 -0400
Received: from blu0-omc1-s31.blu0.hotmail.com ([65.55.116.42]:41136 "EHLO
	blu0-omc1-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab3GXStQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:49:16 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jul 2013 14:49:16 EDT
X-EIP: [s/RI4+/RccEaL4PgFTBNXx9effOVv2o2]
X-Originating-Email: [miaousami@hotmail.com]
Message-ID: <BLU0-SMTP125E791F01E26C3D60D7353A6680@phx.gbl>
Date: Wed, 24 Jul 2013 20:43:00 +0200
From: =?ISO-8859-1?Q?*_SAM=CD_*?= <miaousami@hotmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: rjw@sisk.pl
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.11-rc2 [backlight] [ASUS N56VZ]
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2013 18:43:03.0663 (UTC) FILETIME=[A13BFFF0:01CE889D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it seems a lot of people are complaining about the backlight pull 
request of RC2.

This is to tell you how it saved my life:
- Changing brightness from Fn keys does work
- Writing to /sys/class/backlight/intel_backlight/brightness does work
- Changing brightness from gnome brightness settings does work
--> It seems everything is now working (it wasn't before).
--> I appreciate your patch and I am going to be sad if you revert it :-)


My laptop : Asus N56VZ
My /proc/cpuinfo: 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1030556/+attachment/3241093/+files/ProcCpuinfo.txt
My dmidecode is below.

Changing brightness from Fn keys didn't work on 3.9 and 3.10 kernels.
I a not sure for previous versions though a patch was made for 3.2 in 
ubuntu. See details here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1030556

There are a lot of bugs opened for this:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1173107
http://askubuntu.com/questions/156708/how-to-get-multimedia-keys-working-at-my-asus-n56vz-ubuntu-12-04-notebook 

https://bugs.archlinux.org/task/35320

Regards
Sam


# dmidecode 2.11
# SMBIOS entry point at 0x000f04c0
SMBIOS 2.7 present.
23 structures occupying 1708 bytes.
Table at 0x000EBA70.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
     Vendor: American Megatrends Inc.
     Version: N56VZ.215
     Release Date: 11/02/2012
     Address: 0xF0000
     Runtime Size: 64 kB
     ROM Size: 6144 kB
     Characteristics:
         PCI is supported
         BIOS is upgradeable
         BIOS shadowing is allowed
         Boot from CD is supported
         Selectable boot is supported
         BIOS ROM is socketed
         EDD is supported
         5.25"/1.2 MB floppy services are supported (int 13h)
         3.5"/720 kB floppy services are supported (int 13h)
         3.5"/2.88 MB floppy services are supported (int 13h)
         Print screen service is supported (int 5h)
         8042 keyboard services are supported (int 9h)
         Serial services are supported (int 14h)
         Printer services are supported (int 17h)
         ACPI is supported
         USB legacy is supported
         Smart battery is supported
         BIOS boot specification is supported
         Targeted content distribution is supported
         UEFI is supported
     BIOS Revision: 4.6

Handle 0x0001, DMI type 1, 27 bytes
System Information
     Manufacturer: ASUSTeK COMPUTER INC.
     Product Name: N56VZ
     Version: 1.0
     Serial Number: C6N0AS306834244
     UUID: 10017880-B5B7-81E1-3FDF-3085A9061B75
     Wake-up Type: Power Switch
     SKU Number: ASUS-NotebookSKU
     Family: N

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
     Manufacturer: ASUSTeK COMPUTER INC.
     Product Name: N56VZ
     Version: 1.0
     Serial Number: BSN12345678901234567
     Asset Tag: ATN12345678901234567
     Features:
         Board is a hosting board
         Board is replaceable
     Location In Chassis: MIDDLE
     Chassis Handle: 0x0003
     Type: Motherboard
     Contained Object Handles: 0

Handle 0x0003, DMI type 3, 22 bytes
Chassis Information
     Manufacturer: ASUSTeK COMPUTER INC.
     Type: Notebook
     Lock: Not Present
     Version: 1.0
     Serial Number: C6N0AS306834244
     Asset Tag: No Asset Tag
     Boot-up State: Safe
     Power Supply State: Safe
     Thermal State: Safe
     Security Status: None
     OEM Information: 0x00000000
     Height: Unspecified
     Number Of Power Cords: 1
     Contained Elements: 0
     SKU Number: To be filled by O.E.M.

Handle 0x0004, DMI type 10, 26 bytes
On Board Device 1 Information
     Type: Video
     Status: Enabled
     Description:  VGA
On Board Device 2 Information
     Type: Ethernet
     Status: Enabled
     Description:  GLAN
On Board Device 3 Information
     Type: Ethernet
     Status: Enabled
     Description:  WLAN
On Board Device 4 Information
     Type: Sound
     Status: Enabled
     Description:  Audio CODEC
On Board Device 5 Information
     Type: SATA Controller
     Status: Enabled
     Description:  SATA Controller
On Board Device 6 Information
     Type: Other
     Status: Enabled
     Description:  USB 2.0 Controller
On Board Device 7 Information
     Type: Other
     Status: Enabled
     Description:  USB 3.0 Controller
On Board Device 8 Information
     Type: Other
     Status: Enabled
     Description:  SMBus Controller
On Board Device 9 Information
     Type: Other
     Status: Enabled
     Description:  Card Reader
On Board Device 10 Information
     Type: Other
     Status: Enabled
     Description:  Cmos Camera
On Board Device 11 Information
     Type: Other
     Status: Enabled
     Description:  Bluetooth

Handle 0x0005, DMI type 11, 5 bytes
OEM Strings
     String 1: 6kfb9jsNVeN50
     String 2: I76yifUckyZ2n
     String 3: W0-kvTpaXZUpn
     String 4: 90N9IC442L1875VL355Y
     String 5:
     String 6:
     String 7:
     String 8:
     String 9:
     String 10:

Handle 0x0006, DMI type 12, 5 bytes
System Configuration Options
     Option 1: DSN:            W54S4QJE
     Option 2: DSN:57B1609A5803
     Option 3: DSN:3085A9061B75
     Option 4: SMI:00B2CA

Handle 0x0007, DMI type 32, 20 bytes
System Boot Information
     Status: No errors detected

Handle 0x0008, DMI type 7, 19 bytes
Cache Information
     Socket Designation: CPU Internal L2
     Configuration: Enabled, Not Socketed, Level 2
     Operational Mode: Write Through
     Location: Internal
     Installed Size: 1024 kB
     Maximum Size: 1024 kB
     Supported SRAM Types:
         Unknown
     Installed SRAM Type: Unknown
     Speed: Unknown
     Error Correction Type: Multi-bit ECC
     System Type: Unified
     Associativity: 8-way Set-associative

Handle 0x0009, DMI type 7, 19 bytes
Cache Information
     Socket Designation: CPU Internal L1
     Configuration: Enabled, Not Socketed, Level 1
     Operational Mode: Write Through
     Location: Internal
     Installed Size: 256 kB
     Maximum Size: 256 kB
     Supported SRAM Types:
         Unknown
     Installed SRAM Type: Unknown
     Speed: Unknown
     Error Correction Type: Parity
     System Type: Data
     Associativity: 8-way Set-associative

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
     Socket Designation: CPU Internal L3
     Configuration: Enabled, Not Socketed, Level 3
     Operational Mode: Write Back
     Location: Internal
     Installed Size: 6144 kB
     Maximum Size: 6144 kB
     Supported SRAM Types:
         Unknown
     Installed SRAM Type: Unknown
     Speed: Unknown
     Error Correction Type: Multi-bit ECC
     System Type: Unified
     Associativity: 12-way Set-associative

Handle 0x000B, DMI type 16, 23 bytes
Physical Memory Array
     Location: System Board Or Motherboard
     Use: System Memory
     Error Correction Type: None
     Maximum Capacity: 32 GB
     Error Information Handle: Not Provided
     Number Of Devices: 4

Handle 0x000C, DMI type 4, 42 bytes
Processor Information
     Socket Designation: SOCKET 0
     Type: Central Processor
     Family: Core i7
     Manufacturer: Intel(R) Corporation
     ID: A9 06 03 00 FF FB EB BF
     Signature: Type 0, Family 6, Model 58, Stepping 9
     Flags:
         FPU (Floating-point unit on-chip)
         VME (Virtual mode extension)
         DE (Debugging extension)
         PSE (Page size extension)
         TSC (Time stamp counter)
         MSR (Model specific registers)
         PAE (Physical address extension)
         MCE (Machine check exception)
         CX8 (CMPXCHG8 instruction supported)
         APIC (On-chip APIC hardware supported)
         SEP (Fast system call)
         MTRR (Memory type range registers)
         PGE (Page global enable)
         MCA (Machine check architecture)
         CMOV (Conditional move instruction supported)
         PAT (Page attribute table)
         PSE-36 (36-bit page size extension)
         CLFSH (CLFLUSH instruction supported)
         DS (Debug store)
         ACPI (ACPI supported)
         MMX (MMX technology supported)
         FXSR (FXSAVE and FXSTOR instructions supported)
         SSE (Streaming SIMD extensions)
         SSE2 (Streaming SIMD extensions 2)
         SS (Self-snoop)
         HTT (Multi-threading)
         TM (Thermal monitor supported)
         PBE (Pending break enabled)
     Version: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
     Voltage: 2.9 V
     External Clock: 100 MHz
     Max Speed: 3800 MHz
     Current Speed: 2300 MHz
     Status: Populated, Enabled
     Upgrade: Socket rPGA988B
     L1 Cache Handle: 0x0009
     L2 Cache Handle: 0x0008
     L3 Cache Handle: 0x000A
     Serial Number: Not Specified
     Asset Tag: Fill By OEM
     Part Number: Fill By OEM
     Core Count: 4
     Core Enabled: 4
     Thread Count: 8
     Characteristics:
         64-bit capable

Handle 0x000D, DMI type 17, 34 bytes
Memory Device
     Array Handle: 0x000B
     Error Information Handle: Not Provided
     Total Width: 64 bits
     Data Width: 64 bits
     Size: 2048 MB
     Form Factor: SODIMM
     Set: None
     Locator: ChannelA-DIMM0
     Bank Locator: BANK 0
     Type: DDR3
     Type Detail: Synchronous
     Speed: 1600 MHz
     Manufacturer: Hynix/Hyundai
     Serial Number: 196F857E
     Asset Tag: 9876543210
     Part Number: HMT325S6CFR8C-PB
     Rank: 1
     Configured Clock Speed: 1600 MHz

Handle 0x000E, DMI type 20, 35 bytes
Memory Device Mapped Address
     Starting Address: 0x00000000000
     Ending Address: 0x0007FFFFFFF
     Range Size: 2 GB
     Physical Device Handle: 0x000D
     Memory Array Mapped Address Handle: 0x0013
     Partition Row Position: Unknown
     Interleave Position: 1
     Interleaved Data Depth: 2

Handle 0x000F, DMI type 17, 34 bytes
Memory Device
     Array Handle: 0x000B
     Error Information Handle: Not Provided
     Total Width: Unknown
     Data Width: Unknown
     Size: No Module Installed
     Form Factor: DIMM
     Set: None
     Locator: ChannelA-DIMM1
     Bank Locator: BANK 1
     Type: Unknown
     Type Detail: None
     Speed: Unknown
     Manufacturer: [Empty]
     Serial Number: [Empty]
     Asset Tag: 9876543210
     Part Number: [Empty]
     Rank: Unknown
     Configured Clock Speed: Unknown

Handle 0x0010, DMI type 17, 34 bytes
Memory Device
     Array Handle: 0x000B
     Error Information Handle: Not Provided
     Total Width: 64 bits
     Data Width: 64 bits
     Size: 4096 MB
     Form Factor: SODIMM
     Set: None
     Locator: ChannelB-DIMM0
     Bank Locator: BANK 2
     Type: DDR3
     Type Detail: Synchronous
     Speed: 1600 MHz
     Manufacturer: Hynix/Hyundai
     Serial Number: 0D649EC1
     Asset Tag: 9876543210
     Part Number: HMT351S6CFR8C-PB
     Rank: 2
     Configured Clock Speed: 1600 MHz

Handle 0x0011, DMI type 20, 35 bytes
Memory Device Mapped Address
     Starting Address: 0x00080000000
     Ending Address: 0x0017FFFFFFF
     Range Size: 4 GB
     Physical Device Handle: 0x0010
     Memory Array Mapped Address Handle: 0x0013
     Partition Row Position: Unknown
     Interleave Position: 2
     Interleaved Data Depth: 2

Handle 0x0012, DMI type 17, 34 bytes
Memory Device
     Array Handle: 0x000B
     Error Information Handle: Not Provided
     Total Width: Unknown
     Data Width: Unknown
     Size: No Module Installed
     Form Factor: DIMM
     Set: None
     Locator: ChannelB-DIMM1
     Bank Locator: BANK 3
     Type: Unknown
     Type Detail: None
     Speed: Unknown
     Manufacturer: [Empty]
     Serial Number: [Empty]
     Asset Tag: 9876543210
     Part Number: [Empty]
     Rank: Unknown
     Configured Clock Speed: Unknown

Handle 0x0013, DMI type 19, 31 bytes
Memory Array Mapped Address
     Starting Address: 0x00000000000
     Ending Address: 0x0017FFFFFFF
     Range Size: 6 GB
     Physical Array Handle: 0x000B
     Partition Width: 4

Handle 0x0018, DMI type 131, 64 bytes
OEM-specific Type
     Header and Data:
         83 40 18 00 31 00 00 00 00 00 00 00 00 00 00 00
         F8 00 59 1E 00 00 00 00 01 20 00 00 00 00 08 00
         B8 05 0A 00 00 00 00 00 C8 00 FF FF 00 00 00 00
         00 00 00 00 66 00 00 00 76 50 72 6F 00 00 00 00

Handle 0x0019, DMI type 13, 22 bytes
BIOS Language Information
     Language Description Format: Long
     Installable Languages: 1
         en|US|iso8859-1
     Currently Installed Language: en|US|iso8859-1

Handle 0x001A, DMI type 127, 4 bytes
End Of Table

