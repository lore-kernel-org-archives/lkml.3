Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaCaAcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:32:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36209 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbaC3XY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 00:23:34 +0100
Message-ID: <lsq.1396221814.369444335@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 000/200] 3.2.56-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.56 release.
There are 200 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Apr 02 00:00:00 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.55 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Aisheng Dong (1):
      mmc: sdhci: fix lockdep error in tuning routine
         [2b35bd83467df6f8284b9148d6f768148c3a5e5f]

Al Viro (2):
      hpfs: deadlock and race in directory lseek()
         [31abdab9c11bb1694ecd1476a7edbe8e964d94ac]
      ocfs2 syncs the wrong range...
         [1b56e98990bcdbb20b9fab163654b9315bf158e8]

Alan Stern (4):
      USB: EHCI: add delay during suspend to prevent erroneous wakeups
         [3e8d6d85adedc59115a564c0a54b36e42087c4d9]
      usb-storage: add unusual-devs entry for BlackBerry 9000
         [c5637e5119c43452a00e27c274356b072263ecbb]
      usb-storage: enable multi-LUN scanning when needed
         [823d12c95c666fa7ab7dad208d735f6bc6afabdc]
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
         [a9c143c82608bee2a36410caa56d82cd86bdc7fa]

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8
         [12df84d4a80278a5b1abfec3206795291da52fc9]

Alex Deucher (4):
      drm/radeon/DCE4+: clear bios scratch dpms bit (v2)
         [6802d4bad83f50081b2788698570218aaff8d10e]
      drm/radeon: disable ss on DP for DCE3.x
         [d8e24525094200601236fa64a54cf73e3d682f2e]
      drm/radeon: set the full cache bit for fences on r7xx+
         [d45b964a22cad962d3ede1eba8d24f5cee7b2a92]
      drm/radeon: warn users when hw_i2c is enabled (v2)
         [d195178297de9a91246519dbfa98952b70f9a9b6]

Alex Williamson (1):
      intel-iommu: fix off-by-one in pagetable freeing
         [08336fd218e087cc4fcc458e6b6dcafe8702b098]

Amitkumar Karwar (1):
      mwifiex: copy AP's HT capability info correctly
         [c99b1861c232e1f641f13b8645e0febb3712cc71]

Andy Grover (1):
      target/iscsi: Fix network portal creation race
         [ee291e63293146db64668e8d65eb35c97e8324f4]

Anton Blanchard (2):
      net: unix socket code abuses csum_partial
         [0a13404dd3bf4ea870e3d96270b5a382edca85c0]
      powerpc: Align p_dyn, p_rela and p_st symbols
         [a5b2cf5b1af424ee3dd9e3ce6d5cea18cb927e67]

Arnd Bergmann (1):
      vmxnet3: fix building without CONFIG_PCI_MSI
         [0a8d8c446b5429d15ff2d48f46e00d8a08552303]

Benjamin Herrenschmidt (1):
      of: Fix address decoding on Bimini and js2x machines
         [6dd18e4684f3d188277bbbc27545248487472108]

Bjorn Helgaas (1):
      PCI: Enable INTx if BIOS left them disabled
         [1f42db786b14a31bf807fc41ee5583a00c08fcb1]

Bjørn Mork (1):
      usb: ftdi_sio: add Mindstorms EV3 console adapter
         [67847baee056892dc35efb9c3fd05ae7f075588c]

Boaz Harrosh (1):
      ore: Fix wrong math in allocation of per device BIO
         [aad560b7f63b495f48a7232fd086c5913a676e6f]

Borislav Petkov (2):
      EDAC: Correct workqueue setup path
         [cb6ef42e516cb8948f15e4b70dc03af8020050a2]
      rtc-cmos: Add an alarm disable quirk
         [d5a1c7e3fc38d9c7d629e1e47f32f863acbdec3d]

Chen Gang (1):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use
         [8d80390cfc9434d5aa4fb9e5f9768a66b30cb8a6]

Chris Mason (1):
      Btrfs: setup inode location during btrfs_init_inode_locked
         [90d3e592e99b8e374ead2b45148abf506493a959]

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check
         [c685689fd24d310343ac33942e9a54a974ae9c43]

Clemens Ladisch (2):
      ALSA: oxygen: Xonar DG(X): modify DAC routing
         [1f91ecc14deea9461aca93273d78871ec4d98fcd]
      ALSA: usb-audio: work around KEF X300A firmware bug
         [624aef494f86ed0c58056361c06347ad62b26806]

Colin Cross (1):
      timekeeping: fix 32-bit overflow in get_monotonic_boottime
         [ec145babe754f9ea1079034a108104b6001e001c]

Colin Leitner (1):
      USB: ftdi_sio: added CS5 quirk for broken smartcard readers
         [c1f15196ac3b541d084dc80a8fbd8a74c6a0bd44]

Dan Carpenter (1):
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()
         [aac5c4226e7136c331ed384c25d5560204da10a0]

Dan Williams (2):
      [SCSI] isci: fix reset timeout handling
         [ddfadd7736b677de2d4ca2cd5b4b655368c85a7a]
      ioat: fix tasklet tear down
         [da87ca4d4ca101f177fffd84f1f0a5e4c0343557]

