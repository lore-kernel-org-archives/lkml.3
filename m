Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab3GXEyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:54:31 -0400
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:40015
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab3GXEy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:54:26 -0400
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.0 cv=A800pNqG c=1 sm=1 a=rTb9Q+mClrhkGV9Ah9iRIA==:17
 a=QUtNAsJHzZwA:10 a=xqWC_Br6kY4A:10 a=N1CowNylAAAA:8 a=kYnMWVBo4CoA:10
 a=aoEJ-Xmsi30DAikgs1cA:9 a=QEXdDO2ut3YA:10 a=vFi3h0CCJ_bFFI50wjIA:9
 a=OeTgHhRhY19YCMLX:21 a=dliA6gYrWShCRWwu:21 a=USoLAnTpJFjQLIv22AoA:9
 a=PMQabJXFmU_0AQxC:21 a=C8q8i38Swu8yDn3G:21 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
Message-ID: <1374641658.316.2.camel@artifact>
Subject: Re: Linux 3.11-rc2 (acpi backlight)
From: Steven Newbury <steve@snewbury.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kamal Mostafa <kamal@canonical.com>, James Hogan <james@albanarts.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Date: Wed, 24 Jul 2013 05:54:18 +0100
In-Reply-To: <1657635.t6GA9ja9Ss@vostro.rjw.lan>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <9012759.Alzqtdvh5b@vostro.rjw.lan> <1374605189.31029.25.camel@fourier>
	 <1657635.t6GA9ja9Ss@vostro.rjw.lan>
Content-Type: multipart/mixed; boundary="=-UsBHnA3MpXWrlcXpgRSl"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UsBHnA3MpXWrlcXpgRSl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2013-07-24 at 02:05 +0200, Rafael J. Wysocki wrote:
> On Tuesday, July 23, 2013 11:46:29 AM Kamal Mostafa wrote:
> > On Mon, 2013-07-22 at 21:54 +0200, Rafael J. Wysocki wrote:
> > > On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> > > > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > >
> > > > > Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?
> > > > 
> > > > Yes, but [...] I'd suggest doing the revert just in time for
> > > > rc3, but waiting until then to gather info about people who see
> > > > breakage.
> > > > 
> > > > Sound like a plan?
> > > 
> > > Yes, it does.
> > > 
> > > Rafael
> > 
> > 
> > Hi Rafael-
> > 
> > For your reference...
> > 
> > As James Hogan reported, those ACPI changes break backlight control on
> > the "Dell XPS13" Ivy Bridge models (the Sandy Bridge XPS13 model is not
> > affected).
> > 
> > I confirm that reverting 8c5bd7a and efaa14c fixes it again.
> 
> Thanks!
> 
> I'd like to collect some information on the systems having problems with those
> two commits (to see if they are similar somehow).
> 
> It seems that one common symptom is that brightness cannot be controlled
> through function keys.  Is that correct for all of you?  If so, did you try
> any other way to control brightness, like a GUI-based?
> 
> Also, can you all please send me (a) the output of dmidecode and (b) the
> contents of /proc/cpuinfo from your systems?
> 
> Rafael
> 
> 

Attached.


--=-UsBHnA3MpXWrlcXpgRSl
Content-Disposition: attachment; filename="cpuinfo.txt"
Content-Type: text/plain; name="cpuinfo.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz
stepping	: 9
microcode	: 0x15
cpu MHz		: 2212.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 5587.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz
stepping	: 9
microcode	: 0x15
cpu MHz		: 1960.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 1
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 5587.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz
stepping	: 9
microcode	: 0x15
cpu MHz		: 2716.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 5587.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz
stepping	: 9
microcode	: 0x15
cpu MHz		: 2072.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 6
initial apicid	: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 5587.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 4
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz
stepping	: 9
microcode	: 0x15
cpu MHz		: 1400.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 5587.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 5
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz
stepping	: 9
microcode	: 0x15
cpu MHz		: 1988.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 1
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 5587.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 6
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz
stepping	: 9
microcode	: 0x15
cpu MHz		: 2604.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 5
initial apicid	: 5
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 5587.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 7
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz
stepping	: 9
microcode	: 0x15
cpu MHz		: 2660.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 7
initial apicid	: 7
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips	: 5587.12
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


--=-UsBHnA3MpXWrlcXpgRSl
Content-Disposition: attachment; filename="dmi.txt"
Content-Type: text/plain; name="dmi.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

# dmidecode 2.11
SMBIOS 2.7 present.
40 structures occupying 2086 bytes.
Table at 0x000EB190.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 4.6.5
	Release Date: 11/12/2012
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 4096 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
		UEFI is supported
	BIOS Revision: 4.6

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: CLEVO CO.                       
	Product Name: W240EU/W250EUQ/W270EUQ          
	Version: Not Applicable                  
	Serial Number: Not Applicable                  
	UUID: DFF59000-F04F-0000-0000-000000000000
	Wake-up Type: Power Switch
	SKU Number: Not Applicable                  
	Family: Not Applicable                  

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: CLEVO CO.                       
	Product Name: W240EU/W250EUQ/W270EUQ          
	Version: V3.0
	Serial Number: Not Applicable                  
	Asset Tag: Tag 12345
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: Not Applicable
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 22 bytes
Chassis Information
	Manufacturer: No Enclosure                    
	Type: Notebook
	Lock: Not Present
	Version: N/A                             
	Serial Number: None                            
	Asset Tag: No Asset Tag
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x000004D2
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0
	SKU Number: To be filled by O.E.M.

Handle 0x0004, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_HDMI1
	Internal Connector Type: None
	External Reference Designator: HDMI
	External Connector Type: Other
	Port Type: Video Port

