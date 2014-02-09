Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaBIGq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 01:46:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:9252 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaBIGq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 01:46:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,811,1384329600"; 
   d="scan'208";a="480367288"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Michal Hocko <mhocko@suse.cz>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: wlwifi - Microcode SW error detected.
Thread-Topic: wlwifi - Microcode SW error detected.
Thread-Index: AQHPJBgRRORpxiiGE0S7JYMXh3y2JJqsfNrg
Date: Sun, 9 Feb 2014 06:46:20 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D640E9@HASMSX103.ger.corp.intel.com>
References: <20140207151942.GE5121@dhcp22.suse.cz>
In-Reply-To: <20140207151942.GE5121@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hi,
> I am not sure who to report this issue so please let me know if this is
> not a proper channel.
> 
> My dmesg claims the following:
> [14921.841475] iwlwifi 0000:02:00.0: RF_KILL bit toggled to enable radio.
> [14922.178602] usb 1-1.4: new full-speed USB device number 5 using ehci-pci
> [14922.275384] usb 1-1.4: New USB device found, idVendor=413c,
> idProduct=8187
> [14922.275408] usb 1-1.4: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [14922.275410] usb 1-1.4: Product: DW375 Bluetooth Module
> [14922.275412] usb 1-1.4: Manufacturer: Dell Computer Corp
> [14922.275413] usb 1-1.4: SerialNumber: 446D57C904C4
> [14922.913064] atkbd serio0: Unknown key pressed (translated set 2, code
> 0x88 on isa0060/serio0).
> [14922.913069] atkbd serio0: Use 'setkeycodes e008 <keycode>' to make it
> known.
> [14922.913116] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
> [14923.002924] usb 1-1.4: USB disconnect, device number 5
> [14923.112880] iwlwifi 0000:02:00.0: Microcode SW error detected.
> Restarting 0x2000000.
> [14923.112887] iwlwifi 0000:02:00.0: CSR values:
> [14923.112888] iwlwifi 0000:02:00.0: (2nd byte of CSR_INT_COALESCING is
> CSR_INT_PERIODIC_REG)
> [14923.112918] iwlwifi 0000:02:00.0:        CSR_HW_IF_CONFIG_REG:
> 0X0048d304
> [14923.112944] iwlwifi 0000:02:00.0:          CSR_INT_COALESCING: 0X00000040
> [14923.112969] iwlwifi 0000:02:00.0:                     CSR_INT: 0X00000000
> [14923.112995] iwlwifi 0000:02:00.0:                CSR_INT_MASK: 0X00000000
> [14923.113020] iwlwifi 0000:02:00.0:           CSR_FH_INT_STATUS: 0X00000000
> [14923.113046] iwlwifi 0000:02:00.0:                 CSR_GPIO_IN: 0X0000000f
> [14923.113071] iwlwifi 0000:02:00.0:                   CSR_RESET: 0X00000000
> [14923.113097] iwlwifi 0000:02:00.0:                CSR_GP_CNTRL: 0X000403c5
> [14923.113123] iwlwifi 0000:02:00.0:                  CSR_HW_REV: 0X00000074
> [14923.113149] iwlwifi 0000:02:00.0:              CSR_EEPROM_REG: 0Xf5130ffd
> [14923.113174] iwlwifi 0000:02:00.0:               CSR_EEPROM_GP: 0X90000001
> [14923.113200] iwlwifi 0000:02:00.0:              CSR_OTP_GP_REG: 0X00030001
> [14923.113226] iwlwifi 0000:02:00.0:                 CSR_GIO_REG: 0X00080042
> [14923.113251] iwlwifi 0000:02:00.0:            CSR_GP_UCODE_REG: 0X0000001f
> [14923.113277] iwlwifi 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> [14923.113303] iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP1: 0X00000005
> [14923.113328] iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [14923.113354] iwlwifi 0000:02:00.0:                 CSR_LED_REG: 0X00000038
> [14923.113379] iwlwifi 0000:02:00.0:        CSR_DRAM_INT_TBL_REG:
> 0X880c4272
> [14923.113405] iwlwifi 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [14923.113431] iwlwifi 0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [14923.113457] iwlwifi 0000:02:00.0:           CSR_HW_REV_WA_REG:
> 0X0001001a
> [14923.113482] iwlwifi 0000:02:00.0:        CSR_DBG_HPET_MEM_REG:
> 0Xffff0000
> [14923.113484] iwlwifi 0000:02:00.0: FH register values:
> [14923.113520] iwlwifi 0000:02:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG:
> 0X0a231600
> [14923.113536] iwlwifi 0000:02:00.0:
> FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00a23ed0
> [14923.113551] iwlwifi 0000:02:00.0:                  FH_RSCSR_CHNL0_WPTR:
> 0X00000018
> [14923.113566] iwlwifi 0000:02:00.0:
> FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [14923.113580] iwlwifi 0000:02:00.0:
> FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [14923.113595] iwlwifi 0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG:
> 0X07030000
> [14923.113611] iwlwifi 0000:02:00.0:
> FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [14923.113626] iwlwifi 0000:02:00.0:                FH_TSSR_TX_STATUS_REG:
> 0X07ff0001
> [14923.113641] iwlwifi 0000:02:00.0:                 FH_TSSR_TX_ERROR_REG:
> 0X00000000
> [14923.113644] iwlwifi 0000:02:00.0: Loaded firmware version: 9.221.4.1 build
> 25532
> [14923.113800] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
> [14923.113802] iwlwifi 0000:02:00.0: Status: 0x0000204D, count: 5
> [14923.113804] iwlwifi 0000:02:00.0: 0x00000005 | SYSASSERT
> [14923.113805] iwlwifi 0000:02:00.0: 0x0001EFD8 | uPc
> [14923.113807] iwlwifi 0000:02:00.0: 0x0001EEE4 | branchlink1
> [14923.113808] iwlwifi 0000:02:00.0: 0x0001EEE4 | branchlink2
> [14923.113809] iwlwifi 0000:02:00.0: 0x00001532 | interruptlink1
> [14923.113811] iwlwifi 0000:02:00.0: 0x00000000 | interruptlink2
> [14923.113812] iwlwifi 0000:02:00.0: 0x00000000 | data1
> [14923.113813] iwlwifi 0000:02:00.0: 0x00000000 | data2
> [14923.113815] iwlwifi 0000:02:00.0: 0x0000012E | line
> [14923.113816] iwlwifi 0000:02:00.0: 0x00400529 | beacon time
> [14923.113818] iwlwifi 0000:02:00.0: 0x00031AD7 | tsf low
> [14923.113819] iwlwifi 0000:02:00.0: 0x00000000 | tsf hi
> [14923.113820] iwlwifi 0000:02:00.0: 0x00000000 | time gp1
> [14923.113822] iwlwifi 0000:02:00.0: 0x0004B850 | time gp2
> [14923.113823] iwlwifi 0000:02:00.0: 0x00000000 | time gp3
> [14923.113825] iwlwifi 0000:02:00.0: 0x000109DD | uCode version
> [14923.113826] iwlwifi 0000:02:00.0: 0x00000074 | hw version
> [14923.113827] iwlwifi 0000:02:00.0: 0x0048D304 | board version
> [14923.113829] iwlwifi 0000:02:00.0: 0x04120095 | hcmd
> [14923.113830] iwlwifi 0000:02:00.0: 0x2FE23000 | isr0
> [14923.113831] iwlwifi 0000:02:00.0: 0x01004040 | isr1
> [14923.113833] iwlwifi 0000:02:00.0: 0x00000002 | isr2
> [14923.113834] iwlwifi 0000:02:00.0: 0x1141FCC3 | isr3
> [14923.113835] iwlwifi 0000:02:00.0: 0x00000000 | isr4
> [14923.113837] iwlwifi 0000:02:00.0: 0x10800112 | isr_pref
> [14923.113838] iwlwifi 0000:02:00.0: 0x0001B79C | wait_event
> [14923.113840] iwlwifi 0000:02:00.0: 0x00000080 | l2p_control
> [14923.113841] iwlwifi 0000:02:00.0: 0x00000000 | l2p_duration
> [14923.113842] iwlwifi 0000:02:00.0: 0x0000003F | l2p_mhvalid
> [14923.113844] iwlwifi 0000:02:00.0: 0x00200200 | l2p_addr_match
> [14923.113845] iwlwifi 0000:02:00.0: 0x00000045 | lmpm_pmg_sel
> [14923.113846] iwlwifi 0000:02:00.0: 0x02061043 | timestamp
> [14923.113848] iwlwifi 0000:02:00.0: 0x00001828 | flow_handler
> [14923.113964] iwlwifi 0000:02:00.0: Log capacity 1024 is bogus, limit to 512
> entries
> [14923.113966] iwlwifi 0000:02:00.0: Log write index 873 is bogus, limit to 512
> [14923.113968] iwlwifi 0000:02:00.0: Start IWL Event Log Dump: display last 20
> entries
> [14923.114008] iwlwifi 0000:02:00.0: EVT_LOGT:0000101476:0x00000052:1334
> [14923.114041] iwlwifi 0000:02:00.0: EVT_LOGT:0000101477:0x0150a450:1334
> [14923.114074] iwlwifi 0000:02:00.0: EVT_LOGT:0000101482:0x00280003:1334
> [14923.114106] iwlwifi 0000:02:00.0: EVT_LOGT:0000101486:0x00000054:1334
> [14923.114140] iwlwifi 0000:02:00.0: EVT_LOGT:0000101486:0x0150a450:1334
> [14923.114172] iwlwifi 0000:02:00.0: EVT_LOGT:0000101488:0x00000010:0484
> [14923.114205] iwlwifi 0000:02:00.0: EVT_LOGT:0000101494:0x001e0000:1334
> [14923.114237] iwlwifi 0000:02:00.0: EVT_LOGT:0000101499:0x00000074:1334
> [14923.114270] iwlwifi 0000:02:00.0: EVT_LOGT:0000101500:0x018cda74:1334
> [14923.114302] iwlwifi 0000:02:00.0: EVT_LOGT:0000101501:0x018cda74:1334
> [14923.114334] iwlwifi 0000:02:00.0: EVT_LOGT:0000101503:0x018cda74:1334
> [14923.114368] iwlwifi 0000:02:00.0: EVT_LOGT:0000101504:0x018cda74:1334
> [14923.114400] iwlwifi 0000:02:00.0: EVT_LOGT:0000101506:0x018cda74:1334
> [14923.114433] iwlwifi 0000:02:00.0: EVT_LOGT:0000101512:0x001e0000:1334
> [14923.114465] iwlwifi 0000:02:00.0: EVT_LOGT:0000101517:0x0000006d:1334
> [14923.114498] iwlwifi 0000:02:00.0: EVT_LOGT:0000101518:0x018cda74:1334
> [14923.114530] iwlwifi 0000:02:00.0: EVT_LOGT:0000101520:0x018cda74:1334
> [14923.114563] iwlwifi 0000:02:00.0: EVT_LOGT:0000101521:0x018cda74:1334
> [14923.114595] iwlwifi 0000:02:00.0: EVT_LOGT:0000101523:0x018cda74:1334
> [14923.114628] iwlwifi 0000:02:00.0: EVT_LOGT:0000101524:0x018cda74:1334
> [14923.115279] ieee80211 phy0: Hardware restart was requested
> [14923.115370] iwlwifi 0000:02:00.0: Failed to start RT ucode: -132
> [14923.115450] iwlwifi 0000:02:00.0: Unable to initialize device.
> [15113.918564] atkbd serio0: Unknown key pressed (translated set 2, code
> 0x88 on isa0060/serio0).
> [15113.918569] atkbd serio0: Use 'setkeycodes e008 <keycode>' to make it
> known.
> [15113.918630] iwlwifi 0000:02:00.0: RF_KILL bit toggled to enable radio.
> [15114.300823] usb 1-1.4: new full-speed USB device number 6 using ehci-pci
> [15114.398003] usb 1-1.4: New USB device found, idVendor=413c,
> idProduct=8187
> [15114.398008] usb 1-1.4: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [15114.398010] usb 1-1.4: Product: DW375 Bluetooth Module
> [15114.398019] usb 1-1.4: Manufacturer: Dell Computer Corp
> [15114.398020] usb 1-1.4: SerialNumber: 446D57C904C4
> [15123.535504] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> [15123.535729] iwlwifi 0000:02:00.0: Radio type=0x0-0x3-0x1
> [15123.657396] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 
> The issue started with a flood of
> [  114.439082] iwlwifi 0000:02:00.0: Failed to run INIT ucode: -132
> [  114.439140] iwlwifi 0000:02:00.0: Unable to initialize device.
> [  114.439891] iwlwifi 0000:02:00.0: Failed to run INIT ucode: -132
> [  114.439971] iwlwifi 0000:02:00.0: Unable to initialize device.
> [  114.440201] iwlwifi 0000:02:00.0: Failed to run INIT ucode: -132
> [  114.440259] iwlwifi 0000:02:00.0: Unable to initialize device.
> [  114.440967] iwlwifi 0000:02:00.0: Failed to run INIT ucode: -132
> [  114.441026] iwlwifi 0000:02:00.0: Unable to initialize device.
> 
> which is probably wpa_supplicant over eagerly trying to enable wireless
> interface which is disbaled by rfkill button. But I haven't checked
> that. Then I've killed it and switched rfkill button on and off several
> times which results in the above "Microcode SW error detected"
> 
> I had to rmmod all the iwlwifi related modules and load them again to
> make the device work again.
> 
> Is this a known issue? Is it an issue at all? Do you need an additional
> information?
> 
> I am currently using 3.13 vanilla but the "Failed to run INIT ucode"
> happened with 3.14-rc1 as well.
> 

Is this a regression?
To me, it looks like a pure firmware issue.
