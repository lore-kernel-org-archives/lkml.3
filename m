Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3GORrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:47:51 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:61832 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3GORru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:47:50 -0400
Date: Mon, 15 Jul 2013 19:47:44 +0200 (CEST)
From: Eldad Zack <eldad@fogrefinery.com>
X-X-Sender: eldad@xoschi
To: Alex Deucher <alexdeucher@gmail.com>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: radeon: dpm - 3.11-rc1 positive report
Message-ID: <alpine.LNX.2.00.1307151939490.2826@xoschi>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

I just tested the new 3.11-rc1 and was very happy to find out that it 
reduces the idle temperature of my system by about 12 degrees (C).

Thank you very much for this!

Cheers,
Eldad

P.S. Just for reference, lspci output + dmesg below.

01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Thames [Radeon 7500M/7600M Series] (prog-if 00 [VGA controller])
	Subsystem: Toshiba America Info Systems Device fb91
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 41
	Region 0: Memory at b0000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at c0000000 (64-bit, non-prefetchable) [size=128K]
	Region 4: I/O ports at 2000 [size=256]
	Expansion ROM at c0040000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41a1
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [150 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: radeon

[    0.000000] Command line: root=/dev/sda6 video radeon.dpm=1
[    0.000000] Kernel command line: root=/dev/sda6 video radeon.dpm=1
[    0.347877] [drm] radeon kernel modesetting enabled.
[    0.348701] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    0.348787] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[    0.352677] [drm] radeon: 1024M of VRAM memory ready
[    0.352750] [drm] radeon: 512M of GTT memory ready.
[    0.352876] radeon 0000:01:00.0: ffff8802448bb400 unpin not necessary
[    0.446478] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000072118 and cpu addr 0xffffc900114e6118
[    0.447144] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[    0.458577] radeon 0000:01:00.0: WB enabled
[    0.458651] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff880244b61c00
[    0.458739] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c and cpu addr 0xffff880244b61c0c
[    0.460768] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000174118 and cpu addr 0xffffc90011d32118
[    0.461042] radeon 0000:01:00.0: irq 41 for MSI/MSI-X
[    0.461055] radeon 0000:01:00.0: radeon: using MSI.
[    0.461155] [drm] radeon: irq initialized.
[    0.871099] [drm] radeon atom DIG backlight initialized
[    0.884248] [drm] radeon: dpm initialized
[    1.309272] fbcon: radeondrmfb (fb0) is primary device
[    1.868006] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[    1.868043] radeon 0000:01:00.0: registered panic notifier
[    1.868083] [drm] Initialized radeon 2.34.0 20080528 for 0000:01:00.0 on minor 0



