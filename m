Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3CDDmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60713 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886Ab3CDDmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:06 -0500
Message-Id: <20130304033707.648729212@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [ 000/153] 3.2.40-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.40 release.
There are 153 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Mar  6 02:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.39 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Adam Thomas (1):
      UBIFS: fix double free of ubifs_orphan objects
         [8afd500cb52a5d00bab4525dd5a560d199f979b9]

Al Viro (1):
      [media] omap_vout: find_vma() needs ->mmap_sem held
         [55ee64b30a38d688232e5eb2860467dddc493573]

Alan Cox (1):
      fb: rework locking to fix lock ordering on takeover
         [50e244cc793d511b86adea24972f3a7264cae114]

Alex Deucher (1):
      drm/radeon/evergreen+: wait for the MC to settle after MC  blackout
         [ed39fadd6df01095378e499fac3674883f16b853]

Alexander Duyck (1):
      igb: Remove artificial restriction on RQDPC stat reading
         [ae1c07a6b7ced6c0c94c99e3b53f4e7856fa8bff]

Alexey Klimov (1):
      [hid] usb hid quirks for Masterkit MA901 usb radio
         [0322bd3980b3ebf7dde8474e22614cb443d6479a]

Andrea Arcangeli (1):
      mm: mmu_notifier: make the mmu_notifier srcu static
         [70400303ce0c4ced3139499c676d5c79636b0c72]

Arnd Bergmann (2):
      ARM: samsung: fix assembly syntax for new gas
         [2815774bb38445006074e16251b9ef5123bdc616]
      ARM: w90x900: fix legacy assembly syntax
         [fa5ce5f94c0f2bfa41ba68d2d2524298e1fc405e]

Ashish Sangwan (1):
      ext4: fix hole punch failure when depth is greater than 0
         [968dee77220768a5f52cf8b21d0bdb73486febef]

Ben Hutchings (2):
      8250: use correct value for PORT_BRCM_TRUMANAGE
         [not upstream; fixes deviation from mainline userland ABI]
      asus-laptop: Do not call HWRS on init
         [cb7da022450cdaaebd33078b6b32fb7dd2aaf6db]

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices
         [4fa3e78be7e985ca814ce2aa0c09cbee404efcf7]

Bjørn Mork (3):
      USB: option: add Huawei "ACM" devices using protocol = vendor
         [1f3f687722fd9b29a0c2a85b4844e3b2a3585c63]
      USB: option: add Yota / Megafon M100-1 4g modem
         [cd565279e51bedee1b2988e84f9b3bef485adeb6]
      USB: option: add and update Alcatel modems
         [f8f0302bbcbd1b14655bef29f6996a2152be559d]

Christian Borntraeger (1):
      s390/kvm: Fix store status for ACRS/FPRS
         [15bc8d8457875f495c59d933b05770ba88d1eacb]

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland A-PRO support
         [7da58046482fceb17c4a0d4afefd9507ec56de7f]

Cornelia Huck (1):
      KVM: s390: Handle hosts not supporting s390-virtio.
         [55c171a6d90dc0574021f9c836127cfd1a7d2e30]

Dan Carpenter (1):
      [media] rc: unlock on error in show_protocols()
         [30ebc5e44d057a1619ad63fe32c8c1670c37c4b8]

Daniel Vetter (2):
      Revert "drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S"
         [db3985e5ca8f50fc17606855ba394783d11683a5]
      intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
         [210561ffd72d00eccf12c0131b8024d5436bae95]

Dave Airlie (3):
      drm/usb: bind driver to correct device
         [9f23de52b64f7fb801fd76f3dd8651a0dc89187b]
      fbcon: don't lose the console font across generic->chip driver switch
         [ae1287865f5361fa138d4d3b1b6277908b54eac9]
      vgacon/vt: clear buffer attributes when we load a 512 character font (v2)
         [2a2483072393b27f4336ab068a1f48ca19ff1c1e]

Dave Hansen (1):
      x86-32, mm: Rip out x86_32 NUMA remapping code
         [f03574f2d5b2d6229dcdf2d322848065f72953c7]

David Henningsson (2):
      ALSA: hda - hdmi: ELD shouldn't be valid after unplug
         [bbfd8a19b6913f50a362457c34d49bfafe5e456e]
      ALSA: hda - hdmi: Make jacks phantom, if they're not detectable
         [30efd8debd1ef30be342d374f01e993509f5b76b]