Daniel Borkmann (2):
      net: sctp: fix sctp_connectx abi for ia32  emulation/compat mode
         [ffd5939381c609056b33b7585fb05a77b4c695f3]
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is  AUTH capable
         [ec0223ec48a90cb605244b45f7c62de856403729]

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node
         [847d7970defb45540735b3fb4e88471c27cacd85]

Dave Jones (1):
      [media] mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset
         [13e1b87c986100169b0695aeb26970943665eda9]

Dave Young (1):
      x86/efi: Fix off-by-one bug in EFI Boot Services reservation
         [a7f84f03f660d93574ac88835d056c0d6468aebe]

David Rientjes (1):
      mm, oom: base root bonus on current usage
         [778c14affaf94a9e4953179d3e13a544ccce7707]

David Sterba (1):
      btrfs: restrict snapshotting to own subvolumes
         [d024206133ce21936b3d5780359afc00247655b7]

David Vrabel (2):
      xen-blkfront: handle backend CLOSED without CLOSING
         [3661371701e714f0cea4120f6a365340858fb4e4]
      xen: install xen/gntdev.h and xen/gntalloc.h
         [564eb714f5f09ac733c26860d5f0831f213fbdf1]

Denis V. Lunev (1):
      ata: enable quirk from jmicron JMB350 for JMB394
         [efb9e0f4f43780f0ae0c6428d66bd03e805c7539]

Emil Goode (1):
      usbnet: remove generic hard_header_len check
         [eb85569fe2d06c2fbf4de7b66c263ca095b397aa]

Emmanuel Grumbach (1):
      mac80211: fix AP powersave TX vs. wakeup race
         [1d147bfa64293b2723c4fec50922168658e613ba]

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules
         [9085a6422900092886da8c404e1c5340c4ff1cbf]

Eric W. Biederman (1):
      fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem
         [96c7a2ff21501691587e1ae969b83cbec8b78e08]

Geert Uytterhoeven (1):
      TTY: pmac_zilog, check existence of ports in pmz_console_init()
         [dc1dc2f8a5dd863bf2e79f338fc3ae29e99c683a]

George McCollister (1):
      sched: Fix double normalization of vruntime
         [791c9e0292671a3bfa95286bb5c08129d8605618]

Giridhar Malavali (1):
      [SCSI] qla2xxx: Poll during initialization for ISP25xx and ISP83xx
         [b77ed25c9f8402e8b3e49e220edb4ef09ecfbb53]

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature
         [500a91571f0a5d0d3242d83802ea2fd1faccc66e]

H Hartley Sweeten (1):
      staging: comedi: adv_pci1710: fix analog output readback value
         [1e85c1ea1ff2a60659e790ef8ec76c7339445841]

Hans de Goede (1):
      ACPI / video: Filter the _BCL table for duplicate brightness values
         [bd8ba20597f0cfef3ef65c3fd2aa92ab23d4c8e1]

Harald Freudenberger (3):
      crypto: s390 - fix concurrency issue in aes-ctr mode
         [0519e9ad89e5cd6e6b08398f57c6a71d9580564c]
      crypto: s390 - fix des and des3_ede cbc concurrency issue
         [adc3fcf1552b6e406d172fd9690bbd1395053d13]
      crypto: s390 - fix des and des3_ede ctr concurrency issue
         [ee97dc7db4cbda33e4241c2d85b42d1835bc8a35]

Hartmut Knaack (1):
      staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested
         [38408d056188be29a6c4e17f3703c796551bb330]

Helge Deller (1):
      nfs: fix do_div() warning by instead using sector_div()
         [3873d064b8538686bbbd4b858dc8a07db1f7f43a]

Ian Abbott (2):
      staging: comedi: pcmuio: fix possible NULL deref on detach
         [2fd2bdfccae61efe18f6b92b6a45fbf936d75b48]
      staging: comedi: ssv_dnp: correct insn_bits result
         [f6b316bcd8c421acd6fa5a6e18b4c846ecb9d965]

Ira Weiny (1):
      IB/qib: Fix QP check when looping back to/from QP1
         [6e0ea9e6cbcead7fa8c76e3e3b9de4a50c5131c5]

Jan Glauber (1):
      s390/crypto: Don't panic after crypto instruction failures
         [36eb2caa7bace31b7868a57f77cb148e58d1c9f9]

Jan Kara (2):
      ocfs2: fix quota file corruption
         [15c34a760630ca2c803848fba90ca0646a9907dd]
      quota: Fix race between dqput() and dquot_scan_active()
         [1362f4ea20fa63688ba6026e586d9746ff13a846]

Jan Moskyto Matejka (1):
      Modpost: fixed USB alias generation for ranges including 0x9 and 0xA
         [03b56329f9bb5a1cb73d7dc659d529a9a9bf3acc]

Jani Nikula (2):
      drm/i915/dp: add native aux defer retry limit
         [f51a44b9a6c4982cc25bfb3727de9bb893621ebc]
      drm/i915/dp: increase native aux defer retry timeout
         [04eada25d1f72efdecd32d702706594f81de65d5]

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive  UFO
         [0e7ede80d929ff0f830c44a543daa1acd590c749]

