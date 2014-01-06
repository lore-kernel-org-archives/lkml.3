Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbaAFWo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:44:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497AbaAFWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/43] 3.4.76-stable review
Date: Mon,  6 Jan 2014 14:39:17 -0800
Message-Id: <20140106223942.259651490@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.76 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jan  8 22:39:27 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.76-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.76-rc1

Jean Delvare <khali@linux-fr.org>
    hwmon: (w83l768ng) Fix fan speed control range

Paul Moore <pmoore@redhat.com>
    selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()

Paul Moore <pmoore@redhat.com>
    selinux: look for IPsec labels on both inbound and outbound packets

Geert Uytterhoeven <geert@linux-m68k.org>
    sh: always link in helper functions extracted from libgcc

Ben Segall <bsegall@google.com>
    sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Stephen Boyd <sboyd@codeaurora.org>
    gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Theodore Ts'o <tytso@mit.edu>
    jbd2: don't BUG but return ENOSPC if a handle runs out of space

Steven Whitehouse <swhiteho@redhat.com>
    GFS2: Fix incorrect invalidation for DIO/buffered I/O

Steven Whitehouse <swhiteho@redhat.com>
    GFS2: don't hold s_umount over blkdev_put

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: allocate absinfo data when setting ABS capability

Jianguo Wu <wujianguo@huawei.com>
    mm/hugetlb: check for pte NULL pointer in __page_check_address()

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: pci: Fix oops on driver unload

Johannes Berg <johannes.berg@intel.com>
    radiotap: fix bitmap-end-finding buffer overrun

Michele Baldessari <michele@acksyn.org>
    libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8

Josh Boyer <jwboyer@redhat.com>
    cpupower: Fix segfault due to incorrect getopt_long arugments

Anton Blanchard <anton@samba.org>
    powerpc: Align p_end

Michael Neuling <mikey@neuling.org>
    powerpc: Fix bad stack check in exception entry

Mathy Vanhoef <vanhoefm@gmail.com>
    ath9k_htc: properly set MAC address and BSSID mask

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix interrupt handling for the AR9002 family

Peter Korsgaard <peter@korsgaard.com>
    dm9601: work around tx fifo sync issue on dm962x

Peter Korsgaard <peter@korsgaard.com>
    dm9601: fix reception of full size ethernet frames on dm9620/dm9621a

Nithin Sujir <nsujir@broadcom.com>
    tg3: Expand 4g_overflow_test workaround to skb fragments of any size.

Li Wang <liwang@ubuntukylin.com>
    ceph: Avoid data inconsistency due to d-cache aliasing in readpage()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: 0x9649 is SUMO2 not SUMO

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix asic gfx values for scrapper asics

Dan Williams <dan.j.williams@intel.com>
    net_dma: mark broken

Rafał Miłecki <zajec5@gmail.com>
    drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Kirill Tkhai <tkhai@yandex.ru>
    sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Eryu Guan <guaneryu@gmail.com>
    ext4: check for overlapping extents in ext4_valid_extent_entries()

Junho Ryu <jayr@google.com>
    ext4: fix use-after-free in ext4_mb_new_blocks

Len Brown <len.brown@intel.com>
    intel_idle: enable IVB Xeon support

Len Brown <len.brown@intel.com>
    intel_idle: initial IVB support

Miao Xie <miaox@cn.fujitsu.com>
    ftrace: Initialize the ftrace profiler for each possible cpu

Oleg Nesterov <oleg@redhat.com>
    selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Chad Hanson <chanson@trustedcs.com>
    selinux: fix broken peer recv check

Bjørn Mork <bjorn@mork.no>
    usb: cdc-wdm: manage_power should always set needs_remote_wakeup

JongHo Kim <furmuwon@gmail.com>
    ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Bo Shen <voice.shen@atmel.com>
    ASoC: wm8904: fix DSP mode B configuration

Geert Uytterhoeven <geert@linux-m68k.org>
    TTY: pmac_zilog, check existence of ports in pmz_console_init()

pingfan liu <qemulist@gmail.com>
    powerpc: kvm: fix rare but potential deadlock scene

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: wake up 'safe' waiters when unregistering request

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: cleanup aborted requests when re-sending requests.

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix race in generic write


-------------

Diffstat:

 Makefile                                      |  4 +-
 arch/powerpc/include/asm/exception-64s.h      |  2 +-
 arch/powerpc/kernel/head_64.S                 |  1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |  6 ++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c           |  4 ++
 arch/sh/lib/Makefile                          |  2 +-
 drivers/ata/libata-core.c                     |  3 ++
 drivers/dma/Kconfig                           |  1 +
 drivers/gpio/gpio-msm-v2.c                    |  4 +-
 drivers/gpu/drm/drm_edid.c                    |  8 ++++
 drivers/gpu/drm/radeon/ni.c                   | 20 ++++++++--
 drivers/hwmon/w83l786ng.c                     |  9 +++--
 drivers/idle/intel_idle.c                     | 38 +++++++++++++++++++
 drivers/input/input.c                         |  4 ++
 drivers/net/ethernet/broadcom/tg3.c           |  2 +-
 drivers/net/usb/dm9601.c                      | 34 ++++++++++++-----
 drivers/net/wireless/ath/ath9k/ar9002_mac.c   | 52 +++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 25 +++++++++----
 drivers/net/wireless/ath/ath9k/main.c         |  5 ++-
 drivers/net/wireless/rtlwifi/pci.c            |  4 +-
 drivers/tty/serial/pmac_zilog.c               |  3 ++
 drivers/usb/class/cdc-wdm.c                   |  8 ++--
 drivers/usb/serial/generic.c                  |  9 +----
 fs/ceph/addr.c                                |  8 +++-
 fs/ceph/mds_client.c                          |  8 +++-
 fs/ext4/extents.c                             | 19 +++++++++-
 fs/ext4/mballoc.c                             | 11 ++++--
 fs/gfs2/aops.c                                | 30 +++++++++++++++
 fs/gfs2/ops_fstype.c                          | 12 +++++-
 fs/jbd2/transaction.c                         |  6 ++-
 include/drm/drm_pciids.h                      |  2 +-
 kernel/sched/debug.c                          |  8 ++++
 kernel/sched/fair.c                           |  2 +
 kernel/sched/rt.c                             | 14 +++++++
 kernel/trace/ftrace.c                         |  2 +-
 mm/rmap.c                                     |  4 ++
 net/wireless/radiotap.c                       |  4 ++
 security/selinux/hooks.c                      | 53 +++++++++++++++++++++------
 security/selinux/include/xfrm.h               |  9 +++--
 security/selinux/xfrm.c                       | 53 +++++++++++++++++++++------
 sound/core/pcm_lib.c                          |  2 +
 sound/soc/codecs/wm8904.c                     |  2 +-
 tools/power/cpupower/utils/cpupower-set.c     |  6 +--
 43 files changed, 403 insertions(+), 100 deletions(-)


