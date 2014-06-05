Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaFEETn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:19:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaFEETk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:19:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 000/214] 3.4.92-stable review
Date: Wed,  4 Jun 2014 21:16:03 -0700
Message-Id: <20140605041639.638675216@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.92 release.
There are 214 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jun  7 04:15:47 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.92-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.92-rc1

Marc Dionne <marc.c.dionne@gmail.com>
    HID: logitech: don't use stack based dj_report structures

Joe Lawrence <joe.lawrence@stratus.com>
    PCI/ASPM: Don't touch ASPM if forcibly disabled

Wei Liu <wei.liu2@citrix.com>
    xen-netfront: reduce gso_max_size to account for max TCP header

Joe Perches <joe@perches.com>
    net: Add net_ratelimited_function and net_<level>_ratelimited macros

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    crypto: s390 - Fix aes-xts parameter corruption

Oliver Hartkopp <socketcan@hartkopp.net>
    can: sja1000: fix {pre,post}_irq() handling and IRQ handler return value

Johan Hovold <jhovold@gmail.com>
    backlight: atmel-pwm-bl: fix gpio polarity in remove

Brian Norris <computersforpeace@gmail.com>
    mtd: m25p80: fix allocation size

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: s390 - Fix aes-cbc IV corruption

Felix Fietkau <nbd@openwrt.org>
    mac80211: drop spoofed packets in ad-hoc mode

Marcelo Tosatti <mtosatti@redhat.com>
    vgacon.c: add cond reschedule points in vgacon_do_font_op

Hauke Mehrtens <hauke@hauke-m.de>
    b43: ensue that BCMA is "y" when B43 is "y"

Shane Huang <shane.huang@amd.com>
    i2c-piix4: Add AMD CZ SMBus device ID

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check wdev->netdev in connection work

Jiri Kosina <jkosina@suse.cz>
    random: fix accounting race condition with lockless irq entropy_count update

Ben Hutchings <ben@decadent.org.uk>
    rapidio/tsi721: Fix interrupt mask when handling MSI

Alexandre Bounine <alexandre.bounine@idt.com>
    rapidio/tsi721: fix bug in MSI interrupt handling

Maxim Mikityanskiy <maxtram95@gmail.com>
    msi-wmi: Fix memory leak

Jakub Kicinski <jakub.kicinski@intel.com>
    ixgbe: fix registration order of driver and DCA nofitication

Laxman Dewangan <ldewangan@nvidia.com>
    i2c: tegra: check the clk_prepare_enable() return value

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: lower default software speech rate

James Ralston <james.d.ralston@intel.com>
    ata_piix: Add Device IDs for Intel Lynx Point-LP PCH

Linus Walleij <linus.walleij@linaro.org>
    drivers/rtc/rtc-pl031.c: restore ST variant functionality

Maia Kozheva <sikon@ubuntu.com>
    rt2800usb: Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB Wi-Fi adapter

Jaume Delclòs <jaume@delclos.com>
    Wireless: rt2x00: Add device id for Sweex LW323 to rt2800usb.c

Xose Vazquez Perez <xose.vazquez@gmail.com>
    wireless: rt2x00: rt{2500,73}usb.c put back duplicate id

Haojian Zhuang <haojian.zhuang@linaro.org>
    drivers/rtc/rtc-pl031.c: fix the missing operation on enable

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: always program the MC on startup

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix hdmi mode enable on RS600/RS690/RS740

Thomas Hellstrom <thellstrom@vmware.com>
    drm/ttm: Fix memory type compatibility check

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Pad drm_mode_get_connector to 64-bit boundary

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix panel scaling with eDP and LVDS bridges

Jani Nikula <jani.nikula@intel.com>
    drm/i915: try not to lose backlight CBLV precision

Ondrej Zary <linux@rainbow-software.org>
    drm/radeon: Another card with wrong primary dac adj

Jani Nikula <jani.nikula@intel.com>
    drm/i915: ensure single initialization and cleanup of backlight device

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Workaround incoherence between fences and LLC across multiple CPUs

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: cleanup properly if mmio mapping fails

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: use frac fb div on RS780/RS880

Egbert Eich <eich@suse.de>
    DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.

