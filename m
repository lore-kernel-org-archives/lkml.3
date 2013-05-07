Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab3EGEQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:16:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3EGD6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:43 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eIhxMilvRf8A:10 a=5wqAjsmJL0cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bLFOEYoiK7IA:10 a=20KFwNOVAAAA:8 a=1ikil4_HKmJlE5ppB38A:9 a=jEp0ucaQiEUA:10 a=orT5xgho8cOzugqy:21 a=05blLZwOt2-AQk8N:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035712.909872333@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [000/126] 3.6.11.3-stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for 3.6.11.3 release.
There are 126 patches in this series, which will be posted as responses
to this one. If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu May 9 23:54:01.
Anything received after that time might be too late.

Aaro Koskinen (1):
      ARM: 7692/1: iop3xx: move IOP3XX_PERIPHERAL_VIRT_BASE
         [f5d6a1441a5045824f36ff7c6b6bbae0373472a6]

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running
         [f1ca493b0b5e8f42d3b2dc8877860db2983f47b6]

Alex Williamson (1):
      vfio-pci: Fix possible integer overflow
         [904c680c7bf016a8619a045850937427f8d7368c]

Anatolij Gustschin (1):
      spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts
         [1ad849aee5f53353ed88d9cd3d68a51b03a7d44f]

Andrew Honig (1):
      KVM: Allow cross page reads and writes from cached translations.
         [8f964525a121f2ff2df948dac908dcc65be21b5b]

Andy Honig (3):
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)
         [a2c118bfab8bc6b8bb213abfc35201e441693d55]
      KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache functions (CVE-2013-1797)
         [0b79459b482e85cb7426aa7da683a9f2c97aeae1]
      KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
         [c300aa64ddf57d9c5d9c898a64b36877345dd4a9]

Arnd Bergmann (1):
      block: avoid using uninitialized value in from queue_var_store
         [c678ef5286ddb5cf70384ad5af286b0afc9b73e1]

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case
         [67e753ca41782913d805ff4a8a2b0f60b26b7915]

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after loopback down-up
         [25fb6ca4ed9cad72f14f61629b68dc03c0d9713f]

Ben Greear (1):
      net: rate-limit warn-bad-offload splats.
         [c846ad9b880ece01bb4d8d07ba917734edf0324f]

Boris Ostrovsky (1):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal
         [511ba86e1d386f671084b5d0e6f110bb30b8eeb2]

Christoph Fritz (1):
      can: sja1000: fix handling on dt properties on little endian systems
         [0443de5fbf224abf41f688d8487b0c307dc5a4b4]

Christoph Paasch (1):
      ipv6/tcp: Stop processing ICMPv6 redirect messages
         [50a75a8914539c5dcd441c5f54d237a666a426fd]

Christopher Harvey (1):
      drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not decimal.
         [1812a3db0874be1d1524086da9e84397b800f546]

Dave Airlie (1):
      udl: handle EDID failure properly.
         [1baee58638fc58248625255f5c5fcdb987f11b1f]

Dave Hansen (1):
      x86-32: Fix possible incomplete TLB invalidate with PAE pagetables
         [1de14c3c5cbc9bb17e9dcc648cda51c0c85d54b9]

David Henningsson (1):
      ALSA: hda - fix typo in proc output
         [aeb3a97222832e5457c4b72d72235098ce4bfe8d]

David Woodhouse (1):
      mtd: Disable mtdchar mmap on MMU systems
         [f5cf8f07423b2677cebebcebc863af77223a4972]

Dmitry Popov (1):
      tcp: incoming connections might use wrong route under synflood
         [d66954a066158781ccf9c13c91d0316970fe57b6]

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*
         [889d66848b12d891248b03abcb2a42047f8e172a]

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls
         [b9e146d8eb3b9ecae5086d373b50fa0c1f3e7f0f]

Eric Dumazet (2):
      net: drop dst before queueing fragments
         [97599dc792b45b1669c3cdb9a4b365aad0232f65]
      tcp: call tcp_replace_ts_recent() from tcp_ack()
         [12fb3dd9dc3c64ba7d64cec977cca9b5fb7b1d4e]

Eric W. Biederman (1):
      af_unix: If we don't care about credentials coallesce all messages
         [0e82e7f6dfeec1013339612f74abc2cdd29d43d2]

Felix Fietkau (2):
      ath9k_hw: change AR9580 initvals to fix a stability issue
         [f09a878511997c25a76bf111a32f6b8345a701a5]
      ath9k_htc: accept 1.x firmware newer than 1.3
         [319e7bd96aca64a478f3aad40711c928405b8b77]

