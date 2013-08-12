Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3HLTkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:40:49 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:56518 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3HLTkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzovKwMcBNH_-w9CuSTNwcp_5ut7yWZjbt3SLC=PQhDWQ@mail.gmail.com>
References: <CA+55aFzovKwMcBNH_-w9CuSTNwcp_5ut7yWZjbt3SLC=PQhDWQ@mail.gmail.com>
Date: Mon, 12 Aug 2013 15:40:45 -0400
Message-ID: <CAKON4Ozw1AusY_x6Jijr4CSB-O+jHE7oR+wCXkSLBYXnHHmjPQ@mail.gmail.com>
Subject: Re: Linux 3.11-rc5
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should I admit that long ago I worked on the networking code in Windows 3.11?

On Sun, Aug 11, 2013 at 9:43 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Sadly, the numerology doesn't quite work out, and while releasing the
> final 3.11 today would be a lovely coincidence (Windows 3.11 was
> released twenty years ago today), it is not to be.
>
> Instead, we have 3.11-rc5.
>
> Which is showing signs of calming down, and is noticeably smaller than
> previous rc's (both in number of commits and in size of patch). Let's
> hope that trend isn't just a fluke.
>
> There really doesn't seem to be anything major here. The radeon
> changes are likely the most noticeable, but many of them are for the
> dynamic power management that is still off by default..  Other than
> that, misc media fixes, arch updates, some small filesystem updates
> etc. Nothing really stands out.
>
>         Linus
>
> ---
>
> Aaro Koskinen (1):
>       cpufreq: loongson2: fix regression related to clock management
>
> Aaron Lu (1):
>       drm/i915: avoid brightness overflow when doing scale
>
> Afzal Mohammed (2):
>       ARM: OMAP2+: hwmod: rt address space index for DT
>       ARM: OMAP2+: hwmod: AM335x: fix cpgmac address space
>
> Al Viro (1):
>       reiserfs: fix deadlock in umount
>
> Alban Browaeys (1):
>       [media] em28xx: fix assignment of the eeprom data
>
> Alex Deucher (11):
>       drm/radeon: properly handle pm on gpu reset
>       drm/radeon: select audio dto based on encoder id for DCE3
>       drm/radeon/dpm: adjust thermal protection requirements
>       drm/radeon/dpm: fix spread spectrum setup (v2)
>       drm/radeon/dpm: adjust power state properly for UVD on SI
>       drm/radeon/dpm: disable sclk ss on rv6xx
>       drm/radeon: fix audio dto calculation on DCE3+ (v3)
>       drm/radeon: always program the MC on startup
>       drm/radeon/cik: use a mutex to properly lock srbm instanced registers
>       drm/radeon/dpm: require rlc for dpm
>       drm/radeon: make missing smc ucode non-fatal
>
> Alexander Shiyan (1):
>       [media] media: coda: Fix DT driver data pointer for i.MX27
>
> Alexander Z Lam (2):
>       tracing: Make TRACE_ITER_STOP_ON_FREE stop the correct buffer
>       tracing: Fix reset of time stamps during trace_clock changes
>
> Alexey Khoroshilov (1):
>       [media] hdpvr: fix iteration over uninitialized lists in hdpvr_probe()
>
> Amit Shah (5):
>       virtio: console: fix race with port unplug and open/close
>       virtio: console: fix race in port_fops_open() and port unplug
>       virtio: console: clean up port data immediately at time of unplug
>       virtio: console: fix raising SIGIO after port unplug
>       virtio: console: return -ENODEV on all read operations after unplug
>
> Andrew Vagin (1):
>       tracing: Fix fields of struct trace_iterator that are zeroed by mistake
>
> Andrzej Hajda (2):
>       [media] DocBook: upgrade media_api DocBook version to 4.2
>       [media] v4l2: added missing mutex.h include to v4l2-ctrls.h
>
> Andy Lutomirski (2):
>       fs: Fix file mode for O_TMPFILE
>       fs: Allow unprivileged linkat(..., AT_EMPTY_PATH) aka flink
>
> Anton Blanchard (1):
>       powerpc: On POWERNV enable PPC_DENORMALISATION by default
>
> Aruna Balakrishnaiah (2):
>       powerpc/pseries: Fix buffer overflow when reading from pstore
>       powerpc/pseries: Add backward compatibilty to read old kernel oops-log
>
> Asias He (1):
>       virtio-scsi: Fix virtqueue affinity setup
>
> Casey Schaufler (1):
>       Smack: IPv6 casting error fix for 3.11
>
> Chen Gang (2):
>       s390/Kconfig: select 'TTY' when 'S390_GUEST' is enabled
>       powerpc/kvm: Add signed type cast for comparation
>
> Chris Leech (1):
>       [SCSI] fnic: BUG: sleeping function called from invalid context
> during probe
>
> Christian Eggers (1):
>       spi: spi-davinci: Fix direction in dma_map_single()
>
> Christian König (5):
>       drm/radeon: fix halting UVD
>       drm/radeon: only save UVD bo when we have open handles
>       drm/radeon: stop sending invalid UVD destroy msg
>       drm/radeon: add more UVD CS checking
>       drm/radeon: remove unnecessary unpin
>
> Clemens Ladisch (1):
>       ALSA: usb-audio: do not trust too-big wMaxPacketSize values
>
> Cong Ding (1):
>       avr32: boards/atngw100/mrmt.c: fix building error
>
> Curt Brune (1):
>       hwmon: (adt7470) Fix incorrect return code check
>
> Daniel Vetter (1):
>       drm/i915: fix gen4 digital port hotplug definitions
>
> Dave Airlie (1):
>       drm/ast: invalidate page tables when pinning a BO
>
> Dhaval Giani (1):
>       tracing: Fix trace_dump_stack() proto when CONFIG_TRACING is not set
>
> Dominik Dingel (1):
>       KVM: s390: move kvm_guest_enter,exit closer to sie
>
> Egbert Eich (1):
>       drm/mgag200: Invalidate page tables when pinning a BO
>
> Eric Sandeen (1):
>       ext4: destroy ext4_es_cachep on module unload
>
> Fabio Estevam (1):
>       i2c: i2c-mxs: Use DMA mode even for small transfers
>
> Felipe Contreras (1):
>       ACPI / video: improve quirk check in acpi_video_bqc_quirk()
>
> Florian Fainelli (1):
>       MIPS: BMIPS: fix hardware interrupt routing for boot CPU != 0
>
> H.J. Lu (1):
>       x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz
>
> Hans Verkuil (2):
>       [media] ml86v7667: fix compile warning: 'ret' set but not used
>       [media] usbtv: fix dependency
>
> Hector Palacios (1):
>       video: mxsfb: fix color settings for 18bit data bus and 32bpp
>
> Heiko Carstens (4):
>       s390: add support for LZ4-compressed kernel
>       s390: add support for IBM zBC12 machine
>       s390/perf: fix compile error (undefined reference sie_exit)
>       KVM: s390: fix pfmf non-quiescing control handling
>
> J. Bruce Fields (1):
>       nfsd4: Fix MACH_CRED NULL dereference
>
> James Hogan (1):
>       usb: xhci: add missing dma-mapping.h includes
>
> Jani Nikula (1):
>       drm/i915: do not disable backlight on vgaswitcheroo switch off
>
> Jie Liu (1):
>       btrfs: fix file truncation if FALLOC_FL_KEEP_SIZE is specified
>
> Jiri Kosina (1):
>       Revert "HID: hid-logitech-dj: querying_devices was never set"
>
> Joe Perches (1):
>       MAINTAINERS: Add separate section for USB NETWORKING DRIVERS
>
> John Sheu (1):
>       [media] s5p-mfc: Fix input/output format reporting
>
> Josef Bacik (6):
>       Btrfs: do not offset physical if we're compressed
>       Btrfs: fix backref walking when we hit a compressed extent
>       Btrfs: make sure the backref walker catches all refs to our extent
>       Btrfs: allow splitting of hole em's when dropping extent cache
>       Btrfs: release both paths before logging dir/changed extents
>       Btrfs: check to see if root_list is empty before adding it to dead roots
>
> Julius Werner (1):
>       usb: core: don't try to reset_device() a port that got just disconnected
>
> Jussi Kivilinna (1):
>       ALSA: 6fire: fix DMA issues with URB transfer_buffer usage
>
> Kuninori Morimoto (2):
>       ARM: shmobile: armadillo800eva: Don't request GPIO 166 in board code
>       shdma: fixup sh_dmae_get_partial() calculation error
>
> Lai Jiangshan (1):
>       workqueue: allow work_on_cpu() to be called recursively
>
> Lars-Peter Clausen (2):
>       iio:trigger: Fix use_count race condition
>       regmap: cache: Make sure to sync the last register in a block
>
> Li Zefan (1):
>       cgroup: fix a leak when percpu_ref_init() fails
>
> Linus Torvalds (2):
>       Revert "slub: do not put a slab to cpu partial list when cpu_partial is 0"
>       Linux 3.11-rc5
>
> Linus Walleij (1):
>       MAINTAINERS: delete Srinidhi from ux500
>
> Liu Bo (2):
>       Btrfs: fix a bug of snapshot-aware defrag to make it work on
> partial extents
>       Btrfs: fix extent buffer leak after backref walking
>
> Lubomir Rintel (2):
>       [media] usbtv: Fix deinterlacing
>       [media] usbtv: Throw corrupted frames away
>
> Lucas Stach (1):
>       ARM: tegra: enable ULPI phy on Colibri T20
>
> Markos Chandras (1):
>       MIPS: PNX833x: PNX8335_PCI_ETHERNET_INT depends on CONFIG_SOC_PNX8335
>
> Martin K. Petersen (1):
>       [SCSI] Don't attempt to send extended INQUIRY command if
> skip_vpd_pages is set
>
> Martin Schwidefsky (1):
>       s390/bitops: fix find_next_bit_left
>
> Mateusz Krawczuk (1):
>       regmap: Add missing header for !CONFIG_REGMAP stubs
>
> Maxime Ripard (1):
>       i2c: mv64xxx: Document the newly introduced allwinner compatible
>
> Michael Brunner (1):
>       i2c: Fix Kontron PLD prescaler calculation
>
> Michael Neuling (5):
>       powerpc: Fix hypervisor facility unavaliable vector number
>       powerpc: Rework setting up H/FSCR bit definitions
>       powerpc: Fix context switch DSCR on POWER8
>       powerpc: Save the TAR register earlier
>       powerpc/tm: Fix context switching TAR, PPR and DSCR SPRs
>
> Michal Srb (1):
>       drm/cirrus: Invalidate page tables when pinning a BO
>
> Michel Dänzer (1):
>       drm: Don't pass negative delta to ktime_sub_ns()
>
> Mike Qiu (1):
>       powerpc/eeh: Add missing procfs entry for PowerNV
>
> Neil Horman (1):
>       x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset
>
> Niels de Vos (1):
>       pata_imx: expose module alias for loading from device-tree
>
> Nishanth Menon (5):
>       regulator: palmas-pmic: doc: fix typo for sleep-mode
>       regulator: palmas-pmic: doc: remove ti,tstep
>       ARM: dts: omap5-uevm: document regulator signals used on the actual board
>       ARM: dts: omap5-uevm: fix regulator configurations mandatory for SoC
>       ARM: dts: omap5-uevm: update optional/unused regulator configurations
>
> Oleg Nesterov (12):
>       tracing: Turn event/id->i_private into call->event.type
>       tracing: Change event_enable/disable_read() to verify i_private != NULL
>       tracing: Change event_filter_read/write to verify i_private != NULL
>       tracing: Change f_start() to take event_mutex and verify i_private != NULL
>       tracing: Introduce remove_event_file_dir()
>       tracing: Change remove_event_file_dir() to clear "d_subdirs"->i_private
>       debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)
>       tracing: trace_remove_event_call() should fail if call/file is in use
>       userns: unshare_userns(&cred) should not populate cred on failure
>       Revert "ptrace: PTRACE_DETACH should do flush_ptrace_hw_breakpoint(child)"
>       userns: limit the maximum depth of user_namespace->parent chain
>       dlm: kill the unnecessary and wrong device_close()->recalc_sigpending()
>
> Patil, Rachna (1):
>       iio: ti_am335x_adc: Fix wrong samples received on 1st read
>
> Paulo Zanoni (1):
>       drm/i915: update last_vblank when disabling the power well
>
> Piotr Sarna (1):
>       staging: zcache: fix "zcache=" kernel parameter
>
> Rafael J. Wysocki (3):
>       ACPI / PM: Walk physical_node_list under physical_node_lock
>       ACPI: Drop physical_node_id_bitmap from struct acpi_device
>       ACPI: Try harder to resolve _ADR collisions for bridges
>
> Rajendra Nayak (3):
>       ARM: OMAP2+: hwmod: Fix a crash in _setup_reset() with DEBUG_LL
>       ARM: OMAP2+: Avoid idling memory controllers with no drivers
>       ARM: OMAP2+: Sync hwmod state with the pm_runtime and omap_device state
>
> Ralf Baechle (1):
>       MIPS: oprofile: Fix BUG due to smp_processor_id() in preemptible code.
>
> Rohit Vaswani (2):
>       ARM: msm: dts: Fix the gpio register address for msm8960
>       ARM: msm: Consolidate gpiomux for older architectures
>
> Roy Franz (1):
>       x86, efi: correct call to free_pages
>
> Sachin Kamat (1):
>       [media] s5p-g2d: Fix registration failure
>
> Santosh Shilimkar (1):
>       MAINTAINERS: add TI Keystone ARM platform
>
> Scott Mayhew (1):
>       NFSv4: Fix the sync mount option for nfs4 mounts
>
> Sergei Shtylyov (1):
>       ARM: shmobile: BOCK-W: fix SDHI0 PFC settings
>
> Shaohua Li (1):
>       workqueue: copy workqueue_attrs with all fields
>
> Simon Horman (1):
>       ARM: shmobile: lager: do not annotate gpio_buttons as __initdata
>
> Srinivas Kandagatla (2):
>       ARM: STi: Fix cpu nodes with correct device_type.
>       ARM: STi: remove sti_secondary_start from INIT section.
>
> Stefan Haberland (1):
>       s390/dasd: fix hanging devices after path events
>
> Steven Rostedt (1):
>       printk: Fix return of braille_register_console()
>
> Steven Rostedt (Red Hat) (5):
>       ftrace: Consolidate some duplicate code for updating ftrace ops
>       ftrace: Check module functions being traced on reload
>       tracing: Add comment to describe special break case in
> probe_remove_event_call()
>       tracing/kprobes: Fail to unregister if probe event files are in use
>       tracing/uprobes: Fail to unregister if probe event files are in use
>
> Sumit.Saxena@lsi.com (1):
>       [SCSI] megaraid_sas: megaraid_sas driver init fails in kdump kernel
>
> Thadeu Lima de Souza Cascardo (1):
>       powerpc/kvm/book3s_pr: Return appropriate error when allocation fails
>
> Theodore Ts'o (2):
>       ext4: make sure group number is bumped after a inode allocation race
>       ext4: fix retry handling in ext4_ext_truncate()
>
> Tomi Valkeinen (2):
>       OMAPDSS: analog-tv-connector: compile fix
>       ARM: OMAP: dss-common: fix Panda's DVI DDC channel
>
> Torsten Kaiser (1):
>       x86, amd, microcode: Fix error path in apply_microcode_amd()
>
> Trond Myklebust (6):
>       LOCKD: Don't call utsname()->nodename from nlmclnt_setlockargs
>       SUNRPC: Don't auto-disconnect from the local rpcbind socket
>       SUNRPC: If the rpcbind channel is disconnected, fail the call to
> unregister
>       NFS: Fix writeback performance issue on cache invalidation
>       NFS: Remove unnecessary call to nfs_setsecurity in nfs_fhget()
>       NFSv4: Fix up nfs4_proc_lookup_mountpoint
>
> Ville Syrjälä (1):
>       drm/i915: Don't call encoder's get_config unless encoder is active
>
> Viresh Kumar (1):
>       cpufreq: rename ignore_nice as ignore_nice_load
>
> Weston Andros Adamson (1):
>       nfsd: Fix SP4_MACH_CRED negotiation in EXCHANGE_ID
>
> Yasuaki Ishimatsu (1):
>       ACPI / processor: move try_offline_node() after acpi_unmap_lsapic()
>
> Yoshihiro YUNOMAE (2):
>       virtio/console: Quit from splice_write if pipe->nrbufs is 0
>       virtio/console: Add pipe_lock/unlock for splice_write
>
> Zach Brown (1):
>       btrfs: don't loop on large offsets in readdir
>
> Zheng Liu (2):
>       ext4: add WARN_ON to check the length of allocated blocks
>       vfs: add missing check for __O_TMPFILE in fcntl_init()
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Jon Smirl
jonsmirl@gmail.com
