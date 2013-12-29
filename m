Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3L2CQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:16:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54982 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab3L2CLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:23 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.751256928@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 000/185] 3.2.54-rc1 review
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.54 release.
There are 185 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jan  1 00:00:00 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.53 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Aaron Lu (1):
      PM / hibernate: Avoid overflow in hibernate_preallocate_memory()
         [fd432b9f8c7c88428a4635b9f5a9c6e174df6e36]

Akira Takeuchi (1):
      mm: ensure get_unmapped_area() returns higher address than mmap_min_addr
         [2afc745f3e3079ab16c826be4860da2529054dd2]

Alan Cox (1):
      drivers/char/i8k.c: add Dell XPLS L421X
         [9aa5b0181bdf335f0b731d8502e128a862884bcd]

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge
         [a535d81c92615b8ffb99b7e1fd1fb01effaed1af]

Alex Williamson (1):
      KVM: Fix iommu map/unmap to handle memory slot moves
         [e40f193f5bb022e927a57a4f5d5194e4f12ddb74]

Alistair Popple (1):
      ahci: add support for IBM Akebono platform device
         [2435dcb98cfe13c246aa27df393e22bc24bbcd20]

Andreas Bießmann (2):
      avr32: fix out-of-range jump in large kernels
         [d617b338bbfdd77e9cbd8e7dc949cee3dd73d575]
      avr32: setup crt for early panic()
         [7a2a74f4b856993218aa7cdeeb6c3103101340db]

Andreas Henriksson (1):
      net: Fix "ip rule delete table 256"
         [13eb2ab2d33c57ebddc57437a7d341995fc9138c]

Andy Adamson (1):
      NFSv4 wait on recovery for async session errors
         [4a82fd7c4e78a1b7a224f9ae8bb7e1fd95f670e0]

Andy Honig (2):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
         [338c7dbadd2671189cec7faf64c84d01071b3f96]
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
         [b963a22e6d1a266a67e9eecc88134713fd54775c]

Anton Blanchard (1):
      powerpc/pseries: Duplicate dtl entries sometimes sent to userspace
         [84b073868b9d9e754ae48b828337633d1b386482]

Avinash Patil (1):
      mwifiex: correct packet length for packets from SDIO interface
         [d03b4aa77e1187b77dfe37d14a923547f00baa66]

Ben Segall (1):
      sched: Avoid throttle_cfs_rq() racing with period_timer stopping
         [f9f9ffc237dd924f048204e8799da74f9ecf40cf]

Ben Skeggs (1):
      drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence
         [9360bd1112d8874d21942e2ae74f5416b00a8db6]

Benjamin Tissoires (1):
      HID: multitouch: validate indexes details
         [8821f5dc187bdf16cfb32ef5aa8c3035273fa79a]

Bo Shen (1):
      ASoC: wm8731: fix dsp mode configuration
         [b4af6ef99a60c5b56df137d7accd81ba1ee1254e]

Brian Carnes (1):
      hwmon: (w83l786ng) Fix fan speed control mode setting and reporting
         [cf7559bc053471f32373d71d04a9aa19e0b48d59]

Brian Norris (2):
      mtd: m25p80: fix allocation size
         [778d226a1462572b51d6777cdb1d611543410cb4]
      mtd: nand: hack ONFI for non-power-of-2 dimensions
         [4355b70cf48363c50a9de450b01178c83aba8f6a]

Chris Metcalf (1):
      connector: improved unaligned access error fix
         [1ca1a4cf59ea343a1a70084fe7cc96f37f3cf5b1]

Christoph Hellwig (2):
      nfsd: make sure to balance get/put_write_access
         [987da4791052fa298b7cfcde4dea9f6f2bbc786b]
      nfsd: split up nfsd_setattr
         [818e5a22e907fbae75e9c1fd78233baec9fa64b6]

Colin Leitner (4):
      USB: ftdi_sio: fixed handling of unsupported CSIZE setting
         [8704211f65a2106ba01b6ac9727cdaf9ca11594c]
      USB: mos7840: correct handling of CS5 setting
         [78692cc3382e0603a47e1f2aaeffe0d99891994d]
      USB: pl2303: fixed handling of CS5 setting
         [a313249937820f8b1996133fc285efbd6aad2c5b]
      USB: spcp8x5: correct handling of CS5 setting
         [711fbdfbf2bc4827214a650afe3f64767a1aba16]

Dan Carpenter (5):
      hwmon: Prevent some divide by zeros in FAN_TO_REG()
         [3806b45ba4655147a011df03242cc197ab986c43]
      isdnloop: use strlcpy() instead of strcpy()
         [f9a23c84486ed350cce7bb1b2828abd1f6658796]
      libertas: potential oops in debugfs
         [a497e47d4aec37aaf8f13509f3ef3d1f6a717d88]
      net: clamp ->msg_namelen instead of returning an error
         [db31c55a6fb245fdbb752a2ca4aefec89afabb06]
      xfs: underflow bug in xfs_attrlist_by_handle()
         [071c529eb672648ee8ca3f90944bcbcc730b4c06]