David S. Miller (1):
      sunvdc: Fix off-by-one in generic_request().
         [f4d9605434c0fd4cc8639bf25cfc043418c52362]

David Vrabel (2):
      xen-netback: cancel the credit timer when taking the vif  down
         [3e55f8b306cf305832a4ac78aa82e1b40e818ece]
      xen-netback: correctly return errors from  netbk_count_requests()
         [35876b5ffc154c357476b2c3bdab10feaf4bd8f0]

Denis Efremov (2):
      ALSA: ali5451: remove irq enabling in pointer callback
         [dacae5a19b4cbe1b5e3a86de23ea74cbe9ec9652]
      ALSA: rme32.c irq enabling after spin_lock_irq
         [f49a59c4471d81a233e09dda45187cc44fda009d]

Douglas Bagnall (1):
      [media] Avoid sysfs oops when an rc_dev's raw device is absent
         [720bb6436ff30fccad05cf5bdf961ea5b1f5686d]

Eric Dumazet (1):
      ipv6: use a stronger hash for tcp
         [08dcdbf6a7b9d14c2302c5bd0c5390ddf122f664]

Fanchaoting (1):
      umount oops when remove blocklayoutdriver first
         [5a12cca697aca5dfba42a7d4c3356acc0445a2b0]

Fangxiaozhi (1):
      USB: storage: properly handle the endian issues of idProduct
         [cd060956c5e97931c3909e4a808508469c0bb9f6]

George Spelvin (3):
      pps: Add pps_lookup_dev() function
         [513b032c98b4b9414aa4e9b4a315cb1bf0380101]
      pps: Fix a use-after free bug when unregistering a source.
         [d953e0e837e65ecc1ddaa4f9560f7925878a0de6]
      pps: Use pps_lookup_dev to reduce ldisc coupling
         [03a7ffe4e542310838bac70ef85acc17536b6d7c]

Greg Pearson (1):
      x86/apic: Use x2apic physical mode based on FADT setting
         [ea0dcf903e7d76aa5d483d876215fedcfdfe140f]

Greg Thelen (1):
      tmpfs: fix use-after-free of mempolicy object
         [5f00110f7273f9ff04ac69a5f85bb535a4fd0987]

H. Peter Anvin (2):
      timeconst.pl: Eliminate Perl warning
         [63a3f603413ffe82ad775f2d62a5afff87fd94a0]
      x86: Make sure we can boot in the case the BDA contains pure garbage
         [7c10093692ed2e6f318387d96b829320aa0ca64c]

Heiko Carstens (1):
      s390/timer: avoid overflow when programming clock comparator
         [d911e03d097bdc01363df5d81c43f69432eb785c]

Helge Deller (1):
      unbreak automounter support on 64-bit kernel with 32-bit userspace (v2)
         [4f4ffc3a5398ef9bdbb32db04756d7d34e356fcf]

Hugh Dickins (1):
      idr: make idr_get_next() good for rcu_read_lock()
         [9f7de8275b46d9d11b1505adbfe6c2bb48df4741]

Ian Abbott (4):
      staging: comedi: check s->async for poll(), read() and write()
         [cc400e185c07c15a42d2635995f422de5b94b696]
      staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors
         [754ab5c0e55dd118273ca2c217c4d95e9fbc8259]
      staging: comedi: ni_labpc: correct  differential channel sequence for AI commands
         [4c4bc25d0fa6beaf054c0b4c3b324487f266c820]
      staging: comedi: ni_labpc: set up  command4 register *after* command3
         [22056e2b46246d97ff0f7c6e21a77b8daa07f02c]

Igor Grinberg (1):
      ARM: PXA3xx: program the CSMSADRCFG register
         [d107a204154ddd79339203c2deeb7433f0cf6777]

J. Bruce Fields (1):
      svcrpc: make svc_age_temp_xprts enqueue under sv_lock
         [e75bafbff2270993926abcc31358361db74a9bc2]

James Ralston (2):
      ata_piix: Add Device IDs for Intel Lynx Point-LP PCH
         [389cd784969e9148fedcde0608f15bd74d6b769e]
      ata_piix: Add Device IDs for Intel Wellsburg PCH
         [3aee8bc52c415aba8148f144e5e5359b0fd75dd1]

