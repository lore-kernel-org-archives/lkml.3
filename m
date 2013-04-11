Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980Ab3DKUhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:37:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6109 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3DKU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:02 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eIhxMilvRf8A:10 a=7nUt57gPhWMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bLFOEYoiK7IA:10 a=CxJuTY6TAAAA:8 a=20KFwNOVAAAA:8 a=oFxQuJH9bZpZog646GAA:9 a=jEp0ucaQiEUA:10 a=4s4Vv4RY4JGaAX3E:21 a=dR-gIF6T2dMscf7f:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202503.783159048@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 000/171 ] 3.6.11.2-stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for 3.6.11.2 release.
There are 171 patches in this series, which will be posted as responses
to this one. If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Apr 14 2013.
Anything received after that time might be too late.

Al Viro (3):
      Nest rename_lock inside vfsmount_lock
         [7ea600b5314529f9d1b9d6d3c41cb26fce6a7a4a]
      vt: synchronize_rcu() under spinlock is not nice...
         [e8cd81693bbbb15db57d3c9aa7dd90eda4842874]
      saner proc_get_inode() calling conventions
         [d3d009cb965eae7e002ea5badf603ea8f4c34915]

Alan Stern (2):
      usb: gadget: udc-core: fix a regression during gadget driver unbinding
         [511f3c5326eabe1ece35202a404c24c0aeacc246]
      USB: EHCI: fix regression in QH unlinking
         [d714aaf649460cbfd5e82e75520baa856b4fa0a0]

Alex Deucher (3):
      drm/radeon/benchmark: make sure bo blit copy exists before using it
         [fa8d387dc3f62062a6b4afbbb2a3438094fd8584]
      drm/radeon: add support for Richland APUs
         [e4d170633fde379f39a90f8a5e7eb619b5d1144d]
      drm/radeon: add Richland pci ids
         [b75bbaa038ffc426e88ea3df6c4ae11834fc3e4f]

Amit Shah (2):
      virtio: console: add locking around c_ovq operations
         [9ba5c80b1aea8648a3efe5f22dc1f7cacdfbeeb8]
      virtio: console: rename cvq_lock to c_ivq_lock
         [165b1b8bbc17c9469b053bab78b11b7cbce6d161]

Amitkumar Karwar (1):
      mwifiex: fix race when queuing commands
         [00d7ea11ff0783e24fe70778f3141270b561aaa1]

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use
         [c1681bf8a7b1b98edee8b862a42c19c4e53205fd]

Andrzej Pietrasiewicz (1):
      usb: gadget: ffs: fix enable multiple instances
         [3416905ba058e43112ad7b1b4859797f027f5a07]

Andy Grover (1):
      target/iscsi: Fix mutual CHAP auth on big-endian arches
         [7ac9ad11b2a5cf77a92b58ee6b672ad2fa155eb1]

Ben Hutchings (5):
      sfc: Only use TX push if a single descriptor is to be written
         [fae8563b25f73dc584a07bcda7a82750ff4f7672]
      sfc: Detach net device when stopping queues for reconfiguration
         [29c69a4882641285a854d6d03ca5adbba68c0034]
      sfc: Correct efx_rx_buffer::page_offset when EFX_PAGE_IP_ALIGN != 0
         [c73e787a8db9117d59b5180baf83203a42ecadca]
      sfc: Fix efx_rx_buf_offset() in the presence of swiotlb
         [b590ace09d51cd39744e0f7662c5e4a0d1b5d952]
      sfc: Properly sync RX DMA buffer when it is not the last in the page
         [3a68f19d7afb80f548d016effbc6ed52643a8085]

Bing Zhao (2):
      mwifiex: skip pending commands after function shutdown
         [a3e240cacc93a06bff3313e28938e980d01a2160]
      mwifiex: fix potential out-of-boundary access to ibss rate table
         [5f0fabf84d7b52f979dcbafa3d3c530c60d9a92c]

CQ Tang (1):
      x86-64: Fix the failure case in copy_user_handle_tail()
         [66db3feb486c01349f767b98ebb10b0c3d2d021b]

Chris Mason (1):
      Btrfs: fix race between mmap writes and compression
         [4adaa611020fa6ac65b0ac8db78276af4ec04e63]

Chris Metcalf (1):
      tile: expect new initramfs name from hypervisor file system
         [ff7f3efb9abf986f4ecd8793a9593f7ca4d6431a]

Cong Wang (1):
      8021q: fix a potential use-after-free
         [4a7df340ed1bac190c124c1601bfc10cde9fb4fb]