Girish K S (1):
      spi/s3c64xx: modified error interrupt handling and init
         [375981f2e14868be16cafbffd34a4f16a6ee01c6]

Hannes Frederic Sowa (1):
      atl1e: limit gso segment size to prevent generation of wrong ip length fields
         [31d1670e73f4911fe401273a8f576edc9c2b5fea]

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()
         [6f389a8f1dd22a24f3d9afc2812b30d639e94625]

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon
         [cd272d1ea71583170e95dde02c76166c7f9017e6]

Jan Beulich (1):
      x86: Fix rebuild with EFI_STUB enabled
         [918708245e92941df16a634dc201b407d12bcd91]

Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling
         [5000c418840b309251c5887f0b56503aae30f84c]

Jan Stancek (1):
      mm: prevent mmap_cache race in find_vma()
         [b6a9b7f6b1f21735a7456d534dc0e68e61359d2c]

Jani Nikula (3):
      drm/i915: add quirk to invert brightness on Packard Bell NCL20
         [5559ecadad5a73b27f863e92f4b4f369501dce6f]
      drm/i915: add quirk to invert brightness on eMachines e725
         [01e3a8feb40e54b962a20fa7eb595c5efef5e109]
      drm/i915: add quirk to invert brightness on eMachines G725
         [1ffff60320879830e469e26062c18f75236822ba]

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources
         [aa8b4be3ac049c8b1df2a87e4d1d902ccfc1f7a9]

Jiri Slaby (2):
      TTY: fix atime/mtime regression
         [37b7f3c76595e23257f61bd80b223de8658617ee]
      TTY: do not update atime/mtime on read/write
         [b0de59b5733d18b0d1974a060860a8b5c1b36a2e]

Johannes Berg (2):
      mac80211: fix cfg80211 interaction on auth/assoc request
         [7b119dc06d871405fc7c3e9a73a6c987409ba639]
      mac80211: fix remain-on-channel cancel crash
         [3fbd45ca8d1c98f3c2582ef8bc70ade42f70947b]

Jonghwan Choi (1):
      cpufreq: exynos: Get booting freq value in exynos_cpufreq_init
         [6e45eb12fd1c741d556bf264ee98853b5f3104e5]

Josef Bacik (1):
      Btrfs: make sure nbytes are right after log replay
         [4bc4bee4595662d8bff92180d5c32e3313a704b0]

Jussi Kivilinna (1):
      crypto: gcm - fix assumption that assoc has one segment
         [d3dde52209ab571e4e2ec26c66f85ad1355f7475]

Lars-Peter Clausen (3):
      regmap: cache Fix regcache-rbtree sync
         [8abac3ba51b5525354e9b2ec0eed1c9e95c905d9]
      ASoC: spear_pcm: Update to new pcm_new() API
         [59d9cc2a5073ab4b8c8f8bdbacf230a538abc55d]
      ASoC: dma-sh7760: Fix compile error
         [417a1178f1bf3cdc606376b3ded3a22489fbb3eb]

Li Fei (1):
      hwspinlock: fix __hwspin_lock_request error path
         [c10b90d85a5126d25c89cbaa50dc9fdd1c4d001a]

Linus Torvalds (9):
      net: fix incorrect credentials passing
         [83f1b4ba917db5dc5a061a44b3403ddb6e783494]
      Add file_ns_capable() helper function for open-time capability checking
         [935d8aabd4331f47a89c3e1daa5779d23cf244ee]
      vm: convert mtdchar mmap to vm_iomap_memory() helper
         [8558e4a26b00225efeb085725bc319f91201b239]
      vm: convert HPET mmap to vm_iomap_memory() helper
         [2323036dfec8ce3ce6e1c86a49a31b039f3300d1]
      vm: convert fb_mmap to vm_iomap_memory() helper
         [fc9bbca8f650e5f738af8806317c0a041a48ae4a]
      vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
         [0fe09a45c4848b5b5607b968d959fdc1821c161d]
      vm: add vm_iomap_memory() helper function
         [b4cbb197c7e7a68dbad0d491242e3ca67420c13e]
      kobject: fix kset_find_obj() race with concurrent last kobject_put()
         [a49b7e82cab0f9b41f483359be83f44fbb6b4979]
      spinlocks and preemption points need to be at least compiler barriers
         [386afc91144b36b42117b0092893f15bc8798a80]

