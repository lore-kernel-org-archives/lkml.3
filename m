Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967076AbaLLG61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:58:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51696 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758186AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Phil Jensen <pjensen@evernote.com>,
        akpm@linux-foundation.org
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.554543691@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 000/164] 3.2.65-rc1 review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.65 release.
There are 164 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec 14 06:14:25 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.64 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Aaro Koskinen (2):
      MIPS: Loongson: Make platform serial setup always built-in.
         [26927f76499849e095714452b8a4e09350f6a3b9]
      MIPS: oprofile: Fix backtrace on 64-bit kernel
         [bbaf113a481b6ce32444c125807ad3618643ce57]

Al Viro (1):
      fix misuses of f_count() in ppp and netlink
         [24dff96a37a2ca319e75a74d3929b2de22447ca6]

Alan Stern (1):
      usb-storage: handle a skipped data phase
         [93c9bf4d1838d5851a18ca398b0ad66397f05056]

Alex Deucher (1):
      drm/radeon: remove invalid pci id
         [8c3e434769b1707fd2d24de5a2eb25fedc634c4a]

Alexey Khoroshilov (2):
      can: esd_usb2: fix memory leak on disconnect
         [efbd50d2f62fc1f69a3dcd153e63ba28cc8eb27f]
      dm log userspace: fix memory leak in dm_ulog_tfr_init failure path
         [56ec16cb1e1ce46354de8511eef962a417c32c92]

Andreas Bomholtz (1):
      USB: cp210x: add support for Seluxit USB dongle
         [dee80ad12d2b1b304286a707fde7ab05d1fc7bab]

Andreas Noever (1):
      PCI: pciehp: Prevent NULL dereference during probe
         [bceee4a97eb58bd0e80e39eff11b506ddd9e7ad3]

Andy Adamson (1):
      NFSv4.1: Fix an NFSv4.1 state renewal regression
         [d1f456b0b9545f1606a54cd17c20775f159bd2ce]

Andy Lutomirski (5):
      x86, apic: Handle a bad TSC more gracefully
         [b47dcbdc5161d3d5756f430191e2840d9b855492]
      x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs
         [7ddc6a2199f1da405a2fb68c40db8899b1a8cd87]
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
         [af726f21ed8af2cdaa4e93098dc211521218ae65]
      x86_64, traps: Rework bad_iret
         [b645af2d5905c4e32399005b867987919cbfc3ae]
      x86_64, traps: Stop using IST for #SS
         [6f442be2fb22be02cafa606f1769fa1e6f894441]

Andy Shevchenko (3):
      spi: dw-mid: check that DMA was inited before exit
         [fb57862ead652454ceeb659617404c5f13bc34b5]
      spi: dw-mid: respect 8 bit mode
         [b41583e7299046abdc578c33f25ed83ee95b9b31]
      spi: dw-mid: terminate ongoing transfers at exit
         [8e45ef682cb31fda62ed4eeede5d9745a0a1b1e2]

Artem Bityutskiy (3):
      UBIFS: fix a race condition
         [052c28073ff26f771d44ef33952a41d18dadd255]
      UBIFS: fix free log space calculation
         [ba29e721eb2df6df8f33c1f248388bb037a47914]
      UBIFS: remove mst_mutex
         [07e19dff63e3d5d6500d831e36554ac9b1b0560e]

Ben Hutchings (1):
      compiler: Define OPTIMIZER_HIDE_VAR
         [fe8c8a126806fea4465c43d62a1f9d273a572bf5]

Benjamin Coddington (1):
      lockd: Try to reconnect if statd has moved
         [173b3afceebe76fa2205b2c8808682d5b541fe3c]

Benjamin Herrenschmidt (1):
      of/base: Fix PowerPC address parsing hack
         [746c9e9f92dde2789908e51a354ba90a1962a2eb]

Brian Silverman (1):
      futex: Fix a race condition between REQUEUE_PI and task death
         [30a6b8031fe14031ab27c1fa3483cb9780e7f63c]

Bryan O'Donoghue (1):
      x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead
         [ee1b5b165c0a2f04d2107e634e51f05d0eb107de]

Champion Chen (1):
      Bluetooth: Fix issue with USB suspend in btusb driver
         [85560c4a828ec9c8573840c9b66487b6ae584768]