Handle 0x0005, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_CRT1
	Internal Connector Type: None
	External Reference Designator: CRT
	External Connector Type: Other
	Port Type: Video Port

Handle 0x0006, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: AJ_MIC1
	Internal Connector Type: None
	External Reference Designator: MIC In
	External Connector Type: Other
	Port Type: Audio Port

Handle 0x0007, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: AJ_HP1
	Internal Connector Type: None
	External Reference Designator: Headphone
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_SPK1
	Internal Connector Type: None
	External Reference Designator: Speaker Out
	External Connector Type: Other
	Port Type: Audio Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_USB0
	Internal Connector Type: None
	External Reference Designator: USB 2.0/3.0
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_USB1
	Internal Connector Type: None
	External Reference Designator: USB 2.0/3.0
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_USB9
	Internal Connector Type: None
	External Reference Designator: USB Port9
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_RJ_1
	Internal Connector Type: None
	External Reference Designator: Giga Lan
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_CARD-REV1_1
	Internal Connector Type: None
	External Reference Designator: Card Reader
	External Connector Type: Other
	Port Type: Other

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_LCD1 - LVDS
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_LCD2 - LVDS
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_CCD1 - CCD
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_HDD1 - SATA HDD
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_ODD1 - SATA ODD
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_KB1 - Keyboard
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J_KB2 - Keyboard
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0015, DMI type 9, 17 bytes
System Slot Information
	Designation: J_MINI1
	Type: x1 PCI Express
	Current Usage: In Use
	Length: Short
	ID: 0
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:02:01.0

Handle 0x0016, DMI type 9, 17 bytes
System Slot Information
	Designation: J3G1
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 1
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:ff:1c.3

Handle 0x0017, DMI type 10, 10 bytes
On Board Device 1 Information
	Type: Video
	Status: Enabled
	Description:    IGD
On Board Device 2 Information
	Type: Ethernet
	Status: Enabled
	Description:  RealTek RTL8411
On Board Device 3 Information
	Type: Sound
	Status: Enabled
	Description:   VIA VT1802P

Handle 0x0018, DMI type 11, 5 bytes
OEM Strings
	String 1: 1558
	String 2: OEM String
	String 3: To Be Filled By O.E.M.
	String 4: To Be Filled By O.E.M.
	String 5: BIOS:1.02.09

Handle 0x0019, DMI type 22, 26 bytes
Portable Battery
	Location: Location of the battery
	Manufacturer: Battery Manufacturer
	Manufacture Date: 01/01/2007
	Serial Number: Serial Number
	Name: BATT 1
	Chemistry: Nickel Cadmium
	Design Capacity: 1020800 mWh
	Design Voltage: 11100 mV
	SBDS Version: 01.12.912
	Maximum Error: Unknown
	OEM-specific Information: 0x12345678

Handle 0x001A, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x001B, DMI type 7, 19 bytes
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

Handle 0x001C, DMI type 7, 19 bytes
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

Handle 0x001D, DMI type 7, 19 bytes
Cache Information
	Socket Designation: CPU Internal L3
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8192 kB
	Maximum Size: 8192 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x001E, DMI type 16, 23 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 16 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x001F, DMI type 4, 42 bytes
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
	Version: Intel(R) Core(TM) i7-3840QM CPU @ 2.80GHz
	Voltage: 3.3 V
	External Clock: 100 MHz
	Max Speed: 3800 MHz
	Current Speed: 2800 MHz
	Status: Populated, Enabled
	Upgrade: <OUT OF SPEC>
	L1 Cache Handle: 0x001C
	L2 Cache Handle: 0x001B
	L3 Cache Handle: 0x001D
	Serial Number: Not Specified
	Asset Tag: Fill By OEM
	Part Number: Fill By OEM
	Core Count: 4
	Core Enabled: 4
	Thread Count: 8
	Characteristics:
		64-bit capable

Handle 0x0020, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x001E
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: SODIMM
	Set: None
	Locator: ChannelA-DIMM0
	Bank Locator: BANK 0
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MHz
	Manufacturer: Kingston
	Serial Number: C43E9D46
	Asset Tag: 9876543210
	Part Number: KHX1600C9S3/4GX   
	Rank: 2
	Configured Clock Speed: 1600 MHz

Handle 0x0021, DMI type 20, 35 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0020
	Memory Array Mapped Address Handle: 0x0024
	Partition Row Position: Unknown
	Interleave Position: 1
	Interleaved Data Depth: 1

Handle 0x0022, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x001E
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
	Manufacturer: Kingston
	Serial Number: C53E85C2
	Asset Tag: 9876543210
	Part Number: KHX1600C9S3/4GX   
	Rank: 2
	Configured Clock Speed: 1600 MHz

Handle 0x0023, DMI type 20, 35 bytes
Memory Device Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0022
	Memory Array Mapped Address Handle: 0x0024
	Partition Row Position: Unknown
	Interleave Position: 2
	Interleaved Data Depth: 1

Handle 0x0024, DMI type 19, 31 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 8 GB
	Physical Array Handle: 0x001E
	Partition Width: 2

Handle 0x0027, DMI type 131, 64 bytes
OEM-specific Type
	Header and Data:
		83 40 27 00 35 00 00 00 00 00 00 00 00 00 00 00
		F8 00 59 1E FF FF FF FF 01 00 00 00 01 00 08 00
		E0 04 00 00 00 00 00 00 C8 00 FF FF 00 00 00 00
		00 00 00 00 66 00 00 00 76 50 72 6F 00 00 00 00

Handle 0x0028, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Long
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x002A, DMI type 127, 4 bytes
End Of Table


--=-UsBHnA3MpXWrlcXpgRSl--

