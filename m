Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3IKEay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3623 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3IKE2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:28:54 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=eIhxMilvRf8A:10 a=RacfjoK3x0sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GnT3LFsvGa8A:10 a=XJ73DR3wAAAA:8 a=XZjldTaw5V2CQrvmW5oA:9 a=g3Y4LtA3PwEA:10 a=IJGIoY9qDTD-TzSU:21 a=7aiewhIpmXHGJKpK:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042707.738353451@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [000/251] 3.6.11.9-rc1-stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Yes, I know I said I would stop support of 3.6-stable, but
  I had a need for another release. I may make one or two more
  but don't count on it. ]

This is the start of the stable review cycle for 3.6.11.9-rc1 release.
There are 251 patches in this series, which will be posted as responses
to this one. If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Sep 14 00:25:47 2013.
Anything received after that time might be too late.

Aaro Koskinen (1):
      powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)
         [fe956a1d4081ce1a959f87df397a15e252201f10]

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID to snd-hda
         [d52392b1a80458c0510810789c7db4a39b88022a]

Al Viro (2):
      reiserfs: fix deadlock in umount
         [672fe15d091ce76d6fb98e489962e9add7c1ba4c]
      livelock avoidance in sget()
         [acfec9a5a892f98461f52ed5770de99a3e571ae2]

Alex Deucher (3):
      drm/radeon/atom: initialize more atom interpretor elements to 0
         [42a21826dc54583cdb79cc8477732e911ac9c376]
      drm/radeon: improve dac adjust heuristics for legacy pdac
         [03ed8cf9b28d886c64c7e705c7bb1a365fd8fb95]
      drm/radeon: fix endian issues with DP handling (v3)
         [34be8c9af7b8728465963740fc11136ae90dfc36]

Alex Williamson (1):
      iommu/amd: Only unmap large pages from the first pte
         [60d0ca3cfd199b6612bbbbf4999a3470dad38bb1]

Alexandr \\\"Sky\\\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1
         [ca24763588844b14f019ffc45c7df6d9e8f932c5]

Amit Shah (5):
      virtio: console: return -ENODEV on all read operations after unplug
         [96f97a83910cdb9d89d127c5ee523f8fc040a804]
      virtio: console: fix raising SIGIO after port unplug
         [92d3453815fbe74d539c86b60dab39ecdf01bb99]
      virtio: console: clean up port data immediately at time of unplug
         [ea3768b4386a8d1790f4cc9a35de4f55b92d6442]
      virtio: console: fix race in port_fops_open() and port unplug
         [671bdea2b9f210566610603ecbb6584c8a201c8c]
      virtio: console: fix race with port unplug and open/close
         [057b82be3ca3d066478e43b162fc082930a746c9]

Andrew Vagin (1):
      tracing: Fix fields of struct trace_iterator that are zeroed by mistake
         [ed5467da0e369e65b247b99eb6403cb79172bcda]

Anthony Foiani (1):
      sata_fsl: save irqs while coalescing
         [99bbdfa6bdcb4bdf5be914a48e9b46941bf30819]

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues
         [0e0ed6406e61434d3f38fb58aa8464ec4722b77e]

Arnd Bergmann (2):
      mtd: omap2: allow bulding as a module
         [930d800bded771b26d9944c47810829130ff7c8c]
      nsp32: use mdelay instead of large udelay constants
         [b497ceb964a80ebada3b9b3cea4261409039e25a]

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device
         [b579fa52f6be0b4157ca9cc5e94d44a2c89a7e95]

Baruch Siach (1):
      clocksource: dw_apb: Fix error check
         [1a33bd2be705cbb3f57d7223b60baea441039307]

Benjamin Herrenschmidt (1):
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor
         [f5f6cbb61610b7bf9d9d96db9c3979d62a424bab]

Bjørn Mork (1):
      megaraid_sas: fix memory leak if SGL has zero length entries
         [7a6a731bd00ca90d0e250867c3b9c05b5ff0fa49]

Brian Austin (1):
      ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume
         [e2c98a8bba958045bde861fe1d66be54315c7790]

Bu, Yitian (1):
      printk: Fix rq->lock vs logbuf_lock unlock lock inversion
         [dbda92d16f8655044e082930e4e9d244b87fde77]

Catalin Marinas (1):
      ARM: 7790/1: Fix deferred mm switch on VIVT processors
         [bdae73cd374e28db544fdd9b77de689a36e3c129]

Chen Gang (2):
      cifs: extend the buffer length enought for sprintf() using
         [057d6332b24a4497c55a761c83c823eed9e3f23b]
      powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries
         [8246aca7058f3f2c2ae503081777965cd8df7b90]

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.
         [cb6f66a2d278e57a6c9d8fb59bd9ebd8ab3965c2]

Cho, Yu-Chen (1):
      Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]
         [178c059e7640aa8e50213400c6f3dde00189d979]

Chris Wilson (1):
      drm/i915: Invalidate TLBs for the rings after a reset
         [884020bf3d2a3787a1cc6df902e98e0eec60330b]

Chuck Anderson (1):
      xen/smp: initialize IPI vectors before marking CPU online
         [fc78d343fa74514f6fd117b5ef4cd27e4ac30236]

Clemens Ladisch (1):
      ALSA: usb-audio: do not trust too-big wMaxPacketSize values
         [57e6dae1087bbaa6b33d3dd8a8e90b63888939a3]

Cong Wang (1):
      vti: remove duplicated code to fix a memory leak
         [ab6c7a0a43c2eaafa57583822b619b22637b49c7]

Curt Brune (1):
      hwmon: (adt7470) Fix incorrect return code check
         [93d783bcca69bfacc8dc739d8a050498402587b5]

Dan Carpenter (6):
      Hostap: copying wrong data prism2_ioctl_giwaplist()
         [909bd5926d474e275599094acad986af79671ac9]
      net_sched: info leak in atm_tc_dump_class()
         [8cb3b9c3642c0263d48f31d525bcee7170eedc20]
      af_key: more info leaks in pfkey messages
         [ff862a4668dd6dba962b1d2d8bd344afa6375683]
      arcnet: cleanup sizeof parameter
         [087d273caf4f7d3f2159256f255f1f432bc84a5b]
      fanotify: info leak in copy_event_to_user()
         [de1e0c40aceb9d5bff09c3a3b97b2f1b178af53f]
      svcrdma: underflow issue in decode_write_list()
         [b2781e1021525649c0b33fffd005ef219da33926]

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200
         [4cf76df06ecc852633ed927d91e01c83c33bc331]