Chao Yu (1):
      ecryptfs: avoid to access NULL pointer when write metadata in xattr
         [35425ea2492175fd39f6116481fe98b2b3ddd4ca]

Christian Borntraeger (1):
      KVM: s390: unintended fallthrough for external call
         [f346026e55f1efd3949a67ddd1dcea7c1b9a615e]

Christoph Hellwig (1):
      scsi: only re-lock door after EH on devices that were reset
         [48379270fe6808cf4612ee094adc8da2b7a83baa]

Chuck Lever (1):
      sunrpc: fix byte-swapping of displayed XID
         [71efecb3f58c8c7a15f6135e3f9b39d1e3d3fae3]

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask
         [ccf54555da9a5e91e454b909ca6a5303c7d6b910]

Cyril Brulebois (1):
      wireless: rt2x00: add new rt2800usb device
         [664d6a792785cc677c2091038ce10322c8d04ae1]

Dan Williams (1):
      USB: option: add Haier CE81B CDMA modem
         [012eee1522318b5ccd64d277d50ac32f7e9974fe]

Daniel Borkmann (1):
      random: add and use memzero_explicit() for clearing data
         [d4c5efdb97773f59a2b711754ca0953f24516739]

Daniele Palmas (1):
      usb: option: add support for Telit LE910
         [2d0eb862dd477c3c4f32b201254ca0b40e6f465c]

Darrick J. Wong (1):
      ext4: check EA value offset when loading
         [a0626e75954078cfacddb00a4545dde821170bc5]

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option
         [2cd3949f702692cf4c5d05b463f19cd706a92dd3]

David Matlack (2):
      kvm: don't take vcpu mutex for obviously invalid vcpu ioctls
         [2ea75be3219571d0ec009ce20d9971e54af96e09]
      kvm: x86: fix stale mmio cache bug
         [56f17dd3fbc44adcdbc3340fe3988ddb833a47a7]

David Rientjes (1):
      mm, thp: fix collapsing of hugepages on madvise
         [6d50e60cd2edb5a57154db5a6f64eef5aa59b751]

Dmitry Eremin-Solenikov (1):
      ARM: 8216/1: xscale: correct auxiliary register in suspend/resume
         [ef59a20ba375aeb97b3150a118318884743452a8]

Dmitry Kasatkin (1):
      evm: check xattr value length and type in evm_inode_setxattr()
         [3b1deef6b1289a99505858a3b212c5b50adf0c2f]

Dmitry Torokhov (1):
      Input: synaptics - gate forcepad support by DMI check
         [aa972409951e0675e07918620427517cad5090e0]

Douglas Lehr (1):
      PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size
         [9fe373f9997b48fcd6222b95baf4a20c134b587a]

Eric Dumazet (1):
      tcp: be more strict before accepting ECN negociation
         [bd14b1b2e29bd6812597f896dde06eaf7c6d2f24]

Eric Sandeen (1):
      ext4: fix reservation overflow in ext4_da_write_begin
         [0ff8947fc5f700172b37cbca811a38eb9cb81e08]

Fabio Estevam (1):
      ASoC: sgtl5000: Fix SMALL_POP bit definition
         [c251ea7bd7a04f1f2575467e0de76e803cf59149]

Felipe Balbi (1):
      usb: gadget: udc: core: fix kernel oops with soft-connect
         [bfa6b18c680450c17512c741ed1d818695747621]

Frans Klaver (1):
      usb: serial: ftdi_sio: add Awinda Station and Dongle products
         [edd74ffab1f6909eee400c7de8ce621870aacac9]

Geert Uytterhoeven (1):
      m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()
         [e4dc601bf99ccd1c95b7e6eef1d3cf3c4b0d4961]

Greg Kroah-Hartman (1):
      Input: xpad - use proper endpoint type
         [a1f9a4072655843fc03186acbad65990cc05dd2d]

Hans de Goede (4):
      Input: i8042 - add noloop quirk for Asus X750LN
         [9ff84a17302aeb8913ff244ecc0d8f9d219fecb5]
      Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544
         [993b3a3f80a7842a48cd46c2b41e1b3ef6302468]
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000
         [263e80b43559a6103e178a9176938ce171b23872]
      usb: Do not allow usb_alloc_streams on unconfigured devices
         [90a646c770c50cc206ceba0d7b50453c46c13c36]