Daniel Mack (2):
      ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()
         [83ea5d18d74f032a760fecde78c0210f66f7f70c]
      ALSA: snd-usb: mixer: propagate errors up the call chain
         [4d7b86c98e445b075c2c4c3757eb6d3d6efbe72e]

Daniel Pieczko (1):
      sfc: lock TX queues when calling netif_device_detach()
         [c2f3b8e3a44b6fe9e36704e30157ebe1a88c08b1]

David Vrabel (1):
      xen/blkback: correctly respond to unknown, non-native requests
         [0e367ae46503cfe7791460c8ba8434a5d60b2bd5]

David Ward (1):
      net/ipv4: Ensure that location of timestamp option is stored
         [4660c7f498c07c43173142ea95145e9dac5a6d14]

Denis V. Lunev (1):
      ipv4: fix definition of FIB_TABLE_HASHSZ
         [5b9e12dbf92b441b37136ea71dac59f05f2673a9]

Dmitry Artamonow (1):
      usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player
         [29f86e66428ee083aec106cca1748dc63d98ce23]

Dmitry Torokhov (1):
      USB: xhci - fix bit definitions for IMAN register
         [f8264340e694604863255cc0276491d17c402390]

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't send HCMD in restart flow
         [2d5d50ee596361566f7f84300117cba7d7672bc5]

Eric Dumazet (7):
      net: add a synchronize_net() in netdev_rx_handler_unregister()
         [00cfec37484761a44a3b6f4675a54caa618210ae]
      aoe: reserve enough headroom on skbs
         [91c5746425aed8f7188a351f1224a26aa232e4b3]
      tcp: preserve ACK clocking in TSO
         [f4541d60a449afd40448b06496dcd510f505928e]
      net: remove a WARN_ON() in net_enable_timestamp()
         [9979a55a833883242e3a29f3596676edd7199c46]
      tcp: dont handle MTU reduction on LISTEN socket
         [0d4f0608619de59fd8169dd8e72aadc28d80e715]
      tcp: fix skb_availroom()
         [16fad69cfe4adbbfa813de516757b87bcae36d93]
      net: qdisc busylock needs lockdep annotations
         [23d3b8bfb8eb20e7d96afa09991e6a5ed1c83164]

Eric Hutter (1):
      ARM: kirkwood: Fix chip-delay for GoFlex Net
         [2992714d431976c4b154875bd18ba61bf4df3b93]

Eric W. Biederman (3):
      ipc: Restrict mounting the mqueue filesystem
         [a636b702ed1805e988ad3d8ff8b52c060f8b341c]
      vfs: Add a mount flag to lock read only bind mounts
         [90563b198e4c6674c63672fae1923da467215f45]
      userns: Don't allow creation if the user is chrooted
         [3151527ee007b73a0ebd296010f1c0454a919c7d]

Felix Fietkau (1):
      ath9k: limit tx path hang check to normal data queues
         [01d4ab96d2e7fceaad204e5a8710ce34e229b8c5]

Hannes Frederic Sowa (4):
      ipv6: don't accept node local multicast traffic from the wire
         [1c4a154e5253687c51123956dfcee9e9dfa8542d]
      ipv6: don't accept multicast traffic with scope 0
         [20314092c1b41894d8c181bf9aa6f022be2416aa]
      atl1e: drop pci-msi support because of packet corruption
         [188ab1b105c96656f6bcfb49d0d8bb1b1936b632]
      inet: limit length of fragment queue hash table bucket lists
         [5a3da1fe9561828d0ca7eca664b16ec2b9bf0055]

Hannes Reinecke (1):
      USB: xhci: correctly enable interrupts
         [00eed9c814cb8f281be6f0f5d8f45025dc0a97eb]

Hong Zhiguo (1):
      ipv6: fix bad free of addrconf_init_net
         [a79ca223e029aa4f09abb337accf1812c900a800]

Ian Abbott (1):
      staging: comedi: s626: fix continuous acquisition
         [e4317ce877a31dbb9d96375391c1c4ad2210d637]

Iestyn C. Elfick (1):
      b43: A fix for DMA transmission sequence errors
         [b251412db99ccd4495ce372fec7daee27bf06923]

J. Bruce Fields (1):
      nfsd4: reject "negative" acl lengths
         [64a817cfbded8674f345d1117b117f942a351a69]

Jan Beulich (1):
      xen-blkback: fix dispatch_rw_block_io() error path
         [0e5e098ac22dae38f957e951b70d3cf73beff0f7]