Daniel Drake (1):
      drivers/platform/olpc/olpc-ec.c: initialise earlier
         [93dbc1b3b506e16c1f6d5b5dcfe756a85cb1dc58]

Daniel Hansel (1):
      zfcp: fix adapter (re)open recovery while link to SAN is down
         [f76ccaac4f82c463a037aa4a1e4ccb85c7011814]

Dave Airlie (1):
      drm/ast: invalidate page tables when pinning a BO
         [3ac65259328324de323dc006b52ff7c1a5b18d19]

Dave Jones (1):
      x25: Fix broken locking in ioctl error paths.
         [4ccb93ce7439b63c31bc7597bfffd13567fa483d]

Dave Kleikamp (2):
      jfs: fix readdir cookie incompatibility with NFSv4
         [44512449c0ab368889dd13ae0031fba74ee7e1d2]
      sunvnet: vnet_port_remove must call unregister_netdev
         [aabb9875d02559ab9b928cd6f259a5cc4c21a589]

David Jeffery (1):
      lockd: protect nlm_blocked access in nlmsvc_retry_blocked
         [1c327d962fc420aea046c16215a552710bde8231]

David S. Miller (1):
      net_sched: Fix stack info leak in cbq_dump_wrr().
         [a0db856a95a29efb1c23db55c02d9f0ff4f0db48]

David Vrabel (3):
      x86/xen: do not identity map UNUSABLE regions in the machine E820
         [3bc38cbceb85881a8eb789ee1aa56678038b1909]
      xen/events: initialize local per-cpu mask for all possible events
         [84ca7a8e45dafb49cd5ca90a343ba033e2885c17]
      xen/evtchn: avoid a deadlock when unbinding an event channel
         [179fbd5a45f0d4034cc6fd37b8d367a3b79663c4]

Egbert Eich (1):
      drm/mgag200: Invalidate page tables when pinning a BO
         [ecaac1c866bcda4780a963b3d18cd310d971aea3]

Eldad Zack (1):
      ALSA: usb-audio: 6fire: return correct XRUN indication
         [be2f93a4c4981b3646b6f98f477154411b8516cb]

Emmanuel Grumbach (2):
      iwlwifi: pcie: disable L1 Active after pci_enable_device
         [eabc4ac5d7606a57ee2b7308cb7323ea8f60183b]
      iwlwifi: add DELL SKU for 5150 HMC
         [a1923f1d4723e5757cefdd60f7c7ab30e472007a]

Enrico Mioso (2):
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver
         [878c69aae986ae97084458c0183a8c0a059865b1]
      usb: serial: option: blacklist ONDA MT689DC QMI interface
         [3d1a69e726406ab662ab88fa30a3a05ed404334d]

Eric Dumazet (4):
      atl1c: Fix misuse of netdev_alloc_skb in refilling rx ring
         [7b70176421993866e616f1cbc4d0dd4054f1bf78]
      vlan: fix a race in egress prio management
         [3e3aac497513c669e1c62c71e1d552ea85c1d974]
      vlan: mask vlan prio bits
         [d4b812dea4a236f729526facf97df1a9d18e191c]
      neighbour: fix a race in neigh_destroy()
         [c9ab4d85de222f3390c67aedc9c18a50e767531e]

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.
         [d220980b701d838560a70de691b53be007e99e78]

Ewan D. Milne (1):
      sd: fix crash when UA received on DIF enabled device
         [085b513f97d8d799d28491239be4b451bcd8c2c5]

Fabio Estevam (1):
      ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK
         [5c78dfe87ea04b501ee000a7f03b9432ac9d008c]

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail
         [cdcedd6981194e511cc206887db661d016069d68]

Gabor Juhos (1):
      rt2x00: read 5GHz TX power values from the correct offset
         [0a6f3a8ebaf13407523c2c7d575b4ca2debd23ba]

Geert Uytterhoeven (1):
      m68k/atari: ARAnyM - Fix NatFeat module support
         [e8184e10f89736a23ea6eea8e24cd524c5c513d2]

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0
         [07f3cb7c28bf3f4dd80bfb136cf45810c46ac474]

Gregory CLEMENT (1):
      ARM: 7722/1: zImage: Convert 32bits memory size and address from ATAG to 64bits DTB
         [faefd550c45d8d314e8f260f21565320355c947f]

H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz
         [eaa5a990191d204ba0f9d35dbe5505ec2cdd1460]

Hannes Frederic Sowa (4):
      ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup
         [905a6f96a1b18e490a75f810d733ced93c39b0e5]
      ipv6: in case of link failure remove route directly instead of letting it expire
         [1eb4f758286884e7566627164bca4c4a16952a83]
      ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size
         [75a493e60ac4bbe2e977e7129d6d8cbb0dd236be]
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_INET pending data
         [8822b64a0fa64a5dd1dfcf837c5b0be83f8c05d1]

Hannes Reinecke (1):
      dm mpath: fix ioctl deadlock when no paths
         [6c182cd88d179cbbd06f4f8a8a19b6977940753f]

Harshula Jayasuriya (1):
      nfsd: nfsd_open: when dentry_open returns an error do not propagate as struct file
         [e4daf1ffbe6cc3b12aab4d604e627829e93e9914]

Hauke Mehrtens (1):
      b43: ensue that BCMA is "y" when B43 is "y"
         [693026ef2e751fd94d2e6c71028e68343cc875d5]

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211
         [d2e9fc141e2aa21f4b35ee27072d84e9aa6e2ba0]

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type
         [1974d494dea05ea227cb42f5e918828801e237aa]

Ian Abbott (1):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
         [69acbaac303e8cb948801a9ddd0ac24e86cc4a1b]

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val
         [77fa4cbd5fa389e28419bbe8ac491b5fdd54840d]

J. Bruce Fields (1):
      svcrpc: fix handling of too-short rpc's
         [cf3aa02cb4a0c5af5557dd47f15a08a7df33182a]

Jacob Keller (1):
      ixgbe: Fix Tx Hang issue with lldpad on 82598EB
         [1eb9ac14c34a948bf1538bfb9034e8ab29099a64]

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large
         [6e4dcff3adbf25acb87e74500a58e3c07bdec40f]