Dan Williams (2):
      [SCSI] libsas: fix usage of ata_tf_to_fis
         [ae5fbae0ccd982dfca0ce363036ed92f5b13f150]
      prism54: set netdev type to "wlan"
         [8e3ffa471091c560deb6738ed9ab7445b7a5fd04]

Daniel Borkmann (2):
      packet: fix use after free race in send path when dev  is released
         [e40526cb20b5ee53419452e1f03d97092f144418]
      random32: fix off-by-one in seeding requirement
         [51c37a70aaa3f95773af560e6db3073520513912]

Daniel Vetter (1):
      drm/i915: flush cursors harder
         [b2ea8ef559b4d94190009f3651b5b3ab7c05afd3]

David Cluytens (1):
      USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem
         [3b59d16c513da258ec8f6a0b4db85f257a0380d6]

Ding Tianhong (1):
      bridge: flush br's address entry in fdb when remove  the bridge dev
         [f873042093c0b418d2351fe142222b625c740149]

Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping
         [506cac15ac86f204b83e3cfccde73eeb4e7c5f34]

Duan Jiong (1):
      ipv6: use rt6_get_dflt_router to get default router in  rt6_route_rcv
         [f104a567e673f382b09542a8dc3500aa689957b4]

Eric Dumazet (2):
      inet: fix possible seqlock deadlocks
         [f1d8cba61c3c4b1eb88e507249c4cb8d635d9a76]
      ipv4: fix possible seqlock deadlock
         [c9e9042994d37cbc1ee538c500e9da1bb9d1bcdf]

Eric Seppanen (2):
      iscsi-target: chap auth shouldn't match username with trailing garbage
         [86784c6bdeeef78eed94d298be7a8879f6a97ee2]
      iscsi-target: fix extract_param to handle buffer length corner case
         [369653e4fb511928511b0ce81f41c812ff1f28b6]

Fan.Du (1):
      {pktgen, xfrm} Update IPv4 header total len and  checksum after tranformation
         [3868204d6b89ea373a273e760609cb08020beb1a]

Fangxiaozhi (1):
      USB: option: support new huawei devices
         [2bf308d7bc5e8cdd69672199f59532f35339133c]

Felipe Pena (1):
      rtlwifi: rtl8192se: Fix wrong assignment
         [3aef7dde8dcf09e0124f0a2665845a507331972b]

Fenghua Yu (1):
      x86/apic: Disable I/O APIC before shutdown of the local APIC
         [522e66464467543c0d88d023336eec4df03ad40b]

Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption
         [9dda2769af4f3f3093434648c409bb351120d9e8]

Greg Edwards (1):
      KVM: IOMMU: hva align mapping page size
         [27ef63c7e97d1e5dddd85051c03f8d44cc887f34]

Greg Kroah-Hartman (1):
      Staging: tidspbridge: disable driver
         [930ba4a374b96560ef9fde2145cdc454a164ddcc]

Guenter Roeck (1):
      hwmon: (lm90) Fix max6696 alarm handling
         [e41fae2b1ed8c78283d73651cd65be0228c0dd1c]

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6
         [8f173e22abf2258ddfa73f46eadbb6a6c29f1631]

Gwendal Grignou (1):
      libata: Fix display of sata speed
         [3e85c3ecbc520751324a191d23bb94873ed01b10]

H. Peter Anvin (2):
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h
         [503cf95c061a0551eb684da364509297efbe55d9]
      x86, build: Pass in additional -mno-mmx, -mno-sse options
         [8b3b005d675726e38bc504d2e35a991e55819155]

Hannes Frederic Sowa (6):
      inet: fix addr_len/msg->msg_namelen assignment in  recv_error and rxpmtu functions
         [85fbaa75037d0b6b786ff18658ddf0b4014ce2a4]
      inet: prevent leakage of uninitialized memory to user  in recv syscalls
         [bceaa90240b6019ed73b49965eac7d167610be69]
      ipv6: fix leaking uninitialized port number of  offender sockaddr
         [1fa4c710b6fe7b0aac9907240291b6fe6aafc3b8]
      ipv6: fix possible seqlock deadlock in  ip6_finish_output2
         [7f88c6b23afbd31545c676dea77ba9593a1a14bf]
      net: add BUG_ON if kernel advertises msg_namelen >  sizeof(struct sockaddr_storage)
         [68c6beb373955da0886d8f4f5995b3922ceda4be]
      net: rework recvmsg handler msg_name and msg_namelen  logic
         [f3d3342602f8bcbf37d7c46641cb9bca7618eb1c]

Herbert Xu (1):
      crypto: s390 - Fix aes-cbc IV corruption
         [f262f0f5cad0c9eca61d1d383e3b67b57dcbe5ea]