Jan Kara (2):
      udf: Fix bitmap overflow on large filesystems with small block size
         [89b1f39eb4189de745fae554b0d614d87c8d5c63]
      jbd2: fix use after free in jbd2_journal_dirty_metadata()
         [ad56edad089b56300fd13bb9eeb7d0424d978239]

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes
         [f853c616883a8de966873a1dab283f1369e275a1]

Jiri Kosina (1):
      HID: usbhid: fix build problem
         [570637dc8eeb2faba06228d497ff40bb019bcc93]

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices
         [c2a2876e863356b092967ea62bebdb4dd663af80]

Johan Hovold (21):
      USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT
         [fc98ab873aa3dbe783ce56a2ffdbbe7c7609521a]
      USB: cypress_m8: fix use-after-free in TIOCMIWAIT
         [356050d8b1e526db093e9d2c78daf49d6bf418e3]
      USB: mct_u232: fix use-after-free in TIOCMIWAIT
         [cf1d24443677a0758cfa88ca40f24858b89261c0]
      USB: ark3116: fix use-after-free in TIOCMIWAIT
         [5018860321dc7a9e50a75d5f319bc981298fb5b7]
      USB: f81232: fix use-after-free in TIOCMIWAIT
         [508f940f1407656076a2e7d8f7fa059b567ecac2]
      USB: io_edgeport: fix use-after-free in TIOCMIWAIT
         [333576255d4cfc53efd056aad438568184b36af6]
      USB: ch341: fix use-after-free in TIOCMIWAIT
         [fa1e11d5231c001c80a479160b5832933c5d35fb]
      USB: ssu100: fix use-after-free in TIOCMIWAIT
         [43a66b4c417ad15f6d2f632ce67ad195bdf999e8]
      USB: spcp8x5: fix use-after-free in TIOCMIWAIT
         [dbcea7615d8d7d58f6ff49d2c5568113f70effe9]
      USB: mos7840: fix use-after-free in TIOCMIWAIT
         [a14430db686b8e459e1cf070a6ecf391515c9ab9]
      USB: pl2303: fix use-after-free in TIOCMIWAIT
         [40509ca982c00c4b70fc00be887509feca0bff15]
      USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
         [71ccb9b01981fabae27d3c98260ea4613207618e]
      USB: oti6858: fix use-after-free in TIOCMIWAIT
         [8edfdab37157d2683e51b8be5d3d5697f66a9f7b]
      USB: io_ti: fix use-after-free in TIOCMIWAIT
         [7b2459690584f239650a365f3411ba2ec1c6d1e0]
      USB: mos7840: fix broken TIOCMIWAIT
         [e670c6af12517d08a403487b1122eecf506021cf]
      USB: quatech2: fix use-after-free in TIOCMIWAIT
         [69f87f40d2b98e8b4ab82a121fd2bd584690b887]
      USB: serial: add modem-status-change wait queue
         [e5b33dc9d16053c2ae4c2c669cf008829530364b]
      USB: io_ti: fix get_icount for two port adapters
         [5492bf3d5655b4954164f69c02955a7fca267611]
      USB: garmin_gps: fix memory leak on disconnect
         [618aa1068df29c37a58045fe940f9106664153fd]
      USB: serial: fix interface refcounting
         [d7971051e4df825e0bc11b995e87bfe86355b8e5]
      USB: cdc-acm: fix device unregistration
         [cb25505fc604292c70fc02143fc102f54c8595f0]

Johannes Berg (1):
      mac80211: always synchronize_net() during station removal
         [27a737ff7cb062fb9cbceba9b44d60aa74862bfa]

Josef Bacik (4):
      Btrfs: fix space leak when we fail to reserve metadata space
         [f4881bc7a83eff263789dd524b7c269d138d4af5]
      Btrfs: don't drop path when printing out tree errors in scrub
         [d8fe29e9dea8d7d61fd140d8779326856478fc62]
      Btrfs: limit the global reserve to 512mb
         [fdf30d1c1b386e1b73116cc7e0fb14e962b763b0]
      Btrfs: use set_nlink if our i_nlink is 0
         [9bf7a4890518186238d2579be16ecc5190a707c0]

Joseph CHANG (1):
      DM9000B: driver initialization upgrade
         [6741f40d198c6a5feb23653a1efd4ca47f93d83d]

Josh Boyer (2):
      HID: usbhid: quirk for MSI GX680R led panel
         [620ae90ed8ca8b6e40cb9e10279b4f5ef9f0ab81]
      HID: usbhid: quirk for Realtek Multi-card reader
         [3d464d9b71ef2f2b40a4bc9dcf06794fd1be9d12]