Jan Beulich (1):
      xen-netfront: pull on receive skb may need to happen earlier
         [093b9c71b6e450e375f4646ba86faed0195ec7df]

Jan Kara (2):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()
         [91aa11fae1cf8c2fd67be0609692ea9741cdcc43]
      writeback: Fix periodic writeback after fs mount
         [a5faeaf9109578e65e1a32e2a3e76c8b47e7dcb6]

Jason Wang (4):
      macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
         [ece793fcfc417b3925844be88a6a6dc82ae8f7c6]
      tuntap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
         [885291761dba2bfe04df4c0f7bb75e4c920ab82e]
      macvtap: correctly linearize skb when zerocopy is used
         [61d46bf979d5cd7c164709a80ad5676a35494aae]
      tuntap: correctly linearize skb when zerocopy is used
         [3dd5c3308e8b671e8e8882ba972f51cefbe9fd0d]

Jeff Skirvin (1):
      isci: Fix a race condition in the SSP task management path
         [96f15f29038e58e1b0a96483e2b369ff446becf1]

Jeff Wu (1):
      ACPI: add _STA evaluation at do_acpi_find_child()
         [c7d9ca90aa9497f0b6e301ec67c52dd4b57a7852]

Jiang Liu (6):
      zram: protect sysfs handler from invalid memory access
         [5863e10b441e7ea4b492f930f1be180a97d026f3]
      zram: avoid access beyond the zram device
         [12a7ad3b810e77137d0caf97a6dd97591e075b30]
      zram: avoid double free in function zram_bvec_write()
         [65c484609a3b25c35e4edcd5f2c38f98f5226093]
      zram: destroy all devices on error recovery path in zram_init()
         [39a9b8ac9333e4268ecff7da6c9d1ab3823ff243]
      zram: use zram->lock to protect zram_free_page() in swap free notify path
         [57ab048532c0d975538cebd4456491b5c34248f4]
      zram: avoid invalid memory access in zram_exit()
         [6030ea9b35971a4200062f010341ab832e878ac9]

Jianpeng Ma (1):
      elevator: Fix a race in elevator switching
         [d50235b7bc3ee0a0427984d763ea7534149531b4]

Jiri Olsa (2):
      perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid scenario
         [06f417968beac6e6b614e17b37d347aa6a6b1d30]
      perf: Clone child context from parent context pmu
         [734df5ab549ca44f40de0f07af1c8803856dfb18]

Joe Perches (1):
      ndisc: Add missing inline to ndisc_addr_option_pad
         [d9d10a30964504af834d8d250a0c76d4ae91eb1e]

Johan Hovold (10):
      USB: keyspan: fix null-deref at disconnect and release
         [ff8a43c10f1440f07a5faca0c1556921259f7f76]
      USB: mos7720: fix broken control requests
         [ef6c8c1d733e244f0499035be0dabe1f4ed98c6f]
      USB: mos7840: fix big-endian probe
         [d551ec9b690f3de65b0091a2e767f1382adc792d]
      USB: ti_usb_3410_5052: fix big-endian firmware handling
         [e877dd2f2581628b7119df707d4cf03d940cff49]
      USB: mos7840: fix pointer casts
         [683a0e4d7971c3186dc4d429027debfe309129aa]
      USB: mos7840: fix race in led handling
         [05cf0dec5ccc696a7636c84b265b477173498156]
      USB: mos7840: fix device-type detection
         [40c24f2893ba0ba7df485871f6aac0c197ceef5b]
      USB: mos7840: fix race in register handling
         [d8a083cc746664916d9d36ed9e4d08a29525f245]
      USB: ti_usb_3410_5052: fix dynamic-id matching
         [1fad56424f5ad3ce4973505a357212b2e2282b3f]
      USB: mos7840: fix memory leak in open
         [5f8a2e68b679b41cc8e9b642f2f5aa45dd678641]

Johannes Berg (4):
      cfg80211: fix P2P GO interface teardown
         [74418edec915d0f446debebde08d170c7b8ba0ee]
      genetlink: fix family dump race
         [58ad436fcf49810aa006016107f494c9ac9013db]
      mac80211: fix ethtool stats for non-station interfaces
         [e13bae4f807401729b3f27c7e882a96b8b292809]
      mac80211: fix duplicate retransmission detection
         [6b0f32745dcfba01d7be33acd1b40306c7a914c6]

Josef Bacik (2):
      Btrfs: re-add root to dead root list if we stop dropping it
         [d29a9f629e009c9b90e5859bce581070fd6247fc]
      Btrfs: fix lock leak when resuming snapshot deletion
         [fec386ac1428f9c0e672df952cbca5cebd4e4e2f]

Jussi Kivilinna (2):
      zd1201: do not use stack as URB transfer_buffer
         [1206ff4ff9d2ef7468a355328bc58ac6ebf5be44]
      ALSA: 6fire: fix DMA issues with URB transfer_buffer usage
         [ddb6b5a964371e8e52e696b2b258bda144c8bd3f]

Jóhann B. Guðmundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga
         [58fc90db8261b571c026bb8bf23aad48a7233118]

Jörn Engel (1):
      iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow
         [0fbfc46fb0b2f543a8b539e94c6c293ebc0b05a6]

Karlis Ogsts (1):
      staging: android: logger: Correct write offset reset on error
         [72bb99cfe9c57d2044445fb34bbc95b4c0bae6f2]

Kevin Hilman (1):
      regmap: Add another missing header for !CONFIG_REGMAP stubs
         [3f0fa9a808f98fa10a18ba2a73f13d65fda990fb]

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check device permissions before allowing OP_DISCARD
         [604c499cbbcc3d5fe5fb8d53306aa0fae1990109]

Konstantin Khlebnikov (1):
      drm/i915: fix long-standing SNB regression in power consumption after resume v2
         [7dcd2677ea912573d9ed4bcd629b0023b2d11505]

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value
         [016d5baad04269e8559332df05f89bd95b52d6ad]

Li Zefan (1):
      cgroup: fix umount vs cgroup_cfts_commit() race
         [084457f284abf6789d90509ee11dae383842b23b]