Jani Nikula <jani.nikula@intel.com>
    drm/i915: add quirk to invert brightness on Packard Bell NCL20

Jani Nikula <jani.nikula@intel.com>
    drm/i915: add quirk to invert brightness on eMachines e725

Jani Nikula <jani.nikula@intel.com>
    drm/i915: add quirk to invert brightness on eMachines G725

Carsten Emde <C.Emde@osadl.org>
    drm/i915: panel: invert brightness acer aspire 5734z

Carsten Emde <C.Emde@osadl.org>
    drm/i915: panel: invert brightness via quirk

Carsten Emde <C.Emde@osadl.org>
    drm/i915: panel: invert brightness via parameter

Jani Nikula <jani.nikula@intel.com>
    drm/i915: add missing \n to UTS_RELEASE in the error_state

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: dump UTS_RELEASE into the error_state

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915; Only increment the user-pin-count after successfully pinning the bo

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Close race between processing unpin task and queueing the flip

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in evergreen_mc_resume()

Aaro Koskinen <aaro.koskinen@iki.fi>
    drm/nouveau: fix init with agpgart-uninorth

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add connector table for Mac G4 Silver

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add connector table for SAM440ep embedded board

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: fix amd afusion gpu setup aka sumo v2

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dce32+: use fractional fb dividers for high clocks

Alex Deucher <alexander.deucher@amd.com>
    drm: fix documentation for drm_crtc_set_mode()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures

Jason Wang <jasowang@redhat.com>
    drivers: hv: switch to use mb() instead of smp_mb()

Paolo Bonzini <pbonzini@redhat.com>
    nbd: fsync and kill block device on shutdown

Ben Hutchings <ben@decadent.org.uk>
    x86/efi: Fix dummy variable buffer allocation

Matthew Garrett <matthew.garrett@nebula.com>
    Modify UEFI anti-bricking code

Richard Weinberger <richard@nod.at>
    x86,efi: Implement efi_no_storage_paranoia parameter

Sergey Vlasov <vsu@altlinux.ru>
    efi: Export efi_query_variable_store() for efivars.ko

Richard Weinberger <richard@nod.at>
    x86,efi: Check max_size only if it is non-zero.

Matt Fleming <matt.fleming@intel.com>
    x86, efivars: firmware bug workarounds should be in platform code

Seiji Aguchi <seiji.aguchi@hds.com>
    efi_pstore: Introducing workqueue updating sysfs

Ben Hutchings <ben@decadent.org.uk>
    efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE

Seth Forshee <seth.forshee@canonical.com>
    efivars: Add module parameter to disable use as a pstore backend

Seth Forshee <seth.forshee@canonical.com>
    efivars: Allow disabling use as a pstore backend

Ben Hutchings <ben@decadent.org.uk>
    efivars: pstore: Do not check size when erasing variable

Josh Boyer <jwboyer@redhat.com>
    efi: be more paranoid about available space when creating variables

Josh Boyer <jwboyer@redhat.com>
    efivars: Disable external interrupt while holding efivars->lock

Seiji Aguchi <seiji.aguchi@hds.com>
    efi_pstore: Check remaining space with QueryVariableInfo() before writing data

H. Peter Anvin <hpa@linux.intel.com>
    x86/Sandy Bridge: mark arrays in __init functions as __initconst

Oleg Nesterov <oleg@redhat.com>
    ptrace/x86: Partly fix set_task_blockstep()->update_debugctlmsr() logic

Oleg Nesterov <oleg@redhat.com>
    ptrace/x86: Introduce set_task_blockstep() helper

Radu Caragea <sinaelgl@gmail.com>
    x86 get_unmapped_area: Access mmap_legacy_base through mm_struct member

Russ Gorby <russ.gorby@intel.com>
    n_gsm: replace kfree_skb w/ appropriate dev_* versions

Russ Gorby <russ.gorby@intel.com>
    n_gsm: avoid accessing freed memory during CMD_FCOFF condition

samix.lebsir <samix.lebsir@intel.com>
    char: n_gsm: remove message filtering for contipated DLCI

Frederic Berat <fredericx.berat@intel.com>
    n_gsm : Flow control handling in Mux driver