Jean Delvare (2):
      i7300_edac: Fix device reference count
         [75135da0d68419ef8a925f4c1d5f63d8046e314d]
      i7core_edac: Fix PCI device reference count
         [c0f5eeed0f4cef4f05b74883a7160e7edde58b6a]

Jens Axboe (1):
      block: add cond_resched() to potentially long running ioctl discard loop
         [c8123f8c9cb517403b51aa41c3c46ff5e10b2c17]

Jianguo Wu (1):
      mm/hugetlb: check for pte NULL pointer in __page_check_address()
         [98398c32f6687ee1e1f3ae084effb4b75adb0747]

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private
         [163c8ff30dbe473abfbb24a7eac5536c87f3baa9]

Joe Thornber (1):
      dm space map common: make sure new space is used during extend
         [12c91a5c2d2a8e8cc40a9552313e1e7b0a2d9ee3]

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID
         [6dbd46c849e071e6afc1e0cad489b0175bca9318]

Johan Hovold (2):
      USB: cypress_m8: fix ring-indicator detection and reporting
         [440ebadeae9298d7de3d4d105342691841ec88d0]
      USB: pl2303: fix data corruption on termios updates
         [623c8263376c0b8a4b0c220232e7313d762cd0cc]

Johannes Berg (3):
      iwlwifi: fix TX status for aggregated packets
         [143582c6847cb285b361804c613127c25de60ca4]
      mac80211: clear sequence/fragment number in QoS-null frames
         [864a6040f395464003af8dd0d8ca86fed19866d4]
      mac80211: fix fragmentation code, particularly for encryption
         [338f977f4eb441e69bb9a46eaa0ac715c931a67f]

Josh Triplett (1):
      turbostat: Use GCC's CPUID functions to support PIC
         [2b92865e648ce04a39fda4f903784a5d01ecb0dc]

Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
         [e0429362ab15c46ea4d64c3f8c9e0933e48a143a]
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests
         [d86db25e53fa69e3e97f3b55dd82a70689787c5d]

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Don't timeout during the initial connection with host
         [269f979467cf49f2ea8132316c1f00f8c9678f7c]

KOSAKI Motohiro (2):
      mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq
         [227d53b397a32a7614667b3ecaf1d89902fb6c12]
      mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of spin_lock_irq()
         [a85d9df1ea1d23682a0ed1e100e6965006595d06]

Kieran Clancy (1):
      ACPI / EC: Clear stale EC events on Samsung systems
         [ad332c8a45330d170bb38b95209de449b31cd1b4]

Kleber Sacilotto de Souza (1):
      of: fix PCI bus match for PCIe slots
         [14e2abb732e485ee57d9d5b2cb8884652238e5c1]

Konrad Rzeszutek Wilk (1):
      intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing it.
         [3735d524da64b70b41c764359da36f88aded3610]

Krzysztof Kozlowski (1):
      power: max17040: Fix NULL pointer dereference when there is no platform_data
         [ac323d8d807060f7c95a685a9fe861e7b6300993]

Lai Jiangshan (1):
      workqueue: ensure @task is valid across kthread_stop()
         [5bdfff96c69a4d5ab9c49e60abf9e070ecd2acbb]

Lan Tianyu (1):
      ACPI / processor: Rework processor throttling with work_on_cpu()
         [f3ca4164529b875374c410193bbbac0ee960895f]

Larry Finger (4):
      rtlwifi: Set the link state
         [619ce76f8bb850b57032501a39f26aa6c6731c70]
      rtlwifi: rtl8192cu: Add new device ID
         [f87f960b2fb802f26ee3b00c19320e57a9c583ff]
      rtlwifi: rtl8192cu: Fix some code in RF handling
         [e9b0784bb9de3152e787ee779868c626b137fb3b]
      staging: r8712u: Set device type to wlan
         [3a21f00a5002b14e4aab52aef59d33ed28468a13]

Lars Poeschel (1):
      tty: n_gsm: Fix for modems with brk in modem status control
         [3ac06b905655b3ef2fd2196bab36e4587e1e4e4f]

Lars-Peter Clausen (1):
      ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant
         [e20970ada3f699c113fe64b04492af083d11a7d8]

Laurent Dufour (1):
      powerpc/crashdump : Fix page frame number check in copy_oldmem_page
         [f5295bd8ea8a65dc5eac608b151386314cb978f1]

Levente Kurusa (1):
      ahci: disable NCQ on Samsung pci-e SSDs on macbooks
         [67809f85d31eac600f6b28defa5386c9d2a13b1d]

Li Zefan (2):
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()
         [99afb0fd5f05aac467ffa85c36778fec4396209b]
      slub: Fix calculation of cpu slabs
         [8afb1474db4701d1ab80cd8251137a3260e6913e]

Linus Walleij (1):
      dma: ste_dma40: don't dereference free:d descriptor
         [e9baa9d9d520fb0e24cca671e430689de2d4a4b2]

Ludovic Desroches (1):
      mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA
         [66b512eda74d59b17eac04c4da1b38d82059e6c9]

Lukasz Dorau (1):
      [SCSI] isci: correct erroneous for_each_isci_host macro
         [c59053a23d586675c25d789a7494adfdc02fba57]

Maciej Żenczykowski (1):
      net: fix 'ip rule' iif/oif device rename
         [946c032e5a53992ea45e062ecb08670ba39b99e3]