Jan Beulich (2):
      xen-blkback: do not leak mode property
         [9d092603cc306ee6edfe917bf9ab8beb5f32d7bc]
      xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()
         [51ac8893a7a51b196501164e645583bf78138699]

Jan Kara (3):
      ext4: fix possible use-after-free with AIO
         [091e26dfc156aeb3b73bc5c5f277e433ad39331c]
      fs: Fix possible use-after-free with AIO
         [54c807e71d5ac59dee56c685f2b66e27cd54c475]
      ocfs2: fix possible use-after-free with AIO
         [9b171e0c74ca0549d0610990a862dd895870f04a]

Jani Nikula (1):
      drm/i915: add missing \n to UTS_RELEASE in the error_state
         [fdfa175d0a9cfa2082ce24e67e284e5acbba452a]

Jean Delvare (1):
      pcmcia/vrc4171: Add missing spinlock init
         [811af9723859884f2f771f3174f3ddedab7c53b5]

Jeff Liu (1):
      ocfs2: fix ocfs2_init_security_and_acl() to initialize acl correctly
         [32918dd9f19e5960af4cdfa41190bb843fb2247b]

Jim Somerville (1):
      inotify: remove broken mask checks causing unmount to be EINVAL
         [676a0675cf9200ac047fb50825f80867b3bb733b]

Johan Hovold (1):
      USB: serial: fix null-pointer dereferences on disconnect
         [b2ca699076573c94fee9a73cb0d8645383b602a0]

John David Anglin (1):
      [PARISC] Purge existing TLB entries in set_pte_at and ptep_set_wrprotect
         [7139bc1579901b53db7e898789e916ee2fb52d78]

Joseph Salisbury (1):
      ACPI: Add DMI entry for Sony VGN-FW41E_H
         [66f2fda93b67fa744d406e6dcf443f67bac204b6]

Josh Boyer (1):
      USB: usb-storage: unusual_devs update for Super TOP SATA bridge
         [18e03310b5caa6d11c1a8c61b982c37047693fba]

Junxiao Bi (1):
      ocfs2: unlock super lock if lockres refresh failed
         [3278bb748d2437eb1464765f36429e5d6aa91c38]

Jussi Kivilinna (1):
      rtlwifi: usb: allocate URB control message setup_packet and data buffer separately
         [bc6b89237acb3dee6af6e64e51a18255fef89cc2]

Justin Lecher (1):
      fs: cachefiles: add support for large files in filesystem caching
         [98c350cda2c14a343d34ea01a3d9c24fea5ec66d]

Kees Cook (2):
      exec: use -ELOOP for max recursion depth
         [d740269867021faf4ce38a449353d2b986c34a67]
      x86: Do not leak kernel page mapping locations
         [e575a86fdc50d013bf3ad3aa81d9100e8e6cc60d]

Konrad Rzeszutek Wilk (2):
      doc, kernel-parameters: Document 'console=hvc<n>'
         [a2fd6419174470f5ae6383f5037d0ee21ed9833f]
      doc, xen: Mention 'earlyprintk=xen' in the documentation.
         [2482a92e7d17187301d7313cfe5021b13393a0b4]

Larry Finger (3):
      b43: Increase number of RX DMA slots
         [ccae0e50c16a7f7adb029c169147400d1ce9f703]
      rtlwifi: rtl8192cu: Add new USB ID
         [8708aac79e4572ba673d7a21e94ddca9f3abb7fc]
      rtlwifi: rtl8192cu: Fix NULL dereference BUG when using new_id
         [957f4aca5fa0db69635271bc4621cc0b65b2d590]

Lars-Peter Clausen (1):
      drivers/video/backlight/adp88?0_bl.c: fix resume
         [5eb02c01bd1f3ef195989ab05e835e2b0711b5a9]

Laurent Pinchart (3):
      [media] v4l: Reset subdev v4l2_dev field to NULL if registration fails
         [317efce991620adc589b3005b9baed433dcb2a56]
      usb: Add USB_QUIRK_RESET_RESUME for all Logitech UVC webcams
         [e387ef5c47ddeaeaa3cbdc54424cdb7a28dae2c0]
      usb: Add quirk detection based on interface information
         [80da2e0df5af700518611b7d1cc4fc9945bcaf95]