Randy Dunlap <rdunlap@infradead.org>
    x86: fix build error and kconfig for ia32_emulation and binfmt

Fenghua Yu <fenghua.yu@intel.com>
    x86/apic: Disable I/O APIC before shutdown of the local APIC

H. Peter Anvin <hpa@linux.intel.com>
    x86, build: Pass in additional -mno-mmx, -mno-sse options

H. Peter Anvin <hpa@linux.intel.com>
    x86, build, icc: Remove uninitialized_var() from compiler-intel.h

Dirk Behme <dirk.behme@de.bosch.com>
    tty: serial: imx: don't reinit clock in imx_setup_ufcr()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add support for CX20952

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant - Correct vendor IDs for new codecs

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add stereo-dmic fixup for Acer Aspire One 522

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Fix oops caused by recent commit "Fix internal mic for Lenovo Ideapad U300s"

Felix Kaechele <felix@fetzig.org>
    ALSA: hda - Add inverted internal mic quirk for Lenovo IdeaPad U310

David Henningsson <david.henningsson@canonical.com>
    ALSA: HDA: Add inverted internal mic quirk for Lenovo S205

Alex Hung <alex.hung@canonical.com>
    thinkpad-acpi: fix issuing duplicated key events for brightness up/down

Bjorn Helgaas <bhelgaas@google.com>
    PCI: shpchp: Use per-slot workqueues to avoid deadlock

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL

Bruce Allan <bruce.w.allan@intel.com>
    e1000e: DoS while TSO enabled caused by link partner with small MSS

Alexander Stein <alexander.stein@systec-electronic.com>
    can: c_can: Set reserved bit in IFx_MASK2 to 1 on write

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    intel_idle: Don't register CPU notifier if we are not running.

Axel Lin <axel.lin@ingics.com>
    regulator: max8998: Ensure enough delay time for max8998_set_voltage_buck_time_sel

Axel Lin <axel.lin@ingics.com>
    regulator: max8997: Use uV in voltage_map_desc

Krzysztof Mazur <krzysiek@podlesie.net>
    i915: ensure that VGA plane is disabled

Mauro Carvalho Chehab <mchehab@redhat.com>
    i82975x_edac: Fix dimm label initialization

Jiri Slaby <jslaby@suse.cz>
    MISC: hpilo, remove pci_disable_device

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    floppy: properly handle failure on add_disk loop

Seth Forshee <seth.forshee@canonical.com>
    Input: synaptics - adjust threshold for treating position values as negative

Matthieu CASTET <matthieu.castet@parrot.com>
    UBI: erase free PEB with bitflip in EC header

Rashika Kheria <rashika.kheria@gmail.com>
    Staging: zram: Fix access of NULL pointer

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    zram: allow request end to coincide with disksize

Jiang Liu <liuj97@gmail.com>
    zram: avoid access beyond the zram device

Jiang Liu <liuj97@gmail.com>
    zram: destroy all devices on error recovery path in zram_init()

Jiang Liu <liuj97@gmail.com>
    zram: avoid invalid memory access in zram_exit()

Minchan Kim <minchan@kernel.org>
    zram: Fix deadlock bug in partial read/write

Joe Thornber <ejt@redhat.com>
    dm thin: fix discard corruption

Shiva Krishna Merla <shivakrishna.merla@netapp.com>
    dm mpath: fix race condition between multipath_dtr and pg_init_done

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: avoid snapshot space leak on crash

Harshula Jayasuriya <harshula@redhat.com>
    nfsd: nfsd_open: when dentry_open returns an error do not propagate as struct file

NeilBrown <neilb@suse.de>
    md/raid10: fix "enough" function for detecting if array is failed.

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: add missing module aliases

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: avoid a possible __vmalloc deadlock

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session

Weston Andros Adamson <dros@netapp.com>
    NFSv4.1: Don't decode skipped layoutgets

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.1: Fix a race in pNFS layoutcommit

Chuck Lever <chuck.lever@oracle.com>
    NFS: nfs_getaclargs.acl_len is a size_t

fanchaoting <fanchaoting@cn.fujitsu.com>
    nfsd: don't run get_file if nfs4_preprocess_stateid_op return error