Heinz Mauelshagen (1):
      dm raid: ensure superblock's size matches device's logical block size
         [40d43c4b4cac4c2647bf07110d7b07d35f399a84]

Ilya Dryomov (2):
      libceph: ceph-msgr workqueue needs a resque worker
         [f9865f06f7f18c6661c88d0511f05c48612319cc]
      libceph: do not crash on large auth tickets
         [aaef31703a0cf6a733e651885bfb49edc3ac6774]

Imre Deak (2):
      PM / Sleep: fix recovery during resuming from hibernation
         [94fb823fcb4892614f57e59601bb9d4920f24711]
      tty/vt: don't set font mappings on vc not supporting this
         [9e326f78713a4421fe11afc2ddeac07698fac131]

J. Bruce Fields (1):
      nfsd4: fix crash on unknown operation number
         [51904b08072a8bf2b9ed74d1bd7a5300a614471d]

James Ralston (1):
      ahci: Add Device IDs for Intel Sunrise Point PCH
         [690000b930456a98663567d35dd5c54b688d1e3f]

Jan Kara (9):
      block: Fix computation of merged request priority
         [ece9c72accdc45c3a9484dacb1125ce572647288]
      ext3: Don't check quota format when there are no quota files
         [7938db449bbc55bbeb164bec7af406212e7e98f1]
      ext4: bail out from make_indexed_dir() on first error
         [6050d47adcadbb53582434d919ed7f038d936712]
      ext4: don't check quota format when there are no quota files
         [279bf6d390933d5353ab298fcc306c391a961469]
      ext4: fix oops when loading block bitmap failed
         [599a9b77ab289d85c2d5c8607624efbe1f552b0f]
      ext4: fix overflow when updating superblock backups after resize
         [9378c6768e4fca48971e7b6a9075bc006eda981d]
      lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
         [ea5d05b34aca25c066e0699512d0ffbd8ee6ac3e]
      scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
         [84ce0f0e94ac97217398b3b69c21c7a62ebeed05]
      vfs: fix data corruption when blocksize < pagesize for mmaped data
         [90a8020278c1598fafd071736a0846b38510309c]

Jeffrey Knockel (1):
      Patch for 3.2.x, 3.4.x IP identifier regression
         [not upstream; fixes bad backport]

Joe Savage (1):
      USB: serial: cp210x: added Ketra N1 wireless interface support
         [bfc2d7dfdd761ae3beccdb26abebe03cef042f46]

Joe Thornber (1):
      dm bufio: update last_accessed when relinking a buffer
         [eb76faf53b1ff7a77ce3f78cc98ad392ac70c2a0]

Johan Hovold (7):
      USB: cdc-acm: add device id for GW Instek AFG-2225
         [cf84a691a61606a2e7269907d3727e2d9fa148ee]
      USB: cdc-acm: only raise DTR on transitions from B0
         [4473d054ceb572557954f9536731d39b20937b0c]
      USB: keyspan: fix overrun-error reporting
         [855515a6d3731242d85850a206f2ec084c917338]
      USB: keyspan: fix tty line-status reporting
         [5d1678a33c731b56e245e888fdae5e88efce0997]
      USB: kobil_sct: fix non-atomic allocation in write path
         [191252837626fca0de694c18bb2aa64c118eda89]
      USB: opticon: fix non-atomic allocation in write path
         [e681286de221af78fc85db9222b6a203148c005a]
      USB: ssu100: fix overrun-error reporting
         [75bcbf29c284dd0154c3e895a0bd1ef0e796160e]

Johannes Berg (2):
      mac80211: fix use-after-free in defragmentation
         [b8fff407a180286aa683d543d878d98d9fc57b13]
      mac80211: properly flush delayed scan work on interface removal
         [46238845bd609a5c0fbe076e1b82b4c5b33360b2]

Joonyoung Shim (1):
      USB: add reset resume quirk for usb3503
         [526a4045c60fbaede88ec95a69a73059dff02160]