Malcolm Priestley (1):
      staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning
         [8f248dae133668bfb8e9379b4b3f0571c858b24a]

Marc Kleine-Budde (3):
      can: flexcan: fix shutdown: first disable chip, then all interrupts
         [5be93bdda64e85450598c6e97f79fb8f6acf30e0]
      can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails
         [7e9e148af01ef388efb6e2490805970be4622792]
      can: flexcan: flexcan_remove(): add missing netif_napi_del()
         [d96e43e8fce28cf97df576a07af9d65657a41a6f]

Marcelo Tosatti (1):
      KVM: x86: limit PIT timer frequency
         [9ed96e87c5748de4c2807ef17e81287c7304186c]

Mark Brown (1):
      ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to regulator API
         [49a12877d2777cadcb838981c3c4f5a424aef310]

Martijn de Gouw (1):
      cifs: set MAY_SIGN when sec=krb5
         [0b7bc84000d71f3647ca33ab1bf5bd928535c846]

Mauro Carvalho Chehab (1):
      [media] dib8000: make 32 bits read atomic
         [5ac64ba12aca3bef18e61c866583155a3bbf81c4]

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD
         [d7b95315cc7f441418845a165ee56df723941487]

Michael Grzeschik (1):
      mtd: mxc_nand: remove duplicated ecc_stats counting
         [0566477762f9e174e97af347ee9c865f908a5647]

Michael Holzheu (1):
      s390/dump: Fix dump memory detection
         [d7736ff5be31edaa4fe5ab62810c64529a24b149]

Michel Dänzer (1):
      radeon/pm: Guard access to rdev->pm.power_state array
         [370169516e736edad3b3c5aa49858058f8b55195]

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)
         [b28a613e9138e4b3a64649bd60b13436f4b4b49b]

Mihai Caraman (1):
      KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()
         [70713fe315ed14cd1bb07d1a7f33e973d136ae3d]

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence
         [2f75e12c4457a9b3d042c0a0d748fa198dc2ffaf]

Mikhail Zolotaryov (1):
      USB: Nokia 502 is an unusual device
         [0e16114f2db4838251fb64f3b550996ad3585890]

Miklos Szeredi (1):
      fuse: fix pipe_buf_operations
         [28a625cbc2a14f17b83e47ef907b2658576a32aa]

Mikulas Patocka (5):
      alpha: fix broken network checksum
         [0ef38d70d4118b2ce1a538d14357be5ff9dc2bbd]
      dm sysfs: fix a module unload race
         [2995fa78e423d7193f3b57835f6c1c75006a0315]
      dm: wait until embedded kobject is released before destroying a device
         [be35f486108227e10fe5d96fd42fb2b344c59983]
      hpfs: remember free space
         [2cbe5c76fc5e38e9af4b709593146e4b8272b69e]
      time: Fix overflow when HZ is smaller than 60
         [80d767d770fd9c697e434fd080c2db7b5c60c6dd]

Neil Horman (1):
      vmxnet3: fix netpoll race condition
         [d25f06ea466ea521b563b76661180b4e44714ae6]

NeilBrown (2):
      lockd: send correct lock when granting a delayed lock.
         [2ec197db1a56c9269d75e965f14c344b58b2a4f6]
      md/raid5: fix long-standing problem with bitmap handling on write failure.
         [9f97e4b128d2ea90a5f5063ea0ee3b0911f4c669]

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()
         [c6993dfd7db9b0c6b7ca7503a56fda9236a4710f]

Oleg Nesterov (1):
      md/raid5: Fix CPU hotplug callback registration
         [789b5e0315284463617e106baad360cb9e8db3ac]

Oleksij Rempel (1):
      ath9k_htc: Do not support PowerSave by default
         [6bca610d97b6139a1d7598b8009da9d339daa50f]

Olivier Langlois (1):
      rtlwifi: rtl8192ce: Fix too long disable of IRQs
         [f78bccd79ba3cd9d9664981b501d57bdb81ab8a4]

Paul Bolle (1):
      raw: test against runtime value of max_raw_minors
         [5bbb2ae3d6f896f8d2082d1eceb6131c2420b7cf]

Paul E. McKenney (2):
      jiffies: Avoid undefined behavior from signed overflow
         [5a581b367b5df0531265311fc681c2abd377e5e6]
      printk: Fix scheduling-while-atomic problem in console_cpu_notify()
         [85eae82a0855d49852b87deac8653e4ebc8b291f]

Paul Gortmaker (1):
      avr32: fix missing module.h causing build failure in mimc200/fram.c
         [5745d6a41a4f4aec29e2ccd591c6fb09ed73a955]

Paul Mackerras (1):
      powerpc: Make sure "cache" directory is removed when offlining cpu
         [91b973f90c1220d71923e7efe1e61f5329806380]

Paul Moore (1):
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()
         [5c6c26813a209e7075baf908e3ad81c1a9d389e8]

Peter Chen (1):
      usb: ehci: add freescale imx28 special write register method
         [feffe09f510c475df082546815f9e4a573f6a233]