Julia Lemire (1):
      drm/mgag200: Bug fix: Modified pll algorithm for EH project
         [260b3f1291a75a580d22ce8bfb1499c617272716]

Jussi Kivilinna (1):
      rtlwifi: usb: add missing freeing of skbuff
         [36ef0b473fbf43d5db23eea4616cc1d18cec245f]

Kees Cook (4):
      net/irda: add missing error path release_sock call
         [896ee0eee6261e30c3623be931c3f621428947df]
      tg3: fix length overflow in VPD firmware parsing
         [715230a44310a8cf66fbfb5a46f9a62a9b2de424]
      drm/i915: bounds check execbuffer relocation count
         [3118a4f652c7b12c752f3222af0447008f9b2368]
      drm/i915: restrict kernel address leak in debugfs
         [2563a4524febe8f4a98e717e02436d1aaf672aa2]

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD
         [482b0b5d82bd916cc0c55a2abf65bdc69023b843]

Larry Finger (2):
      rtlwifi: rtl8192cu: Fix problem that prevents reassociation
         [9437a248e7cac427c898bdb11bd1ac6844a1ead4]
      rtlwifi: rtl8192cu: Fix schedule while atomic bug splat
         [664899786cb49cb52f620e06ac19c0be524a7cfa]

Linus Torvalds (1):
      vfs,proc: guarantee unique inodes in /proc
         [51f0885e5415b4cc6535e9cdcc5145bfbc134353]

Luis R. Rodriguez (1):
      ath9k: avoid queueing hw check work when suspended
         [7fc0357479eeff4ca808c4d8c09bc7631f576b8d]

Mac Lin (1):
      ARM: cns3xxx: fix mapping of private memory region
         [a3d9052c6296ad3398d3ad649c3c682c3e7ecfa6]

Maciej Żenczykowski (1):
      bnx2x: fix occasional statistics off-by-4GB error
         [b009aac12cd0fe34293c68af8ac48b85be3bd858]

Marc Kleine-Budde (1):
      can: sja1000: fix define conflict on SH
         [f901b6bc404b67d96eca739857c097e022727b71]

Marek Lindner (1):
      batman-adv: verify tt len does not exceed packet len
         [b47506d91259c29b9c75c404737eb6525556f9b4]

Marek Szyprowski (1):
      ARM: DMA-mapping: add missing GFP_DMA flag for atomic buffer allocation
         [9d1400cf79afb49584b4873eb22cd5130cb341db]

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers
         [a7dc19b8652c862d5b7c4d2339bd3c428bd29c4a]

Masatake YAMATO (2):
      genetlink: trigger BUG_ON if a group name is too long
         [f1e79e208076ffe7bad97158275f1c572c04f5c7]
      thermal: shorten too long mcast group name
         [73214f5d9f33b79918b1f7babddd5c8af28dd23d]

Max.Nekludov@us.elster.com (1):
      ks8851: Fix interpretation of rxlen field.
         [14bc435ea54cb888409efb54fc6b76c13ef530e9]

Michael S. Tsirkin (1):
      vhost/net: fix heads usage of ubuf_info
         [46aa92d1ba162b4b3d6b7102440e459d4e4ee255]

Michal Schmidt (1):
      bnx2x: add missing napi deletion in error path
         [722c6f585088a2c392b4c5d01b87a584bb8fb73f]

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion
         [1ee9e2aa7b31427303466776f455d43e5e3c9275]

Mikulas Patocka (1):
      dm verity: avoid deadlock
         [3b6b7813b198b578aa7e04e4047ddb8225c37b7f]

Ming Lei (5):
      USB: serial: fix hang when opening port
         [eba0e3c3a0ba7b96f01cbe997680f6a4401a0bfc]
      sysfs: handle failure path correctly for readdir()
         [e5110f411d2ee35bf8d202ccca2e89c633060dca]
      sysfs: fix race between readdir and lseek
         [991f76f837bf22c5bb07261cfd86525a0a96650c]
      Bluetooth: Add support for Dell[QCA 0cf3:817a]
         [ebaf5795ef57a70a042ea259448a465024e2821d]
      Bluetooth: Add support for Dell[QCA 0cf3:0036]
         [d66629c1325399cf080ba8b2fb086c10e5439cdd]

Mirko Lindner (2):
      sky2: Threshold for Pause Packet is set wrong
         [74f9f42c1c1650e74fb464f76644c9041f996851]
      sky2: Receive Overflows not counted
         [9cfe8b156c21cf340b3a10ecb3022fbbc1c39185]