Liu ShuoX (1):
      PM / Sleep: avoid 'autosleep' in shutdown progress
         [e5248a111bf4048a9f3fab1a9c94c4630a10592a]

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial adapter
         [90625070c4253377025878c4e82feed8b35c7116]

Mahesh Rajashekhara (1):
      aacraid: Fix for arrays are going offline in the system. System hangs
         [c5bebd829dd95602c15f8da8cc50fa938b5e0254]

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards
         [cef1d00cd56f600121ad121875655ad410a001b8]

Markos Chandras (2):
      MIPS: Expose missing pci_io{map,unmap} declarations
         [78857614104a26cdada4c53eea104752042bf5a1]
      lib/Kconfig.debug: Restrict FRAME_POINTER for MIPS
         [25c87eae1725ed77a8b44d782a86abdc279b4ede]

Martin K. Petersen (1):
      Don't attempt to send extended INQUIRY command if skip_vpd_pages is set
         [7562523e84ddc742fe1f9db8bd76b01acca89f6b]

Martin Peschke (2):
      zfcp: fix schedule-inside-lock in scsi_device list loops
         [924dd584b198a58aa7cb3efefd8a03326550ce8f]
      zfcp: fix lock imbalance by reworking request queue locking
         [d79ff142624e1be080ad8d09101f7004d79c36e1]

Mateusz Krawczuk (1):
      regmap: Add missing header for !CONFIG_REGMAP stubs
         [49ccc142f9cbc33fdda18e8fa90c1c5b4a79c0ad]

Matt Burtch (1):
      USB-Serial: Fix error handling of usb_wwan
         [6c1ee66a0b2bdbd64c078fba684d640cf2fd38a9]

Michael S. Tsirkin (3):
      skb: report completion status for zero copy skbs
         [e19d6763cc300fcb706bd291b24ac06be71e1ce6]
      virtio_net: fix race in RX VQ processing
         [cbdadbbf0c790f79350a8f36029208944c5487d0]
      virtio: support unlocked queue poll
         [cc229884d3f77ec3b1240e467e0236c3e0647c0c]

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns
         [a0ec570f4f69c4cb700d743a915096c2c8f56a99]

Michal Srb (1):
      drm/cirrus: Invalidate page tables when pinning a BO
         [109a51598869a39fdcec2d49672a9a39b6d89481]

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary
         [651e92716aaae60fc41b9652f54cb6803896e0da]

Mikulas Patocka (1):
      dm verity: fix inability to use a few specific devices sizes
         [b1bf2de07271932326af847a3c6a01fdfd29d4be]

Neil Horman (3):
      8139cp: Add dma_mapping_error checking
         [cf3c4c03060b688cbc389ebc5065ebcce5653e96]
      x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset
         [803075dba31c17af110e1d9a915fe7262165b213]
      atl1e: fix dma mapping warnings
         [352900b583b2852152a1e05ea0e8b579292e731e]

NeilBrown (3):
      md/raid10: remove use-after-free bug.
         [0eb25bb027a100f5a9df8991f2f628e7d851bc1e]
      md/raid5: fix interaction of 'replace' and 'recovery'.
         [f94c0b6658c7edea8bc19d13be321e3860a3fa54]
      md/raid10: fix two bugs affecting RAID10 reshape.
         [78eaa0d4cbcdb345992fa3dd22b3bcbb473cc064]

Nicholas Bellinger (1):
      target: Fix trailing ASCII space usage in INQUIRY vendor+model
         [ee60bddba5a5f23e39598195d944aa0eb2d455e5]

Nicolas Ferre (1):
      ARM: at91/DT: fix at91sam9n12ek memory node
         [a57603ca2871ee0773b00839c1ea35c4a2d3eeb0]

Nicolas Pitre (1):
      ARM: 7816/1: CONFIG_KUSER_HELPERS: fix help text
         [ac124504ecf6b20a2457d873d0728a8b991a5b0c]

Nicolin Chen (1):
      ASoC: wm8962: Remove remaining direct register cache accesses
         [2e7ee15ced914e109a1a5b6dfcd463d846a13bd5]

Oleg Nesterov (2):
      debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)
         [776164c1faac4966ab14418bb0922e1820da1d19]
      userns: limit the maximum depth of user_namespace->parent chain
         [8742f229b635bf1c1c84a3dfe5e47c814c20b5c8]

Oleksij Rempel (2):
      ath9k_htc: do some initial hardware configuration
         [dc2a87f519a4d8cb376ab54f22b6b98a943b51ce]
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings
         [d66eaf9f89502971fddcb0de550b01fa6f409d83]

Oliver Neukum (1):
      usb: add two quirky touchscreen
         [304ab4ab079a8ed03ce39f1d274964a532db036b]

Paul Mackerras (1):
      powerpc: Work around gcc miscompilation of __pa() on 64-bit
         [bdbc29c19b2633b1d9c52638fb732bcde7a2031a]

Peter Zijlstra (1):
      perf: Fix perf_lock_task_context() vs RCU
         [058ebd0eba3aff16b144eabf4510ed9510e1416e]

Piotr Sarna (1):
      ext4: fix mount/remount error messages for incompatible mount options
         [6ae6514b33f941d3386da0dfbe2942766eab1577]

Radu Caragea (1):
      x86 get_unmapped_area(): use proper mmap base for bottom-up direction
         [df54d6fa54275ce59660453e29d1228c2b45a826]

Ralf Baechle (2):
      RAPIDIO: IDT_GEN2: Fix build error.
         [27f62b9f294b7e2019c94c385abda43a0af6bb8b]
      MIPS: Oceton: Fix build error.
         [39205750efa6d335fac4f9bcd32b49c7e71c12b7]

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs
         [e7a6121f4929c17215f0cdca3726f4bf3e4e9529]

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices
         [fed1f1ed90bce42ea010e2904cbc04e7b8304940]

Roger Quadros (1):
      USB: EHCI: Fix resume signalling on remote wakeup
         [47a64a13d54f6c669b00542848d5550be3d3310e]

Roland Dreier (1):
      sg: Fix user memory corruption when SG_IO is interrupted by a signal
         [35dc248383bbab0a7203fca4d722875bc81ef091]

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sections
         [21ea9f5ace3a7317cc3ba1fbc749758021a83136]