Peter Oberparleiter (1):
      x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y
         [6583327c4dd55acbbf2a6f25e775b28b3abf9a42]

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
         [26e61e8939b1fe8729572dabe9a9e97d930dd4f6]
      perf: Fix hotplug splat
         [e3703f8cdfcf39c25c4338c3ad8e68891cca3731]

Prarit Bhargava (1):
      x86: Add check for number of available vectors before CPU down
         [da6139e49c7cb0f4251265cb5243b8d220adb48d]

Radim Krčmář (1):
      KVM: SVM: fix cr8 intercept window
         [596f3142d2b7be307a1652d59e7b93adab918437]

Rahul Bedarkar (1):
      USB: serial: add support for iBall 3.5G connect usb modem
         [7d5c1b9c7cb5ec8e52b1adc65c484a923a8ea6c3]

Ralf Baechle (1):
      MIPS: Fix potencial corruption
         [a16dad7763420a3b46cff1e703a9070827796cfc]

Raymond Wanyoike (1):
      usb: option: blacklist ZTE MF667 net interface
         [3635c7e2d59f7861afa6fa5e87e2a58860ff514d]

Roman Volkov (1):
      ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2
         [3dd77654fb1d7f68b9739f3039bad8dbbc0739f8]

Sebastian Andrzej Siewior (1):
      parport: parport_pc: remove double PCI ID for NetMos
         [d6a484520c5572a4170fa915109ccfc0c38f5008]

Shane Huang (1):
      i2c: piix4: Add support for AMD ML and CZ SMBus changes
         [032f708bc4f6da868ec49dac48ddf3670d8035d3]

Stanislaw Gruszka (3):
      ath9k: protect tid->sched check
         [21f8aaee0c62708654988ce092838aa7df4d25d8]
      rtl8187: fix regression on MIPS without coherent DMA
         [b6213e413a4e0c66548153516b074df14f9d08e0]
      usb: ehci: fix deadlock when threadirqs option is used
         [a1227f3c1030e96ebc51d677d2f636268845c5fb]

Stephen Smalley (1):
      SELinux:  Fix kernel BUG on empty security contexts.
         [2172fa709ab32ca60e86179dc67d0857be8e2c98]

Stephen Warren (1):
      serial: 8250: enable UART_BUG_NOMSR for Tegra
         [3685f19e07802ec4207b52465c408f185b66490e]

Steven Noonan (1):
      compiler/gcc4: Make quirk for asm_volatile_goto() unconditional
         [a9f180345f5378ac87d80ed0bea55ba421d83859]

Steven Rostedt (5):
      ftrace: Fix synchronization location disabling and freeing ftrace_ops
         [a4c35ed241129dd142be4cadb1e5a474a56d5464]
      ftrace: Have function graph only trace based on global_ops filters
         [23a8e8441a0a74dd612edf81dc89d1600bc0a3d1]
      ftrace: Use schedule_on_each_cpu() as a heavy synchronize_sched()
         [7614c3dc74733dff4b0e774f7a894b9ea6ec508c]
      ring-buffer: Fix first commit on sub-buffer having non-zero delta
         [d651aa1d68a2f0a7ee65697b04c6a92f8c0a12f2]
      tracing: Do not add event files for modules that fail tracepoints
         [45ab2813d40d88fc575e753c38478de242d03f88]

Sujith Manoharan (2):
      ath9k: Do not support PowerSave by default
         [8298383c2cd5a6d0639f1bb1781fba181bd20154]
      ath9k: Fix ETSI compliance for AR9462 2.0
         [b3050248c167871ca52cfdb2ce78aa2460249346]

Takashi Iwai (9):
      ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks
         [80ab8eae70e51d578ebbeb228e0f7a562471b8b7]
      ALSA: hda/realtek - Avoid invalid COEFs for ALC271X
         [d3c56568f43807135f2c2a09582a69f809f0d8b7]
      ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]
         [770bd4bf2e664939a9dacd3d26ec9ff7a3933210]
      ALSA: usb-audio: Add quirk for Logitech Webcam C500
         [e805ca8b0a9b6c91099c0eaa4b160a1196a4ae25]
      ASoC: sta32x: Fix array access overflow
         [025c3fa9256d4c54506b7a29dc3befac54f5c68d]
      ASoC: sta32x: Fix wrong enum for limiter2 release rate
         [b3619b288b621e63f66908045f48495869a996a6]
      ASoC: wm8770: Fix wrong number of enum items
         [7a6c0a58dc824523966f212c76322d47c5b0e6fe]
      [media] saa7134: Fix unlocked snd_pcm_stop() call
         [e6355ad7b1c6f70e2f48ae159f5658b441ccff95]
      hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
         [b0ad4ff35d479a46a3b995a299db9aeb097acfce]

Tejun Heo (3):
      cgroup: update cgroup_enable_task_cg_lists() to grab siglock
         [532de3fc72adc2a6525c4d53c07bf81e1732083d]
      libata: disable LPM for some WD SATA-I devices
         [ecd75ad514d73efc1bbcc5f10a13566c3ace5f53]
      sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN
         [9f9c47f00ce99329b1a82e2ac4f70f0fe3db549c]

Tetsuo Handa (1):
      SELinux: Fix memory leak upon loading policy
         [8ed814602876bec9bad2649ca17f34b499357a1c]