Linus Walleij (1):
      crypto: ux500 - add missing comma
         [d47cbd5bcee7c7a08fc0283dda465375fa1b1fda]

Lukasz Dorau (1):
      libsas: fix handling vacant phy in sas_set_ex_phy()
         [d4a2618fa77b5e58ec15342972bd3505a1c3f551]

Marc Kleine-Budde (1):
      can: mcp251x: add missing IRQF_ONESHOT to request_threaded_irq
         [db388d6460ffa53b3b38429da6f70a913f89b048]

Markus Pargmann (1):
      ARM: clk-imx35: Bugfix iomux clock
         [cab1e0a36c9dd0b0671fb84197ed294513f5adc1]

Mathias Krause (14):
      tipc: fix info leaks via msg_name in recv_msg/recv_stream
         [60085c3d009b0df252547adb336d1ccca5ce52ec]
      rose: fix info leak via msg_name in rose_recvmsg()
         [4a184233f21645cf0b719366210ed445d1024d72]
      NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
         [d26d6504f23e803824e8ebd14e52d4fc0a0b09cb]
      netrom: fix info leak via msg_name in nr_recvmsg()
         [3ce5efad47b62c57a4f5c54248347085a750ce0e]
      llc: Fix missing msg_namelen update in llc_ui_recvmsg()
         [c77a4b9cffb6215a15196ec499490d116dfad181]
      l2tp: fix info leak in l2tp_ip6_recvmsg()
         [b860d3cc62877fad02863e2a08efff69a19382d2]
      iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
         [a5598bd9c087dc0efc250a5221e5d0e6f584ee88]
      irda: Fix missing msg_namelen update in irda_recvmsg_dgram()
         [5ae94c0d2f0bed41d6718be743985d61b7f5c47d]
      caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
         [2d6fbfe733f35c6b355c216644e08e149c61b271]
      Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_recvmsg()
         [e11e0455c0d7d3d62276a0c55d9dfbc16779d691]
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
         [4683f42fde3977bdb4e8a09622788cc8b5313778]
      ax25: fix info leak via msg_name in ax25_recvmsg()
         [ef3313e84acbf349caecae942ab3ab731471f1a1]
      atm: update msg_namelen in vcc_recvmsg()
         [9b3e617f3df53822345a8573b6d358f6b9e5ed87]
      crypto: algif - suppress sending source address information in recvmsg
         [72a763d805a48ac8c0bf48fdb510e84c12de51fe]

Matt Carlson (1):
      tg3: Add 57766 device support.
         [d3f677afb8076d09d090ff0a5d1229c9dd9f136e]

Maxim Mikityanskiy (1):
      msi-wmi: Fix memory leak
         [51c94491c82c3d9029f6e87a1a153db321d88e35]

Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP
         [84cc8fd2fe65866e49d70b38b3fdf7219dd92fe0]

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header length
         [88c5b5ce5cb57af6ca2a7cf4d5715fa320448ff9]

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test
         [9fb2640159f9d4f5a2a9d60e490482d4cbecafdb]

Namhyung Kim (2):
      tracing: Fix possible NULL pointer dereferences
         [6a76f8c0ab19f215af2a3442870eeb5f0e81998d]
      tracing: Fix double free when function profile init failed
         [83e03b3fe4daffdebbb42151d5410d730ae50bd1]

Naoya Horiguchi (1):
      hugetlbfs: add swap entry check in follow_hugetlb_page()
         [9cc3a5bd40067b9a0fbd49199d0780463fc2140f]

Nicholas Bellinger (1):
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs
         [30f359a6f9da65a66de8cadf959f0f4a0d498bba]

Paul Moore (1):
      x86: remove the x32 syscall bitmask from syscall_get_nr()
         [8b4b9f27e57584f3d90e0bb84cf800ad81cfe3a1]

Rafael J. Wysocki (1):
      PCI/PM: Disable runtime PM of PCIe ports
         [de7d5f729c72638f41d7c17487bccb1c570ff144]

Rafał Miłecki (1):
      ssb: implement spurious tone avoidance
         [46fc4c909339f5a84d1679045297d9d2fb596987]

Rainer Koenig (1):
      ALSA: hda - Enabling Realtek ALC 671 codec
         [1d87caa69c04008e09f5ff47b5e6acb6116febc7]

Richard Guy Briggs (1):
      thermal: return an error on failure to register thermal class
         [da28d966f6aa942ae836d09729f76a1647932309]