Horia Geanta (1):
      crypto: ccm - Fix handling of zero plaintext when computing mac
         [5638cabf3e4883f38dfb246c30980cebf694fbda]

Huang Shijie (1):
      mtd: gpmi: fix kernel BUG due to racing DMA operations
         [7b3d2fb92067bcb29f0f085a9fa9fa64920a6646]

Ilija Hadzic (1):
      devpts: plug the memory leak in kill_sb
         [66da0e1f9034140ae2f571ef96e254a25083906c]

J. Bruce Fields (1):
      nfsd4: fix xdr decoding of large non-write compounds
         [365da4adebb1c012febf81019ad3dc5bb52e2a13]

James Bottomley (1):
      [SCSI] enclosure: fix WARN_ON in dual path device removing
         [a1470c7bf3a4676e62e4c0fb204e339399eb5c59]

James Ralston (1):
      ahci: Add Device IDs for Intel Wildcat Point-LP
         [9f961a5f6efc87a79571d7166257b36af28ffcfe]

Jan Kara (2):
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()
         [4adcf7fb6783e354aab38824d803fa8c4f8e8a27]
      IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()
         [603e7729920e42b3c2f4dbfab9eef4878cb6e8fa]

Jason Wang (1):
      net: flow_dissector: fail on evil iph->ihl
         [6f092343855a71e03b8d209815d8c45bf3a27fcd]

Jean Delvare (1):
      hwmon: (w83l768ng) Fix fan speed control range
         [33a7ab91d509fa33b4bcd3ce0038cc80298050da]

Jeff Moyer (1):
      block: fix race between request completion and timeout handling
         [4912aa6c11e6a5d910264deedbec2075c6f1bb73]

Jerome Glisse (1):
      radeon: workaround pinning failure on low ram gpu
         [97b6ff6be9da7675aab339334fda996d6c5077d9]

Johan Hovold (4):
      USB: mos7840: fix tiocmget error handling
         [a91ccd26e75235d86248d018fe3779732bcafd8d]
      USB: serial: fix race in generic write
         [6f6485463aada1ec6a0f3db6a03eb8e393d6bb55]
      backlight: atmel-pwm-bl: fix gpio polarity in remove
         [ad5066d4c2b1d696749f8d7816357c23b648c4d3]
      backlight: atmel-pwm-bl: fix reported brightness
         [185d91442550110db67a7dc794a32efcea455a36]

Johannes Berg (1):
      mac80211: don't attempt to reorder multicast frames
         [051a41fa4ee14f5c39668f0980973b9a195de560]

Jonathan Austin (1):
      ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD
         [30aeadd44deea3f3b0df45b9a70ee0fd5f8d6dc2]

Jukka Rissanen (1):
      6lowpan: Uncompression of traffic class field was  incorrect
         [1188f05497e7bd2f2614b99c54adfbe7413d5749]

Julius Werner (2):
      usb: hub: Clear Port Reset Change during init/resume
         [e92aee330837e4911553761490a8fb843f2053a6]
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED
         [2d51f3cd11f414c56a87dc018196b85fd50b04a4]

Junxiao Bi (1):
      configfs: fix race between dentry put and lookup
         [76ae281f6307331aa063288edb6422ae99f435f0]

KOBAYASHI Yoshitake (1):
      mmc: block: fix a bug of error handling in MMC driver
         [c8760069627ad3b0dbbea170f0c4c58b16e18d3d]

KOSAKI Motohiro (1):
      alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist
         [98d6f4dd84a134d942827584a3c5f67ffd8ec35f]

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC231 codec
         [ba4c4d0a9021ab034554d532a98133d668b87599]
      ALSA: hda/realtek - Set pcbeep amp for ALC668
         [9ad54547cf6f4410eba83bb95dfd2a0966718d6d]

Kees Cook (1):
      exec/ptrace: fix get_dumpable() incorrect tests
         [d049f74f2dbe71354d43d393ac3a188947811348]

Konstantin Khlebnikov (2):
      ARM: 7912/1: check stack pointer in get_wchan
         [1b15ec7a7427d4188ba91b9bbac696250a059d22]
      ARM: 7913/1: fix framepointer check in unwind_frame
         [3abb6671a9c04479c4bd026798a05f857393b7e2]

Larry Finger (4):
      rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP
         [78dbfecb95be4635b995af3bd29fa10013409fcd]
      rtlwifi: rtl8192cu: Fix more pointer arithmetic errors
         [eafbdde9c5629bea58df07275c5917eb42afbbe7]
      rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP
         [3545f3d5f4af715c914394123ce7725a9cf0a1c4]
      rtlwifi: rtl8192se: Fix incorrect signal strength for unassociated AP
         [b4ade797668e33b4e8353c2701ce01d7084dfafa]

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume
         [ac01810c9d2814238f08a227062e66a35a0e1ea2]

Linus Pizunski (1):
      drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap
         [eb3c227289840eed95ddfb0516046f08d8993940]

