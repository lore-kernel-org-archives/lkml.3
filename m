Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427Ab3GCTV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:21:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882Ab3GCSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:46 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=eIhxMilvRf8A:10 a=FAPq4sIy14gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bLFOEYoiK7IA:10 a=L_cg7s2yAAsFPPGe6fkA:9 a=EBjXWxD1LFuv4Zf-:21 a=wE_-j9RwOmz14F75:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703183857.307196999@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:38:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [000/141] 3.6.11.6-stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for 3.6.11.6 release.
There are 141 patches in this series, which will be posted as responses
to this one. If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jul 6 14:37:54.
Anything received after that time might be too late.

Adis Hamzić (1):
      radeon: Fix system hang issue when using KMS with older cards
         [e49f3959a96dc279860af7e86e6dbcfda50580a5]

Alan Stern (2):
      USB: UHCI: fix for suspend of virtual HP controller
         [997ff893603c6455da4c5e26ba1d0f81adfecdfc]
      USB: xHCI: override bogus bulk wMaxPacketSize values
         [e4f47e3675e6f1f40906b785b934ce963e9f2eb3]

Alex Deucher (3):
      drm/radeon: don't allow audio on DCE6
         [1cbcca302a318499f20a512847c5d6a510c08c35]
      drm/radeon: fix card_posted check for newer asics
         [09fb8bd1a63b0f9f15e655c4fe8d047e5d2bf67a]
      drm/radeon: fix typo in cu_per_sh on verde
         [468ef1a58c9268ac9709350bf95eaf1c22a69f29]

Alex Hung (1):
      ACPI / video: ignore BIOS initial backlight value for HP m4
         [fedbe9bc6fd3e14b1ffbb3dac407777ac4a3650c]

Alex Lyakas (1):
      md/raid1: consider WRITE as successful only if at least one non-Faulty and non-rebuilding drive completed it.
         [3056e3aec8d8ba61a0710fb78b2d562600aa2ea7]

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in MSI interrupt handling
         [1ccc819da6fda9bee10ab8b72e9adbb5ad3e4959]

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer
         [7c3425123ddfdc5f48e7913ff59d908789712b18]

Arnd Bergmann (2):
      ARM: 7743/1: compressed/head.S: work around new binutils warning
         [da94a829305f1c217cfdf6771cb1faca0917e3b9]
      ARM: 7742/1: topology: export cpu_topology
         [92bdd3f5eba299b33c2f4407977d6fa2e2a6a0da]

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6
         [780a6ec640a3fed671fc2c40e4dd30c03eca3ac3]

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist
         [c8f6d8351ba8c89d5cd4c562552ec7ec29274e31]

Ben Hutchings (2):
      perf: net_dropmonitor: Fix symbol-relative addresses
         [5a1e99dd2028e00998d42029be86835d8ef4a46e]
      perf: net_dropmonitor: Fix trace parameter order
         [140c3c6a2bcd2c31e2f7f5a8d59689724776c8e5]

Ben Mesman (1):
      drm/i915: no lvds quirk for hp t5740
         [45a211d75137b1ac869a8a758a6667f15827a115]

Benjamin Herrenschmidt (1):
      powerpc: Fix missing/delayed calls to irq_work
         [230b3034793247f61e6a0b08c44cf415f6d92981]

Bjørn Mork (1):
      USB: option: blacklist network interface on Huawei E1820
         [b8a24e6281d37243c06b9497dcbfaa98c1e2ad35]

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race
         [dfd20b2b174d3a9b258ea3b7a35ead33576587b1]

Brian King (2):
      powerpc/pseries: Force 32 bit MSIs for devices that require it
         [e61133dda480062d221f09e4fc18f66763f8ecd0]
      powerpc: Set default VGA device
         [c2e1d84523ad2a19e5be08c1f01999cc9e82652e]

Chew, Chiau Ee (1):
      ata_piix: add PCI IDs for Intel BayTail
         [fca8c90d519dedd4f4b19901d005c243f7f0bf2e]

Christian Gmeiner (1):
      drivers/leds/leds-ot200.c: fix error caused by shifted mask
         [4b949b8af12e24b8a48fa5bb775a13b558d9f4da]