Russell King (7):
      ARM: make vectors page inaccessible from userspace
         [a5463cd3435475386cbbe7b06e01292ac169d36f]
      ARM: allow kuser helpers to be removed from the vector page
         [f6f91b0d9fd971c630cef908dde8fe8795aefbf8]
      ARM: update FIQ support for relocation of vectors
         [e39e3f3ebfef03450cf7bfa7a974a8c61f7980c8]
      ARM: use linker magic for vectors and vector stubs
         [b9b32bf70f2fb710b07c94e13afbc729afe221da]
      ARM: move vector stubs
         [19accfd373847ac3d10623c5d20f948846299741]
      ARM: poison memory between kuser helpers
         [5b43e7a383d69381ffe53423e46dd0fafae07da3]
      ARM: poison the vectors page
         [f928d4f2a86f46b030fa0850385b4391fc2b5918]

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support
         [7681156982026ebf7eafd7301eb0374d7648d068]

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.
         [203a86613fb3bf2767335659513fa98563a3eb71]

Sasha Levin (1):
      9p: fix off by one causing access violations and memory corruption
         [110ecd69a9feea82a152bbf9b12aba57e6396883]

Saurav Kashyap (1):
      qla2xxx: Properly set the tagging for commands.
         [c3ccb1d7cf4c4549151876dd37c0944a682fd9e1]

Sekhar Nori (1):
      ARM: davinci: nand: specify ecc strength
         [acd36357edc08649e85ff15dc4ed62353c912eff]

Sergey Senozhatsky (2):
      zram: allow request end to coincide with disksize
         [75c7caf5a052ffd8db3312fa7864ee2d142890c4]
      radeon kms: do not flush uninitialized hotplug work
         [a01c34f72e7cd2624570818f579b5ab464f93de2]

Seth Heasley (1):
      ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs
         [c7e8695bfa0611b39493a9dfe8bab9f63f9809bd]

Shane Huang (1):
      i2c-piix4: Add AMD CZ SMBus device ID
         [b996ac90f595dda271cbd858b136b45557fc1a57]

Sreekanth Reddy (1):
      mpt2sas: fix firmware failure with wrong task attribute
         [48ba2efc382f94fae16ca8ca011e5961a81ad1ea]

Stanislaw Gruszka (5):
      iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL
         [9186a1fd9ed190739423db84bc344d258ef3e3d7]
      iwl4965: reset firmware after rfkill off
         [788f7a56fce1bcb2067b62b851a086fca48a0056]
      iwl4965: set power mode early
         [eca396d7a5bdcc1fd67b1b12f737c213ac78a6f4]
      rt2x00: fix stop queue
         [e2288b66fe7ff0288382b2af671b4da558b44472]
      Bluetooth: ath3k: don't use stack memory for DMA
         [517828a87994f41af6ae5a0f96f0f069f05baa81]

Steffen Maier (2):
      zfcp: status read buffers on first adapter open with link down
         [9edf7d75ee5f21663a0183d21f702682d0ef132f]
      zfcp: block queue limits with data router
         [5fea4291deacd80188b996d2f555fc6a1940e5d4]

Stephane Grosjean (1):
      can: pcan_usb: fix wrong memcpy() bytes length
         [3c322a56b01695df15c70bfdc2d02e0ccd80654e]

Stephen Boyd (1):
      perf/arm: Fix armpmu_map_hw_event()
         [b88a2595b6d8aedbd275c07dfa784657b4f757eb]

Stephen Warren (1):
      ASoC: tegra: fix Tegra30 I2S capture parameter setup
         [c90c0d7a96e634a73ef1580f1d20993606545647]

Sujith Manoharan (3):
      ath9k: Enable PLL fix only for AR9340/AR9330
         [19c361608ce3e73f352e323262f7e0a8264be3af]
      ath9k: Do not assign noise for NULL caldata
         [d3bcb7b24bbf09fde8405770e676fe0c11c79662]
      ath9k_hw: Assign default xlna config for AR9485
         [30d5b709da23f4ab9836c7f66d2d2e780a69cf12]

Sumit.Saxena@lsi.com (1):
      megaraid_sas: megaraid_sas driver init fails in kdump kernel
         [6431f5d7c6025f8b007af06ea090de308f7e6881]

Takashi Iwai (13):
      ALSA: opti9xx: Fix conflicting driver object name
         [fb615499f0ad28ed74201c1cdfddf9e64e205424]
      ALSA: hda - Add inverted digital mic fixup for Acer Aspire One
         [d3d3835ce919438c00c5d1270d6f9d6ffea59d03]
      ALSA: hda - Add a fixup for Gateway LT27
         [1801928e0f99d94c55e33c584c5eb2ff5e246ee6]
      staging: line6: Fix unlocked snd_pcm_stop() call
         [86f0b5b86d142b9323432fef078a6cf0fb5dda74]
      ASoC: s6000: Fix unlocked snd_pcm_stop() call
         [61be2b9a18ec70f3cbe3deef7a5f77869c71b5ae]
      ALSA: usx2y: Fix unlocked snd_pcm_stop() call
         [5be1efb4c2ed79c3d7c0cbcbecae768377666e84]
      ALSA: asihpi: Fix unlocked snd_pcm_stop() call
         [60478295d6876619f8f47f6d1a5c25eaade69ee3]
      ALSA: atiixp: Fix unlocked snd_pcm_stop() call
         [cc7282b8d5abbd48c81d1465925d464d9e3eaa8f]
      ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
         [46f6c1aaf790be9ea3c8ddfc8f235a5f677d08e2]
      ALSA: ua101: Fix unlocked snd_pcm_stop() call
         [9538aa46c2427d6782aa10036c4da4c541605e0e]
      ALSA: 6fire: Fix unlocked snd_pcm_stop() call
         [5b9ab3f7324a1b94a5a5a76d44cf92dfeb3b5e80]
      ALSA: seq-oss: Initialize MIDI clients asynchronously
         [256ca9c3ad5013ff8a8f165e5a82fab437628c8e]
      ALSA: hda - Cache the MUX selection for generic HDMI
         [bddee96b5d0db869f47b195fe48c614ca824203c]

Tejun Heo (3):
      workqueue: cond_resched() after processing each work item
         [b22ce2785d97423846206cceec4efee0c4afd980]
      libata: make it clear that sata_inic162x is experimental
         [bb9696192826a7d9279caf872e95b41bc26c7eff]
      libata: skip SRST for all SIMG [34]7x port-multipliers
         [7a87718d92760fc688628ad6a430643dafa16f1f]

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP
         [8ffff94d20b7eb446e848e0046107d51b17a20a8]