Linus Torvalds (1):
      futex: fix handling of read-only-mapped hugepages
         [f12d5bfceb7e1f9051563381ec047f7f13956c3c]

Linus Walleij (1):
      net: smc91: fix crash regression on the versatile
         [a0c20fb02592d372e744d1d739cda3e1b3defaae]

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536
         [1aeef303b5d9e243c41d5b80f8bb059366514a10]

Mahesh Rajashekhara (1):
      aacraid: prevent invalid pointer dereference
         [b4789b8e6be3151a955ade74872822f30e8cd914]

Marcelo Tosatti (1):
      KVM: perform an invalid memslot step for gpa base change
         [12d6e7538e2d418c08f082b1b44ffa5fb7270ed8]

Mark Brown (1):
      ASoC: wm8990: Mark the register map as dirty when powering down
         [2ab2b74277a86afe0dd92976db695a2bb8b93366]

Mark Cave-Ayland (1):
      rtlwifi: Fix endian error in extracting packet type
         [0c5d63f0ab6728f05ddefa25aff55e31297f95e6]

Markus Pargmann (1):
      can: c_can: Fix RX message handling, handle lost message before EOB
         [5d0f801a2ccec3b1fdabc3392c8d99ed0413d216]

Mathias Krause (3):
      audit: fix info leak in AUDIT_GET requests
         [64fbff9ae0a0a843365d922e0057fc785f23f0e3]
      audit: use nlmsg_len() to get message payload length
         [4d8fe7376a12bf4524783dd95cbc00f1fece6232]
      ipc, msg: fix message length check for negative values
         [4e9b45a19241354daec281d7a785739829b52359]

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit
         [04bf9ba720fcc4fa313fa122b799ae0989b6cd50]

Mauro Carvalho Chehab (1):
      cris: media platform drivers: fix build
         [72a0c5571351f5184195754d23db3e14495b2080]

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config
         [2bac51a1827a18821150ed8c9f9752c02f9c2b02]

Michael Neuling (2):
      powerpc/signals: Improved mark VSX not saved with small contexts fix
         [ec67ad82814bee92251fd963bf01c7a173856555]
      powerpc/signals: Mark VSX not saved with small contexts
         [c13f20ac48328b05cd3b8c19e31ed6c132b44b42]

Mikulas Patocka (8):
      blk-core: Fix memory corruption if blkcg_init_queue fails
         [fff4996b7db7955414ac74386efa5e07fd766b50]
      block: fix a probe argument to blk_register_region
         [a207f5937630dd35bd2550620bef416937a1365e]
      dm bufio: initialize read-only module parameters
         [4cb57ab4a2e61978f3a9b7d4f53988f30d61c27f]
      dm delay: fix a possible deadlock due to shared workqueue
         [718822c1c112dc99e0c72c8968ee1db9d9d910f0]
      dm snapshot: avoid snapshot space leak on crash
         [230c83afdd9cd384348475bea1e14b80b3b6b1b8]
      dm table: fail dm_table_create on dm_round_up overflow
         [5b2d06576c5410c10d95adfd5c4d8b24de861d87]
      dm: allocate buffer for messages with small number of arguments using GFP_NOIO
         [f36afb3957353d2529cb2b00f78fdccd14fc5e9c]
      loop: fix crash if blk_alloc_queue fails
         [3ec981e30fae1f3c8728a05c730acaa1f627bcfb]

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request
         [714b33d15130cbb5ab426456d4e3de842d6c5b8a]

Nikolay Aleksandrov (1):
      bonding: fix two race conditions in  bond_store_updelay/downdelay
         [b869ccfab1e324507fa3596e3e1308444fb68227]

Oliver Hartkopp (1):
      can: sja1000: fix {pre,post}_irq() handling and IRQ handler return value
         [2fea6cd303c0d0cd9067da31d873b6a6d5bd75e7]

Paul Moore (3):
      selinux: correct locking in selinux_netlbl_socket_connect)
         [42d64e1add3a1ce8a787116036163b8724362145]
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
         [47180068276a04ed31d24fe04c673138208b07a9]
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()
         [446b802437f285de68ffb8d6fac3c44c3cab5b04]

Peter Zijlstra (1):
      cpuset: Fix memory allocator deadlock
         [0fc0287c9ed1ffd3706f8b4d9b314aa102ef1245]

Phil Edworthy (1):
      ASoC: ak4642: prevent un-necessary changes to SG_SL1
         [7b5bfb82882b9b1c8423ce0ed6852ca3762d967a]

Prarit Bhargava (2):
      powerpc/vio: Fix modalias_show return values
         [e82b89a6f19bae73fb064d1b3dd91fcefbb478f4]
      powerpc/vio: use strcpy in modalias_show
         [411cabf79e684171669ad29a0628c400b4431e95]

Rashika Kheria (2):
      Staging: zram: Fix access of NULL pointer
         [46a51c80216cb891f271ad021f59009f34677499]
      Staging: zram: Fix memory leak by refcount mismatch
         [1b672224d128ec2570eb37572ff803cfe452b4f7]