Christopher Harvey (1):
      drm/mgag200: Add missing write to index before accessing data register
         [91f8f105f2b82b4a38dee2d74760bc39d40ec42c]

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland/Cakewalk UM-3G support
         [a0c6d309c6df14655f9962f666d1da96318b0b7c]

Cliff Wickman (1):
      mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas
         [a9ff785e4437c83d2179161e012f5bdfbd6381f0]

Dan Carpenter (1):
      USB: cxacru: potential underflow in cxacru_cm_get_array()
         [2a0ebf80aa95cc758d4725f74a7016e992606a39]

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card
         [49c6e370dd6400b84897c4100095089b5c13a061]

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID
         [c3456fb3e4712d0448592af3c5d644c9472cd3c1]

Dave Chinner (1):
      xfs: kill suid/sgid through the truncate path.
         [2962f5a5dcc56f69cbf62121a7be67cc15d6940b]

Dave Kleikamp (1):
      jfs: fix a couple races
         [73aaa22d5ffb2630456bac2f9a4ed9b81d0d7271]

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.
         [53d3b4d7778daf15900867336c85d3f8dd70600c]

Emmanuel Grumbach (1):
      iwlwifi: dvm: fix zero LQ CMD sending avoidance
         [a87783699b23395c46bbeeb5d28f6db24897bf26]

Felix Fietkau (1):
      Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"
         [96005931785238e1a24febf65ffb5016273e8225]

Finn Thain (1):
      m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK
         [df66834a43c461de2565c45d815288ba1c0def37]

Gabor Juhos (1):
      ath9k: use correct OTP register offsets for AR9550
         [add295a4afbdf5852d004c754c552d692b0fcac8]

Gavin Shan (1):
      powerpc/eeh: Don't check RTAS token to get PE addr
         [b8b3de224f194005ad87ede6fd022fcc2bef3b1a]

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2
         [5bf8fae33d14cc5c3c53a926f9079f92c8b082b0]

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers
         [7138143972b7c293267c783fc99a194f0ceff7f2]

Gregory CLEMENT (1):
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11
         [2b8b2797142c7951e635c6eec5d1705ee9bc45c5]

Guenter Roeck (1):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617
         [591bfcfc334a003ba31c0deff03b22e73349939b]

Hans-Christian Egtvedt (1):
      avr32: fix relocation check for signed 18-bit offset
         [e68c636d88db3fda74e664ecb1a213ae0d50a7d8]

Heiko Abraham (1):
      Input: egalax_ts - ABS_MT_POSITION_Y not reported well
         [3c9cfa782e075cc2348b949ba139911aac02c7cb]

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled
         [b7ea85a4fed37835eec78a7be3039c8dc22b8178]

Imre Deak (1):
      wait: fix false timeouts when using wait_event_timeout()
         [4c663cfc523a88d97a8309b04a089c27dc57fd7e]

Jeff Layton (2):
      cifs: fix potential buffer overrun when composing a new options string
         [166faf21bd14bc5c5295a44874bf7f3930c30b20]
      cifs: only set ops for inodes in I_NEW state
         [c2b93e0699723700f886ce17bb65ffd771195a6d]

Jeff Mahoney (3):
      reiserfs: fix spurious multiple-fill in reiserfs_readdir_dentry
         [0bdc7acba56a7ca4232f15f37b16f7ec079385ab]
      reiserfs: fix problems with chowning setuid file w/ xattrs
         [4a8570112b76a63ad21cfcbe2783f98f7fd5ba1b]
      reiserfs: fix deadlock with nfs racing on create/lookup
         [a1457c0ce976bad1356b9b0437f2a5c3ab8a9cfc]

Jim Schutt (2):
      ceph: ceph_pagelist_append might sleep while atomic
         [39be95e9c8c0b5668c9f8806ffe29bf9f4bc0f40]
      ceph: add cpu_to_le32() calls when encoding a reconnect capability
         [c420276a532a10ef59849adc2681f45306166b89]

Jiri Kosina (1):
      random: fix accounting race condition with lockless irq entropy_count update
         [10b3a32d292c21ea5b3ad5ca5975e88bb20b8d68]

Joerg Roedel (1):
      iommu/amd: Workaround for ERBT1312
         [d3263bc29706e42f74d8800807c2dedf320d77f1]