Leonid Shatz (1):
      hrtimer: Prevent hrtimer_enqueue_reprogram race
         [b22affe0aef429d657bc6505aacb1c569340ddd2]

Li Wei (1):
      ipv4: fix a bug in ping_err().
         [b531ed61a2a2a77eeb2f7c88b49aa5ec7d9880d8]

Li Zefan (2):
      cgroup: fix exit() vs rmdir() race
         [71b5707e119653039e6e95213f00479668c79b75]
      cpuset: fix cpuset_print_task_mems_allowed() vs rename() race
         [63f43f55c9bbc14f76b582644019b8a07dc8219a]

Linus Torvalds (1):
      mm: fix pageblock bitmap allocation
         [7c45512df987c5619db041b5c9b80d281e26d3db]

Linus Walleij (1):
      drivers/rtc/rtc-pl031.c: restore ST variant functionality
         [3399cfb5df9594495b876d1843a7165f77366b2b]

Lukas Czerner (3):
      ext4: fix free clusters calculation in bigalloc filesystem
         [304e220f0879198b1f5309ad6f0be862b4009491]
      ext4: fix xattr block allocation/release with bigalloc
         [1231b3a1eb5740192aeebf5344dd6d6da000febf]
      ext4: rewrite punch hole to use ext4_ext_remove_space()
         [5f95d21fb6f2aaa52830e5b7fb405f6c71d3ab85]

MITSUNARI Shigeo (1):
      fs/block_dev.c: page cache wrongly left invalidated after revalidate_disk()
         [7630b661da330b35dd57b6f5d6d62b386f2dd751]

Maciej Sosnowski (1):
      dca: check against empty dca_domains list before unregister provider
         [c419fcfd071cf34ba00f9f65282583772d2655e7]

Majianpeng (1):
      nfsd: Fix memleak
         [2d32b29a1c2830f7c42caa8258c714acd983961f]

Matt Fleming (1):
      x86, efi: Make "noefi" really disable EFI runtime serivces
         [fb834c7acc5e140cf4f9e86da93a66de8c0514da]

Mel Gorman (2):
      mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard all pages
         [67d46b296a1ba1477c0df8ff3bc5e0167a0b0732]
      x86/mm: Check if PUD is large when validating a kernel address
         [0ee364eb316348ddf3e0dfcd986f5f13f528f821]

Michael S. Tsirkin (1):
      vhost: fix length for cross region descriptor
         [bd97120fc3d1a11f3124c7c9ba1d91f51829eb85]

Mika Kuoppala (1):
      drm/i915: disable shared panel fitter for pipe
         [24a1f16de97c4cf0029d9acd04be06db32208726]

Minchan Kim (1):
      zram: Fix deadlock bug in partial read/write
         [7e5a5104c6af709a8d97d5f4711e7c917761d464]

Nicholas Bellinger (2):
      target: Add missing mapped_lun bounds checking during make_mappedlun setup
         [fbbf8555a986ed31e54f006b6cc637ea4ff1425b]
      target: Fix lookup of dynamic NodeACLs during cached demo-mode operation
         [fcf29481fb8e106daad6688f2e898226ee928992]

Niu Yawei (1):
      ext4: fix race in ext4_mb_add_n_trim()
         [f1167009711032b0d747ec89a632a626c901a1ad]

Olaf Hering (1):
      x86: Hyper-V: register clocksource only if its advertised
         [32068f6527b8f1822a30671dedaf59c567325026]

Oleg Nesterov (6):
      kmod: introduce call_modprobe() helper
         [3e63a93b987685f02421e18b2aa452d20553a88b]
      kmod: make __request_module() killable
         [1cc684ab75123efe7ff446eb821d44375ba8fa30]
      tty: set_termios/set_termiox should not return -EINTR
         [183d95cdd834381c594d3aa801c1f9f9c0c54fa9]
      usermodehelper: ____call_usermodehelper() doesn't need do_exit()
         [5b9bd473e3b8a8c6c4ae99be475e6e9b27568555]
      usermodehelper: implement UMH_KILLABLE
         [d0bd587a80960d7ba7e0c8396e154028c9045c54]
      usermodehelper: introduce umh_complete(sub_info)
         [b3449922502f5a161ee2b5022a33aec8472fbf18]