Mugunthan V N (2):
      drivers: net: ethernet: cpsw: use netif_wake_queue() while restarting tx queue
         [b56d6b3fca6d1214dbc9c5655f26e5d4ec04afc8]
      drivers: net: ethernet: davinci_emac: use netif_wake_queue() while restarting tx queue
         [7e51cde276ca820d526c6c21cf8147df595a36bf]

Nicholas Bellinger (1):
      target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os
         [f002a24388cc460c8a9be7d446a9871f7c9d52b6]

Nithin Sujir (1):
      tg3: 5715 does not link up when autoneg off
         [7c6cdead7cc9a99650d15497aae47d7472217eb1]

Paul Moore (1):
      unix: fix a race condition in unix_release()
         [ded34e0fe8fe8c2d595bfa30626654e4b87621e0]

Pavel Emelyanov (1):
      skb: Propagate pfmemalloc on skb from head page only
         [cca7af3889bfa343d33d5e657a38d876abd10e58]

Pawel Wieczorkiewicz (1):
      tty: atmel_serial_probe(): index of atmel_ports[] fix
         [503bded92da283b2f31d87e054c4c6d30c3c2340]

Rafael J. Wysocki (1):
      ACPI: Rework acpi_get_child() to be more efficient
         [33f767d767e9a684e9cd60704d4c049a2014c8d5]

Rafał Miłecki (2):
      b43: N-PHY: use more bits for offset in RSSI calibration
         [2e1253d640eb7f8707d2591c93097c1e9f9c71d5]
      b43: N-PHY: increase initial value of "mind" in RSSI calibration
         [e67dd874e60529dbd2e8232babb1e23479ba2ffa]

Soeren Moch (1):
      USB: EHCI: fix bug in iTD/siTD DMA pool allocation
         [85ecd0322b9a1a9f451d9150e9460ab42fd17219]

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support
         [4c51e53689569398d656e631c17308d9b8e84650]

Steven Rostedt (Red Hat) (7):
      tracing: Prevent buffer overwrite disabled for latency tracers
         [613f04a0f51e6e68ac6fe571ab79da3c0a5eb4da]
      tracing: Keep overwrite in sync between regular and snapshot buffers
         [80902822658aab18330569587cdb69ac1dfdcea8]
      tracing: Protect tracer flags with trace_types_lock
         [69d34da2984c95b33ea21518227e1f9470f11d95]
      tracing: Fix free of probe entry by calling call_rcu_sched()
         [740466bc89ad8bd5afcc8de220f715f62b21e365]
      tracing: Fix race in snapshot swapping
         [2721e72dd10f71a3ba90f59781becf02638aa0d9]
      ppp: Revert backport of "ppp: set qdisc_tx_busylock to avoid LOCKDEP splat"
      IP_GRE: Revert "IP_GRE: Fix kernel panic in IP_GRE with GRE csum"

Takashi Iwai (4):
      drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()
         [9d1a455b0ca1c2c956b4d9ab212864a8695270f1]
      Revert "drm/i915: try to train DP even harder"
         [3b4f819d5eac94ba8fe5e8c061f6dabfe8d7b22c]
      ALSA: hda - Fix typo in checking IEC958 emphasis bit
         [a686fd141e20244ad75f80ad54706da07d7bb90a]
      ALSA: hda/cirrus - Fix the digital beep registration
         [a86b1a2cd2f81f74e815e07f756edd7bc5b6f034]

Theodore Ts'o (2):
      ext4: fix data=journal fast mount/umount hang
         [2b405bfa84063bfa35621d2d6879f52693c614b0]
      ext4: use atomic64_t for the per-flexbg free_clusters count
         [90ba983f6889e65a3b506b30dc606aa9d1d46cd2]

Tkhai Kirill (1):
      sunsu: Fix panic in case of nonexistent port at "console=ttySY" cmdline option
         [cb29529ea0030e60ef1bbbf8399a43d397a51526]

Torsten Duwe (2):
      KMS: fix EDID detailed timing frame rate
         [c19b3b0f6eed552952845e4ad908dba2113d67b4]
      KMS: fix EDID detailed timing vsync parsing
         [16dad1d743d31a104a849c8944e6b9eb479f6cd7]

Trond Myklebust (4):
      NFSv4.1: Always clear the NFS_INO_LAYOUTCOMMIT in layoutreturn
         [24956804349ca0eadcdde032d65e8c00b4214096]
      NFSv4.1: Fix a race in pNFS layoutcommit
         [a073dbff359f4741013ae4b8395f5364c5e00b48]
      NFSv4: Fix the string length returned by the idmapper
         [cf4ab538f1516606d3ae730dce15d6f33d96b7e1]
      SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queue_locked
         [1166fde6a923c30f4351515b6a9a1efc513e7d00]