Johan Hedberg (1):
      Bluetooth: Fix mgmt handling of power on failures
         [96570ffcca0b872dc8626e97569d2697f374d868]

Johan Hovold (15):
      USB: spcp8x5: fix device initialisation at open
         [5e4211f1c47560c36a8b3d4544dfd866dcf7ccd0]
      USB: pl2303: fix device initialisation at open
         [2d8f4447b58bba5f8cb895c07690434c02307eaf]
      USB: io_ti: fix chars_in_buffer overhead
         [b16634adce951a7371be931487034f7365971ed0]
      USB: serial: add generic wait_until_sent implementation
         [dcf0105039660e951dfea348d317043d17988dfc]
      USB: serial: add wait_until_sent operation
         [0693196fe7bbb5e6cafd255dfce91ff6d10bc18f]
      USB: mos7720: fix hardware flow control
         [a26f009a070e840fadacb91013b2391ba7ab6cc2]
      USB: mos7720: fix message timeouts
         [849513a7809175420d353625b6f651d961e99d49]
      USB: mos7720: fix DMA to stack
         [72ea18a558ed7a63a50bb121ba60d73b5b38ae30]
      USB: mos7840: fix DMA to stack
         [15ee89c3347fbf58a4361011eda5ac2731e45126]
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
         [5f8e2c07d75967ee49a5da1d21ddf5f50d48cda0]
      USB: whiteheat: fix broken port configuration
         [9eecf22d2b375b9064a20421c6c307b760b03d46]
      USB: visor: fix initialisation of Treo/Kyocera devices
         [420021a395ce38b7ab2cceb52dee4038be7d8fa3]
      USB: ark3116: fix control-message timeout
         [634371911730a462626071065b64cd6e1fe213e0]
      USB: keyspan: fix bogus array index
         [a07088098a650267b2eda689538133a324b9523f]
      USB: iuu_phoenix: fix bulk-message timeout
         [6c13ff68a7ce01da7a51b44241a7aad8eaaedde7]

Johannes Berg (4):
      cfg80211: check wdev->netdev in connection work
         [c815797663b72e3ac1736f1886538152bc48e4af]
      mac80211: close AP_VLAN interfaces before unregistering all
         [c8aa22db0112f640ac6631347f850879c621840b]
      mac80211: fix AP-mode frame matching
         [2b9ccd4e4308272e5aec614b77c5385e7ec2ec90]
      cfg80211: fix wiphy_register error path
         [03cd7e4e1ea16cd151c799a33b5ca1fd41a464df]

Johannes Weiner (1):
      mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge
         [28ccddf7952c496df2a51ce5aee4f2a058a98bab]

Joseph Qi (1):
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()
         [b4ca2b4b577c3530e34dcfaafccb2cc680ce95d1]

Kees Cook (4):
      x86: Fix typo in kexec register clearing
         [c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1]
      kmsg: honor dmesg_restrict sysctl on /dev/kmsg
         [637241a900cbd982f744d44646b48a273d609b34]
      b43: stop format string leaking into error msgs
         [e0e29b683d6784ef59bbc914eac85a04b650e63c]
      iscsi-target: fix heap buffer overflow on error
         [cea4dcfdad926a27a18e188720efe0f2c9403456]

Kishon Vijay Abraham I (1):
      regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10
         [f232168df0c7e7414b70ac5d8fed83086d441c0b]

Kleber Sacilotto de Souza (2):
      radeon: use max_bus_speed to activate gen2 speeds
         [7e0e41963740525af702bb23edede8ae9afc4ac0]
      powerpc/pseries: Perform proper max_bus_speed detection
         [d82fb31abc46620b7c22758c75707069f2763646]

Konrad Rzeszutek Wilk (1):
      xen/smp: Fixup NOHZ per cpu data when onlining an offline CPU.
         [466318a87f28cb3ba0d08a3b7ef1a37ae73d5aa7]

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code
         [c2cc499c5bcf9040a738f49e8051b42078205748]

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x
         [99e11334dcb846f9b76fb808196c7f47aa83abb3]

Michael Chan (1):
      tg3: Fix data corruption on 5725 with TSO
         [0f0d15100a8ac875bdd408324c473e16d73d3557]