Rui li (1):
      USB：add new zte 3g-dongle's pid to option.c
         [0636fc507a976cdc40f21bdbcce6f0b98ff1dfe9]

Russell King (3):
      ARM: 7527/1: uaccess: explicitly check __user pointer when !CPU_USE_DOMAINS
         [8404663f81d212918ff85f493649a7991209fa04]
      ARM: footbridge: fix VGA initialisation
         [43659222e7a0113912ed02f6b2231550b3e471ac]
      ARM: sa11x0/assabet: ensure CS2 is configured appropriately
         [f3964fe1c9d9a887d65faf594669852e4dec46e0]

Ryan Mallon (1):
      vsprintf: check real user/group id for %pK
         [312b4e226951f707e120b95b118cbc14f3d162b2]

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list
         [6d5278a68a75891db1df5ae1ecf83d288fc58c65]

Sarah Sharp (1):
      usb: Disable USB 2.0 Link PM before device reset.
         [dcc01c0864823f91c3bf3ffca6613e2351702b87]

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes
         [ff88b4724fde18056a4c539f7327389aec0f4c2d]

Sergei Trofimovich (1):
      um: add missing declaration of 'getrlimit()' and friends
         [fdfa4c952844fce881df8c76de9c7180cbe913ab]

Shan Hai (1):
      drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH drive
         [0523f037f65dba10191b0fa9c51266f90ba64630]

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST
         [d3f7d56a7a4671d395e8af87071068a195257bf6]

Shiva Krishna Merla (1):
      dm mpath: fix race condition between multipath_dtr and pg_init_done
         [954a73d5d3073df2231820c718fdd2f18b0fe4c9]

Stanislaw Gruszka (2):
      rt2400pci: fix RSSI read
         [2bf127a5cc372b9319afcbae10b090663b621c8b]
      rt2x00: check if device is still available on rt2x00mac_flush()
         [5671ab05cf2a579218985ef56595387932d78ee4]

Stefano Panella (1):
      ALSA: memalloc.h - fix wrong truncation of dma_addr_t
         [932e9dec380c67ec15ac3eb073bb55797d8b4801]

Stephen M. Cameron (2):
      [SCSI] hpsa: do not discard scsi status on aborted commands
         [2e311fbabdc23b7eaec77313dc3b9a151a5407b5]
      [SCSI] hpsa: return 0 from driver probe function on success, not 1
         [88bf6d62db4393fa03a58bada9d746312d5b496f]

Steve French (1):
      setfacl removes part of ACL when setting POSIX ACLs to Samba
         [b1d93356427be6f050dc55c86eb019d173700af6]

Steven Rostedt (5):
      ftrace: Check module functions being traced on reload
         [8c4f3c3fa9681dc549cd35419b259496082fef8b]
      ftrace: Create ftrace_hash_empty() helper routine
         [06a51d9307380c78bb5c92e68fc80ad2c7d7f890]
      ftrace: Fix ftrace hash record update with notrace
         [c842e975520f8ab09e293cc92f51a1f396251fd5]
      ftrace: Fix function graph with loading of modules
         [8a56d7761d2d041ae5e8215d20b4167d8aa93f51]
      tracing: Allow events to have NULL strings
         [4e58e54754dc1fec21c3a9e824bc108b05fdf46e]

Takashi Iwai (4):
      ALSA: 6fire: Fix probe of multiple cards
         [9b389a8a022110b4bc055a19b888283544d9eba6]
      ALSA: hda - Add support for CX20952
         [8f42d7698751a45cd9f7134a5da49bc5b6206179]
      ALSA: msnd: Avoid duplicated driver name
         [092f9cd16aac7d054af1755c945f37c1b33399e6]
      ALSA: pcsp: Fix the order of input device unregistration
         [6408eac2665955343cd0e4bcd7d6237ce39611ed]

Theodore Ts'o (1):
      ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()
         [dcb9917ba041866686fe152850364826c4622a36]

Thomas Hellstrom (1):
      drm/ttm: Fix memory type compatibility check
         [59c8e66378fb78adbcd05f0d09783dde6fef282b]

Thomas Pugliese (2):
      usb: wusbcore: change WA_SEGS_MAX to a legal value
         [f74b75e7f920c700636cccca669c7d16d12e9202]
      usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
         [7b6bc07ab554e929c85d51b3d5b26cf7f12c6a3b]

Thomas Renninger (1):
      x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error
         [11f918d3e2d3861b6931e97b3aa778e4984935aa]

Tom Lendacky (3):
      crypto: authenc - Find proper IV address in ablkcipher callback
         [fc019c7122dfcd69c50142b57a735539aec5da95]
      crypto: scatterwalk - Set the chain pointer indication bit
         [41da8b5adba77e22584f8b45f9641504fa885308]
      crypto: scatterwalk - Use sg_chain_ptr on chain entries
         [389a5390583a18e45bc4abd4439291abec5e7a63]