Dan Carpenter <dan.carpenter@oracle.com>
    NFSv4.1: integer overflow in decode_cb_sequence_args()

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix xdr decoding of large non-write compounds

Andy Adamson <andros@netapp.com>
    NFSv4 wait on recovery for async session errors

Mateusz Guzik <mguzik@redhat.com>
    cifs: delay super block destruction until all cifsFileInfo objects are gone

Linus Torvalds <torvalds@linux-foundation.org>
    VFS: make vfs_fstat() use f[get|put]_light()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Keep overwrite in sync between regular and snapshot buffers

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    perf: Fix error return code

libin <huawei.libin@huawei.com>
    sched/debug: Fix sd->*_idx limit range avoiding overflow

Namhyung Kim <namhyung.kim@lge.com>
    sched/debug: Limit sd->*_idx range on sysctl

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Check module functions being traced on reload

Peter Zijlstra <peterz@infradead.org>
    perf: Fix perf ring buffer memory ordering

Justin Lecher <jlec@gentoo.org>
    fs: cachefiles: add support for large files in filesystem caching

Geyslan G. Bem <geyslan@gmail.com>
    ecryptfs: Fix memory leakage in keystore.c

Pavel Shilovsky <pshilovsky@etersoft.ru>
    CIFS: Fix error handling in cifs_push_mandatory_locks

Steve French <smfrench@gmail.com>
    setfacl removes part of ACL when setting POSIX ACLs to Samba

Horia Geanta <horia.geanta@freescale.com>
    crypto: caam - add allocation failure handling in SPRINTFCAT macro

Du, Wenkai <wenkai.du@intel.com>
    i2c: designware: Mask all interrupts during i2c controller enable

Hans de Goede <hdegoede@redhat.com>
    ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX

Marcel Apfelbaum <marcel.a@redhat.com>
    PCI: shpchp: Check bridge's secondary (not primary) bus speed

Linus Torvalds <torvalds@linux-foundation.org>
    x86-64, modify_ldt: Make support for 16-bit segments a runtime option

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Jianyu Zhan <nasa4836@gmail.com>
    percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

J. Bruce Fields <bfields@redhat.com>
    nfsd4: remove lockowner when removing lock stateid

J. Bruce Fields <bfields@redhat.com>
    nfsd4: warn on finding lockowner without stateid's

Kinglong Mee <kinglongmee@gmail.com>
    NFSD: Call ->set_acl with a NULL ACL structure if no entries

Romain Izard <romain.izard.pro@gmail.com>
    trace: module: Maintain a valid user count

Salva Peiró <speiro@ai2.upv.es>
    media: media-device: fix infoleak in ioctl media_enum_entities()

Tim Chen <tim.c.chen@linux.intel.com>
    crypto: crypto_wq - Fix late crypto work queue initialization

Geert Uytterhoeven <geert+renesas@glider.be>
    Documentation: Update stable address in Chinese and Japanese translations

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Ben Hutchings <ben@decadent.org.uk>
    rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()

Liu Hua <sdu.liu@huawei.com>
    ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr

Christoph Hellwig <hch@lst.de>
    posix_acl: handle NULL ACL in posix_acl_equiv_mode

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: fix beaconing on USB

Daniele Forsi <dforsi@gmail.com>
    USB: Nokia 5300 should be treated as unusual dev

Victor A. Santos <victoraur.santos@gmail.com>
    USB: Nokia 305 should be treated as unusual dev

Daniele Forsi <dforsi@gmail.com>
    usb: storage: shuttle_usbat: fix discs being detected twice

Jean-Jacques Hiblot <jjhiblot@traphandler.com>
    usb: gadget: at91-udc: fix irq and iomem resource retrieval

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: fix ATPX detection on non-VGA GPUs

NeilBrown <neilb@suse.de>
    md: avoid possible spinning md thread at shutdown.

Viresh Kumar <viresh.kumar@linaro.org>
    hrtimer: Set expiry time before switch_hrtimer_base()

Leon Ma <xindong.ma@intel.com>
    hrtimer: Prevent remote enqueue of leftmost timers