Michael Ellerman (1):
      powerpc: Fix stack overflow crash in resume_kernel when ftracing
         [0e37739b1c96d65e6433998454985de994383019]

Michael Hennerich (1):
      iio: frequency: ad4350: Fix bug / typo in mask
         [2eb3a81eef0510511a3211bb3da560f446a8c8de]

Naoya Horiguchi (1):
      mm: migration: add migrate_entry_wait_huge()
         [30dad30922ccc733cfdbfe232090cf674dc374dc]

NeilBrown (1):
      md/raid1,raid10: use freeze_array in place of raise_barrier in various places.
         [e2d59925221cd562e07fee38ec8839f7209ae603]

Nicholas Bellinger (2):
      target: Re-instate sess_wait_list for target_wait_for_sess_cmds
         [9b31a328e344e62e7cc98ae574edcb7b674719bb]
      ib_srpt: Call target_sess_cmd_list_set_waiting during shutdown_session
         [1d19f7800d643b270b28d0a969c5eca455d54397]

Nicolas Schichan (1):
      ASoC: cs42l52: fix default value for MASTERA_VOL.
         [04d245b7899c020559402841d2f70ddd740a7704]

Nithin Sujir (2):
      tg3: Add read dma workaround for 5720
         [9bc297ea0622bb2a6b3abfa2fa84f0a3b86ef8c8]
      tg3: Skip powering down function 0 on certain serdes devices
         [44f3b503c16425c8e9db4bbaa2fc9cd0c9d0ba91]

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters
         [7b92d03c3239f43e5b86c9cc9630f026d36ee995]

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub
         [bac6b03275184c912ad0818c9a0a736847804dca]

Patrik Jakobsson (3):
      drm/gma500/cdv: Unpin framebuffer on crtc disable
         [22e7c385a80d771aaf3a15ae7ccea3b0686bbe10]
      drm/gma500/psb: Unpin framebuffer on crtc disable
         [820de86a90089ee607d7864538c98a23b503c846]
      drm/gma500: Increase max resolution for mode setting
         [cbbd379aa43890f36da934f5af619d2fb8ec3d87]

Paul Mackerras (1):
      powerpc: Fix emulation of illegal instructions on PowerNV platform
         [bf593907f7236e95698a76b7c7a2bbf8b1165327]

Paul Taysom (1):
      ecryptfs: fixed msync to flush data
         [c15cddd900e867c5adfb3c79596479dc5975f743]

Rabin Vincent (1):
      dmaengine: ste_dma40: fix pm runtime ref counting
         [9ecb41bd8cf002fd8f3e063db4df81647ddd623c]

Rafael Aquini (1):
      swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion
         [cbab0e4eec299e9059199ebe6daf48730be46d2b]

Richard Weinberger (1):
      USB: serial: Add Option GTM681W to qcserial device table.
         [8a2f132a01c2dd4c3905fa560f92019761ed72b1]

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device
         [6529591e3eef65f0f528a81ac169f6e294b947a7]

Robin Holt (1):
      reboot: rigrate shutdown/reboot to boot cpu
         [cf7df378aa4ff7da3a44769b7ff6e9eef1a9f3db]

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary
         [136e8770cd5d1fe38b3c613100dd6dc4db6d4fa6]

Sage Weil (5):
      libceph: wrap auth methods in a mutex
         [e9966076cdd952e19f2dd4854cd719be0d7cbebc]
      libceph: wrap auth ops in wrapper functions
         [27859f9773e4a0b2042435b13400ee2c891a61f4]
      libceph: add update_authorizer auth method
         [0bed9b5c523d577378b6f83eab5835fe30c27208]
      libceph: fix authorizer invalidation
         [4b8e8b5d78b8322351d44487c1b76f7e9d3412bc]
      libceph: clear messenger auth_retry flag when we authenticate
         [20e55c4cc758e4dccdfd92ae8e9588dd624b2cd7]

Sarah Sharp (1):
      xhci: Disable D3cold for buggy TI redrivers.
         [c3897aa5386faba77e5bbdf94902a1658d3a5b11]

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface
         [8ff10bdb14a52e3f25d4ce09e0582a8684c1a6db]

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init
         [331de00a64e5027365145bdf51da27b9ce15dfd5]