Theodore Ts'o (2):
      ext4: allow the mount options nodelalloc and data=journal
         [59d9fa5c2e9086db11aa287bb4030151d0095a17]
      ext4: make sure group number is bumped after a inode allocation race
         [a34eb503742fd25155fd6cff6163daacead9fbc3]

Thomas Gleixner (2):
      hrtimers: Move SMP function call to thread context
         [5ec2481b7b47a4005bb446d176e5d0257400c77d]
      tick: Prevent uncontrolled switch to oneshot mode
         [1f73a9806bdd07a5106409bbcab3884078bd34fe]

Thomas Pugliese (1):
      wusbcore: fix kernel panic when disconnecting a wireless USB->serial device
         [ec58fad1feb76c323ef47efff1d1e8660ed4644c]

Tomasz Moń (1):
      mwifiex: Add missing endian conversion.
         [83e612f632c3897be29ef02e0472f6d63e258378]

Torsten Schenk (2):
      ALSA: 6fire: make buffers DMA-able (midi)
         [4c2aee0032b70083dafebd733ed9c774633b2fa3]
      ALSA: 6fire: make buffers DMA-able (pcm)
         [5ece263f1d93fba8d992e67e3ab8a71acf674db9]

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path
         [d19f503e22316a84c39bc19445e0e4fdd49b3532]

Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems
         [347e2233b7667e336d9f671f1a52dfa3f0416e2c]

Uwe Kleine-König (2):
      serial/mxs-auart: increase time to wait for transmitter to become idle
         [079a036f4283e2b0e5c26080b8c5112bc0cc1831]
      serial/mxs-auart: fix race condition in interrupt handler
         [d970d7fe65adff5efe75b4a73c4ffc9be57089f7]

Vince Weaver (1):
      perf/x86: Fix intel QPI uncore event definitions
         [c9601247f8f3fdc18aed7ed7e490e8dfcd07f122]

Vineet Gupta (1):
      mm: fix the TLB range flushed when __tlb_remove_page() runs out of slots
         [e6c495a96ce02574e765d5140039a64c8d4e8c9e]

Vinod Koul (1):
      ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION
         [a8d30608eaed6cc759b8e2e8a8bbbb42591f797f]

Vyacheslav Dubeyko (2):
      nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection
         [4bf93b50fd04118ac7f33a3c2b8a0a1f9fa80bc9]
      nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
         [2df37a19c686c2d7c4e9b4ce1505b5141e3e5552]

Wei Yongjun (1):
      l2tp: add missing .owner to struct pppox_proto
         [e1558a93b61962710733dc8c11a2bc765607f1cd]

Will Deacon (1):
      ARM: 7809/1: perf: fix event validation for software group leaders
         [c95eb3184ea1a3a2551df57190c81da695e2144b]

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.
         [2c7b871b9102c497ba8f972aa5d38532f05b654d]

Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT
         [9e40127526e857fa3f29d51e83277204fbdfc6ba]

Yinghai Lu (1):
      x86: Fix /proc/mtrr with base/size more than 44bits
         [d5c78673b1b28467354c2c30c3d4f003666ff385]

dingtianhong (3):
      ifb: fix oops when loading the ifb failed
         [f2966cd5691058b8674a20766525bedeaea9cbcf]
      dummy: fix oops when loading the dummy failed
         [2c8a01894a12665d8059fad8f0a293c98a264121]
      ifb: fix rcu_sched self-detected stalls
         [440d57bc5ff55ec1efb3efc9cbe9420b4bbdfefa]

yonghua zheng (1):
      fs/proc/task_mmu.c: fix buffer overflow in add_page_map()
         [8c8296223f3abb142be8fc31711b18a704c0e7d8]

zhangwei(Jovi) (2):
      tracing: Fix irqs-off tag display in syscall tracing
         [11034ae9c20f4057a6127fc965906417978e69b2]
      uprobes: Fix return value in error handling path
         [fa44063f9ef163c3a4c8d8c0465bb8a056b42035]