Paolo Bonzini (1):
      nbd: fsync and kill block device on shutdown
         [3a2d63f87989e01437ba994df5f297528c353d7d]

Patrik Jakobsson (1):
      drm/i915: Set i9xx sdvo clock limits according to specifications
         [4f7dfb6788dd022446847fbbfbe45e13bedb5be2]

Paulo Zanoni (1):
      drm: don't add inferred modes for monitors that don't support them
         [196e077dc165a307efbd9e7569f81bbdbcf18f65]

Pawel Moll (1):
      ALSA: usb: Fix Processing Unit Descriptor parsers
         [b531f81b0d70ffbe8d70500512483227cc532608]

Phileas Fogg (1):
      powerpc/kexec: Disable hard IRQ before kexec
         [8520e443aa56cc157b015205ea53e7b9fc831291]

Philipp Reisner (1):
      idr: idr_for_each_entry() macro
         [9749f30f1a387070e6e8351f35aeb829eacc3ab6]

Rafael J. Wysocki (1):
      PCI/PM: Clean up PME state when removing a device
         [249bfb83cf8ba658955f0245ac3981d941f746ee]

Robin Holt (1):
      mmu_notifier_unregister NULL Pointer deref and multiple ->release() callouts
         [751efd8610d3d7d67b7bdf7f62646edea7365dd7]

Roger Quadros (1):
      USB: ehci-omap: Fix autoloading of module
         [04753523266629b1cd0518091da1658755787198]

Sagi Grimberg (1):
      mm: mmu_notifier: have mmu_notifiers use a global SRCU so they may safely schedule
         [21a92735f660eaecf69a6f2e777f18463760ec32]

Samuel Thibault (1):
      speakup: lower default software speech rate
         [cfd757010691eae4e17acc246f74e7622c3a2f05]

Satoru Takeuchi (1):
      efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter
         [1de63d60cd5b0d33a812efa455d5933bf1564a51]

Seiji Aguchi (1):
      pstore: Avoid deadlock in panic and emergency-restart path
         [9f244e9cfd70c7c0f82d3c92ce772ab2a92d9f64]

Seth Heasley (3):
      ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs
         [aaa515277db9585eeb4fdeb4637b9f9df50a1dd9]
      ata_piix: IDE-mode SATA patch for Intel DH89xxCC DeviceIDs
         [96d5d96aedc29c75bb16433f6ecf8664ec3c1b46]
      ata_piix: IDE-mode SATA patch for Intel Lynx Point DeviceIDs
         [78140cfec503c60a178b11fbaae2fef63e9abdc0]

Shawn Guo (1):
      mmc: sdhci-esdhc-imx: fix host version read
         [ef4d0888bb7e1b963880f086575081c3d39cad2d]

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak
         [e6c42c295e071dd74a66b5a9fcf4f44049888ed8]

Stefan Bader (1):
      xen: Send spinlock IPI to all waiters
         [76eaca031f0af2bb303e405986f637811956a422]

Stephen Hemminger (1):
      bridge: set priority of STP packets
         [547b4e718115eea74087e28d7fa70aec619200db]

Steven Rostedt (1):
      ftrace: Call ftrace cleanup module notifier after all other notifiers
         [8c189ea64eea01ca20d102ddb74d6936dd16c579]

Stoney Wang (1):
      x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems
         [cb214ede7657db458fd0b2a25ea0b28dbf900ebc]

Takashi Iwai (3):
      ALSA: aloop: Fix Oops while PM resume
         [edac894389f9c9de2a1368c78809c824b343f3a5]
      ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()
         [2ad779b7329d6894a80df94e693e72eaa0d56790]
      fb: Yet another band-aid for fixing lockdep mess
         [e93a9a868792ad71cdd09d75e5a02d8067473c4e]

Tejun Heo (6):
      block: fix synchronization and limit check in blk_alloc_devt()
         [ce23bba842aee98092225d9576dba47c82352521]
      firewire: add minor number range check to fw_device_init()
         [3bec60d511179853138836ae6e1b61fe34d9235f]
      idr: fix a subtle bug in idr_get_next()
         [6cdae7416a1c45c2ce105a78187d9b7e8feb9e24]
      idr: fix top layer handling
         [326cf0f0f308933c10236280a322031f0097205d]
      posix-timer: Don't call idr_find() with out-of-range ID
         [e182bb38d7db7494fa5dcd82da17fe0dedf60ecf]
      workqueue: consider work function when searching for busy work items
         [a2c1c57be8d9fd5b716113c8991d3d702eeacf77]

