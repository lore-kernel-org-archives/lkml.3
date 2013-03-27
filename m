Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3C0If5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:35:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35718 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3C0Ifv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:35:51 -0400
X-AuditID: cbfee68e-b7f946d000001e37-95-5152af65f049
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
 <00c501ce277c$30e49dc0$92add940$%han@samsung.com>
 <20130325170448.GB16690@obsidianresearch.com>
In-reply-to: <20130325170448.GB16690@obsidianresearch.com>
Subject: Re: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Wed, 27 Mar 2013 17:35:48 +0900
Message-id: <020e01ce2ac6$14fd7850$3ef868f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4peuXkWSsCH4MZSsyA8Jo6oc13hABR4ixQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t8zQ93U9UGBBjOu8lg0/9/OarGkKcPi
	wOyHrBavzmxks7i88BKrxfcbpha9C66yWWx6fI3V4vKuOWwWZ+cdZ7OYcX4fk8WKpq2MFosv
	Lme22L1yCYvFsRlLGC2ePmhichDwWDNvDaNH35SrbB5PNl1k9FiwqdTjzrU9bB6bl9R7nJ+x
	kNHj+45eoIItqxg9fr7U8fi8SS6AO4rLJiU1J7MstUjfLoEr4+Orw8wFy4wqfv6Lb2BcqNbF
	yMkhIWAisah/JRuELSZx4d56IJuLQ0hgGaPEpKszmWGKft2axwqRmM4o8XpCB1TVL0aJFXfX
	gbWzCahJfPlymB3EFhEwl5iw6gdYnFmgl1Vi720RiIaFjBLT3q1iBUlwClhJLNxxCaxIWCBC
	4srzx0wgNouAqsSyWf1gg3gFbCW+TPkCZQtK/Jh8jwViqJbE+p3HmSBseYnNa94CncoBdKq6
	xKO/uhA3GEnsvrIJ6gYRiX0v3jGC3CAhcIFD4uG7SywQuwQkvk0+xALRKyux6QDUx5ISB1fc
	YJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmKEpJK+HYw3
	D1gfYkwGWj+RWUo0OR+YivJK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwFhmU6DuWbx+b93byg6Hh9ez1jgt2bhMuzBy8fQ7m/usRP31hFZvMAhI
	s2iRCFr3W+94sb3FigoJHuaTXJVcpy7eY2thObt7k1qBftrF4HuzGRVl/v3NeLXmgHLSlOQt
	BcUN85z+prn3CM2oEk29xfZj4QObv9dezX55XknEu+Ri2Bz7wlcyh5RYijMSDbWYi4oTAZRG
	RCE7AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42I5/e+xoG7q+qBAg6lvWS2a/29ntVjSlGFx
	YPZDVotXZzayWVxeeInV4vsNU4veBVfZLDY9vsZqcXnXHDaLs/OOs1nMOL+PyWJF01ZGi8UX
	lzNb7F65hMXi2IwljBZPHzQxOQh4rJm3htGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9Y
	yOjxfUcvUMGWVYweP1/qeHzeJBfAHdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkD9I2SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCOMePjq8PMBcuMKn7+i29gXKjWxcjJISFgIvHr1jxWCFtM4sK99WxdjFwcQgLTGSVeT+iA
	cn4xSqy4u44NpIpNQE3iy5fD7CC2iIC5xIRVP8DizAK9rBJ7b4tANCxklJj2bhXYWE4BK4mF
	Oy6BFQkLREhcef6YCcRmEVCVWDarH2wQr4CtxJcpX6BsQYkfk++xQAzVkli/8zgThC0vsXnN
	W+YuRg6gU9UlHv3VhbjBSGL3lU1QN4hI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1I
	LihOSs810itOzC0uzUvXS87P3cQITlTPpHcwrmqwOMQowMGoxMPr8C8wUIg1say4MvcQowQH
	s5II74sVQYFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9Monkl8YbGJmZGlkZmFkYm5uak
	CSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJh97d6KawyPCnQeffnLu0G9ddbeGRu32Bjl
	17g+VP8sdz841tfz/cFMf87lzGYPZP9p7zm5II1vlgz/dd6W1dt1jjVlbvcy/R/IFarfqMy0
	/5/ub7u8K607ZEMOnmj5dXDuXWmZquKZV2xaHTlO/D/3ovv4s3KbBNnjufZmB5h/xkZvsO89
	ZqPEUpyRaKjFXFScCABogVVOmAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 26, 2013 2:05 AM, Jason Gunthorpe wrote:
> 
> On Sat, Mar 23, 2013 at 01:09:18PM +0900, Jingoo Han wrote:
> 
> > +	pcie0@40000000 {
> > +		compatible = "samsung,exynos5440-pcie";
> > +		reg = <0x40000000 0x4000
> > +			0x290000 0x1000
> > +			0x270000 0x1000
> > +			0x271000 0x40>;
> > +		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
> > +		#address-cells = <3>;
> > +		#size-cells = <2>;
> > +		device_type = "pci";
> > +		bus-range = <0x0 0xf>;
> > +		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> > +			  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
> > +			  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
> > +	};
> 
> Can you send the lspci output so these bindings can be properly
> reviewed? What PCI devices are internal to the SOC?
> 
> What is behind 'exynos_pcie_wr_own_conf' ? Is this a root port bridge
> config space? What line is it in the lspci output? Can you include a
> lspci -vv for it as well?

Hi Jason Gunthorpe,
Thank you for your comment :)

Here is the lspci -vv output.
I tested Exynos PCIe with e1000e lan card.

00:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 00000000-00000fff
        Memory behind bridge: 40300000-403fffff
        Prefetchable memory behind bridge: 40400000-404fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: <access denied>
        Kernel driver in use: pcieport

01:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
        Subsystem: Intel Corporation Gigabit CT Desktop Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 53
        Region 0: Memory at 40380000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at 40300000 (32-bit, non-prefetchable) [size=512K]
        Region 2: I/O ports at 40200000 [disabled] [size=32]
        Region 3: Memory at 403a0000 (32-bit, non-prefetchable) [size=16K]
        [virtual] Expansion ROM at 40400000 [disabled] [size=256K]
        Capabilities: <access denied>
        Kernel driver in use: e1000e

10:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=10, secondary=11, subordinate=11, sec-latency=0
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: <access denied>
        Kernel driver in use: pcieport



> 
> Your DT has overlapping bus-ranges, and two top level nodes. This is
> going to require separate PCI domains in Linux.
> 
> However, based on your driver this HW looks similar to tegra, did you
> review how tegra is setup? Merging all the ports into a single domain
> is certainly preferred.

In Tegra case, the address of IO control register is same.
+	pcie-controller {
+		compatible = "nvidia,tegra20-pcie";
+		reg = <0x80003000 0x00000800   /* PADS registers */
+		       0x80003800 0x00000200   /* AFI registers */
+		       0x81000000 0x01000000   /* configuration space */
+		       0x90000000 0x10000000>; /* extended configuration space */

But, in Exynos case, address of IP control register is different
between PCIe0 and PCIe1.

+	pcie0@40000000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x40000000 0x4000
+			0x290000 0x1000
+			0x270000 0x1000
+			0x271000 0x40>;

+	pcie1@60000000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x60000000 0x4000
+			0x2a0000 0x1000
+			0x272000 0x1000
+			0x271040 0x40>;


> 
> > +	pcie1@60000000 {
> > +		compatible = "samsung,exynos5440-pcie";
> > +		reg = <0x60000000 0x4000
> > +			0x2a0000 0x1000
> > +			0x272000 0x1000
> > +			0x271040 0x40>;
> > +		interrupts = <0 23 0>, <0 24 0>, <0 25 0>;
> > +		#address-cells = <3>;
> > +		#size-cells = <2>;
> > +		device_type = "pci";
> > +		bus-range = <0x0 0xf>;
> > +		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00200000   /* configuration space */
> 
> Do not include configuration space in ranges

How can I include configuration space?
Please let me know kindly :)

> 
> > +			  0x81000000 0 0	  0x60200000 0 0x00004000   /* downstream I/O */
> 
> Please confirm that an MMIO to 0x60200000 produces a PCI-E IO TLP to
> address 0
> 
> > +			  0x82000000 0 0	  0x60204000 0 0x10000000>; /* non-prefetchable memory */
> 
> Please check this, generally it should be:
> 
> 			  0x82000000 0 0x60204000 0x60204000 0 0x10000000>; /* non-prefetchable memory */
> 
> Reflecting an identity mapping for MMIO - eg MMIO access to 0x60204000
> producse a PCI Memory TLP to address 0x60204000 - unless your hardware
> is actually doing address translation (then there are other things to
> confirm..)

OK, I will change it.

> 
> It is usual to have an interrupt-map - have you tested that interrupts
> resolve properly?

There is no problem about interrupts.
However, I will consider an interrupt-map.

> 
> It looks like the INTx's should be routed by an interrupt-map to the
> pulse pin. Consider an interrupt controller to decode the INT ABCD.
> 
> Regards,
> Jason