----
 Documentation/i2c/busses/i2c-piix4                 |    2 +-
 arch/arm/Kconfig                                   |    3 +-
 arch/arm/boot/compressed/atags_to_fdt.c            |   44 ++++-
 arch/arm/boot/dts/at91sam9n12ek.dts                |    4 +-
 arch/arm/include/asm/mmu.h                         |    2 +
 arch/arm/include/asm/mmu_context.h                 |   20 ++-
 arch/arm/include/asm/page.h                        |    2 +
 arch/arm/include/asm/thread_info.h                 |    1 -
 arch/arm/kernel/entry-armv.S                       |  103 ++++++------
 arch/arm/kernel/fiq.c                              |   19 ++-
 arch/arm/kernel/perf_event.c                       |   10 +-
 arch/arm/kernel/process.c                          |    7 +-
 arch/arm/kernel/traps.c                            |   37 +++--
 arch/arm/kernel/vmlinux.lds.S                      |   17 ++
 arch/arm/mach-davinci/board-dm355-leopard.c        |    1 +
 arch/arm/mach-davinci/board-dm644x-evm.c           |    1 +
 arch/arm/mach-davinci/board-dm646x-evm.c           |    1 +
 arch/arm/mach-davinci/board-neuros-osd2.c          |    1 +
 arch/arm/mm/Kconfig                                |   37 +++++
 arch/arm/mm/mmu.c                                  |   14 +-
 arch/m68k/emu/natfeat.c                            |   23 ++-
 arch/mips/Kconfig                                  |    2 +-
 arch/mips/cavium-octeon/setup.c                    |    3 +-
 arch/mips/include/asm/io.h                         |    5 +
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/include/asm/module.h                  |    5 +-
 arch/powerpc/include/asm/page.h                    |   10 ++
 arch/powerpc/kernel/lparcfg.c                      |   23 +--
 arch/powerpc/kernel/setup_64.c                     |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |    3 -
 arch/x86/kernel/cpu/mtrr/generic.c                 |   21 +--
 arch/x86/kernel/cpu/mtrr/main.c                    |   16 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |    4 +-
 arch/x86/kernel/early-quirks.c                     |   14 +-
 arch/x86/kernel/i387.c                             |    2 +-
 arch/x86/kernel/sys_x86_64.c                       |    2 +-
 arch/x86/mm/mmap.c                                 |    2 +-
 arch/x86/xen/setup.c                               |   22 +++
 arch/x86/xen/smp.c                                 |   11 +-
 block/cfq-iosched.c                                |   17 +-
 block/deadline-iosched.c                           |   16 +-
 block/elevator.c                                   |   25 +--
 block/noop-iosched.c                               |   17 +-
 drivers/acpi/acpi_memhotplug.c                     |    1 +
 drivers/acpi/battery.c                             |    2 +
 drivers/acpi/glue.c                                |    6 +-
 drivers/ata/Kconfig                                |    2 +-
 drivers/ata/ata_piix.c                             |    2 +
 drivers/ata/libata-pmp.c                           |   45 ++---
 drivers/ata/sata_fsl.c                             |    5 +-
 drivers/ata/sata_inic162x.c                        |   14 ++
 drivers/base/memory.c                              |    2 +
 drivers/block/xen-blkback/blkback.c                |   13 +-
 drivers/bluetooth/ath3k.c                          |   38 ++++-
 drivers/bluetooth/btusb.c                          |    3 +
 drivers/char/virtio_console.c                      |   47 +++---
 drivers/clocksource/dw_apb_timer_of.c              |    2 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |    1 +
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |    1 +
 drivers/gpu/drm/i915/i915_dma.c                    |   10 +-
 drivers/gpu/drm/i915/i915_reg.h                    |    4 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   12 ++
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |    1 +
 drivers/gpu/drm/radeon/atom.c                      |    5 +
 drivers/gpu/drm/radeon/atombios_dp.c               |   43 ++++-
 drivers/gpu/drm/radeon/radeon_combios.c            |  151 +++++------------
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c                |   58 ++++---
 drivers/hwmon/adt7470.c                            |    2 +-
 drivers/i2c/busses/Kconfig                         |    1 +
 drivers/i2c/busses/i2c-piix4.c                     |    3 +-
 drivers/iommu/amd_iommu.c                          |    6 +-
 drivers/macintosh/windfarm_rm31.c                  |   18 +-
 drivers/md/dm-mpath.c                              |    8 +-
 drivers/md/dm-verity.c                             |    5 +-
 drivers/md/dm.c                                    |    9 +-
 drivers/md/raid10.c                                |   12 +-
 drivers/md/raid5.c                                 |   15 +-
 drivers/md/raid5.h                                 |    1 +
 drivers/mtd/nand/Kconfig                           |    2 +-
 drivers/net/arcnet/arcnet.c                        |    2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |    2 +-
 drivers/net/dummy.c                                |    4 +
 drivers/net/ethernet/atheros/atl1c/atl1c.h         |    3 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   40 ++++-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   28 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |    3 +-
 drivers/net/ethernet/realtek/8139cp.c              |   48 +++++-
 drivers/net/ethernet/sun/sunvnet.c                 |    2 +
 drivers/net/ifb.c                                  |    8 +-
 drivers/net/macvtap.c                              |   66 +++++---
 drivers/net/tun.c                                  |   69 +++++---
 drivers/net/virtio_net.c                           |    5 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    2 +
 drivers/net/wireless/ath/ath9k/calib.c             |    1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   10 ++
 drivers/net/wireless/ath/ath9k/main.c              |    3 +-
 drivers/net/wireless/b43/Kconfig                   |    4 +-
 drivers/net/wireless/hostap/hostap_ioctl.c         |    4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   16 +-
 drivers/net/wireless/iwlegacy/common.c             |    1 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    5 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |    1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   10 +-
 drivers/net/wireless/mwifiex/sdio.c                |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   18 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    3 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    3 +-
 drivers/net/wireless/zd1201.c                      |    4 +-
 drivers/net/xen-netfront.c                         |   50 ++----
 drivers/of/fdt.c                                   |    2 +
 drivers/platform/olpc/olpc-ec.c                    |    2 +-
 drivers/rapidio/switches/idt_gen2.c                |    2 +
 drivers/s390/scsi/zfcp_aux.c                       |    5 +-
 drivers/s390/scsi/zfcp_erp.c                       |   29 +++-
 drivers/s390/scsi/zfcp_fsf.c                       |   27 ++-
 drivers/s390/scsi/zfcp_qdio.c                      |    8 +-
 drivers/s390/scsi/zfcp_scsi.c                      |   10 +-
 drivers/scsi/aacraid/src.c                         |    3 +
 drivers/scsi/isci/task.c                           |    9 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   30 +++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    6 +-
 drivers/scsi/nsp32.c                               |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |   11 +-
 drivers/scsi/scsi.c                                |    3 +
 drivers/scsi/sd.c                                  |   22 +--
 drivers/staging/android/logger.c                   |    4 +-
 drivers/staging/comedi/comedi_fops.c               |    7 +-
 drivers/staging/line6/pcm.c                        |    5 +-
 drivers/staging/zram/zram_drv.c                    |   38 +++--
 drivers/staging/zram/zram_drv.h                    |    5 +-
 drivers/staging/zram/zram_sysfs.c                  |    2 +
 drivers/target/iscsi/iscsi_target_configfs.c       |    2 +-
 drivers/target/target_core_spc.c                   |    9 +-
 drivers/tty/hvc/hvsi_lib.c                         |    4 +-
 drivers/tty/serial/mxs-auart.c                     |   38 +++--
 drivers/usb/core/hub.c                             |    9 +
 drivers/usb/core/quirks.c                          |    6 +
 drivers/usb/dwc3/core.h                            |    4 +-
 drivers/usb/dwc3/gadget.c                          |    1 +
 drivers/usb/host/ehci-hub.c                        |    1 +
 drivers/usb/host/xhci-pci.c                        |    1 -
 drivers/usb/host/xhci-ring.c                       |    2 +-
 drivers/usb/host/xhci.c                            |   13 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |    1 +
 drivers/usb/serial/cp210x.c                        |    4 +
 drivers/usb/serial/ftdi_sio.c                      |   31 +++-
 drivers/usb/serial/ftdi_sio_ids.h                  |   34 +++-
 drivers/usb/serial/keyspan.c                       |    2 +-
 drivers/usb/serial/mos7720.c                       |   21 ++-
 drivers/usb/serial/mos7840.c                       |  175 ++++++++++++--------
 drivers/usb/serial/option.c                        |   14 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   11 +-
 drivers/usb/serial/usb_wwan.c                      |   20 +--
 drivers/usb/storage/unusual_devs.h                 |    7 +
 drivers/usb/wusbcore/wa-xfer.c                     |    9 +-
 drivers/vhost/vhost.c                              |    2 +-
 drivers/vhost/vhost.h                              |    2 +-
 drivers/virtio/virtio_ring.c                       |   54 ++++--
 drivers/xen/events.c                               |    2 +-
 drivers/xen/evtchn.c                               |   21 +--
 fs/bio.c                                           |   20 ++-
 fs/block_dev.c                                     |    9 +-
 fs/btrfs/extent-tree.c                             |   13 ++
 fs/cifs/cifsencrypt.c                              |    2 +-
 fs/cifs/cifsglob.h                                 |    1 +
 fs/cifs/connect.c                                  |    7 +-
 fs/cifs/sess.c                                     |    6 +-
 fs/debugfs/inode.c                                 |   69 +++-----
 fs/ext4/ext4_jbd2.c                                |    8 +-
 fs/ext4/ialloc.c                                   |   10 +-
 fs/ext4/super.c                                    |   19 ++-
 fs/jfs/jfs_dtree.c                                 |   31 +++-
 fs/lockd/svclock.c                                 |    4 +
 fs/nfsd/vfs.c                                      |    5 +-
 fs/nilfs2/segbuf.c                                 |    5 +-
 fs/notify/fanotify/fanotify_user.c                 |    1 +
 fs/proc/task_mmu.c                                 |    8 +-
 fs/reiserfs/procfs.c                               |   92 +++-------
 fs/reiserfs/super.c                                |    3 +-
 fs/super.c                                         |   25 ++-
 include/linux/elevator.h                           |    6 +-
 include/linux/ftrace_event.h                       |    4 +-
 include/linux/if_vlan.h                            |    3 +-
 include/linux/regmap.h                             |    2 +
 include/linux/sched.h                              |    1 +
 include/linux/skbuff.h                             |    4 +-
 include/linux/user_namespace.h                     |    1 +
 include/linux/virtio.h                             |    4 +
 include/linux/wait.h                               |   57 +++++++
 include/net/ndisc.h                                |    2 +-
 include/net/udp.h                                  |    1 +
 kernel/cgroup.c                                    |    9 +-
 kernel/events/core.c                               |   28 +++-
 kernel/hrtimer.c                                   |   28 ++--
 kernel/power/autosleep.c                           |    3 +-
 kernel/printk.c                                    |    2 +-
 kernel/time/tick-broadcast.c                       |   10 +-
 kernel/trace/trace.c                               |    1 +
 kernel/trace/trace_syscalls.c                      |   21 ++-
 kernel/trace/trace_uprobe.c                        |    4 +-
 kernel/user_namespace.c                            |    4 +
 kernel/workqueue.c                                 |    9 +
 lib/Kconfig.debug                                  |    2 +-
 mm/memory.c                                        |    9 +-
 net/8021q/vlan_core.c                              |    2 +-
 net/8021q/vlan_dev.c                               |    7 +
 net/9p/trans_common.c                              |   10 +-
 net/core/dev.c                                     |   11 +-
 net/core/neighbour.c                               |   12 +-
 net/core/skbuff.c                                  |    4 +-
 net/ipv4/ip_vti.c                                  |    7 -
 net/ipv4/sysctl_net_ipv4.c                         |    6 +-
 net/ipv4/udp.c                                     |    3 +-
 net/ipv6/ip6_output.c                              |   16 +-
 net/ipv6/ip6mr.c                                   |    5 +
 net/ipv6/route.c                                   |    9 +-
 net/ipv6/udp.c                                     |    7 +-
 net/key/af_key.c                                   |    4 +
 net/l2tp/l2tp_ppp.c                                |    3 +-
 net/mac80211/cfg.c                                 |    2 +
 net/mac80211/rx.c                                  |   10 +-
 net/netlink/genetlink.c                            |    7 +
 net/sched/sch_atm.c                                |    1 +
 net/sched/sch_cbq.c                                |    1 +
 net/sunrpc/svcsock.c                               |    5 +-
 net/sunrpc/xdr.c                                   |    9 +-
 net/sunrpc/xprtrdma/svc_rdma_marshal.c             |   20 ++-
 net/wireless/core.c                                |    1 +
 net/wireless/nl80211.c                             |    7 +-
 net/x25/af_x25.c                                   |   15 +-
 sound/arm/pxa2xx-pcm-lib.c                         |    2 +
 sound/core/compress_offload.c                      |    2 +-
 sound/core/seq/oss/seq_oss_init.c                  |   16 +-
 sound/core/seq/oss/seq_oss_midi.c                  |    2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |    8 +-
 sound/pci/asihpi/asihpi.c                          |    3 +
 sound/pci/atiixp.c                                 |    2 +
 sound/pci/atiixp_modem.c                           |    2 +
 sound/pci/hda/patch_hdmi.c                         |    4 +-
 sound/pci/hda/patch_realtek.c                      |    2 +
 sound/soc/codecs/cs42l52.c                         |    2 +-
 sound/soc/codecs/max98088.c                        |    2 +-
 sound/soc/codecs/sgtl5000.h                        |    2 +-
 sound/soc/codecs/wm8962.c                          |   24 +--
 sound/soc/s6000/s6000-pcm.c                        |    2 +
 sound/soc/tegra/tegra30_i2s.c                      |    2 +-
 sound/usb/6fire/comm.c                             |   38 ++++-
 sound/usb/6fire/comm.h                             |    2 +-
 sound/usb/6fire/midi.c                             |   16 +-
 sound/usb/6fire/midi.h                             |    6 +-
 sound/usb/6fire/pcm.c                              |   55 +++++-
 sound/usb/6fire/pcm.h                              |    2 +-
 sound/usb/endpoint.c                               |   13 +-
 sound/usb/misc/ua101.c                             |   14 +-
 sound/usb/usx2y/usbusx2yaudio.c                    |    4 +
 259 files changed, 2152 insertions(+), 1107 deletions(-)