Trond Myklebust (3):
      NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()
         [a6f951ddbdfb7bd87d31a44f61abe202ed6ce57f]
      NFSv4: Update list of irrecoverable errors on DELEGRETURN
         [c97cf606e43b85a6cf158b810375dd77312024db]
      SUNRPC: Fix a data corruption issue when retransmitting RPC calls
         [a6b31d18b02ff9d7915c5898c9b5ca41a798cd73]

Tyler Hicks (1):
      audit: printk USER_AVC messages when audit isn't enabled
         [0868a5e150bc4c47e7a003367cd755811eb41e0b]

Ursula Braun (1):
      qeth: avoid buffer overflow in snmp ioctl
         [6fb392b1a63ae36c31f62bc3fc8630b49d602b62]

Veaceslav Falico (2):
      af_packet: block BH in prb_shutdown_retire_blk_timer()
         [ec6f809ff6f19fafba3212f6aff0dda71dfac8e8]
      bonding: don't permit to use ARP monitoring in 802.3ad  mode
         [ec9f1d15db8185f63a2c3143dc1e90ba18541b08]

Vlad Yasevich (1):
      net: core: Always propagate flag changes to interfaces
         [d2615bf450694c1302d86b9cc8a8958edfe4c3a4]

Wang Haitao (1):
      mtd: map: fixed bug in 64-bit systems
         [a4d62babf988fe5dfde24437fa135ef147bc7aa0]

Wei Yongjun (1):
      [media] saa7164: fix return value check in saa7164_initdev()
         [89f4d45b2752df5d222b5f63919ce59e2d8afaf4]

Xiangliang Yu (2):
      PCI: Define macro for Marvell vendor ID
         [8e7ee6f5dfb56a32da760d990be908ed35b1c5bf]
      ahci: disabled FBS prior to issuing software reset
         [89dafa20f3daab5b3e0c13d0068a28e8e64e2102]

Ying Xue (1):
      atm: idt77252: fix dev refcnt leak
         [b5de4a22f157ca345cdb3575207bf46402414bc1]