Thadeu Lima de Souza Cascardo (1):
      powerpc/eeh: Fix crash when adding a device in a slot with DDW
         [6a040ce72598159a74969a2d01ab0ba5ee6536b3]

Theodore Ts'o (3):
      ext4: fix kernel BUG on large-scale rm -rf commands
         [89a4e48f8479f8145eca9698f39fe188c982212f]
      ext4: return ENOMEM if sb_getblk() fails
         [860d21e2c585f7ee8a4ecc06f474fdc33c9474f4]
      quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format
         [c3ad83d9efdfe6a86efd44945a781f00c879b7b4]

Thomas Gleixner (1):
      genirq: Avoid deadlock in spurious handling
         [e716efde75267eab919cdb2bef5b2cb77f305326]

Tomas Henzl (1):
      block: fix ext_devt_idr handling
         [7b74e912785a11572da43292786ed07ada7e3e0c]

Tomasz Guszkowski (1):
      p54usb: corrected USB ID for T-Com Sinus 154 data II
         [008e33f733ca51acb2dd9d88ea878693b04d1d2a]

Trond Myklebust (1):
      NLM: Ensure that we resend all pending blocking locks after a reclaim
         [666b3d803a511fbc9bc5e5ea8ce66010cf03ea13]

Wei Liu (1):
      xen: close evtchn port if binding to irq fails
         [e7e44e444876478d50630f57b0c31d29f6725020]

Weston Andros Adamson (1):
      NFSv4.1: Don't decode skipped layoutgets
         [085b7a45c63d3da5be155faab9249a5cab224561]

Xi Wang (1):
      sysctl: fix null checking in bin_dn_node_address()
         [df1778be1a33edffa51d094eeda87c858ded6560]