Theodore Ts'o (1):
      ext4: don't leave i_crtime.tv_sec uninitialized
         [19ea80603715d473600cd993b9987bc97d042e02]

Tony Breeds (1):
      powerpc/le: Ensure that the 'stop-self' RTAS token is handled correctly
         [41dd03a94c7d408d2ef32530545097f7d1befe5c]

Trond Myklebust (2):
      NFSv4: OPEN must handle the NFS4ERR_IO return code correctly
         [c7848f69ec4a8c03732cde5c949bd2aa711a9f4b]
      SUNRPC: Fix races in xs_nospace()
         [06ea0bfe6e6043cb56a78935a19f6f8ebc636226]

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs
         [76f24e3f39a1a94bab0d54e98899d64abcd9f69c]

Vijaya Mohan Guvva (1):
      [SCSI] bfa: Chinook quad port 16G FC HBA claim issue
         [dcaf9aed995c2b2a49fb86bbbcfa2f92c797ab5d]

Ville Syrjälä (2):
      drm/i915: Add intel_ring_cachline_align()
         [753b1ad4a281b0663329409d410243e91825c323]
      drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB
         [f66fab8e1cd6b3127ba4c5c0d11539fbe1de1e36]

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()
         [39544ac9df20f73e49fc6b9ac19ff533388c82c0]

Wang Shilong (1):
      Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()
         [90515e7f5d7d24cbb2a4038a3f1b5cfa2921aa17]

Weijie Yang (1):
      mm/swap: fix race on swap_info reuse between swapoff and swapon
         [f893ab41e4dae2fe8991faf5d86d029068d1ef3a]

Weston Andros Adamson (2):
      nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME
         [78b19bae0813bd6f921ca58490196abd101297bd]
      sunrpc: Fix infinite loop in RPC state machine
         [6ff33b7dd0228b7d7ed44791bbbc98b03fd15d9d]

Will Deacon (2):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU
         [bae0ca2bc550d1ec6a118fb8f2696f18c4da3d8e]
      ARM: 7955/1: spinlock: ensure we have a compiler barrier before sev
         [7c8746a9eb287642deaad0e7c2cdf482dce5e4be]

Yegor Yefremov (2):
      serial: add support for 200 v3 series Titan card
         [48c0247d7b7bf58abb85a39021099529df365c4d]
      serial: add support for 400 and 800 v3 series Titan cards
         [1e9deb118ed76b9df89d189f27a06522a03cf743]

ZHAO Gang (1):
      b43: fix the wrong assignment of status.freq in b43_rx()
         [64e5acb09ca6b50c97299cff9ef51299470b29f2]

Алексей Крамаренко (1):
      USB: serial: ftdi_sio: add id for Z3X Box device
         [e1466ad5b1aeda303f9282463d55798d2eda218c]