K. Y. Srinivasan (6):
      Drivers: hv: vmbus: Cleanup hv_post_message()
         [b29ef3546aecb253a5552b198cef23750d56e1e4]
      Drivers: hv: vmbus: Cleanup vmbus_close_internal()
         [98d731bb064a9d1817a6ca9bf8b97051334a7cfe]
      Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
         [72c6b71c245dac8f371167d97ef471b367d0b66b]
      Drivers: hv: vmbus: Cleanup vmbus_post_msg()
         [fdeebcc62279119dbeafbc1a2e39e773839025fd]
      Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
         [66be653083057358724d56d817e870e53fb81ca7]
      Drivers: hv: vmbus: Fix a bug in vmbus_open()
         [45d727cee9e200f5b351528b9fb063b69cf702c8]

Kees Cook (2):
      firmware_class: make sure fw requests contain a name
         [471b095dfe0d693a8d624cbc716d1ee4d74eb437]
      x86, mm: Set NX across entire PMD at boot
         [45e2a9d4701d8c624d4a4bcdd1084eae31e92f58]

Kuninori Morimoto (1):
      ASoC: fsi: remove unsupported PAUSE flag
         [c1b9b9b1ad2df6144ca3fbe6989f7bd9ea5c5562]

Lars-Peter Clausen (2):
      staging:iio:ad5933: Drop "raw" from channel names
         [6822ee34ad57b29a3b44df2c2829910f03c34fa4]
      staging:iio:ade7758: Remove "raw" from channel name
         [b598aacc29331e7e638cd509108600e916c6331b]

Lu Baolu (3):
      Revert "xhci: clear root port wake on bits if controller isn't wake-up capable"
         [9b41ebd3cf0f68d8cad779d3eeba336f78262e43]
      USB: Add device quirk for ASUS T100 Base Station keyboard
         [ddbe1fca0bcb87ca8c199ea873a456ca8a948567]
      usb: xhci: rework root port wake bits if controller isn't allowed to wakeup
         [a1377e5397ab321e21b793ec8cd2b6f12bd3c718]

Maciej Matraszek (1):
      [media] v4l2-common: fix overflow in v4l_bound_align_image()
         [3bacc10cd4a85bc70bc0b6c001d3bf995c7fe04c]

Markos Chandras (1):
      MIPS: ftrace: Fix a microMIPS build problem
         [aedd153f5bb5b1f1d6d9142014f521ae2ec294cc]

Mathias Krause (1):
      posix-timers: Fix stack info leak in timer_create()
         [6891c4509c792209c44ced55a60f13954cb50ef4]

Mathias Nyman (2):
      USB: xhci: Reset a halted endpoint immediately when we encounter a stall.
         [8e71a322fdb127814bcba423a512914ca5bc6cf5]
      USB: xhci: don't start a halted endpoint before its new dequeue is set
         [c3492dbfa1050debf23a5b5cd2bc7514c5b37896]

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list
         [01a4cc4d0cd6a836c7b923760e8eb1cbb6a47258]

Max Filippov (1):
      xtensa: re-wire umount syscall to sys_oldumount
         [2651cc6974d47fc43bef1cd8cd26966e4f5ba306]

Michael S. Tsirkin (1):
      kvm: x86: don't kill guest on unknown exit reason
         [2bc19dc3754fc066c43799659f0d848631c44cfe]

Mike Snitzer (1):
      block: fix alignment_offset math that assumes io_min is a power-of-2
         [b8839b8c55f3fdd60dc36abcda7e0266aff7985c]

Miklos Szeredi (1):
      audit: keep inode pinned
         [799b601451b21ebe7af0e6e8f6e2ccd4683c5064]

Mikulas Patocka (4):
      dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks
         [9d28eb12447ee08bb5d1e8bb3195cf20e1ecd1c0]
      framebuffer: fix border color
         [f74a289b9480648a654e5afd8458c2263c03a1e1]
      framebuffer: fix screen corruption when copying
         [5b789da8a7fc357661fc61faaf853e9161cc9700]
      fs: make cont_expand_zero interruptible
         [c2ca0fcd202863b14bd041a7fece2e789926c225]

Nathaniel Ting (1):
      USB: serial: cp210x: add Silicon Labs 358x VID and PID
         [35cc83eab097e5720a9cc0ec12bdc3a726f58381]

Oliver Neukum (1):
      xhci: no switching back on non-ULT Haswell
         [b45abacde3d551c6696c6738bef4a1805d0bf27a]

Ondrej Kozina (1):
      crypto: algif - avoid excessive use of socket buffer in skcipher
         [e2cffb5f493a8b431dc87124388ea59b79f0bccb]