Xiaowei.Hu (1):
      ocfs2: ac->ac_allow_chain_relink=0 won't disable group relink
         [309a85b6861fedbb48a22d45e0e079d1be993b3a]

 Documentation/kernel-parameters.txt              |    5 +
 Makefile                                         |    4 +-
 arch/arm/mach-pxa/include/mach/smemc.h           |    1 +
 arch/arm/mach-pxa/smemc.c                        |   15 +-
 arch/arm/mach-s3c2410/include/mach/debug-macro.S |   12 +-
 arch/arm/mach-s3c2410/include/mach/entry-macro.S |    4 +-
 arch/arm/mach-s3c2410/pm-h1940.S                 |    2 +-
 arch/arm/mach-s3c2410/sleep.S                    |   12 +-
 arch/arm/mach-s3c2412/sleep.S                    |   12 +-
 arch/arm/mach-w90x900/include/mach/entry-macro.S |    4 +-
 arch/arm/plat-samsung/include/plat/debug-macro.S |   18 +-
 arch/parisc/include/asm/pgtable.h                |   13 +-
 arch/parisc/kernel/cache.c                       |   18 ++
 arch/powerpc/include/asm/eeh.h                   |    3 +
 arch/powerpc/kernel/machine_kexec_64.c           |    5 +
 arch/powerpc/kernel/of_platform.c                |    3 +
 arch/powerpc/kernel/pci-common.c                 |    7 +-
 arch/powerpc/platforms/pseries/eeh.c             |   24 ++-
 arch/s390/kernel/time.c                          |    3 +
 arch/s390/kvm/kvm-s390.c                         |    8 +
 arch/x86/Kconfig                                 |    2 +-
 arch/x86/include/asm/pgtable.h                   |    5 +
 arch/x86/kernel/apic/x2apic_phys.c               |   17 +-
 arch/x86/kernel/cpu/mshyperv.c                   |    3 +-
 arch/x86/kernel/head.c                           |   53 +++--
 arch/x86/mm/fault.c                              |    8 +-
 arch/x86/mm/init_64.c                            |    3 +
 arch/x86/platform/efi/efi.c                      |   59 +++---
 arch/x86/xen/spinlock.c                          |    1 -
 block/genhd.c                                    |   15 +-
 drivers/acpi/sleep.c                             |    8 +
 drivers/ata/ata_piix.c                           |   35 ++++
 drivers/base/bus.c                               |    4 +-
 drivers/block/nbd.c                              |   10 +
 drivers/block/sunvdc.c                           |    2 +-
 drivers/block/xen-blkback/xenbus.c               |   49 +++--
 drivers/dca/dca-core.c                           |    5 +
 drivers/firewire/core-device.c                   |    4 +
 drivers/gpu/drm/drm_edid.c                       |    6 +-
 drivers/gpu/drm/drm_usb.c                        |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c              |    2 +-
 drivers/gpu/drm/i915/intel_display.c             |   12 +-
 drivers/gpu/drm/radeon/evergreen.c               |    2 +
 drivers/hid/hid-core.c                           |    1 +
 drivers/hid/hid-ids.h                            |    3 +
 drivers/iommu/intel-iommu.c                      |    8 +-
 drivers/media/rc/rc-main.c                       |    5 +-
 drivers/media/video/omap/omap_vout.c             |   12 +-
 drivers/media/video/v4l2-device.c                |   30 ++-
 drivers/mmc/host/sdhci-esdhc-imx.c               |   19 +-
 drivers/net/ethernet/intel/igb/igb_main.c        |    8 +-
 drivers/net/wireless/b43/dma.h                   |    2 +-
 drivers/net/wireless/p54/p54usb.c                |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c      |    9 +-
 drivers/net/wireless/rtlwifi/usb.c               |   49 +++--
 drivers/net/wireless/rtlwifi/usb.h               |    3 +-
 drivers/net/xen-netback/interface.c              |    3 +-
 drivers/net/xen-netback/netback.c                |    8 +-
 drivers/pci/remove.c                             |    2 +
 drivers/pcmcia/vrc4171_card.c                    |    1 +
 drivers/platform/x86/asus-laptop.c               |   17 +-
 drivers/pps/clients/pps-ldisc.c                  |   10 +-
 drivers/pps/pps.c                                |   47 ++++-
 drivers/rtc/rtc-pl031.c                          |    4 +-
 drivers/s390/kvm/kvm_virtio.c                    |   38 +++-
 drivers/staging/comedi/comedi_fops.c             |   13 +-
 drivers/staging/comedi/drivers/ni_labpc.c        |   35 ++--
 drivers/staging/speakup/speakup_soft.c           |    2 +-
 drivers/staging/zram/zram_drv.c                  |    4 +-
 drivers/target/target_core_device.c              |   13 +-
 drivers/target/target_core_fabric_configfs.c     |   12 +-
 drivers/target/target_core_tpg.c                 |   10 +-
 drivers/tty/serial/8250.c                        |    4 +-
 drivers/tty/tty_ioctl.c                          |    4 +-
 drivers/tty/vt/vt.c                              |  136 ++++++++----
 drivers/usb/core/driver.c                        |   38 ++--
 drivers/usb/core/hub.c                           |   10 +-
 drivers/usb/core/quirks.c                        |  151 ++++++++------
 drivers/usb/core/usb.h                           |    4 +
 drivers/usb/host/ehci-omap.c                     |    2 +-
 drivers/usb/serial/ftdi_sio.c                    |   20 +-
 drivers/usb/serial/mct_u232.c                    |   22 +-
 drivers/usb/serial/option.c                      |   16 +-
 drivers/usb/serial/sierra.c                      |    8 +-
 drivers/usb/serial/ssu100.c                      |   19 +-
 drivers/usb/serial/usb-serial.c                  |   15 +-
 drivers/usb/serial/usb_wwan.c                    |    8 +-
 drivers/usb/storage/initializers.c               |    4 +-
 drivers/usb/storage/unusual_cypress.h            |    2 +-
 drivers/vhost/vhost.c                            |    2 +-
 drivers/video/backlight/adp8860_bl.c             |    2 +-
 drivers/video/backlight/adp8870_bl.c             |    2 +-
 drivers/video/console/fbcon.c                    |   47 ++++-
 drivers/video/console/vgacon.c                   |   22 +-
 drivers/video/fbmem.c                            |    9 +-
 drivers/video/fbsysfs.c                          |    3 +
 drivers/xen/evtchn.c                             |   10 +
 drivers/xen/xen-pciback/pciback_ops.c            |   15 +-
 fs/binfmt_em86.c                                 |    1 -
 fs/binfmt_misc.c                                 |    6 -
 fs/binfmt_script.c                               |    4 +-
 fs/block_dev.c                                   |    4 +-
 fs/cachefiles/rdwr.c                             |    2 +-
 fs/direct-io.c                                   |    2 +-
 fs/exec.c                                        |   10 +-
 fs/ext4/balloc.c                                 |    9 +-
 fs/ext4/extents.c                                |  242 ++++++++++++----------
 fs/ext4/indirect.c                               |    9 +-
 fs/ext4/inode.c                                  |   11 +-
 fs/ext4/mballoc.c                                |    6 +-
 fs/ext4/mmp.c                                    |    2 +
 fs/ext4/page-io.c                                |    9 +-
 fs/ext4/resize.c                                 |    6 +-
 fs/ext4/xattr.c                                  |   10 +-
 fs/lockd/clntproc.c                              |    3 +
 fs/nfs/blocklayout/blocklayout.c                 |    1 +
 fs/nfs/nfs4proc.c                                |    3 +-
 fs/nfs/objlayout/objio_osd.c                     |    1 +
 fs/nfsd/nfs4state.c                              |    2 +
 fs/notify/inotify/inotify_user.c                 |    4 -
 fs/ocfs2/aops.c                                  |    2 +-
 fs/ocfs2/dlmglue.c                               |    5 +-
 fs/ocfs2/suballoc.c                              |    7 +-
 fs/ocfs2/suballoc.h                              |    2 +-
 fs/ocfs2/xattr.c                                 |    2 +-
 fs/partitions/check.c                            |    2 +-
 fs/pstore/platform.c                             |   35 +++-
 fs/ubifs/orphan.c                                |    5 +-
 fs/ubifs/ubifs.h                                 |    2 +
 include/linux/auto_fs.h                          |   25 +--
 include/linux/binfmts.h                          |    2 -
 include/linux/console.h                          |    2 +
 include/linux/fs.h                               |    2 +
 include/linux/idr.h                              |   11 +
 include/linux/kmod.h                             |    2 +
 include/linux/mmu_notifier.h                     |    1 +
 include/linux/pps_kernel.h                       |   17 +-
 include/linux/pstore.h                           |    8 +
 include/linux/quota.h                            |    1 +
 include/linux/serial_core.h                      |    4 +-
 include/linux/usb/audio.h                        |    6 +-
 include/linux/vt_kern.h                          |    3 +
 include/net/inet6_hashtables.h                   |    8 +-
 include/net/inet_sock.h                          |    1 +
 include/net/ipv6.h                               |   12 ++
 include/target/target_core_device.h              |    2 +-
 kernel/cgroup.c                                  |    8 +
 kernel/cpuset.c                                  |   12 +-
 kernel/hrtimer.c                                 |   36 ++--
 kernel/irq/spurious.c                            |    7 +-
 kernel/kmod.c                                    |   82 ++++++--
 kernel/posix-cpu-timers.c                        |   23 +-
 kernel/posix-timers.c                            |    7 +
 kernel/sysctl_binary.c                           |    3 +-
 kernel/timeconst.pl                              |    6 +-
 kernel/trace/ftrace.c                            |   46 ++--
 kernel/workqueue.c                               |   42 +++-
 lib/idr.c                                        |   51 +++--
 mm/fadvise.c                                     |   18 +-
 mm/mmu_notifier.c                                |  147 +++++++------
 mm/page_alloc.c                                  |   15 +-
 mm/shmem.c                                       |   10 +-
 net/bridge/br_stp_bpdu.c                         |    2 +
 net/ipv4/af_inet.c                               |    9 +-
 net/ipv4/ping.c                                  |    4 +-
 net/sunrpc/svc_xprt.c                            |   15 +-
 sound/drivers/aloop.c                            |    5 +-
 sound/pci/ali5451/ali5451.c                      |    2 +-
 sound/pci/hda/patch_hdmi.c                       |   10 +-
 sound/pci/rme32.c                                |    2 +-
 sound/usb/quirks-table.h                         |    2 +-
 171 files changed, 1638 insertions(+), 867 deletions(-)

-- 
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