张君 (1):
      usb: option: add new zte 3g modem pids to option driver
         [4d90b819ae4c7ea8fd5e2bb7edc68c0f334be2e4]

 Documentation/filesystems/proc.txt                 |   4 +-
 Documentation/i2c/busses/i2c-piix4                 |   2 +-
 Makefile                                           |   4 +-
 arch/alpha/lib/csum_partial_copy.c                 |   9 +-
 arch/arm/include/asm/cacheflush.h                  |   1 +
 arch/arm/include/asm/spinlock.h                    |  15 +--
 arch/arm/mm/proc-v6.S                              |   3 +-
 arch/arm/mm/proc-v7.S                              |   2 +-
 arch/avr32/Makefile                                |   2 +-
 arch/avr32/boards/mimc200/fram.c                   |   1 +
 arch/mips/mm/c-r4k.c                               |  11 ---
 arch/powerpc/kernel/cacheinfo.c                    |   3 +
 arch/powerpc/kernel/crash_dump.c                   |   8 +-
 arch/powerpc/kernel/reloc_64.S                     |   1 +
 arch/powerpc/kvm/e500_tlb.c                        |   2 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |  22 ++---
 arch/s390/crypto/aes_s390.c                        |  79 +++++++++++-----
 arch/s390/crypto/des_s390.c                        | 103 ++++++++++++++-------
 arch/s390/crypto/ghash_s390.c                      |  21 +++--
 arch/s390/crypto/sha_common.c                      |   9 +-
 arch/s390/mm/page-states.c                         |  10 ++
 arch/x86/include/asm/irq.h                         |   1 +
 arch/x86/kernel/cpu/perf_event.c                   |   3 +
 arch/x86/kernel/irq.c                              |  70 ++++++++++++++
 arch/x86/kernel/quirks.c                           |   2 +-
 arch/x86/kernel/smpboot.c                          |   5 +
 arch/x86/kvm/i8254.c                               |  18 ++++
 arch/x86/kvm/lapic.c                               |   3 -
 arch/x86/kvm/svm.c                                 |   6 +-
 arch/x86/kvm/x86.c                                 |   3 +
 arch/x86/kvm/x86.h                                 |   2 +
 arch/x86/platform/efi/efi.c                        |   2 +-
 block/blk-lib.c                                    |   8 ++
 drivers/acpi/bus.c                                 |   9 ++
 drivers/acpi/ec.c                                  |  64 +++++++++++++
 drivers/acpi/processor_throttling.c                |  69 +++++++-------
 drivers/acpi/video.c                               |   8 +-
 drivers/ata/ahci.c                                 |  14 +++
 drivers/ata/libata-core.c                          |  28 ++++++
 drivers/ata/libata-pmp.c                           |   7 +-
 drivers/ata/libata-scsi.c                          |  18 +++-
 drivers/ata/sata_sil.c                             |   1 +
 drivers/block/xen-blkfront.c                       |   5 +-
 drivers/char/raw.c                                 |   2 +-
 drivers/dma/ioat/dma.c                             |  46 +++++++--
 drivers/dma/ioat/dma.h                             |   1 +
 drivers/dma/ioat/dma_v2.c                          |  11 +--
 drivers/dma/ioat/dma_v3.c                          |   3 +
 drivers/dma/ste_dma40.c                            |   4 +-
 drivers/edac/edac_mc.c                             |  11 ++-
 drivers/edac/i7300_edac.c                          |  38 ++++----
 drivers/edac/i7core_edac.c                         |   9 +-
 drivers/gpu/drm/i915/intel_display.c               |  14 +++
 drivers/gpu/drm/i915/intel_dp.c                    |  19 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  21 +++++
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   1 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |   5 +-
 drivers/gpu/drm/radeon/r600.c                      |  14 +--
 drivers/gpu/drm/radeon/r600d.h                     |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |   4 +
 drivers/gpu/drm/radeon/radeon_i2c.c                |   3 +
 drivers/gpu/drm/radeon/radeon_pm.c                 |   6 +-
 drivers/hv/connection.c                            |  12 +--
 drivers/hwmon/max1668.c                            |   2 +-
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/busses/i2c-piix4.c                     |  26 +++++-
 drivers/idle/intel_idle.c                          |   3 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |   5 +
 drivers/infiniband/hw/qib/qib_ud.c                 |   9 +-
 drivers/iommu/intel-iommu.c                        |   2 +-
 drivers/md/Kconfig                                 |   4 +
 drivers/md/Makefile                                |   1 +
 drivers/md/dm-builtin.c                            |  49 ++++++++++
 drivers/md/dm-sysfs.c                              |   5 +-
 drivers/md/dm.c                                    |  11 +--
 drivers/md/dm.h                                    |  17 ++++
 drivers/md/persistent-data/dm-space-map-common.c   |   6 +-
 drivers/md/raid5.c                                 |  91 +++++++++---------
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.h         |   2 +-
 drivers/media/dvb/frontends/dib8000.c              |  33 +++++--
 drivers/media/video/saa7134/saa7134-alsa.c         |   2 +
 drivers/mmc/host/atmel-mci.c                       |  13 ++-
 drivers/mmc/host/sdhci.c                           |  17 ++--
 drivers/mtd/nand/mxc_nand.c                        |   1 -
 drivers/net/bonding/bond_3ad.c                     |   6 +-
 drivers/net/bonding/bond_3ad.h                     |   1 +
 drivers/net/can/flexcan.c                          |  13 ++-
 drivers/net/ethernet/broadcom/tg3.c                |   7 +-
 drivers/net/ethernet/broadcom/tg3.h                |   6 +-
 drivers/net/usb/gl620a.c                           |   4 +
 drivers/net/usb/mcs7830.c                          |   5 +-
 drivers/net/usb/net1080.c                          |   4 +
 drivers/net/usb/rndis_host.c                       |   4 +
 drivers/net/usb/smsc75xx.c                         |   4 +
 drivers/net/usb/smsc95xx.c                         |   4 +
 drivers/net/usb/usbnet.c                           |  25 ++---
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  19 +++-
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   8 +-
 drivers/net/wireless/ath/ath9k/init.c              |   8 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   8 +-
 drivers/net/wireless/b43/xmit.c                    |   4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |  16 +++-
 drivers/net/wireless/mwifiex/11n.c                 |   3 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h     |  10 +-
 drivers/net/wireless/rtlwifi/core.c                |   1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |  18 +++-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |  29 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   1 +
 drivers/of/address.c                               |   9 +-
 drivers/parport/parport_pc.c                       |  10 +-
 drivers/pci/pci.c                                  |  10 ++
 drivers/platform/x86/hp_accel.c                    |   1 +
 drivers/power/max17040_battery.c                   |   5 +-
 drivers/rtc/rtc-cmos.c                             |  52 ++++++++++-
 drivers/scsi/bfa/bfad.c                            |   6 +-
 drivers/scsi/isci/host.h                           |   5 +-
 drivers/scsi/isci/port_config.c                    |   7 --
 drivers/scsi/isci/task.c                           |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   3 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  17 +++-
 drivers/staging/comedi/drivers/pcmuio.c            |  12 +--
 drivers/staging/comedi/drivers/ssv_dnp.c           |   6 +-
 drivers/staging/iio/adc/ad799x_core.c              |   3 +-
 drivers/staging/rtl8712/usb_intf.c                 |   5 +
 drivers/staging/vt6656/baseband.c                  |   3 -
 drivers/target/iscsi/iscsi_target.c                |  34 ++++---
 drivers/tty/n_gsm.c                                |  11 +++
 drivers/tty/serial/8250.c                          |   4 +
 drivers/tty/serial/8250_pci.c                      |  20 ++++
 drivers/tty/serial/pmac_zilog.c                    |   3 +
 drivers/usb/core/config.c                          |   4 +
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/host/ehci-hcd.c                        |  13 ++-
 drivers/usb/host/ehci-hub.c                        |  26 +++++-
 drivers/usb/host/ehci.h                            |  18 +++-
 drivers/usb/serial/cypress_m8.h                    |   2 +-
 drivers/usb/serial/ftdi_sio.c                      |  23 ++++-
 drivers/usb/serial/ftdi_sio_ids.h                  |  19 ++++
 drivers/usb/serial/option.c                        |  21 ++++-
 drivers/usb/serial/pl2303.c                        |  33 +++++--
 drivers/usb/storage/Kconfig                        |   4 +-
 drivers/usb/storage/scsiglue.c                     |   4 +
 drivers/usb/storage/unusual_cypress.h              |   2 +-
 drivers/usb/storage/unusual_devs.h                 |  14 +++
 fs/btrfs/extent-tree.c                             |   2 +-
 fs/btrfs/inode.c                                   |  18 ++--
 fs/btrfs/ioctl.c                                   |  15 ++-
 fs/buffer.c                                        |   6 +-
 fs/cifs/connect.c                                  |   3 +-
 fs/exofs/ore.c                                     |  37 +++++---
 fs/ext4/ext4.h                                     |   2 +
 fs/file.c                                          |   2 +-
 fs/fuse/dev.c                                      |  22 +----
 fs/hpfs/alloc.c                                    |  66 ++++++++++++-
 fs/hpfs/dir.c                                      |  10 +-
 fs/hpfs/hpfs_fn.h                                  |   2 +-
 fs/hpfs/super.c                                    |  32 +++++--
 fs/lockd/svclock.c                                 |   8 ++
 fs/nfs/blocklayout/extents.c                       |   2 +-
 fs/nfs/nfs4proc.c                                  |   4 +-
 fs/nfs/nfs4xdr.c                                   |  47 ++++++----
 fs/ocfs2/file.c                                    |   8 +-
 fs/ocfs2/quota_global.c                            |  27 ++++--
 fs/ocfs2/quota_local.c                             |   4 -
 fs/quota/dquot.c                                   |  14 ++-
 fs/splice.c                                        |  18 ++++
 include/linux/compiler-gcc4.h                      |   6 +-
 include/linux/jiffies.h                            |   8 +-
 include/linux/libata.h                             |   2 +
 include/linux/pipe_fs_i.h                          |   2 +
 include/linux/tracepoint.h                         |   6 ++
 include/scsi/osd_ore.h                             |   1 +
 include/xen/Kbuild                                 |   2 +
 kernel/cgroup.c                                    |   5 +
 kernel/cpuset.c                                    |   2 +-
 kernel/events/core.c                               |  12 +--
 kernel/irq/manage.c                                |   2 +-
 kernel/printk.c                                    |   1 -
 kernel/sched_fair.c                                |   8 +-
 kernel/time/jiffies.c                              |   6 ++
 kernel/time/timekeeping.c                          |   2 +-
 kernel/trace/ftrace.c                              |  81 ++++++++++++++--
 kernel/trace/ring_buffer.c                         |   7 ++
 kernel/trace/trace_events.c                        |  10 ++
 kernel/tracepoint.c                                |   7 +-
 kernel/workqueue.c                                 |   7 ++
 lib/Makefile                                       |   1 +
 mm/oom_kill.c                                      |   2 +-
 mm/page-writeback.c                                |   5 +-
 mm/rmap.c                                          |   4 +
 mm/slub.c                                          |   8 +-
 mm/swapfile.c                                      |  11 ++-
 net/core/fib_rules.c                               |   7 ++
 net/core/skbuff.c                                  |  32 +------
 net/mac80211/sta_info.c                            |   5 +
 net/mac80211/sta_info.h                            |   7 +-
 net/mac80211/tx.c                                  |  17 +++-
 net/sctp/sm_statefuns.c                            |   7 ++
 net/sctp/socket.c                                  |  41 ++++++--
 net/sunrpc/clnt.c                                  |   8 +-
 net/sunrpc/xprtsock.c                              |   6 +-
 net/unix/af_unix.c                                 |   4 +-
 scripts/mod/file2alias.c                           |   4 +-
 security/selinux/hooks.c                           |  42 +++++++--
 security/selinux/ss/policydb.c                     |  22 ++++-
 security/selinux/ss/services.c                     |   4 +
 sound/pci/Kconfig                                  |  12 +++
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/pci/oxygen/xonar_dg.c                        |  12 ++-
 sound/pci/rme9652/rme9652.c                        |   2 +-
 sound/soc/codecs/adau1701.c                        |   2 +-
 sound/soc/codecs/sta32x.c                          |  74 +++++++--------
 sound/soc/codecs/wm8770.c                          |   4 +-
 sound/usb/mixer.c                                  |   1 +
 sound/usb/mixer_maps.c                             |   9 ++
 tools/power/x86/turbostat/turbostat.c              |  11 ++-
 virt/kvm/coalesced_mmio.c                          |   8 +-
 219 files changed, 1989 insertions(+), 725 deletions(-)

-- 
Ben Hutchings
friends: People who know you well, but like you anyway.