Ondrej Zary (1):
      libata-sff: Fix controllers with no ctl port
         [6d8ca28fa688a9354bc9fbc935bdaeb3651b6677]

Pali Rohár (2):
      Input: alps - allow up to 2 invalid packets without resetting device
         [9d720b34c0a432639252f63012e18b0507f5b432]
      Input: alps - ignore potential bare packets when device is out of sync
         [4ab8f7f320f91f279c3f06a9795cfea5c972888a]

Paul Fertser (1):
      [media] media: usb: uvc: add a quirk for Dell XPS M1330 webcam
         [62ea864f84fed6e04dd033d500d4c9183a83d590]

Pawel Moll (1):
      perf: Handle compat ioctl
         [b3f207855f57b9c8f43a547a801340bb5cbc59e5]

Perry Hung (1):
      usb: serial: ftdi_sio: add "bricked" FTDI device PID
         [7f2719f0003da1ad13124ef00f48d7514c79e30d]

Peter Hurley (2):
      serial: Fix divide-by-zero fault in uart_get_divisor()
         [547039ec502076e60034eeb79611df3433a99b7d]
      tty: Fix high cpu load if tty is unreleaseable
         [37b164578826406a173ca7c20d9ba7430134d23e]

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick
         [ffcfe30ebd8dd703d0fc4324ffe56ea21f5479f4]

Quentin Casasnovas (1):
      kvm: fix excessive pages un-pinning in kvm_iommu_map error path.
         [3d32e4dbe71374a6780eaf51d719d76f9a9bf22f]

Quinn Tran (1):
      target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SENSE
         [082f58ac4a48d3f5cb4597232cb2ac6823a96f43]

Rabin Vincent (1):
      tracing/syscalls: Ignore numbers outside NR_syscalls' range
         [086ba77a6db00ed858ff07451bedee197df868c9]

Ray Jui (1):
      spi: pl022: Fix incorrect dma_unmap_sg
         [3ffa6158f002e096d28ede71be4e0ee8ab20baa2]

Ricardo Ribalda Delgado (1):
      PCI: Generate uppercase hex for modalias interface class
         [89ec3dcf17fd3fa009ecf8faaba36828dd6bc416]

Sasha Levin (1):
      kernel: add support for gcc 5
         [71458cfc782eafe4b27656e078d379a34e472adf]

Scott Carter (1):
      pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Controller
         [37017ac6849e772e67dd187ba2fbd056c4afa533]

Shai Fultheim (1):
      x86: Conditionally update time when ack-ing pending irqs
         [42fa4250436304d4650fa271f37671f6cee24e08]

Sinclair Yeh (1):
      drm/vmwgfx: Filter out modes those cannot be supported by the current VRAM size.
         [9a72384d86b26cb8a2b25106677e1197f606668f]

Stanislaw Gruszka (2):
      rt2800: correct BBP1_TX_POWER_CTRL mask
         [01f7feeaf4528bec83798316b3c811701bac5d3e]
      rt2x00: do not align payload on modern H/W
         [cfd9167af14eb4ec21517a32911d460083ee3d59]

Stefan Richter (1):
      firewire: cdev: prevent kernel stack leaking into ioctl arguments
         [eaca2d8e75e90a70a63a6695c9f61932609db212]

Stephen Smalley (1):
      selinux: fix inode security list corruption
         [923190d32de4428afbea5e5773be86bea60a9925]

Takashi Iwai (4):
      ALSA: emu10k1: Fix deadlock in synth voice lookup
         [95926035b187cc9fee6fb61385b7da9c28123f74]
      ALSA: hda - Limit 40bit DMA for AMD HDMI controllers
         [413cbf469a19e7662ba5025695bf5a573927105a]
      ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode
         [317168d0c766defd14b3d0e9c2c4a9a258b803ee]
      ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect
         [0725dda207e95ff25f1aa01432250323e0ec49d6]

Tejun Heo (1):
      ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks
         [66a7cbc303f4d28f201529b06061944d51ab530c]

Tetsuo Handa (1):
      fs: Fix theoretical division by 0 in super_cache_scan().
         [475d0db742e3755c6b267f48577ff7cbb7dfda0d]