Robert Tivy (1):
      remoteproc: fix FW_CONFIG typo
         [c7426bce5933d16b492a34e42ae77e26fceddff6]

Russell King (1):
      ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend support) properly
         [b6c7aabd923a17af993c5a5d5d7995f0b27c000a]

Sachin Prabhu (1):
      cifs: Allow passwords which begin with a delimitor
         [c369c9a4a7c82d33329d869cbaf93304cc7a0c40]

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates
         [1160c2779b826c6f5c08e5cc542de58fd1f667d5]

Sascha Hauer (2):
      ARM: i.MX35: enable MAX clock
         [5dc2eb7da1e387e31ce54f54af580c6a6f512ca6]
      ASoC: imx-ssi: Fix occasional AC97 reset failure
         [b6e51600f4e983e757b1b6942becaa1ae7d82e67]

Shan Hai (2):
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive
         [a32450e127fc6e5ca6d958ceb3cfea4d30a00846]
      libata: Use integer return value for atapi_command_packet_set
         [d8668fcb0b257d9fdcfbe5c172a99b8d85e1cd82]

Sjur Brændeland (1):
      remoteproc: fix error path of handle_vdev
         [cde42e076c1cdd69a1f955d66ff6596bad3d2105]

Stephane Eranian (1):
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB
         [f1923820c447e986a9da0fc6bf60c1dccdf0408e]

Stephen Boyd (1):
      ARM: 7699/1: sched_clock: Add more notrace to prevent recursion
         [cea15092f098b7018e89f64a5a14bb71955965d5]

Steven Rostedt (Red Hat) (1):
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section
         [7f49ef69db6bbf756c0abca7e9b65b32e999eec8]

Steven Whitehouse (1):
      GFS2: Fix unlock of fcntl locks during withdrawn state
         [c2952d202f710d326ac36a8ea6bd216b20615ec8]

Stone Piao (1):
      mwifiex: limit channel number not to overflow memory
         [901ceba4e81e9dd6b4a3c4c37ee22000a6c5c65f]

Suleiman Souhlal (1):
      vfs: Revert spurious fix to spinning prevention in prune_icache_sb
         [5b55d708335a9e3e4f61f2dadf7511502205ccd1]

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s
         [383efcd00053ec40023010ce5034bd702e7ab373]

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems
         [a1cbcaa9ea87b87a96b9fc465951dcf36e459ca2]

Thomas Graf (1):
      tcp: Reallocate headroom if it would overflow csum_start
         [50bceae9bd3569d56744882f3012734d48a1d413]

Thomas Hellstrom (1):
      kref: Implement kref_get_unless_zero v3
         [4b20db3de8dab005b07c74161cb041db8c5ff3a7]

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure once
         [83589b30f1e1dc9898986293c9336b8ce1705dec]

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()
         [8176cced706b5e5d15887584150764894e94e02f]

Vasily Averin (1):
      cbq: incorrect processing of high limits
         [f0f6ee1f70c4eaab9d52cf7d255df4bd89f8d1c2]

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works properly.
         [4543fbefe6e06a9e40d9f2b28d688393a299f079]

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()
         [12f267a20aecf8b84a2a9069b9011f1661c779b4]

Wei Yongjun (3):
      esp4: fix error return code in esp_output()
         [06848c10f720cbc20e3b784c0df24930b7304b93]
      netrom: fix invalid use of sizeof in nr_recvmsg()
         [c802d759623acbd6e1ee9fbdabae89159a513913]
      can: gw: use kmem_cache_free() instead of kfree()
         [3480a2125923e4b7a56d79efc76743089bf273fc]

Will Deacon (1):
      ARM: 7698/1: perf: fix group validation when using enable_on_exec
         [cb2d8b342aa084d1f3ac29966245dec9163677fb]

Yinghai Lu (2):
      EISA/PCI: Fix bus res reference
         [2cfda637e29ce9e3df31b59f64516b2e571cc985]
      EISA/PCI: Init EISA early, before PNP
         [c5fb301ae83bec6892e54984e6ec765c47df8e10]

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms
         [b55f84e2d527182e7c611d466cd0bb6ddce201de]

Zhao Hongjiang (1):
      aio: fix possible invalid memory access when DEBUG is enabled
         [91d80a84bbc8f28375cca7e65ec666577b4209ad]

hayeswang (1):
      r8169: fix auto speed down issue
         [e2409d83434d77874b461b78af6a19cd6e6a1280]