Veaceslav Falico (5):
      bonding: get netdev_rx_handler_unregister out of locks
         [fcd99434fb5c137274d2e15dd2a6a7455f0f29ff]
      pch_gbe: fix ip_summed checksum reporting on rx
         [76a0e68129d7d24eb995a6871ab47081bbfa0acc]
      bonding: remove already created master sysfs link on failure
         [9fe16b78ee17579cb4f333534cf7043e94c67024]
      bonding: don't call update_speed_duplex() under spinlocks
         [876254ae2758d50dcb08c7bd00caf6a806571178]
      netconsole: don't call __netpoll_cleanup() while atomic
         [3f315bef23075ea8a98a6fe4221a83b83456d970]

Vijay Subramanian (1):
      net: fq_codel: Fix off-by-one error
         [cd68ddd4c29ab523440299f24ff2417fe7a0dca6]

Ville Syrjälä (1):
      drm/i915: Don't clobber crtc->fb when queue_flip fails
         [4a35f83b2b7c6aae3fc0d1c4554fdc99dc33ad07]

Vivek Gautam (1):
      usb: xhci: Fix TRB transfer length macro used for Event TRB.
         [1c11a172cb30492f5f6a82c6e118fdcd9946c34f]

Vlad Yasevich (2):
      rtnetlink: Mask the rta_type when range checking
         [a5b8db91442fce9c9713fcd656c3698f1adde1d6]
      sctp: Use correct sideffect command in duplicate cookie handling
         [f2815633504b442ca0b0605c16bf3d88a3a0fcea]

Vladimir Davydov (1):
      mqueue: sys_mq_open: do not call mnt_drop_write() if read-only
         [38d78e587d4960d0db94add518d27ee74bad2301]

Wanpeng Li (1):
      mm/hugetlb: fix total hugetlbfs pages count when using memory overcommit accouting
         [d00285884c0892bb1310df96bce6056e9ce9b9d9]

Xufeng Zhang (1):
      sctp: don't break the loop while meeting the active_path so as to find the matched transport
         [2317f449af30073cfa6ec8352e4a65a89e357bdd]

Yuchung Cheng (1):
      tcp: undo spurious timeout after SACK reneging
         [7ebe183c6d444ef5587d803b64a1f4734b18c564]

Zheng Liu (1):
      ext4: fix the wrong number of the allocated blocks in ext4_split_extent()
         [3a2256702e47f68f921dfad41b1764d05c572329]

fanchaoting (1):
      pnfs-block: removing DM device maybe cause oops when call dev_remove
         [4376c94618c26225e69e17b7c91169c45a90b292]

nikolay@redhat.com (2):
      bonding: fix disabling of arp_interval and miimon
         [1bc7db16782c2a581fb4d53ca853631050f31611]
      bonding: fix miimon and arp_interval delayed work race conditions
         [fbb0c41b814d497c656fc7be9e35456f139cb2fb]