Srivatsa S. Bhat (1):
      CPU hotplug: provide a generic helper to disable/enable CPU hotplug
         [16e53dbf10a2d7e228709a7286310e629ede5e45]

Stephen M. Cameron (1):
      cciss: fix broken mutex usage in ioctl
         [03f47e888daf56c8e9046c674719a0bcc644eed5]

Sujith Manoharan (2):
      ath9k: Use minstrel rate control by default
         [5efac94999ff218e0101f67a059e44abb4b0b523]
      ath9k: Disable PowerSave by default
         [531671cb17af07281e6f28c1425f754346e65c41]

Suravee Suthikulpanit (1):
      iommu/amd: Re-enable IOMMU event log interrupt after handling.
         [925fe08bce38d1ff052fe2209b9e2b8d5fbb7f98]

Takashi Iwai (2):
      ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270
         [11e7064f35bb87da8f427d1aa4bbd8b7473a3993]
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audio iface
         [8eafc0a161123d90617c9ca2eddfe87b382b1b89]

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G
         [73c042df6e1bc50544842a04b777b36bbe3630e6]

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate
         [77df9e0b799b03e1d5d9c68062709af5f637e834]

Tony Lindgren (1):
      drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree
         [24b8256a1fb28d357bc6fa09184ba29b4255ba5c]

Trond Myklebust (2):
      NFSv4: Fix a thinko in nfs4_try_open_cached
         [f448badd34700ae728a32ba024249626d49c10e1]
      SUNRPC: Prevent an rpc_task wakeup race
         [a3c3cac5d31879cd9ae2de7874dc6544ca704aec]

Tyler Hicks (1):
      eCryptfs: Check return of filemap_write_and_wait during fsync
         [bc5abcf7e411b889f73ea2a90439071a0f451011]

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR
         [e771451c0a831d96a7c14b0ca8a8ec671d98567b]

Vladimir Murzin (1):
      xhci: fix list access before init
         [88696ae432ce7321540ac53d9caab3de9118b094]

Wang YanQing (1):
      TTY: Fix tty miss restart after we turn off flow-control
         [dab73b4eb9ef924a2b90dab84e539076d82b256f]

Wei Liu (7):
      xen-netback: better names for thresholds
         [376414945d15aa636e65f7e773c1e398b7a21cb9]
      xen-netfront: reduce gso_max_size to account for max TCP header
         [9ecd1a75d977e2e8c48139c7d3efed183f898d94]
      xen-netback: avoid allocating variable size array on stack
         [59ccb4ebbc35e36a3c143f2d1355deb75c2e628f]
      xen-netback: remove redundent parameter in netbk_count_requests
         [ac69c26e7accb04ae2cb9ab0872068983a42b3c8]
      xen-netback: don't disconnect frontend when seeing oversize packet
         [03393fd5cc2b6cdeec32b704ecba64dbb0feae3c]
      xen-netback: coalesce slots in TX path and fix regressions
         [2810e5b9a7731ca5fce22bfbe12c96e16ac44b6f]
      xen-netback: remove skb in xen_netbk_alloc_page
         [27f852282ab9a028f57da96d05c26f38c424a315]