Stuart Hayes <stuart.w.hayes@gmail.com>
    hrtimer: Prevent all reprogramming if hang detected

Grant Likely <grant.likely@linaro.org>
    drivercore: deferral race condition fix

Josef Gajdusek <atx@atx.name>
    hwmon: (emc1403) Support full range of known chip revision numbers

Josef Gajdusek <atx@atx.name>
    hwmon: (emc1403) fix inverted store_hyst()

Chen Yucong <slaoub@gmail.com>
    hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage

Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
    x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Corey Minyard <cminyard@mvista.com>
    ipmi: Reset the KCS timeout when starting error recovery

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    ipmi: Fix a race restarting the timer

Jiri Bohac <jbohac@suse.cz>
    timer: Prevent overflow in apply_slack

Linus Torvalds <torvalds@linux-foundation.org>
    mm: make fixup_user_fault() check the vma access rights too

Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    pata_at91: fix ata_host_activate() failure handling

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace/module: Hardcode ftrace_module_init() call into load_module()

Thomas Gleixner <tglx@linutronix.de>
    futex: Prevent attaching to kernel threads

Thomas Gleixner <tglx@linutronix.de>
    futex: Add another early deadlock detection check

Eric Dumazet <edumazet@google.com>
    net-gro: reset skb->truesize in napi_reuse_skb()

Alexander Duyck <alexander.h.duyck@intel.com>
    skb: Add inline helper for getting the skb end offset from head

Li RongQing <roy.qing.li@gmail.com>
    ipv4: initialise the itag variable in __mkroute_input

Jason Wang <jasowang@redhat.com>
    act_mirred: do not drop packets when fails to mirror it

Sergey Popovich <popovich_sergei@mail.ru>
    ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Florian Westphal <fw@strlen.de>
    net: ipv4: ip_forward: fix inverted local_df test

Liu Yu <allanyuliu@tencent.com>
    tcp_cubic: fix the range of delayed_ack

Vlad Yasevich <vyasevic@redhat.com>
    Revert "macvlan : fix checksums error when we are in bridge mode"

David Gibson <david@gibson.dropbear.id.au>
    rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF is set

David Gibson <david@gibson.dropbear.id.au>
    rtnetlink: Warn when interface's information won't fit in our packet

Ivan Vecera <ivecera@redhat.com>
    tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled

Mathias Krause <minipli@googlemail.com>
    filter: prevent nla extensions to peek beyond the end of the message

Wang, Xiaoming <xiaoming.wang@intel.com>
    net: ipv4: current group_info should be put after using.

Eric Dumazet <edumazet@google.com>
    ipv6: Limit mtu to 65575 bytes

Thomas Richter <tmricht@linux.vnet.ibm.com>
    bonding: Remove debug_fs files when module init fails

Florian Westphal <fw@strlen.de>
    net: core: don't account for udp header size when computing seglen

Dmitry Petukhov <dmgenp@gmail.com>
    l2tp: take PMTU from tunnel UDP socket

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: test if association is dead in sctp_wake_up_waiters

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: wake up all assocs if sndbuf policy is per socket

Oleg Nesterov <oleg@redhat.com>
    list: introduce list_next_entry() and list_prev_entry()

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: call drm_edid_to_eld when we update the edid

Christopher Friedt <chrisfriedt@gmail.com>
    drm/vmwgfx: correct fb_fix_screeninfo.line_length

Bjørn Mork <bjorn@mork.no>
    usb: option: add and update a number of CMOTech devices

Bjørn Mork <bjorn@mork.no>
    usb: option: add Alcatel L800MA

Bjørn Mork <bjorn@mork.no>
    usb: option: add Olivetti Olicard 500

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix firmware download on big-endian machines

Johan Hovold <jhovold@gmail.com>
    Revert "USB: serial: add usbid for dell wwan card to sierra.c"

Daniele Palmas <dnlplm@gmail.com>
    usb: option driver, add support for Telit UE910v2

Michele Baldessari <michele@acksyn.org>
    USB: serial: ftdi_sio: add id for Brainboxes serial cards

Tristan Bruns <tristan@tristanbruns.de>
    USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Michael Ulbricht <michael.ulbricht@systec-electronic.com>
    USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver

Mizuma, Masayoshi <m.mizuma@jp.fujitsu.com>
    mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

Helge Deller <deller@gmx.de>
    parisc: fix epoll_pwait syscall on compat kernel


-------------

Diffstat:

 Documentation/i2c/busses/i2c-piix4             |   2 +-
 Documentation/ja_JP/HOWTO                      |   2 +-
 Documentation/ja_JP/stable_kernel_rules.txt    |   6 +-
 Documentation/kernel-parameters.txt            |  20 ++
 Documentation/zh_CN/HOWTO                      |   2 +-
 Documentation/zh_CN/stable_kernel_rules.txt    |   2 +-
 Makefile                                       |   4 +-
 arch/arm/kernel/crash_dump.c                   |   2 +-
 arch/parisc/kernel/syscall_table.S             |   2 +-
 arch/s390/crypto/aes_s390.c                    |  50 +++--
 arch/x86/Kconfig                               |   1 +
 arch/x86/boot/Makefile                         |   6 +-
 arch/x86/boot/compressed/Makefile              |   1 +
 arch/x86/include/asm/hugetlb.h                 |   1 +
 arch/x86/kernel/crash.c                        |   2 +-
 arch/x86/kernel/ldt.c                          |   4 +-
 arch/x86/kernel/reboot.c                       |  11 +-
 arch/x86/kernel/setup.c                        |   4 +-
 arch/x86/kernel/step.c                         |  53 +++--
 arch/x86/kernel/sys_x86_64.c                   |   2 +-
 arch/x86/mm/mmap.c                             |   6 +-
 arch/x86/platform/efi/efi.c                    | 105 ++++++++++
 arch/x86/vdso/vdso32-setup.c                   |   8 +
 crypto/crypto_wq.c                             |   2 +-
 drivers/acpi/blacklist.c                       |  13 ++
 drivers/ata/ata_piix.c                         |   8 +
 drivers/ata/pata_at91.c                        |  11 +-
 drivers/atm/ambassador.c                       |   2 +-
 drivers/atm/idt77252.c                         |   2 +-
 drivers/base/dd.c                              |  17 ++
 drivers/block/floppy.c                         |  11 +-
 drivers/block/nbd.c                            |   9 +
 drivers/char/ipmi/ipmi_kcs_sm.c                |   5 +-
 drivers/char/ipmi/ipmi_si_intf.c               |  46 +++--
 drivers/char/random.c                          |  24 ++-
 drivers/crypto/caam/error.c                    |  10 +-
 drivers/edac/i82975x_edac.c                    |  11 +-
 drivers/firmware/Kconfig                       |  18 ++
 drivers/firmware/efivars.c                     | 256 ++++++++++++++++++-------
 drivers/gpu/drm/drm_crtc_helper.c              |   4 +-
 drivers/gpu/drm/i915/i915_debugfs.c            |   6 +-
 drivers/gpu/drm/i915/i915_drv.h                |   4 +-
 drivers/gpu/drm/i915/i915_gem.c                |  23 ++-
 drivers/gpu/drm/i915/i915_irq.c                |   4 +-
 drivers/gpu/drm/i915/intel_display.c           | 114 ++++++++++-
 drivers/gpu/drm/i915/intel_dp.c                |   5 -
 drivers/gpu/drm/i915/intel_drv.h               |   5 +-
 drivers/gpu/drm/i915/intel_lvds.c              |   3 +-
 drivers/gpu/drm/i915/intel_opregion.c          |   2 +-
 drivers/gpu/drm/i915/intel_panel.c             |  31 ++-
 drivers/gpu/drm/i915/intel_sdvo.c              |  22 ++-
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |   3 -
 drivers/gpu/drm/nouveau/nouveau_bo.c           |   2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c         |   5 +
 drivers/gpu/drm/radeon/evergreen.c             |   9 +-
 drivers/gpu/drm/radeon/ni.c                    |   3 +-
 drivers/gpu/drm/radeon/r600.c                  |   3 +-
 drivers/gpu/drm/radeon/r600_hdmi.c             |   4 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c   |   7 +
 drivers/gpu/drm/radeon/radeon_combios.c        | 125 +++++++++++-
 drivers/gpu/drm/radeon/radeon_connectors.c     |  34 +++-
 drivers/gpu/drm/radeon/radeon_display.c        |   1 +
 drivers/gpu/drm/radeon/radeon_kms.c            |   4 +
 drivers/gpu/drm/radeon/radeon_mode.h           |   2 +
 drivers/gpu/drm/radeon/rv770.c                 |   3 +-
 drivers/gpu/drm/radeon/si.c                    |   3 +-
 drivers/gpu/drm/ttm/ttm_bo.c                   |  32 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c             |   5 +-
 drivers/hid/hid-logitech-dj.c                  |  38 ++--
 drivers/hv/ring_buffer.c                       |   4 +-
 drivers/hv/vmbus_drv.c                         |   2 +-
 drivers/hwmon/emc1403.c                        |   4 +-
 drivers/i2c/busses/Kconfig                     |   1 +
 drivers/i2c/busses/i2c-designware-core.c       |   3 +
 drivers/i2c/busses/i2c-piix4.c                 |   3 +-
 drivers/i2c/busses/i2c-tegra.c                 |  13 +-
 drivers/idle/intel_idle.c                      |   7 +-
 drivers/input/mouse/synaptics.c                |  31 ++-
 drivers/md/dm-bufio.c                          |  26 ++-
 drivers/md/dm-mpath.c                          |  18 +-
 drivers/md/dm-snap.c                           |  73 ++++++-
 drivers/md/dm-thin.c                           |   4 +-
 drivers/md/md.c                                |   3 +-
 drivers/md/persistent-data/dm-btree-remove.c   |  46 ++---
 drivers/md/raid10.c                            |   8 +-
 drivers/media/media-device.c                   |   1 +
 drivers/misc/hpilo.c                           |  11 +-
 drivers/mtd/devices/m25p80.c                   |  19 +-
 drivers/mtd/ubi/scan.c                         |   2 +-
 drivers/net/bonding/bond_main.c                |   1 +
 drivers/net/can/c_can/c_can.c                  |   6 +-
 drivers/net/can/sja1000/sja1000.c              |  17 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |   3 -
 drivers/net/ethernet/broadcom/tg3.c            |   4 +-
 drivers/net/ethernet/intel/e1000e/e1000.h      |   1 +
 drivers/net/ethernet/intel/e1000e/netdev.c     |  48 +++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |   7 +-
 drivers/net/macvlan.c                          |   3 -
 drivers/net/wimax/i2400m/usb-rx.c              |   2 +-
 drivers/net/wireless/b43/Kconfig               |   4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c        |   2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c        |   2 +
 drivers/net/wireless/rt2x00/rt2x00mac.c        |  22 ++-
 drivers/net/wireless/rt2x00/rt73usb.c          |   1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c    |   2 +-
 drivers/net/xen-netfront.c                     |  17 +-
 drivers/pci/hotplug/shpchp.h                   |   2 +-
 drivers/pci/hotplug/shpchp_core.c              |  26 +--
 drivers/pci/hotplug/shpchp_ctrl.c              |  10 +-
 drivers/pci/pcie/aspm.c                        |   3 +
 drivers/platform/x86/msi-wmi.c                 |   4 +-
 drivers/platform/x86/thinkpad_acpi.c           |   2 +-
 drivers/rapidio/devices/tsi721.c               |  11 ++
 drivers/regulator/max8997.c                    |  36 ++--
 drivers/regulator/max8998.c                    |   2 +-
 drivers/rtc/rtc-pl031.c                        |  10 +-
 drivers/staging/octeon/ethernet-tx.c           |   2 +-
 drivers/staging/speakup/speakup_soft.c         |   2 +-
 drivers/staging/zram/zram_drv.c                |  38 ++--
 drivers/staging/zram/zram_sysfs.c              |   6 +-
 drivers/tty/n_gsm.c                            |  78 ++++----
 drivers/tty/serial/imx.c                       |  18 +-
 drivers/usb/class/cdc-acm.c                    |  28 ++-
 drivers/usb/gadget/at91_udc.c                  |  10 -
 drivers/usb/serial/cp210x.c                    |   1 +
 drivers/usb/serial/ftdi_sio.c                  |  33 ++++
 drivers/usb/serial/ftdi_sio_ids.h              |  37 ++++
 drivers/usb/serial/io_ti.c                     |  50 +++--
 drivers/usb/serial/option.c                    |  83 +++++++-
 drivers/usb/serial/sierra.c                    |   1 -
 drivers/usb/storage/shuttle_usbat.c            |   2 +-
 drivers/usb/storage/unusual_devs.h             |  14 ++
 drivers/video/backlight/atmel-pwm-bl.c         |   3 +-
 drivers/video/console/vgacon.c                 |  17 +-
 fs/cachefiles/rdwr.c                           |   2 +-
 fs/cifs/cifsfs.c                               |  24 +++
 fs/cifs/cifsfs.h                               |   4 +
 fs/cifs/cifssmb.c                              |   8 +-
 fs/cifs/file.c                                 |   8 +-
 fs/ecryptfs/keystore.c                         |   3 +-
 fs/nfs/callback_xdr.c                          |   6 +-
 fs/nfs/nfs4proc.c                              |  23 +--
 fs/nfs/nfs4state.c                             |  14 +-
 fs/nfs/pnfs.c                                  |  19 +-
 fs/nfsd/nfs4acl.c                              |  17 +-
 fs/nfsd/nfs4proc.c                             |   8 +-
 fs/nfsd/nfs4state.c                            |  15 +-
 fs/nfsd/nfs4xdr.c                              |   2 +-
 fs/nfsd/vfs.c                                  |   5 +-
 fs/posix_acl.c                                 |   6 +
 fs/stat.c                                      |   5 +-
 include/drm/drm_mode.h                         |   2 +
 include/linux/compiler-intel.h                 |   2 -
 include/linux/efi.h                            |  16 +-
 include/linux/ftrace.h                         |   2 +
 include/linux/list.h                           |  16 ++
 include/linux/mm_types.h                       |   1 +
 include/linux/net.h                            |  23 +++
 include/linux/perf_event.h                     |  12 +-
 include/linux/skbuff.h                         |  12 +-
 include/net/ip6_route.h                        |   5 +
 include/net/mac80211.h                         |   5 +
 include/trace/events/module.h                  |   2 +-
 include/xen/interface/io/netif.h               |   1 +
 kernel/events/core.c                           |   4 +-
 kernel/events/ring_buffer.c                    |  31 ++-
 kernel/futex.c                                 |  52 +++--
 kernel/hrtimer.c                               |  30 ++-
 kernel/module.c                                |   3 +
 kernel/sched/core.c                            |  35 ++--
 kernel/timer.c                                 |   2 +-
 kernel/trace/ftrace.c                          |  98 ++++++----
 kernel/trace/trace.c                           |   6 +-
 mm/hugetlb.c                                   |   1 +
 mm/memory-failure.c                            |  15 +-
 mm/memory.c                                    |   5 +
 mm/percpu.c                                    |   2 +-
 net/core/dev.c                                 |   1 +
 net/core/filter.c                              |   6 +-
 net/core/rtnetlink.c                           |  33 ++--
 net/core/skbuff.c                              |  21 +-
 net/ipv4/fib_semantics.c                       |   2 +-
 net/ipv4/ip_forward.c                          |   4 +-
 net/ipv4/ping.c                                |  15 +-
 net/ipv4/route.c                               |   2 +-
 net/ipv4/tcp_cubic.c                           |   2 +-
 net/ipv6/route.c                               |   5 +-
 net/l2tp/l2tp_ppp.c                            |   4 +-
 net/mac80211/rx.c                              |   3 +
 net/mac80211/status.c                          |   6 +-
 net/sched/act_mirred.c                         |  11 +-
 net/sctp/socket.c                              |  42 +++-
 net/wireless/sme.c                             |   3 +
 sound/pci/hda/patch_conexant.c                 |  34 +++-
 sound/soc/codecs/wm8962.c                      |  15 +-
 sound/soc/codecs/wm8962.h                      |   4 +
 196 files changed, 2217 insertions(+), 745 deletions(-)