----
 arch/arm/boot/dts/kirkwood-goflexnet.dts           |    1 +
 arch/arm/mach-cns3xxx/core.c                       |   16 +-
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h       |   16 +-
 arch/arm/mm/dma-mapping.c                          |    5 +-
 arch/tile/kernel/setup.c                           |   25 ++-
 arch/x86/lib/usercopy_64.c                         |    4 +-
 drivers/acpi/glue.c                                |   35 ++--
 drivers/block/aoe/aoecmd.c                         |    3 +-
 drivers/block/loop.c                               |    9 +-
 drivers/block/xen-blkback/blkback.c                |   38 +++-
 drivers/block/xen-blkback/common.h                 |   25 +++
 drivers/bluetooth/ath3k.c                          |    4 +
 drivers/bluetooth/btusb.c                          |    2 +
 drivers/char/virtio_console.c                      |   22 +-
 drivers/gpu/drm/drm_edid.c                         |    3 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |    2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   11 +-
 drivers/gpu/drm/i915/intel_display.c               |   11 +-
 drivers/gpu/drm/i915/intel_dp.c                    |   14 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   10 +-
 drivers/gpu/drm/radeon/ni.c                        |   11 +-
 drivers/gpu/drm/radeon/radeon_benchmark.c          |   16 +-
 drivers/hid/hid-ids.h                              |    6 +
 drivers/hid/usbhid/hid-quirks.c                    |    2 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |    8 +-
 drivers/iommu/amd_iommu.c                          |   22 +-
 drivers/md/dm-bufio.c                              |    2 +
 drivers/md/dm-verity.c                             |   39 +++-
 drivers/net/bonding/bond_main.c                    |   97 +++------
 drivers/net/bonding/bond_sysfs.c                   |  121 ++++++-----
 drivers/net/can/sja1000/plx_pci.c                  |    4 +-
 drivers/net/can/sja1000/sja1000.c                  |    6 +-
 drivers/net/can/sja1000/sja1000.h                  |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |    1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   19 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h  |    3 +-
 drivers/net/ethernet/broadcom/tg3.c                |   15 +-
 drivers/net/ethernet/davicom/dm9000.c              |  214 ++++++++++----------
 drivers/net/ethernet/davicom/dm9000.h              |   11 +-
 drivers/net/ethernet/marvell/sky2.c                |    2 +-
 drivers/net/ethernet/marvell/sky2.h                |    2 +-
 drivers/net/ethernet/micrel/ks8851.c               |    2 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    4 +-
 drivers/net/ethernet/sfc/efx.c                     |   20 +-
 drivers/net/ethernet/sfc/efx.h                     |   13 ++
 drivers/net/ethernet/sfc/net_driver.h              |    4 +-
 drivers/net/ethernet/sfc/nic.c                     |    3 +-
 drivers/net/ethernet/sfc/rx.c                      |   25 ++-
 drivers/net/ethernet/sfc/selftest.c                |    2 +-
 drivers/net/ethernet/ti/cpsw.c                     |    2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    2 +-
 drivers/net/netconsole.c                           |   15 +-
 drivers/net/ppp/ppp_generic.c                      |    8 -
 drivers/net/usb/smsc75xx.c                         |   12 +-
 drivers/net/wireless/ath/ath9k/link.c              |   29 +--
 drivers/net/wireless/b43/dma.c                     |   65 ++++--
 drivers/net/wireless/b43/phy_n.c                   |    8 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |    9 +
 drivers/net/wireless/iwlwifi/dvm/ucode.c           |    4 +-
 drivers/net/wireless/mwifiex/cmdevt.c              |   22 +-
 drivers/net/wireless/mwifiex/join.c                |    7 +-
 drivers/net/wireless/mwifiex/main.h                |    4 +-
 drivers/net/wireless/mwifiex/scan.c                |    8 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   89 ++++----
 drivers/net/wireless/rtlwifi/usb.c                 |    1 +
 drivers/staging/comedi/drivers/s626.c              |    2 +-
 drivers/target/iscsi/iscsi_target_auth.c           |    5 +-
 drivers/target/target_core_file.h                  |    2 +-
 drivers/tty/serial/atmel_serial.c                  |   11 +-
 drivers/tty/serial/sunsu.c                         |   21 +-
 drivers/tty/vt/vc_screen.c                         |    6 +-
 drivers/usb/class/cdc-acm.c                        |    3 +-
 drivers/usb/core/hcd-pci.c                         |   23 ++-
 drivers/usb/gadget/g_ffs.c                         |    4 +-
 drivers/usb/gadget/udc-core.c                      |    2 +-
 drivers/usb/host/ehci-sched.c                      |    2 +
 drivers/usb/host/ehci-timer.c                      |    2 +-
 drivers/usb/host/xhci-ring.c                       |   24 +--
 drivers/usb/host/xhci.c                            |    3 +-
 drivers/usb/host/xhci.h                            |    8 +-
 drivers/usb/serial/ark3116.c                       |   10 +-
 drivers/usb/serial/ch341.c                         |   11 +-
 drivers/usb/serial/cypress_m8.c                    |   14 +-
 drivers/usb/serial/f81232.c                        |    9 +-
 drivers/usb/serial/ftdi_sio.c                      |   20 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |    7 +
 drivers/usb/serial/garmin_gps.c                    |    7 +-
 drivers/usb/serial/io_edgeport.c                   |   12 +-
 drivers/usb/serial/io_ti.c                         |   13 +-
 drivers/usb/serial/mct_u232.c                      |   13 +-
 drivers/usb/serial/mos7840.c                       |   16 +-
 drivers/usb/serial/oti6858.c                       |   10 +-
 drivers/usb/serial/pl2303.c                        |   11 +-
 drivers/usb/serial/quatech2.c                      |   12 +-
 drivers/usb/serial/spcp8x5.c                       |    9 +-
 drivers/usb/serial/ssu100.c                        |   12 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   10 +-
 drivers/usb/serial/usb-serial.c                    |    4 +-
 drivers/usb/storage/unusual_devs.h                 |    7 +
 drivers/vhost/net.c                                |    3 +-
 fs/block_dev.c                                     |    1 +
 fs/btrfs/extent-tree.c                             |   49 ++++-
 fs/btrfs/extent_io.c                               |   33 +++
 fs/btrfs/extent_io.h                               |    2 +
 fs/btrfs/inode.c                                   |   14 ++
 fs/btrfs/scrub.c                                   |    3 +-
 fs/btrfs/tree-log.c                                |    5 +-
 fs/cifs/asn1.c                                     |   53 +----
 fs/dcache.c                                        |   16 +-
 fs/ext4/ext4.h                                     |    6 +-
 fs/ext4/extents.c                                  |    6 +-
 fs/ext4/ialloc.c                                   |    4 +-
 fs/ext4/inode.c                                    |    3 +-
 fs/ext4/mballoc.c                                  |   12 +-
 fs/ext4/super.c                                    |    4 +-
 fs/jbd2/transaction.c                              |   15 +-
 fs/namespace.c                                     |   28 +++
 fs/nfs/blocklayout/blocklayoutdm.c                 |    4 +-
 fs/nfs/idmap.c                                     |   13 +-
 fs/nfs/nfs4proc.c                                  |   14 --
 fs/nfs/pnfs.c                                      |   54 ++++-
 fs/nfsd/nfs4xdr.c                                  |    2 +-
 fs/proc/generic.c                                  |   21 +-
 fs/proc/inode.c                                    |   11 +-
 fs/sysfs/dir.c                                     |   17 +-
 fs/udf/udf_sb.h                                    |    2 +-
 include/drm/drm_pciids.h                           |   13 +-
 include/linux/fs_struct.h                          |    2 +
 include/linux/mount.h                              |    2 +
 include/linux/netdevice.h                          |    2 +
 include/linux/skbuff.h                             |   13 +-
 include/linux/thermal.h                            |    2 +-
 include/linux/usb/serial.h                         |    2 +
 include/net/inet_frag.h                            |    9 +
 include/net/ip_fib.h                               |   12 +-
 include/xen/interface/io/blkif.h                   |   10 +
 ipc/mqueue.c                                       |   15 +-
 kernel/time/tick-broadcast.c                       |    3 +-
 kernel/trace/ftrace.c                              |    4 +-
 kernel/trace/trace.c                               |   61 ++++--
 kernel/trace/trace.h                               |    6 +
 kernel/trace/trace_irqsoff.c                       |   19 +-
 kernel/trace/trace_sched_wakeup.c                  |   18 +-
 kernel/user_namespace.c                            |    9 +
 mm/hugetlb.c                                       |    8 +-
 net/8021q/vlan.c                                   |   14 +-
 net/batman-adv/bat_iv_ogm.c                        |    6 +-
 net/core/dev.c                                     |    7 +-
 net/core/rtnetlink.c                               |    2 +-
 net/ipv4/inet_fragment.c                           |   20 +-
 net/ipv4/ip_fragment.c                             |   11 +-
 net/ipv4/ip_gre.c                                  |    6 +-
 net/ipv4/ip_options.c                              |    5 +-
 net/ipv4/tcp.c                                     |    2 +-
 net/ipv4/tcp_input.c                               |    7 +-
 net/ipv4/tcp_ipv4.c                                |   14 +-
 net/ipv4/tcp_output.c                              |    8 +-
 net/ipv6/addrconf.c                                |   26 +--
 net/ipv6/ip6_input.c                               |   21 ++
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   12 +-
 net/ipv6/reassembly.c                              |    8 +-
 net/ipv6/tcp_ipv6.c                                |    7 +
 net/irda/af_irda.c                                 |    6 +-
 net/l2tp/l2tp_eth.c                                |    3 +-
 net/mac80211/sta_info.c                            |   12 +-
 net/netlink/genetlink.c                            |    1 +
 net/sched/sch_fq_codel.c                           |    2 +-
 net/sched/sch_generic.c                            |    9 +-
 net/sctp/associola.c                               |    2 +-
 net/sctp/sm_statefuns.c                            |    2 +-
 net/sunrpc/sched.c                                 |    9 +-
 net/unix/af_unix.c                                 |    7 +-
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/hda/patch_conexant.c                     |    8 +-
 sound/usb/mixer.c                                  |   16 +-
 177 files changed, 1453 insertions(+), 960 deletions(-)