----
 arch/arm/boot/compressed/Makefile                  |    2 +-
 arch/arm/boot/compressed/head-sa1100.S             |    1 +
 arch/arm/boot/compressed/head-shark.S              |    1 +
 arch/arm/boot/compressed/head.S                    |    1 +
 arch/arm/kernel/topology.c                         |    2 +
 arch/arm/mach-kirkwood/ts219-setup.c               |    2 +-
 arch/arm/plat-orion/common.c                       |   12 +-
 arch/avr32/kernel/module.c                         |    2 +-
 arch/m68k/kernel/head.S                            |   29 +-
 arch/powerpc/include/asm/exception-64s.h           |    2 +-
 arch/powerpc/include/asm/machdep.h                 |    3 +
 arch/powerpc/include/asm/pci-bridge.h              |    2 +
 arch/powerpc/kernel/exceptions-64s.S               |    2 +-
 arch/powerpc/kernel/irq.c                          |    2 +-
 arch/powerpc/kernel/pci-common.c                   |   21 ++
 arch/powerpc/kernel/process.c                      |    4 +-
 arch/powerpc/kernel/traps.c                        |   10 +
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   12 +-
 arch/powerpc/platforms/pseries/msi.c               |   21 +-
 arch/powerpc/platforms/pseries/pci.c               |   53 ++++
 arch/powerpc/platforms/pseries/pseries.h           |    4 +
 arch/powerpc/platforms/pseries/setup.c             |    3 +
 arch/x86/kernel/relocate_kernel_64.S               |    2 +-
 arch/x86/xen/smp.c                                 |    8 +
 drivers/acpi/video.c                               |   16 +
 drivers/acpi/video_detect.c                        |    8 +
 drivers/ata/ata_piix.c                             |   15 +
 drivers/ata/libata-core.c                          |    6 +
 drivers/block/brd.c                                |    4 +-
 drivers/block/cciss.c                              |   32 +-
 drivers/char/random.c                              |   24 +-
 drivers/dma/ste_dma40.c                            |    8 +-
 drivers/gpu/drm/drm_irq.c                          |    6 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |   14 +
 drivers/gpu/drm/gma500/framebuffer.c               |    4 +-
 drivers/gpu/drm/gma500/psb_intel_display.c         |   14 +
 drivers/gpu/drm/i915/intel_lvds.c                  |    4 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   12 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |    9 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   11 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   20 +-
 drivers/gpu/drm/radeon/ni.c                        |   10 +-
 drivers/gpu/drm/radeon/r100.c                      |    9 +-
 drivers/gpu/drm/radeon/r300.c                      |    9 +-
 drivers/gpu/drm/radeon/r420.c                      |   10 +-
 drivers/gpu/drm/radeon/r520.c                      |    9 +-
 drivers/gpu/drm/radeon/r600.c                      |   19 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   19 +-
 drivers/gpu/drm/radeon/rs400.c                     |    9 +-
 drivers/gpu/drm/radeon/rs600.c                     |    9 +-
 drivers/gpu/drm/radeon/rs690.c                     |    9 +-
 drivers/gpu/drm/radeon/rv515.c                     |    9 +-
 drivers/gpu/drm/radeon/rv770.c                     |   19 +-
 drivers/gpu/drm/radeon/si.c                        |   12 +-
 drivers/hwmon/adm1021.c                            |   58 +++-
 drivers/iio/frequency/adf4350.c                    |    2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   32 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |    1 +
 drivers/input/touchscreen/egalax_ts.c              |    2 +-
 drivers/iommu/amd_iommu.c                          |   31 +-
 drivers/iommu/amd_iommu_types.h                    |    1 +
 drivers/leds/leds-ot200.c                          |   14 +-
 drivers/md/raid1.c                                 |   34 ++-
 drivers/md/raid10.c                                |   26 +-
 drivers/net/ethernet/broadcom/tg3.c                |   70 ++++-
 drivers/net/ethernet/broadcom/tg3.h                |    6 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |   10 +-
 drivers/net/wireless/ath/ath9k/Makefile            |    2 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |    9 +-
 drivers/net/wireless/ath/ath9k/init.c              |    7 +-
 drivers/net/wireless/ath/ath9k/rc.h                |    2 +-
 drivers/net/wireless/b43/main.c                    |    2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |    2 +-
 drivers/net/xen-netback/netback.c                  |  311 ++++++++++++++++----
 drivers/net/xen-netfront.c                         |   17 +-
 drivers/rapidio/devices/tsi721.c                   |   12 +
 drivers/regulator/palmas-regulator.c               |    2 +-
 drivers/rtc/rtc-twl.c                              |    1 +
 drivers/target/iscsi/iscsi_target_parameters.c     |    8 +-
 drivers/target/iscsi/iscsi_target_parameters.h     |    4 +-
 drivers/target/target_core_transport.c             |   18 +-
 drivers/tty/n_tty.c                                |    8 +
 drivers/usb/atm/cxacru.c                           |    3 +-
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/dwc3/gadget.c                          |   17 +-
 drivers/usb/host/uhci-hub.c                        |    3 +-
 drivers/usb/host/xhci-mem.c                        |   27 +-
 drivers/usb/host/xhci-pci.c                        |   10 +
 drivers/usb/host/xhci.c                            |   16 +-
 drivers/usb/host/xhci.h                            |    3 +
 drivers/usb/serial/ark3116.c                       |    2 +-
 drivers/usb/serial/cypress_m8.c                    |   18 +-
 drivers/usb/serial/cypress_m8.h                    |    4 +
 drivers/usb/serial/ftdi_sio.c                      |    2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    2 +
 drivers/usb/serial/generic.c                       |   31 ++
 drivers/usb/serial/io_ti.c                         |   14 +
 drivers/usb/serial/iuu_phoenix.c                   |    4 +-
 drivers/usb/serial/keyspan.c                       |    2 +-
 drivers/usb/serial/mos7720.c                       |   25 +-
 drivers/usb/serial/mos7840.c                       |   35 ++-
 drivers/usb/serial/option.c                        |   11 +
 drivers/usb/serial/pl2303.c                        |   10 +-
 drivers/usb/serial/qcserial.c                      |    1 +
 drivers/usb/serial/spcp8x5.c                       |   10 +-
 drivers/usb/serial/usb-serial.c                    |   19 ++
 drivers/usb/serial/visor.c                         |    9 +
 drivers/usb/serial/whiteheat.c                     |    2 +-
 fs/ceph/locks.c                                    |   73 +++--
 fs/ceph/mds_client.c                               |   90 +++---
 fs/ceph/super.h                                    |    9 +-
 fs/cifs/cifs_dfs_ref.c                             |    4 +-
 fs/cifs/inode.c                                    |    3 +-
 fs/ecryptfs/file.c                                 |    6 +
 fs/fat/inode.c                                     |   15 +-
 fs/jfs/inode.c                                     |    2 +-
 fs/jfs/jfs_logmgr.c                                |    3 +-
 fs/nfs/nfs4proc.c                                  |    2 +-
 fs/nilfs2/inode.c                                  |   27 +-
 fs/ocfs2/extent_map.c                              |    2 +-
 fs/proc/kmsg.c                                     |   10 +-
 fs/reiserfs/dir.c                                  |    2 +
 fs/reiserfs/inode.c                                |    9 +-
 fs/reiserfs/xattr.c                                |   14 +-
 fs/reiserfs/xattr_acl.c                            |    3 +
 fs/xfs/xfs_iops.c                                  |   47 ++-
 include/linux/ceph/auth.h                          |   18 ++
 include/linux/cpu.h                                |    4 +
 include/linux/swapops.h                            |    3 +
 include/linux/syslog.h                             |    4 +-
 include/linux/usb/serial.h                         |    4 +
 include/linux/wait.h                               |   16 +-
 include/net/bluetooth/hci_core.h                   |    1 +
 include/net/bluetooth/mgmt.h                       |    1 +
 include/target/target_core_base.h                  |    1 +
 include/xen/interface/io/netif.h                   |   19 ++
 kernel/cpu.c                                       |   55 ++--
 kernel/printk.c                                    |   91 +++---
 kernel/sys.c                                       |   29 +-
 mm/huge_memory.c                                   |    7 +-
 mm/hugetlb.c                                       |    2 +-
 mm/memcontrol.c                                    |   14 +-
 mm/migrate.c                                       |   25 +-
 mm/pagewalk.c                                      |   70 ++---
 mm/swap_state.c                                    |   18 +-
 net/bluetooth/hci_core.c                           |    6 +-
 net/bluetooth/mgmt.c                               |   21 ++
 net/ceph/auth.c                                    |  117 ++++++--
 net/ceph/auth_x.c                                  |   24 +-
 net/ceph/auth_x.h                                  |    1 +
 net/ceph/messenger.c                               |    3 +-
 net/ceph/mon_client.c                              |    7 +-
 net/ceph/osd_client.c                              |   27 +-
 net/mac80211/iface.c                               |    9 +
 net/mac80211/rx.c                                  |    3 +
 net/sunrpc/sched.c                                 |    8 +-
 net/wireless/core.c                                |   16 +-
 net/wireless/sme.c                                 |    3 +
 sound/soc/codecs/cs42l52.c                         |    2 +-
 sound/usb/mixer.c                                  |    1 +
 sound/usb/quirks-table.h                           |   14 +-
 tools/perf/scripts/python/net_dropmonitor.py       |    8 +-
 163 files changed, 1870 insertions(+), 648 deletions(-)