Theodore Ts'o (2):
      ext4: add ext4_iget_normal() which is to be used for dir tree lookups
         [f4bb2981024fc91b23b4d09a8817c415396dbabb]
      ext4: don't orphan or truncate the boot loader inode
         [e2bfb088fac03c0f621886a04cffc7faa2b49b1d]

Thomas Körper (1):
      can: dev: avoid calling kfree_skb() from interrupt context
         [5247a589c24022ab34e780039cc8000c48f2035e]

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.
         [0a8727e69778683495058852f783eeda141a754e]

Tomas Henzl (1):
      [SCSI] hpsa: fix a race in cmd_free/scsi_done
         [2cc5bfaf854463d9d1aa52091f60110fbf102a96]

Tomas Winkler (2):
      mei: add mei_quirk_probe function
         [9a123f19832702753805afe0e93db26799b91b07]
      mei: limit the number of consecutive resets
         [6adb8efb024a7e413b93b22848fc13395b1a438a]

Trond Myklebust (3):
      NFSv4: fix open/lock state recovery error handling
         [df817ba35736db2d62b07de6f050a4db53492ad8]
      SUNRPC: Fix locking around callback channel reply receive
         [093a1468b6edb0e568be7311b8d2228d205702db]
      nfsd: Fix slot wake up race in the nfsv4.1 callback code
         [c6c15e1ed303ffc47e696ea1c9a9df1761c1f603]

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products
         [204ec6e07ea7aff863df0f7c53301f9cbbfbb9d3]

Ulrich Eckhardt (1):
      [media] ds3000: fix LNB supply voltage on Tevii S480 on initialization
         [8c5bcded11cb607b1bb5920de3b9c882136d27db]

Wang Nan (1):
      cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.
         [401507d67d5c2854f5a88b3f93f64fc6f267bca5]

Will Deacon (2):
      tracing/syscalls: Fix perf syscall tracing when syscall_nr == -1
         [60916a9382e88fbf5e54fd36a3e658efd7ab7bed]
      zap_pte_range: update addr when forcing flush after TLB batching faiure
         [ce9ec37bddb633404a0c23e1acb181a264e7f7f2]

Willy Tarreau (3):
      Documentation: lzo: document part of the encoding
         [d98a0526434d27e261f622cf9d2e0028b5ff1a00]
      Revert "lzo: properly check for overruns"
         [af958a38a60c7ca3d8a39c918c1baa2ff7b6b233]
      lzo: check for length overrun in variable length encoding.
         [72cf90124e87d975d0b2114d930808c58b4c05e4]

Yann Droneaud (1):
      fanotify: enable close-on-exec on events' fd when requested in fanotify_init()
         [0b37e097a648aa71d4db1ad108001e95b69a2da4]