Yinghai Lu (1):
      PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()
         [e7cc5cf74544d97d7b69e2701595037474db1f96]

 Documentation/sysctl/kernel.txt               |  25 ++--
 Makefile                                      |   4 +-
 arch/arm/include/asm/assembler.h              |   8 ++
 arch/arm/include/asm/uaccess.h                |  40 ++++--
 arch/arm/kernel/process.c                     |   7 +-
 arch/arm/kernel/stacktrace.c                  |   2 +-
 arch/arm/lib/getuser.S                        |  23 ++--
 arch/arm/lib/putuser.S                        |   6 +
 arch/arm/mach-footbridge/common.c             |   3 +
 arch/arm/mach-footbridge/dc21285.c            |   2 -
 arch/arm/mach-integrator/integrator_cp.c      |   3 +-
 arch/arm/mach-pxa/reset.c                     |   8 +-
 arch/arm/mach-pxa/tosa.c                      | 102 +++++++--------
 arch/arm/mach-sa1100/assabet.c                |   3 +
 arch/avr32/boot/u-boot/head.S                 |  35 +++++-
 arch/avr32/kernel/entry-avr32b.S              |   3 +-
 arch/avr32/kernel/head.S                      |  20 ---
 arch/cris/include/asm/io.h                    |   1 +
 arch/ia64/include/asm/processor.h             |   2 +-
 arch/powerpc/kernel/signal_32.c               |   6 +
 arch/powerpc/kernel/signal_64.c               |   6 +
 arch/powerpc/kernel/time.c                    |   4 +-
 arch/powerpc/kernel/vio.c                     |  12 +-
 arch/s390/crypto/aes_s390.c                   |  50 ++++----
 arch/um/os-Linux/start_up.c                   |   2 +
 arch/x86/boot/Makefile                        |   6 +-
 arch/x86/boot/compressed/Makefile             |   1 +
 arch/x86/kernel/crash.c                       |   2 +-
 arch/x86/kernel/microcode_amd.c               |   2 +-
 arch/x86/kernel/reboot.c                      |  11 +-
 arch/x86/kvm/lapic.c                          |   3 +-
 arch/x86/platform/efi/efi.c                   |   5 -
 block/blk-core.c                              |   2 +
 block/blk-timeout.c                           |   3 +-
 crypto/algif_hash.c                           |   5 +-
 crypto/algif_skcipher.c                       |   4 +-
 crypto/ansi_cprng.c                           |   4 +-
 crypto/authenc.c                              |   7 +-
 crypto/ccm.c                                  |   3 +-
 drivers/ata/ahci.c                            |   6 +
 drivers/ata/ahci_platform.c                   |   1 +
 drivers/ata/libahci.c                         |  16 +++
 drivers/ata/libata-core.c                     |   1 +
 drivers/ata/libata-transport.c                |  16 +--
 drivers/atm/idt77252.c                        |   2 +-
 drivers/block/brd.c                           |   2 +-
 drivers/block/loop.c                          |   6 +-
 drivers/char/i8k.c                            |   7 ++
 drivers/connector/cn_proc.c                   |  66 ++++++----
 drivers/gpio/gpio-mpc8xxx.c                   |   8 +-
 drivers/gpu/drm/i915/intel_display.c          |   4 +
 drivers/gpu/drm/nouveau/nouveau_gem.c         |   3 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |  28 +++++
 drivers/gpu/drm/ttm/ttm_bo.c                  |  32 +++--
 drivers/hid/hid-multitouch.c                  |   2 +-
 drivers/hwmon/lm78.c                          |   2 +
 drivers/hwmon/lm90.c                          |  11 +-
 drivers/hwmon/sis5595.c                       |   2 +
 drivers/hwmon/vt8231.c                        |   2 +-
 drivers/hwmon/w83l786ng.c                     |  14 ++-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |   7 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c     |   6 +-
 drivers/isdn/isdnloop/isdnloop.c              |   8 +-
 drivers/isdn/mISDN/socket.c                   |  13 +-
 drivers/md/dm-bufio.c                         |   5 +
 drivers/md/dm-delay.c                         |  23 ++--
 drivers/md/dm-mpath.c                         |  18 ++-
 drivers/md/dm-snap.c                          |  71 +++++++++--
 drivers/md/dm-table.c                         |  23 +++-
 drivers/media/video/saa7164/saa7164-core.c    |   4 +-
 drivers/misc/enclosure.c                      |   7 ++
 drivers/mmc/card/block.c                      |  47 ++++++-
 drivers/mtd/devices/m25p80.c                  |  19 ++-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |   4 +-
 drivers/mtd/nand/nand_base.c                  |  16 ++-
 drivers/net/bonding/bond_sysfs.c              |  11 +-
 drivers/net/can/c_can/c_can.c                 |   6 +-
 drivers/net/can/sja1000/sja1000.c             |  17 +--
 drivers/net/ethernet/smsc/smc91x.h            |  22 +---
 drivers/net/ppp/pppoe.c                       |   2 -
 drivers/net/wireless/libertas/debugfs.c       |   6 +-
 drivers/net/wireless/mwifiex/sdio.c           |   3 +
 drivers/net/wireless/prism54/islpci_dev.c     |   7 +-
 drivers/net/wireless/rt2x00/rt2400pci.c       |   2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c       |   3 +
 drivers/net/wireless/rtlwifi/base.c           |  90 ++++++--------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c  |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c  |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c   |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c  |   2 +-
 drivers/net/wireless/rtlwifi/wifi.h           |   6 +-
 drivers/pci/pcie/portdrv_pci.c                |   1 -
 drivers/rtc/rtc-at91rm9200.c                  |   2 +
 drivers/s390/net/qeth_core_main.c             |   6 +-
 drivers/scsi/aacraid/commctrl.c               |   3 +-
 drivers/scsi/hpsa.c                           |   4 +-
 drivers/scsi/libsas/sas_ata.c                 |   2 +-
 drivers/staging/tidspbridge/Kconfig           |   2 +-
 drivers/staging/zram/zram_sysfs.c             |  25 ++--
 drivers/target/iscsi/iscsi_target_auth.c      |   5 +-
 drivers/target/iscsi/iscsi_target_nego.c      |   2 +-
 drivers/usb/class/cdc-acm.c                   |   2 +
 drivers/usb/core/hub.c                        |  16 ++-
 drivers/usb/dwc3/ep0.c                        |   2 +
 drivers/usb/dwc3/gadget.c                     |   5 +-
 drivers/usb/gadget/composite.c                |   1 +
 drivers/usb/serial/ftdi_sio.c                 |  31 +++--
 drivers/usb/serial/generic.c                  |   9 +-
 drivers/usb/serial/mos7840.c                  |  36 +++---
 drivers/usb/serial/option.c                   |  44 +++++++
 drivers/usb/serial/pl2303.c                   |  31 +++--
 drivers/usb/serial/spcp8x5.c                  |  30 +++--
 drivers/usb/wusbcore/wa-rpipe.c               |   5 +-
 drivers/usb/wusbcore/wa-xfer.c                |   5 +-
 drivers/video/backlight/atmel-pwm-bl.c        |   7 +-
 fs/cifs/cifssmb.c                             |   8 +-
 fs/configfs/dir.c                             |  16 ++-
 fs/devpts/inode.c                             |   1 +
 fs/exec.c                                     |   6 +
 fs/ext4/xattr.c                               |   1 +
 fs/nfs/nfs4proc.c                             |  14 ++-
 fs/nfsd/nfs4xdr.c                             |   2 +-
 fs/nfsd/vfs.c                                 | 173 +++++++++++++++-----------
 fs/xfs/xfs_ioctl.c                            |   3 +-
 fs/xfs/xfs_ioctl32.c                          |   3 +-
 include/crypto/scatterwalk.h                  |   3 +-
 include/linux/binfmts.h                       |   3 -
 include/linux/compiler-intel.h                |   2 -
 include/linux/msg.h                           |   6 +-
 include/linux/mtd/map.h                       |   4 +-
 include/linux/net.h                           |   8 ++
 include/linux/pci_ids.h                       |   1 +
 include/linux/random.h                        |   6 +-
 include/linux/sched.h                         |   4 +
 include/net/ip.h                              |   2 +-
 include/net/ipv6.h                            |   6 +-
 include/sound/memalloc.h                      |   2 +-
 include/trace/ftrace.h                        |   5 +-
 ipc/msgutil.c                                 |  12 +-
 ipc/util.h                                    |   4 +-
 kernel/audit.c                                |   7 +-
 kernel/cpuset.c                               |   8 +-
 kernel/futex.c                                |   2 +-
 kernel/irq/pm.c                               |   2 +-
 kernel/power/snapshot.c                       |   6 +-
 kernel/ptrace.c                               |   3 +-
 kernel/sched_debug.c                          |   8 ++
 kernel/sched_fair.c                           |   2 +
 kernel/time/alarmtimer.c                      |   4 +-
 kernel/trace/ftrace.c                         | 164 ++++++++++++++++--------
 lib/random32.c                                |  14 +--
 lib/vsprintf.c                                |  32 ++++-
 mm/mmap.c                                     |  15 +--
 net/appletalk/ddp.c                           |  16 ++-
 net/atm/common.c                              |   2 -
 net/ax25/af_ax25.c                            |   4 +-
 net/bluetooth/af_bluetooth.c                  |   4 -
 net/bluetooth/hci_sock.c                      |   2 -
 net/bluetooth/rfcomm/sock.c                   |   1 -
 net/bridge/br_if.c                            |   2 +
 net/caif/caif_socket.c                        |   4 -
 net/compat.c                                  |   5 +-
 net/core/dev.c                                |   4 +-
 net/core/fib_rules.c                          |   3 +-
 net/core/iovec.c                              |   3 +-
 net/core/pktgen.c                             |   7 ++
 net/ieee802154/6lowpan.c                      |   4 +-
 net/ipv4/datagram.c                           |   2 +-
 net/ipv4/ip_sockglue.c                        |   3 +-
 net/ipv4/ping.c                               |  13 +-
 net/ipv4/raw.c                                |   6 +-
 net/ipv4/tcp_ipv4.c                           |   2 +-
 net/ipv4/udp.c                                |  14 +--
 net/ipv6/datagram.c                           |   8 +-
 net/ipv6/ip6_output.c                         |   4 +-
 net/ipv6/raw.c                                |   8 +-
 net/ipv6/route.c                              |   7 +-
 net/ipv6/udp.c                                |   9 +-
 net/ipx/af_ipx.c                              |   3 +-
 net/irda/af_irda.c                            |   4 -
 net/iucv/af_iucv.c                            |   2 -
 net/key/af_key.c                              |   1 -
 net/l2tp/l2tp_ip.c                            |   4 +-
 net/l2tp/l2tp_ppp.c                           |   2 -
 net/llc/af_llc.c                              |   2 -
 net/mac80211/rx.c                             |   3 +-
 net/netlink/af_netlink.c                      |   2 -
 net/netrom/af_netrom.c                        |   3 +-
 net/nfc/rawsock.c                             |   2 -
 net/packet/af_packet.c                        |  96 +++++++-------
 net/phonet/datagram.c                         |   9 +-
 net/rds/recv.c                                |   2 -
 net/rose/af_rose.c                            |   8 +-
 net/rxrpc/ar-recvmsg.c                        |   9 +-
 net/socket.c                                  |  24 ++--
 net/sunrpc/xprtsock.c                         |  28 +++--
 net/tipc/socket.c                             |   6 -
 net/unix/af_unix.c                            |   5 -
 net/x25/af_x25.c                              |   3 +-
 security/selinux/hooks.c                      |  93 +++++++++++---
 security/selinux/netlabel.c                   |   6 +-
 sound/drivers/pcsp/pcsp.c                     |   2 +-
 sound/isa/msnd/msnd_pinnacle.c                |   4 +-
 sound/pci/hda/patch_conexant.c                |   3 +
 sound/pci/hda/patch_realtek.c                 |   2 +
 sound/soc/codecs/ak4642.c                     |   2 +-
 sound/soc/codecs/wm8731.c                     |   4 +-
 sound/soc/codecs/wm8990.c                     |   2 +
 sound/usb/6fire/chip.c                        |   2 +-
 virt/kvm/iommu.c                              |   4 +
 virt/kvm/kvm_main.c                           |  28 +++--
 212 files changed, 1571 insertions(+), 906 deletions(-)

-- 
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others.