nikolay@redhat.com (2):
      bonding: IFF_BONDING is not stripped on enslave failure
         [b6a5a7b9a528a8b4c8bec940b607c5dd9102b8cc]
      bonding: fix bonding_masters race condition in bond unloading
         [69b0216ac255f523556fa3d4ff030d857eaaa37f]

----
 arch/alpha/kernel/sys_nautilus.c                   |    5 ++
 arch/arm/include/asm/hardware/iop3xx.h             |    2 +-
 arch/arm/kernel/perf_event.c                       |    5 +-
 arch/arm/kernel/sched_clock.c                      |    4 +-
 arch/arm/mach-imx/clk-imx35.c                      |    2 +
 arch/arm/mm/cache-feroceon-l2.c                    |    1 +
 arch/arm/mm/proc-arm920.S                          |    2 +-
 arch/arm/mm/proc-arm926.S                          |    2 +-
 arch/arm/mm/proc-mohawk.S                          |    2 +-
 arch/arm/mm/proc-sa1100.S                          |    2 +-
 arch/arm/mm/proc-v6.S                              |    2 +-
 arch/arm/mm/proc-xsc3.S                            |    2 +-
 arch/arm/mm/proc-xscale.S                          |    2 +-
 arch/powerpc/platforms/pseries/lpar.c              |    8 ++-
 arch/x86/boot/compressed/Makefile                  |    5 +-
 arch/x86/include/asm/kvm_host.h                    |    4 +-
 arch/x86/include/asm/paravirt.h                    |    5 +-
 arch/x86/include/asm/paravirt_types.h              |    2 +
 arch/x86/include/asm/syscall.h                     |    4 +-
 arch/x86/include/asm/tlb.h                         |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   20 ++++--
 arch/x86/kernel/paravirt.c                         |   25 ++++----
 arch/x86/kvm/lapic.c                               |    2 +-
 arch/x86/kvm/x86.c                                 |   45 ++++++-------
 arch/x86/lguest/boot.c                             |    1 +
 arch/x86/mm/fault.c                                |    6 +-
 arch/x86/mm/pgtable.c                              |    7 ++
 arch/x86/xen/mmu.c                                 |    1 +
 block/blk-sysfs.c                                  |    2 +
 crypto/algif_hash.c                                |    2 +
 crypto/algif_skcipher.c                            |    1 +
 crypto/gcm.c                                       |   17 ++++-
 drivers/ata/ata_piix.c                             |   11 ++++
 drivers/ata/libata-core.c                          |    4 ++
 drivers/base/regmap/regcache-rbtree.c              |    2 +-
 drivers/char/hpet.c                                |   14 +---
 drivers/cpufreq/exynos-cpufreq.c                   |    4 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    2 +-
 drivers/eisa/pci_eisa.c                            |   67 ++++++++++++++------
 drivers/gpu/drm/i915/intel_display.c               |    9 +++
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   13 +---
 drivers/gpu/drm/udl/udl_connector.c                |    4 ++
 drivers/hwspinlock/hwspinlock_core.c               |    2 +
 drivers/mtd/mtdchar.c                              |   38 ++---------
 drivers/net/bonding/bond_main.c                    |   10 +++
 drivers/net/can/mcp251x.c                          |   10 ++-
 drivers/net/can/sja1000/sja1000_of_platform.c      |   31 +++++----
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    1 +
 drivers/net/ethernet/broadcom/tg3.c                |   18 +++++-
 drivers/net/ethernet/broadcom/tg3.h                |    2 +
 drivers/net/ethernet/realtek/r8169.c               |   28 +++++++-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
 drivers/net/wireless/b43/phy_n.c                   |    3 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |    4 +-
 drivers/pci/pcie/portdrv_pci.c                     |   13 ----
 drivers/platform/x86/msi-wmi.c                     |    4 +-
 drivers/remoteproc/Kconfig                         |    2 +-
 drivers/remoteproc/remoteproc_core.c               |    4 +-
 drivers/scsi/libsas/sas_expander.c                 |   12 ++++
 drivers/spi/spi-mpc512x-psc.c                      |    2 +-
 drivers/spi/spi-s3c64xx.c                          |   41 +++++++-----
 drivers/ssb/driver_chipcommon_pmu.c                |   29 +++++++++
 drivers/target/target_core_alua.c                  |    3 +
 drivers/thermal/thermal_sys.c                      |    1 +
 drivers/tty/tty_io.c                               |   14 +++-
 drivers/vfio/pci/vfio_pci.c                        |    3 +-
 drivers/video/fbmem.c                              |   40 ++++--------
 fs/aio.c                                           |    2 +-
 fs/btrfs/tree-log.c                                |   48 ++++++++++++--
 fs/cifs/connect.c                                  |   16 ++++-
 fs/gfs2/file.c                                     |    5 +-
 fs/hfsplus/extents.c                               |    2 +-
 fs/inode.c                                         |    2 +-
 fs/ubifs/super.c                                   |   12 ++--
 include/asm-generic/tlb.h                          |    7 +-
 include/linux/ata.h                                |    2 +-
 include/linux/capability.h                         |    2 +
 include/linux/ftrace.h                             |    3 +-
 include/linux/kref.h                               |   21 ++++++
 include/linux/kvm_host.h                           |    2 +-
 include/linux/kvm_types.h                          |    1 +
 include/linux/libata.h                             |    1 +
 include/linux/mm.h                                 |    2 +
 include/linux/netdevice.h                          |    2 +-
 include/linux/preempt.h                            |   22 ++++---
 include/linux/socket.h                             |    3 +-
 include/linux/spinlock_up.h                        |   29 +++++----
 include/linux/ssb/ssb_driver_chipcommon.h          |    2 +
 include/net/scm.h                                  |    2 +-
 kernel/capability.c                                |   24 +++++++
 kernel/events/core.c                               |    2 +-
 kernel/hrtimer.c                                   |    3 +-
 kernel/sched/clock.c                               |   26 ++++++++
 kernel/sched/core.c                                |    6 +-
 kernel/signal.c                                    |    2 +-
 kernel/sys.c                                       |    3 +-
 kernel/trace/ftrace.c                              |   21 +++---
 kernel/trace/trace_stack.c                         |    2 +-
 lib/kobject.c                                      |    9 ++-
 mm/hugetlb.c                                       |   12 +++-
 mm/memory.c                                        |   48 ++++++++++++++
 mm/mmap.c                                          |    2 +-
 mm/nommu.c                                         |    2 +-
 net/atm/common.c                                   |    2 +
 net/ax25/af_ax25.c                                 |    1 +
 net/bluetooth/af_bluetooth.c                       |    4 +-
 net/bluetooth/rfcomm/sock.c                        |    1 +
 net/caif/caif_socket.c                             |    2 +
 net/can/gw.c                                       |    6 +-
 net/core/dev.c                                     |    3 +
 net/core/dev_addr_lists.c                          |    6 +-
 net/core/rtnetlink.c                               |    4 +-
 net/core/sock.c                                    |   14 ++--
 net/ipv4/esp4.c                                    |    6 +-
 net/ipv4/ip_fragment.c                             |   15 +++--
 net/ipv4/syncookies.c                              |    4 +-
 net/ipv4/tcp_input.c                               |   65 ++++++++++---------
 net/ipv4/tcp_output.c                              |    8 ++-
 net/ipv6/addrconf.c                                |   27 ++++++++
 net/ipv6/reassembly.c                              |   13 +++-
 net/ipv6/tcp_ipv6.c                                |    1 +
 net/irda/af_irda.c                                 |    2 +
 net/iucv/af_iucv.c                                 |    2 +
 net/l2tp/l2tp_ip6.c                                |    1 +
 net/llc/af_llc.c                                   |    2 +
 net/mac80211/cfg.c                                 |    6 +-
 net/mac80211/ieee80211_i.h                         |    3 +-
 net/mac80211/mlme.c                                |   24 +++++--
 net/mac80211/offchannel.c                          |   23 +++++--
 net/netrom/af_netrom.c                             |    1 +
 net/nfc/llcp/sock.c                                |    2 +
 net/rose/af_rose.c                                 |    1 +
 net/sched/sch_cbq.c                                |    5 +-
 net/tipc/socket.c                                  |    7 ++
 net/unix/af_unix.c                                 |    2 +-
 sound/core/pcm_native.c                            |   12 +---
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/hda/patch_realtek.c                      |    4 +-
 sound/soc/codecs/wm8903.c                          |    2 +
 sound/soc/fsl/imx-ssi.c                            |    5 ++
 sound/soc/sh/dma-sh7760.c                          |    4 +-
 sound/soc/spear/spear_pcm.c                        |   12 ++--
 sound/usb/mixer_quirks.c                           |    4 +-
 sound/usb/quirks.c                                 |    2 +-
 virt/kvm/ioapic.c                                  |    7 +-
 virt/kvm/kvm_main.c                                |   47 +++++++++++---
 149 files changed, 941 insertions(+), 419 deletions(-)
