Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab3BYOYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:24:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48432 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759386Ab3BYOYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:24:18 -0500
Date: Mon, 25 Feb 2013 16:24:11 +0200
From: Felipe Balbi <balbi@ti.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: i915 not working on Dell e6410
Message-ID: <20130225142411.GD15499@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I have a Dell e6410 whose framebuffer gets corrupted with v3.7.9 and
v3.8.0 but works fine with v3.6.11.

Below you can find lspci and my .config, maybe I'm missing something ?

8<-----------------------------------------------------------------

00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev =
02)
	Subsystem: Dell Device 040a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>

00:02.0 VGA compatible controller: Intel Corporation Core Processor Integra=
ted Graphics Controller (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Dell Device 040a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=3D4M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=3D256M]
	Region 4: I/O ports at 70b0 [size=3D8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-

00:19.0 Ethernet controller: Intel Corporation 82577LM Gigabit Network Conn=
ection (rev 05)
	Subsystem: Dell Latitude E6410
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 41
	Region 0: Memory at f6900000 (32-bit, non-prefetchable) [size=3D128K]
	Region 1: Memory at f6980000 (32-bit, non-prefetchable) [size=3D4K]
	Region 2: I/O ports at 7040 [size=3D32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [d0] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 4122
	Capabilities: [e0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: e1000e
	Kernel modules: e1000e

00:1a.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset USB2=
 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device 040a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f6970000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High D=
efinition Audio (rev 05)
	Subsystem: Dell Device 040a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at f6960000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D2-,D3hot+,D3co=
ld+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41d1
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns,=
 L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt-=
 ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D1 ArbSelect=3DFixed TC/VC=3D02
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=3D0f ComponentID=3D00 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D00 AssocRCRB- LinkType=3DM=
emMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Expr=
ess Root Port 1 (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: f5500000-f68fffff
	Prefetchable memory behind bridge: 00000000f6a00000-00000000f6bfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L=
1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not Suppor=
ted ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabl=
ed ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, Equaliza=
tionPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 040a
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Expr=
ess Root Port 2 (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: f4100000-f54fffff
	Prefetchable memory behind bridge: 00000000f6c00000-00000000f6dfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns,=
 L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt-=
 ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not Suppor=
ted ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabl=
ed ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, Equaliza=
tionPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 040a
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Expr=
ess Root Port 3 (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D03, subordinate=3D04, sec-latency=3D0
	I/O behind bridge: 00002000-00003fff
	Memory behind bridge: f0400000-f2cfffff
	Prefetchable memory behind bridge: 00000000f6e00000-00000000f6ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns,=
 L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt-=
 ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not Suppor=
ted ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabl=
ed ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, Equaliza=
tionPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 040a
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Expr=
ess Root Port 4 (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D05, subordinate=3D0a, sec-latency=3D0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: f2d00000-f40fffff
	Prefetchable memory behind bridge: 00000000f7000000-00000000f71fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L=
1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not Suppor=
ted ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabl=
ed ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- Compl=
ianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, Equaliza=
tionPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 040a
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset USB2=
 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device 040a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at f6950000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5) (pro=
g-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=3D00, secondary=3D0b, subordinate=3D0b, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Dell Device 040a

00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface=
 Controller (rev 05)
	Subsystem: Dell Device 040a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=3D10 <?>

00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 p=
ort SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Device 040a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 40
	Region 0: I/O ports at 7090 [size=3D8]
	Region 1: I/O ports at 7080 [size=3D4]
	Region 2: I/O ports at 7070 [size=3D8]
	Region 3: I/O ports at 7060 [size=3D4]
	Region 4: I/O ports at 7020 [size=3D32]
	Region 5: Memory at f6940000 (32-bit, non-prefetchable) [size=3D2K]
	Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4191
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3col=
d-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=3D00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci
	Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Control=
ler (rev 05)
	Subsystem: Dell Device 040a
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 5
	Region 0: Memory at f6930000 (64-bit, non-prefetchable) [size=3D256]
	Region 4: I/O ports at 7000 [size=3D32]

00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Serie=
s Chipset Thermal Subsystem (rev 05)
	Subsystem: Dell Device 040a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 5
	Region 0: Memory at f6920000 (64-bit, non-prefetchable) [size=3D4K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000

02:00.0 Network controller: Broadcom Corporation BCM43224 802.11a/b/g/n (re=
v 01)
	Subsystem: Dell Wireless 1520 Half-size Mini PCIe Card
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f4100000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D2 PME-
	Capabilities: [58] Vendor Specific Information: Len=3D78 <?>
	Capabilities: [48] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L=
1 <64us
			ClockPM+ Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt-=
 ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- =
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+=
 ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-4c-ff-ff-ab-5c-ac
	Capabilities: [16c v1] Power Budgeting <?>

03:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 03) (p=
rog-if 01)
	Subsystem: Dell Latitude E6410
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at f2c40000 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D2 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unli=
mited
			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L=
1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci

03:00.4 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 PCIe IEEE 1394 Controller=
 (rev 03) (prog-if 10 [OHCI])
	Subsystem: Dell Latitude E6410
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f2c00000 (32-bit, non-prefetchable) [size=3D2K]
	Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D2 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unli=
mited
			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L=
1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-

3f:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architectur=
e Generic Non-core Registers (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

3f:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architectur=
e System Address Decoder (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

3f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

3f:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 0=
2)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

3f:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0

3f:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0


8<-----------------------------------------------------------------

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.8.0 Kernel Configuration
#
CONFIG_64BIT=3Dy
CONFIG_X86_64=3Dy
CONFIG_X86=3Dy
CONFIG_INSTRUCTION_DECODER=3Dy
CONFIG_OUTPUT_FORMAT=3D"elf64-x86-64"
CONFIG_ARCH_DEFCONFIG=3D"arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_MMU=3Dy
CONFIG_NEED_DMA_MAP_STATE=3Dy
CONFIG_NEED_SG_DMA_LENGTH=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_GENERIC_GPIO=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
CONFIG_ARCH_HAS_DEFAULT_IDLE=3Dy
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=3Dy
CONFIG_ARCH_HAS_CPU_AUTOPROBE=3Dy
CONFIG_HAVE_SETUP_PER_CPU_AREA=3Dy
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=3Dy
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=3Dy
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=3Dy
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=3Dy
CONFIG_HAVE_INTEL_TXT=3Dy
CONFIG_X86_64_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_ARCH_HWEIGHT_CFLAGS=3D"-fcall-saved-rdi -fcall-saved-rsi -fcall-save=
d-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fc=
all-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=3Dy
CONFIG_ARCH_SUPPORTS_UPROBES=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=3Dy
CONFIG_IRQ_WORK=3Dy
CONFIG_BUILDTIME_EXTABLE_SORT=3Dy

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_CROSS_COMPILE=3D""
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=3Dy
CONFIG_HAVE_KERNEL_BZIP2=3Dy
CONFIG_HAVE_KERNEL_LZMA=3Dy
CONFIG_HAVE_KERNEL_XZ=3Dy
CONFIG_HAVE_KERNEL_LZO=3Dy
CONFIG_KERNEL_GZIP=3Dy
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME=3D"(none)"
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_POSIX_MQUEUE_SYSCTL=3Dy
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=3Dy
CONFIG_AUDITSYSCALL=3Dy
CONFIG_AUDIT_WATCH=3Dy
CONFIG_AUDIT_TREE=3Dy
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=3Dy

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_IRQ_SHOW=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_IRQ_DOMAIN=3Dy
CONFIG_IRQ_DOMAIN_DEBUG=3Dy
CONFIG_IRQ_FORCED_THREADING=3Dy
CONFIG_SPARSE_IRQ=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_ARCH_CLOCKSOURCE_DATA=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=3Dy
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
CONFIG_TASKSTATS=3Dy
CONFIG_TASK_DELAY_ACCT=3Dy
CONFIG_TASK_XACCT=3Dy
CONFIG_TASK_IO_ACCOUNTING=3Dy

#
# RCU Subsystem
#
CONFIG_TREE_RCU=3Dy
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=3D64
CONFIG_RCU_FANOUT_LEAF=3D16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=3D17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=3Dy
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=3Dy
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=3Dy
CONFIG_CGROUPS=3Dy
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=3Dy
CONFIG_CGROUP_DEVICE=3Dy
CONFIG_CPUSETS=3Dy
CONFIG_PROC_PID_CPUSET=3Dy
CONFIG_CGROUP_CPUACCT=3Dy
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=3Dy
CONFIG_FAIR_GROUP_SCHED=3Dy
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=3Dy
CONFIG_UTS_NS=3Dy
CONFIG_IPC_NS=3Dy
CONFIG_PID_NS=3Dy
CONFIG_NET_NS=3Dy
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=3Dy
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_ANON_INODES=3Dy
# CONFIG_EXPERT is not set
CONFIG_HAVE_UID16=3Dy
CONFIG_UID16=3Dy
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=3Dy
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_PCSPKR_PLATFORM=3Dy
CONFIG_HAVE_PCSPKR_PLATFORM=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_AIO=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=3Dy

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=3Dy
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_PCI_QUIRKS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
CONFIG_PROFILING=3Dy
CONFIG_TRACEPOINTS=3Dy
CONFIG_OPROFILE=3Dm
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=3Dy
CONFIG_OPROFILE_NMI_TIMER=3Dy
CONFIG_KPROBES=3Dy
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=3Dy
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_KRETPROBES=3Dy
CONFIG_USER_RETURN_NOTIFIER=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_OPTPROBES=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_HAVE_DMA_ATTRS=3Dy
CONFIG_USE_GENERIC_SMP_HELPERS=3Dy
CONFIG_GENERIC_SMP_IDLE_THREAD=3Dy
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=3Dy
CONFIG_HAVE_DMA_API_DEBUG=3Dy
CONFIG_HAVE_HW_BREAKPOINT=3Dy
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=3Dy
CONFIG_HAVE_USER_RETURN_NOTIFIER=3Dy
CONFIG_HAVE_PERF_EVENTS_NMI=3Dy
CONFIG_HAVE_PERF_REGS=3Dy
CONFIG_HAVE_PERF_USER_STACK_DUMP=3Dy
CONFIG_HAVE_ARCH_JUMP_LABEL=3Dy
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=3Dy
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=3Dy
CONFIG_HAVE_CMPXCHG_LOCAL=3Dy
CONFIG_HAVE_CMPXCHG_DOUBLE=3Dy
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=3Dy
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=3Dy
CONFIG_HAVE_ARCH_SECCOMP_FILTER=3Dy
CONFIG_SECCOMP_FILTER=3Dy
CONFIG_HAVE_CONTEXT_TRACKING=3Dy
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=3Dy
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=3Dy
CONFIG_MODULES_USE_ELF_RELA=3Dy
CONFIG_GENERIC_SIGALTSTACK=3Dy

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
CONFIG_MODULE_FORCE_LOAD=3Dy
CONFIG_MODULE_UNLOAD=3Dy
CONFIG_MODULE_FORCE_UNLOAD=3Dy
CONFIG_MODVERSIONS=3Dy
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
CONFIG_BLK_DEV_BSG=3Dy
CONFIG_BLK_DEV_BSGLIB=3Dy
CONFIG_BLK_DEV_INTEGRITY=3Dy

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
CONFIG_ACORN_PARTITION=3Dy
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=3Dy
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=3Dy
CONFIG_OSF_PARTITION=3Dy
CONFIG_AMIGA_PARTITION=3Dy
CONFIG_ATARI_PARTITION=3Dy
CONFIG_MAC_PARTITION=3Dy
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
CONFIG_MINIX_SUBPARTITION=3Dy
CONFIG_SOLARIS_X86_PARTITION=3Dy
CONFIG_UNIXWARE_DISKLABEL=3Dy
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=3Dy
CONFIG_ULTRIX_PARTITION=3Dy
CONFIG_SUN_PARTITION=3Dy
CONFIG_KARMA_PARTITION=3Dy
CONFIG_EFI_PARTITION=3Dy
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"
CONFIG_PREEMPT_NOTIFIERS=3Dy
CONFIG_INLINE_SPIN_UNLOCK_IRQ=3Dy
CONFIG_INLINE_READ_UNLOCK=3Dy
CONFIG_INLINE_READ_UNLOCK_IRQ=3Dy
CONFIG_INLINE_WRITE_UNLOCK=3Dy
CONFIG_INLINE_WRITE_UNLOCK_IRQ=3Dy
CONFIG_MUTEX_SPIN_ON_OWNER=3Dy
CONFIG_FREEZER=3Dy

#
# Processor type and features
#
CONFIG_ZONE_DMA=3Dy
CONFIG_SMP=3Dy
# CONFIG_X86_X2APIC is not set
CONFIG_X86_MPPARSE=3Dy
CONFIG_X86_EXTENDED_PLATFORM=3Dy
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=3Dy
CONFIG_PARAVIRT_GUEST=3Dy
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=3Dy
CONFIG_PARAVIRT=3Dy
CONFIG_PARAVIRT_SPINLOCKS=3Dy
CONFIG_PARAVIRT_CLOCK=3Dy
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=3Dy
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=3Dy
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=3D6
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_P6_NOP=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMPXCHG64=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D64
CONFIG_X86_DEBUGCTLMSR=3Dy
CONFIG_CPU_SUP_INTEL=3Dy
CONFIG_CPU_SUP_AMD=3Dy
CONFIG_CPU_SUP_CENTAUR=3Dy
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=3Dy
CONFIG_IOMMU_HELPER=3Dy
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=3D8
CONFIG_SCHED_SMT=3Dy
CONFIG_SCHED_MC=3Dy
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=3Dm
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ARCH_DMA_ADDR_T_64BIT=3Dy
CONFIG_DIRECT_GBPAGES=3Dy
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ILLEGAL_POINTER_VALUE=3D0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy
CONFIG_HAVE_MEMBLOCK=3Dy
CONFIG_HAVE_MEMBLOCK_NODE_MAP=3Dy
CONFIG_ARCH_DISCARD_MEMBLOCK=3Dy
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
CONFIG_BALLOON_COMPACTION=3Dy
CONFIG_COMPACTION=3Dy
CONFIG_MIGRATION=3Dy
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
CONFIG_MMU_NOTIFIER=3Dy
CONFIG_KSM=3Dy
CONFIG_DEFAULT_MMAP_MIN_ADDR=3D65536
CONFIG_TRANSPARENT_HUGEPAGE=3Dy
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=3Dy
CONFIG_CROSS_MEMORY_ATTACH=3Dy
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=3D64
CONFIG_MTRR=3Dy
CONFIG_MTRR_SANITIZER=3Dy
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
CONFIG_X86_PAT=3Dy
CONFIG_ARCH_USES_PG_UNCACHED=3Dy
CONFIG_ARCH_RANDOM=3Dy
CONFIG_X86_SMAP=3Dy
# CONFIG_EFI is not set
CONFIG_SECCOMP=3Dy
CONFIG_CC_STACKPROTECTOR=3Dy
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=3Dy
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D250
CONFIG_SCHED_HRTICK=3Dy
CONFIG_KEXEC=3Dy
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=3D0x1000000
CONFIG_RELOCATABLE=3Dy
CONFIG_PHYSICAL_ALIGN=3D0x1000000
CONFIG_HOTPLUG_CPU=3Dy
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=3Dy
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_SUSPEND_FREEZER=3Dy
CONFIG_HIBERNATE_CALLBACKS=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D"/dev/sda2"
CONFIG_PM_SLEEP=3Dy
CONFIG_PM_SLEEP_SMP=3Dy
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=3Dy
CONFIG_PM=3Dy
CONFIG_PM_DEBUG=3Dy
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=3Dy
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=3Dy
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_VIDEO=3Dy
CONFIG_ACPI_FAN=3Dy
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=3Dy
CONFIG_ACPI_PROCESSOR=3Dy
CONFIG_ACPI_HOTPLUG_CPU=3Dy
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=3Dy
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=3Dy
CONFIG_ACPI_CONTAINER=3Dy
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
CONFIG_CPU_FREQ_GOV_COMMON=3Dy
CONFIG_CPU_FREQ_STAT=3Dy
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dm
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_PCC_CPUFREQ=3Dm
CONFIG_X86_ACPI_CPUFREQ=3Dm
CONFIG_X86_ACPI_CPUFREQ_CPB=3Dy
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=3Dy
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_CPU_IDLE_GOV_MENU=3Dy
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=3Dy

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=3Dy
CONFIG_I7300_IDLE=3Dm

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=3Dy
CONFIG_PCIEPORTBUS=3Dy
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=3Dy
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=3Dy
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=3Dy
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=3Dy
CONFIG_ARCH_SUPPORTS_MSI=3Dy
CONFIG_PCI_MSI=3Dy
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=3Dm
CONFIG_HT_IRQ=3Dy
CONFIG_PCI_ATS=3Dy
CONFIG_PCI_IOV=3Dy
CONFIG_PCI_PRI=3Dy
CONFIG_PCI_PASID=3Dy
CONFIG_PCI_IOAPIC=3Dy
CONFIG_PCI_LABEL=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_AMD_NB=3Dy
CONFIG_PCCARD=3Dm
CONFIG_PCMCIA=3Dm
CONFIG_PCMCIA_LOAD_CIS=3Dy
CONFIG_CARDBUS=3Dy

#
# PC-card bridges
#
CONFIG_YENTA=3Dm
CONFIG_YENTA_O2=3Dy
CONFIG_YENTA_RICOH=3Dy
CONFIG_YENTA_TI=3Dy
CONFIG_YENTA_ENE_TUNE=3Dy
CONFIG_YENTA_TOSHIBA=3Dy
CONFIG_PD6729=3Dm
CONFIG_I82092=3Dm
CONFIG_PCCARD_NONSTATIC=3Dy
CONFIG_HOTPLUG_PCI=3Dm
CONFIG_HOTPLUG_PCI_ACPI=3Dm
CONFIG_HOTPLUG_PCI_ACPI_IBM=3Dm
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=3Dm
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=3Dy
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=3Dy
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=3Dm
CONFIG_COREDUMP=3Dy
CONFIG_IA32_EMULATION=3Dy
CONFIG_IA32_AOUT=3Dy
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
CONFIG_KEYS_COMPAT=3Dy
CONFIG_HAVE_TEXT_POKE_SMP=3Dy
CONFIG_X86_DEV_DMA_OPS=3Dy
CONFIG_NET=3Dy
CONFIG_COMPAT_NETLINK_MESSAGES=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=3Dy
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=3Dy
CONFIG_XFRM_ALGO=3Dm
CONFIG_XFRM_USER=3Dm
CONFIG_XFRM_SUB_POLICY=3Dy
CONFIG_XFRM_MIGRATE=3Dy
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=3Dm
CONFIG_NET_KEY=3Dm
CONFIG_NET_KEY_MIGRATE=3Dy
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_IP_ROUTE_MULTIPATH=3Dy
CONFIG_IP_ROUTE_VERBOSE=3Dy
CONFIG_IP_ROUTE_CLASSID=3Dy
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dm
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=3Dy
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=3Dm
CONFIG_INET_ESP=3Dm
CONFIG_INET_IPCOMP=3Dm
CONFIG_INET_XFRM_TUNNEL=3Dm
CONFIG_INET_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_TRANSPORT=3Dm
CONFIG_INET_XFRM_MODE_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_BEET=3Dm
CONFIG_INET_LRO=3Dy
CONFIG_INET_DIAG=3Dm
CONFIG_INET_TCP_DIAG=3Dm
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=3Dy
CONFIG_TCP_CONG_BIC=3Dm
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_TCP_CONG_WESTWOOD=3Dm
CONFIG_TCP_CONG_HTCP=3Dm
CONFIG_TCP_CONG_HSTCP=3Dm
CONFIG_TCP_CONG_HYBLA=3Dm
CONFIG_TCP_CONG_VEGAS=3Dm
CONFIG_TCP_CONG_SCALABLE=3Dm
CONFIG_TCP_CONG_LP=3Dm
CONFIG_TCP_CONG_VENO=3Dm
CONFIG_TCP_CONG_YEAH=3Dm
CONFIG_TCP_CONG_ILLINOIS=3Dm
CONFIG_DEFAULT_CUBIC=3Dy
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
CONFIG_TCP_MD5SIG=3Dy
CONFIG_IPV6=3Dy
CONFIG_IPV6_PRIVACY=3Dy
CONFIG_IPV6_ROUTER_PREF=3Dy
CONFIG_IPV6_ROUTE_INFO=3Dy
CONFIG_IPV6_OPTIMISTIC_DAD=3Dy
CONFIG_INET6_AH=3Dm
CONFIG_INET6_ESP=3Dm
CONFIG_INET6_IPCOMP=3Dm
CONFIG_IPV6_MIP6=3Dy
CONFIG_INET6_XFRM_TUNNEL=3Dm
CONFIG_INET6_TUNNEL=3Dm
CONFIG_INET6_XFRM_MODE_TRANSPORT=3Dm
CONFIG_INET6_XFRM_MODE_TUNNEL=3Dm
CONFIG_INET6_XFRM_MODE_BEET=3Dm
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=3Dm
CONFIG_IPV6_SIT=3Dm
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=3Dy
CONFIG_IPV6_TUNNEL=3Dm
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=3Dy
CONFIG_IPV6_SUBTREES=3Dy
CONFIG_IPV6_MROUTE=3Dy
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=3Dy
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=3Dy
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=3Dy
CONFIG_BRIDGE_NETFILTER=3Dy

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=3Dm
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=3Dm
CONFIG_NETFILTER_NETLINK_LOG=3Dm
CONFIG_NF_CONNTRACK=3Dm
CONFIG_NF_CONNTRACK_MARK=3Dy
CONFIG_NF_CONNTRACK_SECMARK=3Dy
# CONFIG_NF_CONNTRACK_ZONES is not set
CONFIG_NF_CONNTRACK_PROCFS=3Dy
CONFIG_NF_CONNTRACK_EVENTS=3Dy
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=3Dm
CONFIG_NF_CT_PROTO_GRE=3Dm
CONFIG_NF_CT_PROTO_SCTP=3Dm
CONFIG_NF_CT_PROTO_UDPLITE=3Dm
CONFIG_NF_CONNTRACK_AMANDA=3Dm
CONFIG_NF_CONNTRACK_FTP=3Dm
CONFIG_NF_CONNTRACK_H323=3Dm
CONFIG_NF_CONNTRACK_IRC=3Dm
CONFIG_NF_CONNTRACK_BROADCAST=3Dm
CONFIG_NF_CONNTRACK_NETBIOS_NS=3Dm
# CONFIG_NF_CONNTRACK_SNMP is not set
CONFIG_NF_CONNTRACK_PPTP=3Dm
CONFIG_NF_CONNTRACK_SANE=3Dm
CONFIG_NF_CONNTRACK_SIP=3Dm
CONFIG_NF_CONNTRACK_TFTP=3Dm
CONFIG_NF_CT_NETLINK=3Dm
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
CONFIG_NETFILTER_TPROXY=3Dm
CONFIG_NETFILTER_XTABLES=3Dm

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=3Dm
CONFIG_NETFILTER_XT_CONNMARK=3Dm

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_CT=3Dm
CONFIG_NETFILTER_XT_TARGET_DSCP=3Dm
CONFIG_NETFILTER_XT_TARGET_HL=3Dm
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
CONFIG_NETFILTER_XT_TARGET_LED=3Dm
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=3Dm
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dm
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=3Dm
CONFIG_NETFILTER_XT_TARGET_NOTRACK=3Dm
CONFIG_NETFILTER_XT_TARGET_RATEEST=3Dm
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TPROXY=3Dm
CONFIG_NETFILTER_XT_TARGET_TRACE=3Dm
CONFIG_NETFILTER_XT_TARGET_SECMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPMSS=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=3Dm

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=3Dm
CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNMARK=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=3Dm
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=3Dm
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=3Dm
CONFIG_NETFILTER_XT_MATCH_ECN=3Dm
CONFIG_NETFILTER_XT_MATCH_ESP=3Dm
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_HELPER=3Dm
CONFIG_NETFILTER_XT_MATCH_HL=3Dm
CONFIG_NETFILTER_XT_MATCH_IPRANGE=3Dm
# CONFIG_NETFILTER_XT_MATCH_IPVS is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dm
CONFIG_NETFILTER_XT_MATCH_LIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_MAC=3Dm
CONFIG_NETFILTER_XT_MATCH_MARK=3Dm
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=3Dm
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=3Dm
CONFIG_NETFILTER_XT_MATCH_OWNER=3Dm
CONFIG_NETFILTER_XT_MATCH_POLICY=3Dm
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=3Dm
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=3Dm
CONFIG_NETFILTER_XT_MATCH_QUOTA=3Dm
CONFIG_NETFILTER_XT_MATCH_RATEEST=3Dm
CONFIG_NETFILTER_XT_MATCH_REALM=3Dm
CONFIG_NETFILTER_XT_MATCH_RECENT=3Dm
CONFIG_NETFILTER_XT_MATCH_SCTP=3Dm
CONFIG_NETFILTER_XT_MATCH_SOCKET=3Dm
CONFIG_NETFILTER_XT_MATCH_STATE=3Dm
CONFIG_NETFILTER_XT_MATCH_STATISTIC=3Dm
CONFIG_NETFILTER_XT_MATCH_STRING=3Dm
CONFIG_NETFILTER_XT_MATCH_TCPMSS=3Dm
CONFIG_NETFILTER_XT_MATCH_TIME=3Dm
CONFIG_NETFILTER_XT_MATCH_U32=3Dm
# CONFIG_IP_SET is not set
CONFIG_IP_VS=3Dm
CONFIG_IP_VS_IPV6=3Dy
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=3D12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=3Dy
CONFIG_IP_VS_PROTO_UDP=3Dy
CONFIG_IP_VS_PROTO_AH_ESP=3Dy
CONFIG_IP_VS_PROTO_ESP=3Dy
CONFIG_IP_VS_PROTO_AH=3Dy
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=3Dm
CONFIG_IP_VS_WRR=3Dm
CONFIG_IP_VS_LC=3Dm
CONFIG_IP_VS_WLC=3Dm
CONFIG_IP_VS_LBLC=3Dm
CONFIG_IP_VS_LBLCR=3Dm
CONFIG_IP_VS_DH=3Dm
CONFIG_IP_VS_SH=3Dm
CONFIG_IP_VS_SED=3Dm
CONFIG_IP_VS_NQ=3Dm

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=3D8

#
# IPVS application helper
#
CONFIG_IP_VS_NFCT=3Dy
# CONFIG_IP_VS_PE_SIP is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=3Dm
CONFIG_NF_CONNTRACK_IPV4=3Dm
CONFIG_NF_CONNTRACK_PROC_COMPAT=3Dy
CONFIG_IP_NF_QUEUE=3Dm
CONFIG_IP_NF_IPTABLES=3Dm
CONFIG_IP_NF_MATCH_AH=3Dm
CONFIG_IP_NF_MATCH_ECN=3Dm
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=3Dm
CONFIG_IP_NF_FILTER=3Dm
CONFIG_IP_NF_TARGET_REJECT=3Dm
CONFIG_IP_NF_TARGET_ULOG=3Dm
# CONFIG_NF_NAT_IPV4 is not set
CONFIG_IP_NF_MANGLE=3Dm
CONFIG_IP_NF_TARGET_CLUSTERIP=3Dm
CONFIG_IP_NF_TARGET_ECN=3Dm
CONFIG_IP_NF_TARGET_TTL=3Dm
CONFIG_IP_NF_RAW=3Dm
CONFIG_IP_NF_SECURITY=3Dm
CONFIG_IP_NF_ARPTABLES=3Dm
CONFIG_IP_NF_ARPFILTER=3Dm
CONFIG_IP_NF_ARP_MANGLE=3Dm

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=3Dm
CONFIG_NF_CONNTRACK_IPV6=3Dm
CONFIG_IP6_NF_IPTABLES=3Dm
CONFIG_IP6_NF_MATCH_AH=3Dm
CONFIG_IP6_NF_MATCH_EUI64=3Dm
CONFIG_IP6_NF_MATCH_FRAG=3Dm
CONFIG_IP6_NF_MATCH_OPTS=3Dm
CONFIG_IP6_NF_MATCH_HL=3Dm
CONFIG_IP6_NF_MATCH_IPV6HEADER=3Dm
CONFIG_IP6_NF_MATCH_MH=3Dm
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
CONFIG_IP6_NF_MATCH_RT=3Dm
CONFIG_IP6_NF_TARGET_HL=3Dm
CONFIG_IP6_NF_FILTER=3Dm
CONFIG_IP6_NF_TARGET_REJECT=3Dm
CONFIG_IP6_NF_MANGLE=3Dm
CONFIG_IP6_NF_RAW=3Dm
CONFIG_IP6_NF_SECURITY=3Dm
# CONFIG_NF_NAT_IPV6 is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=3Dm
CONFIG_BRIDGE_NF_EBTABLES=3Dm
CONFIG_BRIDGE_EBT_BROUTE=3Dm
CONFIG_BRIDGE_EBT_T_FILTER=3Dm
CONFIG_BRIDGE_EBT_T_NAT=3Dm
CONFIG_BRIDGE_EBT_802_3=3Dm
CONFIG_BRIDGE_EBT_AMONG=3Dm
CONFIG_BRIDGE_EBT_ARP=3Dm
CONFIG_BRIDGE_EBT_IP=3Dm
CONFIG_BRIDGE_EBT_IP6=3Dm
CONFIG_BRIDGE_EBT_LIMIT=3Dm
CONFIG_BRIDGE_EBT_MARK=3Dm
CONFIG_BRIDGE_EBT_PKTTYPE=3Dm
CONFIG_BRIDGE_EBT_STP=3Dm
CONFIG_BRIDGE_EBT_VLAN=3Dm
CONFIG_BRIDGE_EBT_ARPREPLY=3Dm
CONFIG_BRIDGE_EBT_DNAT=3Dm
CONFIG_BRIDGE_EBT_MARK_T=3Dm
CONFIG_BRIDGE_EBT_REDIRECT=3Dm
CONFIG_BRIDGE_EBT_SNAT=3Dm
CONFIG_BRIDGE_EBT_LOG=3Dm
CONFIG_BRIDGE_EBT_ULOG=3Dm
CONFIG_BRIDGE_EBT_NFLOG=3Dm
CONFIG_IP_DCCP=3Dm
CONFIG_INET_DCCP_DIAG=3Dm

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=3Dy
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=3Dy

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=3Dm
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=3Dy
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=3Dy
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
CONFIG_RDS=3Dm
CONFIG_RDS_TCP=3Dm
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=3Dm
CONFIG_TIPC_PORTS=3D8191
CONFIG_ATM=3Dm
CONFIG_ATM_CLIP=3Dm
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=3Dm
CONFIG_ATM_MPOA=3Dm
CONFIG_ATM_BR2684=3Dm
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
CONFIG_STP=3Dm
CONFIG_GARP=3Dm
CONFIG_BRIDGE=3Dm
CONFIG_BRIDGE_IGMP_SNOOPING=3Dy
CONFIG_HAVE_NET_DSA=3Dy
CONFIG_VLAN_8021Q=3Dm
CONFIG_VLAN_8021Q_GVRP=3Dy
CONFIG_DECNET=3Dm
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=3Dm
CONFIG_LLC2=3Dm
CONFIG_IPX=3Dm
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=3Dm
CONFIG_DEV_APPLETALK=3Dm
CONFIG_IPDDP=3Dm
CONFIG_IPDDP_ENCAP=3Dy
CONFIG_IPDDP_DECAP=3Dy
CONFIG_X25=3Dm
CONFIG_LAPB=3Dm
CONFIG_WAN_ROUTER=3Dm
CONFIG_PHONET=3Dm
CONFIG_IEEE802154=3Dm
# CONFIG_IEEE802154_6LOWPAN is not set
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=3Dy

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=3Dm
CONFIG_NET_SCH_HTB=3Dm
CONFIG_NET_SCH_HFSC=3Dm
CONFIG_NET_SCH_ATM=3Dm
CONFIG_NET_SCH_PRIO=3Dm
CONFIG_NET_SCH_MULTIQ=3Dm
CONFIG_NET_SCH_RED=3Dm
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=3Dm
CONFIG_NET_SCH_TEQL=3Dm
CONFIG_NET_SCH_TBF=3Dm
CONFIG_NET_SCH_GRED=3Dm
CONFIG_NET_SCH_DSMARK=3Dm
CONFIG_NET_SCH_NETEM=3Dm
CONFIG_NET_SCH_DRR=3Dm
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_INGRESS=3Dm
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=3Dy
CONFIG_NET_CLS_BASIC=3Dm
CONFIG_NET_CLS_TCINDEX=3Dm
CONFIG_NET_CLS_ROUTE4=3Dm
CONFIG_NET_CLS_FW=3Dm
CONFIG_NET_CLS_U32=3Dm
CONFIG_CLS_U32_PERF=3Dy
CONFIG_CLS_U32_MARK=3Dy
CONFIG_NET_CLS_RSVP=3Dm
CONFIG_NET_CLS_RSVP6=3Dm
CONFIG_NET_CLS_FLOW=3Dm
CONFIG_NET_CLS_CGROUP=3Dy
CONFIG_NET_EMATCH=3Dy
CONFIG_NET_EMATCH_STACK=3D32
CONFIG_NET_EMATCH_CMP=3Dm
CONFIG_NET_EMATCH_NBYTE=3Dm
CONFIG_NET_EMATCH_U32=3Dm
CONFIG_NET_EMATCH_META=3Dm
CONFIG_NET_EMATCH_TEXT=3Dm
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_CLS_ACT=3Dy
CONFIG_NET_ACT_POLICE=3Dm
CONFIG_NET_ACT_GACT=3Dm
CONFIG_GACT_PROB=3Dy
CONFIG_NET_ACT_MIRRED=3Dm
CONFIG_NET_ACT_IPT=3Dm
CONFIG_NET_ACT_NAT=3Dm
CONFIG_NET_ACT_PEDIT=3Dm
CONFIG_NET_ACT_SIMP=3Dm
CONFIG_NET_ACT_SKBEDIT=3Dm
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=3Dy
CONFIG_NET_SCH_FIFO=3Dy
CONFIG_DCB=3Dy
CONFIG_DNS_RESOLVER=3Dy
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=3Dy
CONFIG_RFS_ACCEL=3Dy
CONFIG_XPS=3Dy
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=3Dy
# CONFIG_BPF_JIT is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=3Dm
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=3Dy
CONFIG_HAMRADIO=3Dy

#
# Packet Radio protocols
#
CONFIG_AX25=3Dm
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=3Dm
CONFIG_ROSE=3Dm

#
# AX.25 network device drivers
#
CONFIG_MKISS=3Dm
CONFIG_6PACK=3Dm
CONFIG_BPQETHER=3Dm
CONFIG_BAYCOM_SER_FDX=3Dm
CONFIG_BAYCOM_SER_HDX=3Dm
CONFIG_BAYCOM_PAR=3Dm
CONFIG_YAM=3Dm
CONFIG_CAN=3Dm
CONFIG_CAN_RAW=3Dm
CONFIG_CAN_BCM=3Dm
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=3Dm
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=3Dm
CONFIG_CAN_CALC_BITTIMING=3Dy
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=3Dm
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=3Dm
# CONFIG_CAN_EMS_PCMCIA is not set
CONFIG_CAN_EMS_PCI=3Dm
# CONFIG_CAN_PEAK_PCMCIA is not set
# CONFIG_CAN_PEAK_PCI is not set
CONFIG_CAN_KVASER_PCI=3Dm
# CONFIG_CAN_PLX_PCI is not set
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=3Dm
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=3Dm

#
# IrDA protocols
#
CONFIG_IRLAN=3Dm
CONFIG_IRNET=3Dm
CONFIG_IRCOMM=3Dm
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
CONFIG_IRDA_FAST_RR=3Dy
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=3Dm

#
# Dongle support
#
CONFIG_DONGLE=3Dy
CONFIG_ESI_DONGLE=3Dm
CONFIG_ACTISYS_DONGLE=3Dm
CONFIG_TEKRAM_DONGLE=3Dm
CONFIG_TOIM3232_DONGLE=3Dm
CONFIG_LITELINK_DONGLE=3Dm
CONFIG_MA600_DONGLE=3Dm
CONFIG_GIRBIL_DONGLE=3Dm
CONFIG_MCP2120_DONGLE=3Dm
CONFIG_OLD_BELKIN_DONGLE=3Dm
CONFIG_ACT200L_DONGLE=3Dm
CONFIG_KINGSUN_DONGLE=3Dm
CONFIG_KSDAZZLE_DONGLE=3Dm
CONFIG_KS959_DONGLE=3Dm

#
# FIR device drivers
#
CONFIG_USB_IRDA=3Dm
CONFIG_SIGMATEL_FIR=3Dm
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=3Dm
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=3Dm
CONFIG_BT=3Dm
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=3Dm
CONFIG_BT_HCIBTSDIO=3Dm
CONFIG_BT_HCIUART=3Dm
CONFIG_BT_HCIUART_H4=3Dy
CONFIG_BT_HCIUART_BCSP=3Dy
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=3Dy
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIBCM203X=3Dm
CONFIG_BT_HCIBPA10X=3Dm
CONFIG_BT_HCIBFUSB=3Dm
CONFIG_BT_HCIDTL1=3Dm
CONFIG_BT_HCIBT3C=3Dm
CONFIG_BT_HCIBLUECARD=3Dm
CONFIG_BT_HCIBTUART=3Dm
CONFIG_BT_HCIVHCI=3Dm
CONFIG_BT_MRVL=3Dm
CONFIG_BT_MRVL_SDIO=3Dm
# CONFIG_BT_ATH3K is not set
CONFIG_AF_RXRPC=3Dm
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=3Dm
CONFIG_FIB_RULES=3Dy
CONFIG_WIRELESS=3Dy
CONFIG_WEXT_CORE=3Dy
CONFIG_WEXT_PROC=3Dy
CONFIG_CFG80211=3Dm
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=3Dy
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=3Dy
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=3Dm
CONFIG_MAC80211_HAS_RC=3Dy
CONFIG_MAC80211_RC_MINSTREL=3Dy
CONFIG_MAC80211_RC_MINSTREL_HT=3Dy
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
CONFIG_MAC80211_RC_DEFAULT=3D"minstrel_ht"
CONFIG_MAC80211_MESH=3Dy
CONFIG_MAC80211_LEDS=3Dy
CONFIG_MAC80211_DEBUGFS=3Dy
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=3Dm
CONFIG_WIMAX_DEBUG_LEVEL=3D8
CONFIG_RFKILL=3Dm
CONFIG_RFKILL_LEDS=3Dy
CONFIG_RFKILL_INPUT=3Dy
CONFIG_NET_9P=3Dm
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=3Dy

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D""
CONFIG_DEVTMPFS=3Dy
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=3Dy
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=3D""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=3Dy

#
# Bus devices
#
CONFIG_CONNECTOR=3Dm
# CONFIG_MTD is not set
CONFIG_PARPORT=3Dm
CONFIG_PARPORT_PC=3Dm
CONFIG_PARPORT_SERIAL=3Dm
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=3Dm
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=3Dm
CONFIG_PARPORT_1284=3Dy
CONFIG_PARPORT_NOT_PC=3Dy
CONFIG_PNP=3Dy
CONFIG_PNP_DEBUG_MESSAGES=3Dy

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=3Dy
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dy
CONFIG_BLK_DEV_LOOP_MIN_COUNT=3D8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_DRBD=3Dm
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=3Dm
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SX8=3Dm
CONFIG_BLK_DEV_RAM=3Dm
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=3Dm
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=3Dy
CONFIG_IDE=3Dy

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=3Dy
CONFIG_RAID_ATTRS=3Dm
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dy
CONFIG_SCSI_NETLINK=3Dy
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=3Dy
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dy
CONFIG_CHR_DEV_SCH=3Dy
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
CONFIG_SCSI_SCAN_ASYNC=3Dy

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dm
CONFIG_SCSI_FC_ATTRS=3Dm
CONFIG_SCSI_FC_TGT_ATTRS=3Dy
CONFIG_SCSI_ISCSI_ATTRS=3Dm
CONFIG_SCSI_SAS_ATTRS=3Dm
CONFIG_SCSI_SAS_LIBSAS=3Dm
CONFIG_SCSI_SAS_ATA=3Dy
CONFIG_SCSI_SAS_HOST_SMP=3Dy
CONFIG_SCSI_SRP_ATTRS=3Dm
CONFIG_SCSI_SRP_TGT_ATTRS=3Dy
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=3Dy
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=3Dy
CONFIG_ATA_ACPI=3Dy
CONFIG_SATA_PMP=3Dy

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=3Dy
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=3Dy
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=3Dy
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=3Dy
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=3Dm
CONFIG_FIREWIRE_OHCI=3Dm
CONFIG_FIREWIRE_SBP2=3Dm
CONFIG_FIREWIRE_NET=3Dm
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=3Dy
CONFIG_NET_CORE=3Dy
# CONFIG_BONDING is not set
CONFIG_DUMMY=3Dm
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=3Dm
CONFIG_IFB=3Dm
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=3Dm
CONFIG_VETH=3Dm
# CONFIG_VIRTIO_NET is not set
CONFIG_SUNGEM_PHY=3Dm
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=3Dy
CONFIG_NET_VENDOR_3COM=3Dy
CONFIG_PCMCIA_3C574=3Dm
CONFIG_PCMCIA_3C589=3Dm
CONFIG_VORTEX=3Dm
CONFIG_TYPHOON=3Dm
CONFIG_NET_VENDOR_ADAPTEC=3Dy
CONFIG_ADAPTEC_STARFIRE=3Dm
CONFIG_NET_VENDOR_ALTEON=3Dy
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=3Dy
CONFIG_AMD8111_ETH=3Dm
CONFIG_PCNET32=3Dm
CONFIG_PCMCIA_NMCLAN=3Dm
CONFIG_NET_VENDOR_ATHEROS=3Dy
CONFIG_ATL2=3Dm
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_NET_CADENCE=3Dy
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=3Dy
CONFIG_B44=3Dm
CONFIG_B44_PCI_AUTOSELECT=3Dy
CONFIG_B44_PCICORE_AUTOSELECT=3Dy
CONFIG_B44_PCI=3Dy
CONFIG_BNX2=3Dm
CONFIG_CNIC=3Dm
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=3Dy
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=3Dy
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=3Dy
# CONFIG_ENIC is not set
CONFIG_DNET=3Dm
CONFIG_NET_VENDOR_DEC=3Dy
CONFIG_NET_TULIP=3Dy
CONFIG_DE2104X=3Dm
CONFIG_DE2104X_DSL=3D0
CONFIG_TULIP=3Dm
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=3Dy
CONFIG_TULIP_NAPI_HW_MITIGATION=3Dy
CONFIG_DE4X5=3Dm
CONFIG_WINBOND_840=3Dm
CONFIG_DM9102=3Dm
CONFIG_ULI526X=3Dm
CONFIG_PCMCIA_XIRCOM=3Dm
CONFIG_NET_VENDOR_DLINK=3Dy
# CONFIG_DE600 is not set
# CONFIG_DE620 is not set
# CONFIG_DL2K is not set
CONFIG_SUNDANCE=3Dm
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_NET_VENDOR_EMULEX=3Dy
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=3Dy
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=3Dy
CONFIG_PCMCIA_FMVJ18X=3Dm
CONFIG_NET_VENDOR_HP=3Dy
CONFIG_HP100=3Dm
CONFIG_NET_VENDOR_INTEL=3Dy
CONFIG_E100=3Dm
# CONFIG_E1000 is not set
CONFIG_E1000E=3Dm
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
CONFIG_NET_VENDOR_I825XX=3Dy
# CONFIG_ZNET is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=3Dy
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=3Dy
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=3Dy
CONFIG_KS8851_MLL=3Dm
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=3Dy
# CONFIG_MYRI10GE is not set
CONFIG_FEALNX=3Dm
CONFIG_NET_VENDOR_NATSEMI=3Dy
CONFIG_NATSEMI=3Dm
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=3Dy
CONFIG_PCMCIA_AXNET=3Dm
CONFIG_NE2K_PCI=3Dm
CONFIG_PCMCIA_PCNET=3Dm
CONFIG_NET_VENDOR_NVIDIA=3Dy
CONFIG_FORCEDETH=3Dm
CONFIG_NET_VENDOR_OKI=3Dy
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=3Dm
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=3Dy
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=3Dy
# CONFIG_ATP is not set
CONFIG_8139CP=3Dm
CONFIG_8139TOO=3Dm
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=3Dy
CONFIG_8139TOO_8129=3Dy
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RDC=3Dy
CONFIG_R6040=3Dm
CONFIG_NET_VENDOR_SEEQ=3Dy
# CONFIG_SEEQ8005 is not set
CONFIG_NET_VENDOR_SILAN=3Dy
CONFIG_SC92031=3Dm
CONFIG_NET_VENDOR_SIS=3Dy
CONFIG_SIS900=3Dm
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=3Dy
CONFIG_PCMCIA_SMC91C92=3Dm
CONFIG_EPIC100=3Dm
CONFIG_SMSC9420=3Dm
CONFIG_NET_VENDOR_STMICRO=3Dy
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=3Dy
CONFIG_HAPPYMEAL=3Dm
CONFIG_SUNGEM=3Dm
CONFIG_CASSINI=3Dm
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=3Dy
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=3Dy
CONFIG_TLAN=3Dm
CONFIG_NET_VENDOR_VIA=3Dy
CONFIG_VIA_RHINE=3Dm
# CONFIG_VIA_RHINE_MMIO is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=3Dy
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=3Dy
CONFIG_PCMCIA_XIRC2PS=3Dm
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=3Dy

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=3Dm
CONFIG_BROADCOM_PHY=3Dm
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_PLIP=3Dm
CONFIG_PPP=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_MPPE=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPPOATM=3Dm
CONFIG_PPPOE=3Dm
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
# CONFIG_SLIP is not set
CONFIG_SLHC=3Dm

#
# USB Network Adapters
#
CONFIG_USB_CATC=3Dm
CONFIG_USB_KAWETH=3Dm
CONFIG_USB_PEGASUS=3Dm
CONFIG_USB_RTL8150=3Dm
CONFIG_USB_USBNET=3Dm
CONFIG_USB_NET_AX8817X=3Dm
CONFIG_USB_NET_CDCETHER=3Dm
CONFIG_USB_NET_CDC_EEM=3Dm
CONFIG_USB_NET_CDC_NCM=3Dm
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=3Dm
CONFIG_USB_NET_SMSC75XX=3Dm
CONFIG_USB_NET_SMSC95XX=3Dm
CONFIG_USB_NET_GL620A=3Dm
CONFIG_USB_NET_NET1080=3Dm
CONFIG_USB_NET_PLUSB=3Dm
CONFIG_USB_NET_MCS7830=3Dm
CONFIG_USB_NET_RNDIS_HOST=3Dm
CONFIG_USB_NET_CDC_SUBSET=3Dm
CONFIG_USB_ALI_M5632=3Dy
CONFIG_USB_AN2720=3Dy
CONFIG_USB_BELKIN=3Dy
CONFIG_USB_ARMLINUX=3Dy
CONFIG_USB_EPSON2888=3Dy
CONFIG_USB_KC2190=3Dy
CONFIG_USB_NET_ZAURUS=3Dm
CONFIG_USB_NET_CX82310_ETH=3Dm
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_HSO=3Dm
CONFIG_USB_NET_INT51X1=3Dm
CONFIG_USB_CDC_PHONET=3Dm
CONFIG_USB_IPHETH=3Dm
CONFIG_USB_SIERRA_NET=3Dm
CONFIG_USB_VL600=3Dm
CONFIG_WLAN=3Dy
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_CARDS is not set
CONFIG_B43=3Dm
CONFIG_B43_SSB=3Dy
CONFIG_B43_PCI_AUTOSELECT=3Dy
CONFIG_B43_PCICORE_AUTOSELECT=3Dy
# CONFIG_B43_PCMCIA is not set
# CONFIG_B43_SDIO is not set
CONFIG_B43_PIO=3Dy
# CONFIG_B43_PHY_N is not set
CONFIG_B43_PHY_LP=3Dy
CONFIG_B43_PHY_HT=3Dy
CONFIG_B43_LEDS=3Dy
CONFIG_B43_HWRNG=3Dy
# CONFIG_B43_DEBUG is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
CONFIG_RT2X00=3Dm
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
CONFIG_RT2500USB=3Dm
CONFIG_RT73USB=3Dm
CONFIG_RT2800USB=3Dm
CONFIG_RT2800USB_RT33XX=3Dy
CONFIG_RT2800USB_RT35XX=3Dy
# CONFIG_RT2800USB_RT53XX is not set
CONFIG_RT2800USB_UNKNOWN=3Dy
CONFIG_RT2800_LIB=3Dm
CONFIG_RT2X00_LIB_USB=3Dm
CONFIG_RT2X00_LIB=3Dm
CONFIG_RT2X00_LIB_FIRMWARE=3Dy
CONFIG_RT2X00_LIB_CRYPTO=3Dy
CONFIG_RT2X00_LIB_LEDS=3Dy
CONFIG_RT2X00_LIB_DEBUGFS=3Dy
CONFIG_RT2X00_DEBUG=3Dy
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL_TI is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
CONFIG_INPUT_FF_MEMLESS=3Dm
CONFIG_INPUT_POLLDEV=3Dm
CONFIG_INPUT_SPARSEKMAP=3Dm
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dm
CONFIG_INPUT_EVDEV=3Dm
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ADP5588=3Dm
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=3Dm
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=3Dm
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=3Dm
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=3Dm
CONFIG_KEYBOARD_OPENCORES=3Dm
CONFIG_KEYBOARD_STOWAWAY=3Dm
CONFIG_KEYBOARD_SUNKBD=3Dm
CONFIG_KEYBOARD_XTKBD=3Dm
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dm
CONFIG_MOUSE_PS2_ALPS=3Dy
CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
CONFIG_MOUSE_PS2_LIFEBOOK=3Dy
CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
CONFIG_MOUSE_PS2_ELANTECH=3Dy
CONFIG_MOUSE_PS2_SENTELIC=3Dy
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=3Dm
CONFIG_MOUSE_APPLETOUCH=3Dm
CONFIG_MOUSE_BCM5974=3Dm
CONFIG_MOUSE_VSXXXAA=3Dm
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=3Dm
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=3Dy
CONFIG_JOYSTICK_ANALOG=3Dm
CONFIG_JOYSTICK_A3D=3Dm
CONFIG_JOYSTICK_ADI=3Dm
CONFIG_JOYSTICK_COBRA=3Dm
CONFIG_JOYSTICK_GF2K=3Dm
CONFIG_JOYSTICK_GRIP=3Dm
CONFIG_JOYSTICK_GRIP_MP=3Dm
CONFIG_JOYSTICK_GUILLEMOT=3Dm
CONFIG_JOYSTICK_INTERACT=3Dm
CONFIG_JOYSTICK_SIDEWINDER=3Dm
CONFIG_JOYSTICK_TMDC=3Dm
CONFIG_JOYSTICK_IFORCE=3Dm
CONFIG_JOYSTICK_IFORCE_USB=3Dy
CONFIG_JOYSTICK_IFORCE_232=3Dy
CONFIG_JOYSTICK_WARRIOR=3Dm
CONFIG_JOYSTICK_MAGELLAN=3Dm
CONFIG_JOYSTICK_SPACEORB=3Dm
CONFIG_JOYSTICK_SPACEBALL=3Dm
CONFIG_JOYSTICK_STINGER=3Dm
CONFIG_JOYSTICK_TWIDJOY=3Dm
CONFIG_JOYSTICK_ZHENHUA=3Dm
CONFIG_JOYSTICK_DB9=3Dm
CONFIG_JOYSTICK_GAMECON=3Dm
CONFIG_JOYSTICK_TURBOGRAFX=3Dm
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=3Dm
CONFIG_JOYSTICK_XPAD=3Dm
CONFIG_JOYSTICK_XPAD_FF=3Dy
CONFIG_JOYSTICK_XPAD_LEDS=3Dy
CONFIG_JOYSTICK_WALKERA0701=3Dm
CONFIG_INPUT_TABLET=3Dy
CONFIG_TABLET_USB_ACECAD=3Dm
CONFIG_TABLET_USB_AIPTEK=3Dm
CONFIG_TABLET_USB_GTCO=3Dm
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=3Dm
CONFIG_TABLET_USB_WACOM=3Dm
CONFIG_INPUT_TOUCHSCREEN=3Dy
CONFIG_TOUCHSCREEN_AD7879=3Dm
CONFIG_TOUCHSCREEN_AD7879_I2C=3Dm
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=3Dm
CONFIG_TOUCHSCREEN_FUJITSU=3Dm
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=3Dm
CONFIG_TOUCHSCREEN_ELO=3Dm
CONFIG_TOUCHSCREEN_WACOM_W8001=3Dm
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=3Dm
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=3Dm
CONFIG_TOUCHSCREEN_INEXIO=3Dm
CONFIG_TOUCHSCREEN_MK712=3Dm
CONFIG_TOUCHSCREEN_PENMOUNT=3Dm
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=3Dm
CONFIG_TOUCHSCREEN_TOUCHWIN=3Dm
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=3Dm
CONFIG_TOUCHSCREEN_USB_EGALAX=3Dy
CONFIG_TOUCHSCREEN_USB_PANJIT=3Dy
CONFIG_TOUCHSCREEN_USB_3M=3Dy
CONFIG_TOUCHSCREEN_USB_ITM=3Dy
CONFIG_TOUCHSCREEN_USB_ETURBO=3Dy
CONFIG_TOUCHSCREEN_USB_GUNZE=3Dy
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=3Dy
CONFIG_TOUCHSCREEN_USB_IRTOUCH=3Dy
CONFIG_TOUCHSCREEN_USB_IDEALTEK=3Dy
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=3Dy
CONFIG_TOUCHSCREEN_USB_GOTOP=3Dy
CONFIG_TOUCHSCREEN_USB_JASTEC=3Dy
CONFIG_TOUCHSCREEN_USB_ELO=3Dy
CONFIG_TOUCHSCREEN_USB_E2I=3Dy
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=3Dy
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=3Dy
CONFIG_TOUCHSCREEN_USB_NEXIO=3Dy
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=3Dy
CONFIG_TOUCHSCREEN_TOUCHIT213=3Dm
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=3Dm
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=3Dy
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=3Dm
CONFIG_INPUT_KEYSPAN_REMOTE=3Dm
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=3Dm
CONFIG_INPUT_YEALINK=3Dm
CONFIG_INPUT_CM109=3Dm
CONFIG_INPUT_UINPUT=3Dm
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dm
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=3Dm
CONFIG_SERIO_PCIPS2=3Dm
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=3Dm
CONFIG_GAMEPORT_NS558=3Dm
CONFIG_GAMEPORT_L4=3Dm
CONFIG_GAMEPORT_EMU10K1=3Dm
CONFIG_GAMEPORT_FM801=3Dm

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_VT_CONSOLE_SLEEP=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
CONFIG_UNIX98_PTYS=3Dy
CONFIG_DEVPTS_MULTIPLE_INSTANCES=3Dy
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_CONSOLE=3Dy
CONFIG_FIX_EARLYCON_MEM=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_CS=3Dm
CONFIG_SERIAL_8250_NR_UARTS=3D32
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
CONFIG_SERIAL_8250_MANY_PORTS=3Dy
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=3Dy

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_CORE_CONSOLE=3Dy
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dm
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=3Dm
CONFIG_HW_RANDOM_AMD=3Dm
CONFIG_HW_RANDOM_VIA=3Dm
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=3Dm
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=3Dm
CONFIG_CARDMAN_4000=3Dm
CONFIG_CARDMAN_4040=3Dm
CONFIG_IPWIRELESS=3Dm
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=3Dm
CONFIG_MAX_RAW_DEVS=3D256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
CONFIG_I2C=3Dy
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_COMPAT=3Dy
CONFIG_I2C_CHARDEV=3Dm
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=3Dy
CONFIG_I2C_ALGOBIT=3Dy

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=3Dm
CONFIG_I2C_ISCH=3Dm
CONFIG_I2C_PIIX4=3Dm
CONFIG_I2C_NFORCE2=3Dm
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=3Dm

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=3Dy
CONFIG_GPIOLIB=3Dy
CONFIG_GPIO_ACPI=3Dy
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=3Dy
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=3Dy
CONFIG_THERMAL_HWMON=3Dy
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=3Dy
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_FAIR_SHARE is not set
CONFIG_STEP_WISE=3Dy
# CONFIG_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
CONFIG_WATCHDOG=3Dy
CONFIG_WATCHDOG_CORE=3Dy
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=3Dm
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=3Dm
CONFIG_HPWDT_NMI_DECODING=3Dy
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=3Dy

#
# Sonics Silicon Backplane
#
CONFIG_SSB=3Dm
CONFIG_SSB_SPROM=3Dy
CONFIG_SSB_BLOCKIO=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
CONFIG_SSB_PCIHOST=3Dy
CONFIG_SSB_B43_PCI_BRIDGE=3Dy
CONFIG_SSB_PCMCIAHOST_POSSIBLE=3Dy
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=3Dy
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
CONFIG_SSB_DRIVER_PCICORE=3Dy
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=3Dy

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=3Dm
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=3Dm
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=3Dm

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Customise DVB Frontends
#
CONFIG_DVB_TUNER_DIB0070=3Dm
CONFIG_DVB_TUNER_DIB0090=3Dm

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=3Dy
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=3Dy
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=3Dy
CONFIG_VGA_ARB_MAX_GPUS=3D16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=3Dy
CONFIG_DRM_KMS_HELPER=3Dy
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=3Dy
CONFIG_DRM_I915_KMS=3Dy
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=3Dy
CONFIG_FB=3Dy
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=3Dy
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy
CONFIG_LOGO=3Dy
CONFIG_LOGO_LINUX_MONO=3Dy
CONFIG_LOGO_LINUX_VGA16=3Dy
CONFIG_LOGO_LINUX_CLUT224=3Dy
CONFIG_SOUND=3Dm
CONFIG_SOUND_OSS_CORE=3Dy
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=3Dm
CONFIG_SND_TIMER=3Dm
CONFIG_SND_PCM=3Dm
CONFIG_SND_HWDEP=3Dm
CONFIG_SND_RAWMIDI=3Dm
CONFIG_SND_JACK=3Dy
CONFIG_SND_SEQUENCER=3Dm
CONFIG_SND_SEQ_DUMMY=3Dm
CONFIG_SND_OSSEMUL=3Dy
CONFIG_SND_MIXER_OSS=3Dm
CONFIG_SND_PCM_OSS=3Dm
CONFIG_SND_PCM_OSS_PLUGINS=3Dy
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=3Dm
CONFIG_SND_SEQ_HRTIMER_DEFAULT=3Dy
CONFIG_SND_DYNAMIC_MINORS=3Dy
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=3Dy
CONFIG_SND_KCTL_JACK=3Dy
CONFIG_SND_DMA_SGBUF=3Dy
CONFIG_SND_RAWMIDI_SEQ=3Dm
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND_DRIVERS=3Dy
# CONFIG_SND_PCSP is not set
CONFIG_SND_DUMMY=3Dm
# CONFIG_SND_ALOOP is not set
CONFIG_SND_VIRMIDI=3Dm
CONFIG_SND_MTPAV=3Dm
CONFIG_SND_MTS64=3Dm
CONFIG_SND_SERIAL_U16550=3Dm
CONFIG_SND_MPU401=3Dm
CONFIG_SND_PORTMAN2X4=3Dm
CONFIG_SND_PCI=3Dy
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=3Dm
CONFIG_SND_HDA_PREALLOC_SIZE=3D64
CONFIG_SND_HDA_HWDEP=3Dy
CONFIG_SND_HDA_RECONFIG=3Dy
CONFIG_SND_HDA_INPUT_BEEP=3Dy
CONFIG_SND_HDA_INPUT_BEEP_MODE=3D1
CONFIG_SND_HDA_INPUT_JACK=3Dy
CONFIG_SND_HDA_PATCH_LOADER=3Dy
CONFIG_SND_HDA_CODEC_REALTEK=3Dy
CONFIG_SND_HDA_CODEC_ANALOG=3Dy
CONFIG_SND_HDA_CODEC_SIGMATEL=3Dy
CONFIG_SND_HDA_CODEC_VIA=3Dy
CONFIG_SND_HDA_CODEC_HDMI=3Dy
CONFIG_SND_HDA_CODEC_CIRRUS=3Dy
CONFIG_SND_HDA_CODEC_CONEXANT=3Dy
CONFIG_SND_HDA_CODEC_CA0110=3Dy
CONFIG_SND_HDA_CODEC_CA0132=3Dy
CONFIG_SND_HDA_CODEC_CMEDIA=3Dy
CONFIG_SND_HDA_CODEC_SI3054=3Dy
CONFIG_SND_HDA_GENERIC=3Dy
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=3D0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=3Dm
CONFIG_HIDRAW=3Dy
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=3Dm

#
# Special HID drivers
#
CONFIG_HID_A4TECH=3Dm
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=3Dm
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=3Dm
CONFIG_HID_CHERRY=3Dm
CONFIG_HID_CHICONY=3Dm
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=3Dm
CONFIG_HID_DRAGONRISE=3Dm
CONFIG_DRAGONRISE_FF=3Dy
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=3Dm
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=3Dm
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=3Dm
CONFIG_HID_TWINHAN=3Dm
CONFIG_HID_KENSINGTON=3Dm
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=3Dm
CONFIG_HID_LOGITECH_DJ=3Dm
CONFIG_LOGITECH_FF=3Dy
CONFIG_LOGIRUMBLEPAD2_FF=3Dy
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=3Dy
CONFIG_HID_MICROSOFT=3Dm
CONFIG_HID_MONTEREY=3Dm
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=3Dm
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=3Dm
CONFIG_PANTHERLORD_FF=3Dy
CONFIG_HID_PETALYNX=3Dm
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=3Dm
CONFIG_HID_SONY=3Dm
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=3Dm
CONFIG_HID_GREENASIA=3Dm
CONFIG_GREENASIA_FF=3Dy
CONFIG_HID_SMARTJOYPLUS=3Dm
CONFIG_SMARTJOYPLUS_FF=3Dy
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=3Dm
CONFIG_HID_THRUSTMASTER=3Dm
CONFIG_THRUSTMASTER_FF=3Dy
CONFIG_HID_ZEROPLUS=3Dm
CONFIG_ZEROPLUS_FF=3Dy
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=3Dm
CONFIG_HID_PID=3Dy
CONFIG_USB_HIDDEV=3Dy

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB_ARCH_HAS_XHCI=3Dy
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_COMMON=3Dm
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB=3Dm
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=3Dy

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=3Dy
CONFIG_USB_SUSPEND=3Dy
# CONFIG_USB_OTG is not set
CONFIG_USB_DWC3=3Dm
CONFIG_USB_DWC3_DEBUG=3Dy
CONFIG_USB_DWC3_VERBOSE=3Dy
CONFIG_USB_MON=3Dm
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=3Dm
CONFIG_USB_XHCI_PLATFORM=3Dm
CONFIG_USB_XHCI_HCD_DEBUGGING=3Dy
CONFIG_USB_EHCI_HCD=3Dm
CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
CONFIG_USB_EHCI_TT_NEWSCHED=3Dy
CONFIG_USB_EHCI_PCI=3Dm
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=3Dm
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_RENESAS_USBHS_HCD is not set
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_MUSB_HDRC=3Dm
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_MUSB_PIO_ONLY=3Dy
CONFIG_USB_CHIPIDEA=3Dm
CONFIG_USB_CHIPIDEA_UDC=3Dy
CONFIG_USB_CHIPIDEA_HOST=3Dy
CONFIG_USB_CHIPIDEA_DEBUG=3Dy
CONFIG_USB_RENESAS_USBHS=3Dm

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm
CONFIG_USB_WDM=3Dm
CONFIG_USB_TMC=3Dm

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=3Dm
CONFIG_REALTEK_AUTOPM=3Dy
CONFIG_USB_STORAGE_DATAFAB=3Dm
CONFIG_USB_STORAGE_FREECOM=3Dm
CONFIG_USB_STORAGE_ISD200=3Dm
CONFIG_USB_STORAGE_USBAT=3Dm
CONFIG_USB_STORAGE_SDDR09=3Dm
CONFIG_USB_STORAGE_SDDR55=3Dm
CONFIG_USB_STORAGE_JUMPSHOT=3Dm
CONFIG_USB_STORAGE_ALAUDA=3Dm
CONFIG_USB_STORAGE_ONETOUCH=3Dm
CONFIG_USB_STORAGE_KARMA=3Dm
CONFIG_USB_STORAGE_CYPRESS_ATACB=3Dm
CONFIG_USB_STORAGE_ENE_UB6250=3Dm

#
# USB Imaging devices
#
CONFIG_USB_MDC800=3Dm
CONFIG_USB_MICROTEK=3Dm

#
# USB port drivers
#
CONFIG_USB_USS720=3Dm
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_SERIAL_GENERIC=3Dy
CONFIG_USB_SERIAL_AIRCABLE=3Dm
CONFIG_USB_SERIAL_ARK3116=3Dm
CONFIG_USB_SERIAL_BELKIN=3Dm
CONFIG_USB_SERIAL_CH341=3Dm
CONFIG_USB_SERIAL_WHITEHEAT=3Dm
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=3Dm
CONFIG_USB_SERIAL_CP210X=3Dm
CONFIG_USB_SERIAL_CYPRESS_M8=3Dm
CONFIG_USB_SERIAL_EMPEG=3Dm
CONFIG_USB_SERIAL_FTDI_SIO=3Dm
CONFIG_USB_SERIAL_FUNSOFT=3Dm
CONFIG_USB_SERIAL_VISOR=3Dm
CONFIG_USB_SERIAL_IPAQ=3Dm
CONFIG_USB_SERIAL_IR=3Dm
CONFIG_USB_SERIAL_EDGEPORT=3Dm
CONFIG_USB_SERIAL_EDGEPORT_TI=3Dm
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=3Dm
CONFIG_USB_SERIAL_IPW=3Dm
CONFIG_USB_SERIAL_IUU=3Dm
CONFIG_USB_SERIAL_KEYSPAN_PDA=3Dm
CONFIG_USB_SERIAL_KEYSPAN=3Dm
CONFIG_USB_SERIAL_KLSI=3Dm
CONFIG_USB_SERIAL_KOBIL_SCT=3Dm
CONFIG_USB_SERIAL_MCT_U232=3Dm
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=3Dm
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=3Dm
CONFIG_USB_SERIAL_MOTOROLA=3Dm
CONFIG_USB_SERIAL_NAVMAN=3Dm
CONFIG_USB_SERIAL_PL2303=3Dm
CONFIG_USB_SERIAL_OTI6858=3Dm
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=3Dm
CONFIG_USB_SERIAL_SPCP8X5=3Dm
CONFIG_USB_SERIAL_HP4X=3Dm
CONFIG_USB_SERIAL_SAFE=3Dm
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=3Dm
CONFIG_USB_SERIAL_SIERRAWIRELESS=3Dm
CONFIG_USB_SERIAL_SYMBOL=3Dm
CONFIG_USB_SERIAL_TI=3Dm
CONFIG_USB_SERIAL_CYBERJACK=3Dm
CONFIG_USB_SERIAL_XIRCOM=3Dm
CONFIG_USB_SERIAL_WWAN=3Dm
CONFIG_USB_SERIAL_OPTION=3Dm
CONFIG_USB_SERIAL_OMNINET=3Dm
CONFIG_USB_SERIAL_OPTICON=3Dm
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=3Dm
CONFIG_USB_SERIAL_ZIO=3Dm
# CONFIG_USB_SERIAL_ZTE is not set
CONFIG_USB_SERIAL_SSU100=3Dm
# CONFIG_USB_SERIAL_QT2 is not set
CONFIG_USB_SERIAL_DEBUG=3Dm

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=3Dm
CONFIG_USB_EMI26=3Dm
CONFIG_USB_ADUTUX=3Dm
CONFIG_USB_SEVSEG=3Dm
CONFIG_USB_RIO500=3Dm
CONFIG_USB_LEGOTOWER=3Dm
CONFIG_USB_LCD=3Dm
CONFIG_USB_LED=3Dm
CONFIG_USB_CYPRESS_CY7C63=3Dm
CONFIG_USB_CYTHERM=3Dm
CONFIG_USB_IDMOUSE=3Dm
CONFIG_USB_FTDI_ELAN=3Dm
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=3Dm
CONFIG_USB_SISUSBVGA_CON=3Dy
CONFIG_USB_LD=3Dm
CONFIG_USB_TRANCEVIBRATOR=3Dm
CONFIG_USB_IOWARRIOR=3Dm
CONFIG_USB_TEST=3Dm
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=3Dm

#
# USB Physical Layer drivers
#
CONFIG_USB_ISP1301=3Dm
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_ATM=3Dm
CONFIG_USB_SPEEDTOUCH=3Dm
CONFIG_USB_CXACRU=3Dm
CONFIG_USB_UEAGLEATM=3Dm
CONFIG_USB_XUSBATM=3Dm
CONFIG_USB_GADGET=3Dm
CONFIG_USB_GADGET_DEBUG=3Dy
CONFIG_USB_GADGET_DEBUG_FILES=3Dy
CONFIG_USB_GADGET_DEBUG_FS=3Dy
CONFIG_USB_GADGET_VBUS_DRAW=3D2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=3D2

#
# USB Peripheral Controller
#
CONFIG_USB_R8A66597=3Dm
CONFIG_USB_RENESAS_USBHS_UDC=3Dm
CONFIG_USB_MV_UDC=3Dm
CONFIG_USB_GADGET_MUSB_HDRC=3Dm
CONFIG_USB_M66592=3Dm
CONFIG_USB_AMD5536UDC=3Dm
CONFIG_USB_NET2272=3Dm
CONFIG_USB_NET2272_DMA=3Dy
CONFIG_USB_NET2280=3Dm
CONFIG_USB_GOKU=3Dm
CONFIG_USB_EG20T=3Dm
CONFIG_USB_DUMMY_HCD=3Dm
CONFIG_USB_LIBCOMPOSITE=3Dm
CONFIG_USB_ZERO=3Dm
CONFIG_USB_AUDIO=3Dm
# CONFIG_GADGET_UAC1 is not set
CONFIG_USB_ETH=3Dm
CONFIG_USB_ETH_RNDIS=3Dy
CONFIG_USB_ETH_EEM=3Dy
CONFIG_USB_G_NCM=3Dm
CONFIG_USB_GADGETFS=3Dm
CONFIG_USB_FUNCTIONFS=3Dm
CONFIG_USB_FUNCTIONFS_ETH=3Dy
CONFIG_USB_FUNCTIONFS_RNDIS=3Dy
CONFIG_USB_FUNCTIONFS_GENERIC=3Dy
CONFIG_USB_MASS_STORAGE=3Dm
CONFIG_USB_G_SERIAL=3Dm
CONFIG_USB_MIDI_GADGET=3Dm
CONFIG_USB_G_PRINTER=3Dm
CONFIG_USB_CDC_COMPOSITE=3Dm
CONFIG_USB_G_NOKIA=3Dm
CONFIG_USB_G_ACM_MS=3Dm
CONFIG_USB_G_MULTI=3Dm
CONFIG_USB_G_MULTI_RNDIS=3Dy
CONFIG_USB_G_MULTI_CDC=3Dy
CONFIG_USB_G_HID=3Dm
CONFIG_USB_G_DBGP=3Dm
# CONFIG_USB_G_DBGP_PRINTK is not set
CONFIG_USB_G_DBGP_SERIAL=3Dy

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=3Dy
CONFIG_USB_GPIO_VBUS=3Dm
CONFIG_NOP_USB_XCEIV=3Dm
# CONFIG_UWB is not set
CONFIG_MMC=3Dm
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=3Dm
CONFIG_MMC_BLOCK_MINORS=3D8
CONFIG_MMC_BLOCK_BOUNCE=3Dy
CONFIG_SDIO_UART=3Dm
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=3Dm
CONFIG_MMC_SDHCI_PCI=3Dm
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=3Dy
CONFIG_LEDS_CLASS=3Dy

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=3Dm
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=3Dm
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=3Dm
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_BD2802=3Dm
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_TRIGGERS=3Dy

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=3Dm
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=3Dm
CONFIG_LEDS_TRIGGER_BACKLIGHT=3Dm
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=3Dm

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=3Dy
CONFIG_RTC_CLASS=3Dy
CONFIG_RTC_HCTOSYS=3Dy
CONFIG_RTC_HCTOSYS_DEVICE=3D"rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=3Dy
CONFIG_RTC_INTF_PROC=3Dy
CONFIG_RTC_INTF_DEV=3Dy
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=3Dm
CONFIG_RTC_DRV_DS1374=3Dm
CONFIG_RTC_DRV_DS1672=3Dm
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=3Dm
CONFIG_RTC_DRV_RS5C372=3Dm
CONFIG_RTC_DRV_ISL1208=3Dm
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=3Dm
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=3Dm
CONFIG_RTC_DRV_PCF8583=3Dm
CONFIG_RTC_DRV_M41T80=3Dm
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_S35390A=3Dm
CONFIG_RTC_DRV_FM3130=3Dm
CONFIG_RTC_DRV_RX8581=3Dm
CONFIG_RTC_DRV_RX8025=3Dm
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=3Dy
CONFIG_RTC_DRV_DS1286=3Dm
CONFIG_RTC_DRV_DS1511=3Dm
CONFIG_RTC_DRV_DS1553=3Dm
CONFIG_RTC_DRV_DS1742=3Dm
CONFIG_RTC_DRV_STK17TA8=3Dm
CONFIG_RTC_DRV_M48T86=3Dm
CONFIG_RTC_DRV_M48T35=3Dm
CONFIG_RTC_DRV_M48T59=3Dm
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=3Dm
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=3Dm
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=3Dy
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=3Dm
CONFIG_UIO_CIF=3Dm
CONFIG_UIO_PDRV=3Dm
CONFIG_UIO_PDRV_GENIRQ=3Dm
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=3Dm
CONFIG_UIO_SERCOS3=3Dm
CONFIG_UIO_PCI_GENERIC=3Dm
# CONFIG_UIO_NETX is not set
# CONFIG_VFIO is not set
CONFIG_VIRTIO=3Dm

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=3Dm
CONFIG_VIRTIO_BALLOON=3Dm
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=3Dy
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=3Dm
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=3Dy
CONFIG_I8253_LOCK=3Dy
CONFIG_CLKBLD_I8253=3Dy
CONFIG_IOMMU_API=3Dy
CONFIG_IOMMU_SUPPORT=3Dy
CONFIG_AMD_IOMMU=3Dy
# CONFIG_AMD_IOMMU_STATS is not set
# CONFIG_AMD_IOMMU_V2 is not set
CONFIG_DMAR_TABLE=3Dy
CONFIG_INTEL_IOMMU=3Dy
CONFIG_INTEL_IOMMU_DEFAULT_ON=3Dy
CONFIG_INTEL_IOMMU_FLOPPY_WA=3Dy
CONFIG_IRQ_REMAP=3Dy

#
# Remoteproc drivers (EXPERIMENTAL)
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=3Dy
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=3Dy
CONFIG_DELL_RBU=3Dm
CONFIG_DCDBAS=3Dm
CONFIG_DMIID=3Dy
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=3Dy
CONFIG_EXT2_FS=3Dy
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dy
CONFIG_EXT3_DEFAULTS_TO_ORDERED=3Dy
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
CONFIG_EXT4_FS=3Dm
CONFIG_EXT4_FS_POSIX_ACL=3Dy
CONFIG_EXT4_FS_SECURITY=3Dy
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=3Dy
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=3Dm
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=3Dy
CONFIG_REISERFS_FS=3Dm
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
CONFIG_REISERFS_FS_SECURITY=3Dy
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=3Dm
CONFIG_BTRFS_FS_POSIX_ACL=3Dy
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_NILFS2_FS=3Dm
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_EXPORTFS=3Dm
CONFIG_FILE_LOCKING=3Dy
CONFIG_FSNOTIFY=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=3Dy
CONFIG_QUOTA_NETLINK_INTERFACE=3Dy
CONFIG_PRINT_QUOTA_WARNING=3Dy
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=3Dm
CONFIG_QFMT_V1=3Dm
CONFIG_QFMT_V2=3Dm
CONFIG_QUOTACTL=3Dy
CONFIG_QUOTACTL_COMPAT=3Dy
CONFIG_AUTOFS4_FS=3Dm
CONFIG_FUSE_FS=3Dm
CONFIG_CUSE=3Dm
CONFIG_GENERIC_ACL=3Dy

#
# Caches
#
CONFIG_FSCACHE=3Dm
CONFIG_FSCACHE_STATS=3Dy
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=3Dm
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dm
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
CONFIG_MSDOS_FS=3Dm
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"utf8"
CONFIG_NTFS_FS=3Dm
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=3Dy

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
CONFIG_TMPFS_XATTR=3Dy
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=3Dm
CONFIG_MISC_FILESYSTEMS=3Dy
CONFIG_ADFS_FS=3Dm
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=3Dm
CONFIG_ECRYPT_FS=3Dm
CONFIG_HFS_FS=3Dm
CONFIG_HFSPLUS_FS=3Dm
CONFIG_BEFS_FS=3Dm
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=3Dm
CONFIG_EFS_FS=3Dm
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=3Dm
CONFIG_SQUASHFS=3Dm
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=3Dy
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3D3
CONFIG_VXFS_FS=3Dm
CONFIG_MINIX_FS=3Dm
CONFIG_OMFS_FS=3Dm
CONFIG_HPFS_FS=3Dm
CONFIG_QNX4FS_FS=3Dm
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=3Dm
CONFIG_ROMFS_BACKED_BY_BLOCK=3Dy
CONFIG_ROMFS_ON_BLOCK=3Dy
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=3Dm
CONFIG_UFS_FS=3Dm
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dm
CONFIG_NFS_V2=3Dm
CONFIG_NFS_V3=3Dm
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dm
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
CONFIG_NFS_FSCACHE=3Dy
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=3Dy
CONFIG_NFSD=3Dm
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
CONFIG_NFSD_V4=3Dy
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=3Dm
CONFIG_LOCKD_V4=3Dy
CONFIG_NFS_ACL_SUPPORT=3Dm
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dm
CONFIG_SUNRPC_GSS=3Dm
CONFIG_RPCSEC_GSS_KRB5=3Dm
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=3Dm
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=3Dy
CONFIG_CIFS_UPCALL=3Dy
CONFIG_CIFS_XATTR=3Dy
CONFIG_CIFS_POSIX=3Dy
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=3Dy
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=3Dy
# CONFIG_CIFS_SMB2 is not set
# CONFIG_CIFS_FSCACHE is not set
CONFIG_NCP_FS=3Dm
CONFIG_NCPFS_PACKET_SIGNING=3Dy
CONFIG_NCPFS_IOCTL_LOCKING=3Dy
CONFIG_NCPFS_STRONG=3Dy
CONFIG_NCPFS_NFS_NS=3Dy
CONFIG_NCPFS_OS2_NS=3Dy
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=3Dy
CONFIG_NCPFS_EXTRAS=3Dy
CONFIG_CODA_FS=3Dm
CONFIG_AFS_FS=3Dm
# CONFIG_AFS_DEBUG is not set
CONFIG_AFS_FSCACHE=3Dy
CONFIG_9P_FS=3Dm
CONFIG_9P_FSCACHE=3Dy
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dm
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dm
CONFIG_NLS_CODEPAGE_950=3Dm
CONFIG_NLS_CODEPAGE_932=3Dm
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dm
CONFIG_NLS_ISO8859_1=3Dm
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=3Dm
CONFIG_DLM=3Dm
CONFIG_DLM_DEBUG=3Dy

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=3D4
CONFIG_ENABLE_WARN_DEPRECATED=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_FRAME_WARN=3D2048
CONFIG_MAGIC_SYSRQ=3Dy
CONFIG_STRIP_ASM_SYMS=3Dy
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=3Dy
CONFIG_DEBUG_FS=3Dy
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=3Dy
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=3D0
CONFIG_DETECT_HUNG_TASK=3Dy
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=3D120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=3D0
CONFIG_SCHED_DEBUG=3Dy
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=3Dy
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=3Dy
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=3Dy
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=3Dy
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_DEBUG_INFO=3Dy
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=3Dy
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=3Dy
CONFIG_FRAME_POINTER=3Dy
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=3D60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_NOP_TRACER=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=3Dy
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_HAVE_SYSCALL_TRACEPOINTS=3Dy
CONFIG_HAVE_FENTRY=3Dy
CONFIG_HAVE_C_RECORDMCOUNT=3Dy
CONFIG_TRACER_MAX_TRACE=3Dy
CONFIG_TRACE_CLOCK=3Dy
CONFIG_RING_BUFFER=3Dy
CONFIG_EVENT_TRACING=3Dy
CONFIG_EVENT_POWER_TRACING_DEPRECATED=3Dy
CONFIG_CONTEXT_SWITCH_TRACER=3Dy
CONFIG_RING_BUFFER_ALLOW_SWAP=3Dy
CONFIG_TRACING=3Dy
CONFIG_GENERIC_TRACER=3Dy
CONFIG_TRACING_SUPPORT=3Dy
CONFIG_FTRACE=3Dy
CONFIG_FUNCTION_TRACER=3Dy
CONFIG_FUNCTION_GRAPH_TRACER=3Dy
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=3Dy
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=3Dy
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=3Dy
CONFIG_KPROBE_EVENT=3Dy
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=3Dy
CONFIG_DYNAMIC_FTRACE=3Dy
CONFIG_FUNCTION_PROFILER=3Dy
CONFIG_FTRACE_MCOUNT_RECORD=3Dy
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=3Dy
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=3Dy
CONFIG_X86_VERBOSE_BOOTUP=3Dy
CONFIG_EARLY_PRINTK=3Dy
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=3Dy
CONFIG_DEBUG_RODATA_TEST=3Dy
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=3Dy
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=3Dy
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=3Dy
CONFIG_SECURITYFS=3Dy
CONFIG_SECURITY_NETWORK=3Dy
CONFIG_SECURITY_NETWORK_XFRM=3Dy
CONFIG_SECURITY_PATH=3Dy
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=3D65536
CONFIG_SECURITY_SELINUX=3Dy
CONFIG_SECURITY_SELINUX_BOOTPARAM=3Dy
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=3D0
CONFIG_SECURITY_SELINUX_DISABLE=3Dy
CONFIG_SECURITY_SELINUX_DEVELOP=3Dy
CONFIG_SECURITY_SELINUX_AVC_STATS=3Dy
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=3D1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_SECURITY_TOMOYO=3Dy
CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY=3D2048
CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG=3D1024
# CONFIG_SECURITY_TOMOYO_OMIT_USERSPACE_LOADER is not set
CONFIG_SECURITY_TOMOYO_POLICY_LOADER=3D"/sbin/tomoyo-init"
CONFIG_SECURITY_TOMOYO_ACTIVATION_TRIGGER=3D"/sbin/init"
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_SELINUX=3Dy
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY=3D"selinux"
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD=3Dm
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dm
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG=3Dm
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_PCOMP=3Dm
CONFIG_CRYPTO_PCOMP2=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=3Dy
CONFIG_CRYPTO_GF128MUL=3Dm
CONFIG_CRYPTO_NULL=3Dm
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=3Dy
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=3Dm
CONFIG_CRYPTO_TEST=3Dm

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=3Dm
CONFIG_CRYPTO_GCM=3Dm
CONFIG_CRYPTO_SEQIV=3Dm

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dm
CONFIG_CRYPTO_CTR=3Dm
CONFIG_CRYPTO_CTS=3Dm
CONFIG_CRYPTO_ECB=3Dm
CONFIG_CRYPTO_LRW=3Dm
CONFIG_CRYPTO_PCBC=3Dm
CONFIG_CRYPTO_XTS=3Dm

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=3Dm
CONFIG_CRYPTO_XCBC=3Dm
CONFIG_CRYPTO_VMAC=3Dm

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dm
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=3Dm
CONFIG_CRYPTO_MD4=3Dm
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_MICHAEL_MIC=3Dm
CONFIG_CRYPTO_RMD128=3Dm
CONFIG_CRYPTO_RMD160=3Dm
CONFIG_CRYPTO_RMD256=3Dm
CONFIG_CRYPTO_RMD320=3Dm
CONFIG_CRYPTO_SHA1=3Dm
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=3Dm
CONFIG_CRYPTO_SHA512=3Dm
CONFIG_CRYPTO_TGR192=3Dm
CONFIG_CRYPTO_WP512=3Dm
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=3Dy
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=3Dm
CONFIG_CRYPTO_ARC4=3Dm
CONFIG_CRYPTO_BLOWFISH=3Dm
CONFIG_CRYPTO_BLOWFISH_COMMON=3Dm
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=3Dm
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=3Dm
CONFIG_CRYPTO_CAST5=3Dm
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=3Dm
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=3Dm
CONFIG_CRYPTO_FCRYPT=3Dm
CONFIG_CRYPTO_KHAZAD=3Dm
CONFIG_CRYPTO_SALSA20=3Dm
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=3Dm
CONFIG_CRYPTO_SERPENT=3Dm
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=3Dm
CONFIG_CRYPTO_TWOFISH=3Dm
CONFIG_CRYPTO_TWOFISH_COMMON=3Dm
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=3Dm
CONFIG_CRYPTO_ZLIB=3Dm
CONFIG_CRYPTO_LZO=3Dm

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=3Dm
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=3Dy
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=3Dy
CONFIG_HAVE_KVM_IRQCHIP=3Dy
CONFIG_HAVE_KVM_EVENTFD=3Dy
CONFIG_KVM_APIC_ARCHITECTURE=3Dy
CONFIG_KVM_MMIO=3Dy
CONFIG_KVM_ASYNC_PF=3Dy
CONFIG_HAVE_KVM_MSI=3Dy
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=3Dy
CONFIG_VIRTUALIZATION=3Dy
CONFIG_KVM=3Dm
CONFIG_KVM_INTEL=3Dm
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=3Dm
CONFIG_BINARY_PRINTF=3Dy

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_STRNCPY_FROM_USER=3Dy
CONFIG_GENERIC_STRNLEN_USER=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
CONFIG_GENERIC_PCI_IOMAP=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_IO=3Dy
CONFIG_PERCPU_RWSEM=3Dy
CONFIG_CRC_CCITT=3Dm
CONFIG_CRC16=3Dm
CONFIG_CRC_T10DIF=3Dy
CONFIG_CRC_ITU_T=3Dm
CONFIG_CRC32=3Dy
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=3Dy
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=3Dm
CONFIG_LIBCRC32C=3Dm
CONFIG_CRC8=3Dm
CONFIG_ZLIB_INFLATE=3Dm
CONFIG_ZLIB_DEFLATE=3Dm
CONFIG_LZO_COMPRESS=3Dy
CONFIG_LZO_DECOMPRESS=3Dy
CONFIG_XZ_DEC=3Dy
CONFIG_XZ_DEC_X86=3Dy
CONFIG_XZ_DEC_POWERPC=3Dy
CONFIG_XZ_DEC_IA64=3Dy
CONFIG_XZ_DEC_ARM=3Dy
CONFIG_XZ_DEC_ARMTHUMB=3Dy
CONFIG_XZ_DEC_SPARC=3Dy
CONFIG_XZ_DEC_BCJ=3Dy
# CONFIG_XZ_DEC_TEST is not set
CONFIG_TEXTSEARCH=3Dy
CONFIG_TEXTSEARCH_KMP=3Dm
CONFIG_TEXTSEARCH_BM=3Dm
CONFIG_TEXTSEARCH_FSM=3Dm
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_CHECK_SIGNATURE=3Dy
CONFIG_CPU_RMAP=3Dy
CONFIG_DQL=3Dy
CONFIG_NLATTR=3Dy
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=3Dy
CONFIG_LRU_CACHE=3Dm
CONFIG_AVERAGE=3Dy
CONFIG_CORDIC=3Dm
# CONFIG_DDR is not set

--=20
balbi

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRK3QLAAoJEIaOsuA1yqREEpoP/0xAXUKY9RfMj3pksr77U8dw
mNOcbZEbUiCK0TlBrW2l7w8w358VkIr+PC6K65KFjXZ2kD1ZfPCRAhNV3GlSpih+
lckAtTDB7RxN1JDtAxpqz/YnJPFAUzv+U2l1++sJdsTF4y5loI/NaKmSOyMWt18J
2DQcXtjXvQh6efa/Z1u81An/0SlzDFEqNyy0DeTjlixOPzKL4eAuRQAb4GmwP+hY
QkU6Q/MyBqHBkXbwks/mdXuyy6RNVZ4z+lEjH3SQ5o8Jx8L9T10jVUpYMrp7OeCw
jk1tEKIGuzuU2ZuLId6wGJP3333k1xDvJXAU5RIuZERWKjhFU+yjc/h2DLQcIiqE
ahZP9FWhW7thwPXgbexfVYv4/g+TGOdYCIgTnxTbd7xDxStIUreTKdkDraQIimWu
NzMOUsHFHscijkUGva8cB0I8Fg9g7Wa38obs+iydwUjAaItSLlflD7AFA72fqm4f
5ONVRkC26l7zabGO4sj0/apEmH45zIFUGdEKzGdABro9VWpJcoffiRWnBvY0sfP8
n8FA5rBIYb/0CVbJSR8fSooT1Vqmb6PtlMHcoNUdp4uPO9XUANsCGS9JCs5fmDwk
2wjzcLgsxtaMG1J0ULNT60+JkfRQIOC/S835XtwBmVA9BqSXQ3vwqpYj+Z4ICVaH
j2ePS1FL5lnWEThAls3c
=TjW6
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--