Yinghai Lu (1):
      x86, 64bit, mm: Mark data/bss/brk to nx
         [72212675d1c96f5db8ec6fb35701879911193158]

 Makefile                                        |   4 +-
 arch/arm/mm/proc-xscale.S                       |   4 +-
 arch/m68k/mm/hwtest.c                           |   6 +
 arch/mips/include/asm/ftrace.h                  |   4 +-
 arch/mips/loongson/common/Makefile              |   3 +-
 arch/mips/oprofile/backtrace.c                  |   2 +-
 arch/s390/kvm/interrupt.c                       |   1 +
 arch/x86/include/asm/kvm_host.h                 |   1 +
 arch/x86/include/asm/page_32_types.h            |   1 -
 arch/x86/include/asm/page_64_types.h            |  11 +-
 arch/x86/kernel/apic/apic.c                     |  14 +-
 arch/x86/kernel/cpu/common.c                    |   2 +
 arch/x86/kernel/cpu/intel.c                     |  15 +++
 arch/x86/kernel/dumpstack_64.c                  |   1 -
 arch/x86/kernel/entry_64.S                      |  84 +++---------
 arch/x86/kernel/traps.c                         |  69 ++++++++--
 arch/x86/kernel/tsc.c                           |   5 +-
 arch/x86/kvm/mmu.c                              |   2 +-
 arch/x86/kvm/svm.c                              |   6 +-
 arch/x86/kvm/vmx.c                              |   6 +-
 arch/x86/kvm/x86.h                              |  20 ++-
 arch/x86/mm/init_64.c                           |  16 ++-
 arch/xtensa/include/asm/unistd.h                |   3 +-
 block/blk-settings.c                            |   4 +-
 block/scsi_ioctl.c                              |   3 +-
 crypto/algif_skcipher.c                         |   2 +-
 drivers/ata/ahci.c                              |  19 ++-
 drivers/ata/libata-sff.c                        |  20 ++-
 drivers/ata/pata_serverworks.c                  |  13 +-
 drivers/base/firmware_class.c                   |   3 +
 drivers/bluetooth/btusb.c                       |   9 ++
 drivers/char/random.c                           |  10 +-
 drivers/firewire/core-cdev.c                    |   3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c             |  16 ++-
 drivers/hv/channel.c                            |  45 +++++--
 drivers/hv/connection.c                         |  17 ++-
 drivers/hv/hv.c                                 |  28 ++--
 drivers/hv/hyperv_vmbus.h                       |   4 +
 drivers/input/joystick/xpad.c                   |  16 ++-
 drivers/input/mouse/alps.c                      |  11 +-
 drivers/input/mouse/synaptics.c                 |  22 ++-
 drivers/input/mouse/synaptics.h                 |   8 +-
 drivers/input/serio/i8042-x86ia64io.h           |  22 +++
 drivers/md/dm-bufio.c                           |  11 +-
 drivers/md/dm-log-userspace-transfer.c          |   2 +-
 drivers/md/dm-raid.c                            |  11 +-
 drivers/media/dvb/frontends/ds3000.c            |   7 +
 drivers/media/video/uvc/uvc_driver.c            |   9 ++
 drivers/media/video/v4l2-common.c               |   9 +-
 drivers/net/can/dev.c                           |   2 +-
 drivers/net/can/usb/esd_usb2.c                  |   1 +
 drivers/net/ppp/ppp_generic.c                   |   2 +-
 drivers/net/wireless/rt2x00/rt2800.h            |   2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c         |   1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c       |  50 ++-----
 drivers/of/address.c                            |  20 ++-
 drivers/pci/hotplug/pciehp_core.c               |   7 +
 drivers/pci/pci-sysfs.c                         |   2 +-
 drivers/pci/quirks.c                            |  20 +++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c               |   7 +
 drivers/scsi/hpsa.c                             |   4 +-
 drivers/scsi/scsi_error.c                       |   4 +-
 drivers/spi/spi-dw-mid.c                        |  10 +-
 drivers/spi/spi-dw.c                            |   6 +-
 drivers/spi/spi-pl022.c                         |   2 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c |   4 +-
 drivers/staging/iio/meter/ade7758_core.c        |  30 ++---
 drivers/staging/iio/sysfs.h                     |   2 +-
 drivers/staging/mei/init.c                      |   9 ++
 drivers/staging/mei/interrupt.c                 |   4 +-
 drivers/staging/mei/main.c                      |  27 ++++
 drivers/staging/mei/mei_dev.h                   |  12 +-
 drivers/target/target_core_transport.c          |   3 +-
 drivers/tty/serial/serial_core.c                |   2 +-
 drivers/tty/tty_io.c                            |   7 +-
 drivers/tty/vt/consolemap.c                     |   2 +
 drivers/usb/class/cdc-acm.c                     |   6 +-
 drivers/usb/core/hcd.c                          |   2 +
 drivers/usb/core/hub.c                          |   6 +-
 drivers/usb/core/quirks.c                       |  10 ++
 drivers/usb/gadget/udc-core.c                   |   5 +
 drivers/usb/host/xhci-hub.c                     |   5 +-
 drivers/usb/host/xhci-pci.c                     |  16 +--
 drivers/usb/host/xhci-ring.c                    |  43 ++----
 drivers/usb/host/xhci.c                         |  99 ++++++++------
 drivers/usb/host/xhci.h                         |   2 +-
 drivers/usb/serial/cp210x.c                     |   4 +
 drivers/usb/serial/ftdi_sio.c                   |  36 +++++
 drivers/usb/serial/ftdi_sio_ids.h               |  51 ++++++-
 drivers/usb/serial/keyspan.c                    |  96 ++++++++------
 drivers/usb/serial/kobil_sct.c                  |   5 +-
 drivers/usb/serial/opticon.c                    |   2 +-
 drivers/usb/serial/option.c                     |  10 ++
 drivers/usb/serial/ssu100.c                     |  11 +-
 drivers/usb/storage/transport.c                 |  26 ++++
 drivers/video/cfbcopyarea.c                     |  13 +-
 drivers/video/console/bitblit.c                 |   3 +-
 drivers/video/console/fbcon_ccw.c               |   3 +-
 drivers/video/console/fbcon_cw.c                |   3 +-
 drivers/video/console/fbcon_ud.c                |   3 +-
 fs/buffer.c                                     |   8 ++
 fs/ecryptfs/inode.c                             |   2 +-
 fs/ext3/super.c                                 |   7 -
 fs/ext4/ext4.h                                  |   1 +
 fs/ext4/ialloc.c                                |   4 +
 fs/ext4/inode.c                                 |  31 ++++-
 fs/ext4/namei.c                                 |  33 +++--
 fs/ext4/resize.c                                |   2 +-
 fs/ext4/super.c                                 |   9 +-
 fs/ext4/xattr.c                                 |  32 +++--
 fs/ioprio.c                                     |  14 +-
 fs/lockd/mon.c                                  |   6 +
 fs/nfs/nfs4proc.c                               |   2 +-
 fs/nfs/nfs4renewd.c                             |  12 +-
 fs/nfs/nfs4state.c                              |  16 +--
 fs/nfsd/nfs4callback.c                          |   8 +-
 fs/nfsd/nfs4proc.c                              |   3 +-
 fs/notify/fanotify/fanotify_user.c              |   2 +-
 fs/super.c                                      |   2 +
 fs/ubifs/commit.c                               |  10 +-
 fs/ubifs/log.c                                  |  19 ++-
 fs/ubifs/master.c                               |   7 +-
 fs/ubifs/super.c                                |   1 -
 fs/ubifs/ubifs.h                                |   2 -
 include/drm/drm_pciids.h                        |   1 -
 include/linux/blkdev.h                          |   5 +-
 include/linux/compiler-gcc.h                    |   3 +
 include/linux/compiler-intel.h                  |   7 +
 include/linux/compiler.h                        |   4 +
 include/linux/khugepaged.h                      |  17 ++-
 include/linux/mm.h                              |   1 +
 include/linux/string.h                          |   2 +
 include/linux/usb/quirks.h                      |   3 +
 include/net/tcp.h                               |  23 +++-
 kernel/audit_tree.c                             |   1 +
 kernel/events/core.c                            |  22 ++-
 kernel/futex.c                                  |  22 +--
 kernel/posix-timers.c                           |   1 +
 kernel/power/hibernate.c                        |   8 +-
 kernel/trace/trace_syscalls.c                   |   8 +-
 lib/bitmap.c                                    |   8 +-
 lib/lzo/lzo1x_decompress_safe.c                 | 103 ++++++++-------
 lib/string.c                                    |  16 +++
 mm/huge_memory.c                                |  11 +-
 mm/memory.c                                     |   4 +-
 mm/mmap.c                                       |   8 +-
 mm/page_cgroup.c                                |   1 +
 mm/truncate.c                                   |  56 +++++++-
 net/ceph/crypto.c                               | 169 ++++++++++++++++++------
 net/ceph/messenger.c                            |   7 +-
 net/ipv4/ip_output.c                            |   2 +-
 net/ipv4/tcp_ipv4.c                             |   2 +-
 net/ipv6/tcp_ipv6.c                             |   2 +-
 net/mac80211/iface.c                            |   7 +-
 net/mac80211/rx.c                               |  14 +-
 net/sunrpc/svcsock.c                            |  27 ++--
 security/integrity/evm/evm_main.c               |   9 +-
 security/selinux/hooks.c                        |   2 +-
 sound/core/pcm_compat.c                         |   2 +
 sound/pci/emu10k1/emu10k1_callback.c            |   6 +-
 sound/pci/hda/hda_intel.c                       |  14 +-
 sound/soc/codecs/sgtl5000.c                     |   3 +-
 sound/soc/codecs/sgtl5000.h                     |   2 +-
 sound/soc/sh/fsi.c                              |   3 +-
 sound/usb/card.c                                |   9 +-
 virt/kvm/iommu.c                                |   8 +-
 virt/kvm/kvm_main.c                             |   4 +
 167 files changed, 1460 insertions(+), 706 deletions(-)

-- 
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

