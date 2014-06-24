Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbaFXQOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:14:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964866AbaFXPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:55:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.15 00/61] 3.15.2-stable review
Date: Tue, 24 Jun 2014 11:50:43 -0400
Message-Id: <20140624154952.751713761@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.15.2 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 26 15:49:36 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.15.2-rc1

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    slab: fix oops when reading /proc/slab_allocators

Hugh Dickins <hughd@google.com>
    tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently supported

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Make sure that id->index does not overflow

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Handle numid overflow

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Don't access controls outside of protected regions

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Fix replacing user controls

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Protect user controls against concurrent access

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add quirk for external mic on Lifebook U904

Mengdong Lin <mengdong.lin@intel.com>
    ALSA: hda - verify pin:converter connection on unsol event for HSW and VLV

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add more entry for enable HP mute led

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support of ALC891 codec

Wang, Xiaoming <xiaoming.wang@intel.com>
    ALSA: compress: Cancel the optimization of compiler and fix the size of struct for all platform.

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lz4: ensure length does not wrap

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lzo: properly check for overruns

Peter Meerwald <pmeerw@pmeerw.net>
    iio: Fix two mpl3115 issues in measurement conversion

Peter Meerwald <pmeerw@pmeerw.net>
    iio: Fix endianness issue in ak8975_read_axis()

Dan Carpenter <dan.carpenter@oracle.com>
    iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()

Robert Hodaszi <robert.hodaszi@digi.com>
    iio: mxs-lradc: fix divider

Dan Carpenter <dan.carpenter@oracle.com>
    iio: adc: checking for NULL instead of IS_ERR() in probe

Mario Schuknecht <mario.schuknecht@dresearch-fe.de>
    staging: iio: tsl2x7x_core: fix proximity treshold

Jonathan Cameron <jic23@kernel.org>
    iio:adc:max1363 incorrect resolutions for max11604, max11605, max11610 and max11611.

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: tlv320aci3x: Fix custom snd_soc_dapm_put_volsw_aic3x() function

Liam Girdwood <liam.r.girdwood@linux.intel.com>
    ASoC: max98090: Fix reset at resume time

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: dapm: Make sure to always update the DAPM graph in _put_volsw()

Radim Krčmář <rkrcmar@redhat.com>
    hv: use correct order when freeing monitor_pages

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: balloon: Ensure pressure reports are posted regularly

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix runtime PM imbalance at shutdown

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix I/O after failed open

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix failed open not being detected

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix open and suspend race

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix potential urb leak and PM imbalance in write

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix shutdown and suspend race

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix runtime PM for control messages

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix broken runtime suspend

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix write and resume race

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix write and suspend race

James Hogan <james.hogan@imgtec.com>
    MIPS: KVM: Allocate at least 16KB for exception handlers

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: Drop pending interrupts on guest exit

Paolo Bonzini <pbonzini@redhat.com>
    KVM: lapic: sync highest ISR to hardware apic on EOI

Boris BREZILLON <boris.brezillon@free-electrons.com>
    ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs

Eric Dumazet <edumazet@google.com>
    udp: ipv4: do not waste time in __udp4_lib_mcast_demux_lookup

Cong Wang <cwang@twopensource.com>
    vxlan: use dev->needed_headroom instead of dev->hard_header_len

Michal Schmidt <mschmidt@redhat.com>
    rtnetlink: fix userspace API breakage for iproute2 < v3.9.0

Xufeng Zhang <xufeng.zhang@windriver.com>
    sctp: Fix sk_ack_backlog wrap-around problem

Eric Dumazet <edumazet@google.com>
    ipv4: fix a race in ip4_datagram_release_cb()

Jon Cooper <jcooper@solarflare.com>
    sfc: PIO:Restrict to 64bit arch and use 64-bit writes.

Dmitry Popov <ixaphire@qrator.net>
    ipip, sit: fix ipv4_{update_pmtu,redirect} calls

Eric Dumazet <edumazet@google.com>
    net: force a list_del() in unregister_netdevice_many()

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Olivetti Olicard modems

Alexei Starovoitov <ast@plumgrid.com>
    net: filter: fix sparc32 typo

Alexei Starovoitov <ast@plumgrid.com>
    net: filter: fix typo in sparc BPF JIT

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    sh_eth: fix SH7619/771x support

Ben Dooks <ben.dooks@codethink.co.uk>
    sh_eth: use RNC mode for packet reception

Tom Gundersen <teg@jklm.no>
    net: tunnels - enable module autoloading

Sven Wegener <sven.wegener@stealer.net>
    ipv6: Fix regression caused by efe4208 in udp_v6_mcast_next()

Mimi Zohar <zohar@linux.vnet.ibm.com>
    evm: prohibit userspace writing 'security.evm' HMAC value

Dmitry Kasatkin <d.kasatkin@samsung.com>
    ima: introduce ima_kernel_read()

Mimi Zohar <zohar@linux.vnet.ibm.com>
    ima: audit log files opened with O_DIRECT flag

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Reject mutual authentication with reflected CHAP_C

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix NULL pointer dereference for XCOPY in target_put_sess_cmd

Boris BREZILLON <boris.brezillon@free-electrons.com>
    rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq


-------------

Diffstat:

 Documentation/ABI/testing/ima_policy     |   2 +-
 Makefile                                 |   4 +-
 arch/arm/mach-at91/sysirq_mask.c         |  22 +++---
 arch/mips/kvm/kvm_mips.c                 |   2 +-
 arch/s390/kvm/interrupt.c                |   4 +-
 arch/s390/kvm/kvm-s390.c                 |   2 +
 arch/s390/kvm/kvm-s390.h                 |   1 +
 arch/sparc/net/bpf_jit_comp.c            |   8 +-
 arch/x86/kvm/lapic.c                     |  62 ++++++++++-----
 drivers/hv/connection.c                  |   4 +-
 drivers/hv/hv_balloon.c                  |  29 ++++++-
 drivers/iio/adc/at91_adc.c               |  16 ++--
 drivers/iio/adc/max1363.c                |  16 ++--
 drivers/iio/adc/men_z188_adc.c           |   4 +-
 drivers/iio/magnetometer/ak8975.c        |   9 +--
 drivers/iio/pressure/mpl3115.c           |   6 +-
 drivers/net/ethernet/renesas/sh_eth.c    |  32 +++++---
 drivers/net/ethernet/renesas/sh_eth.h    |   2 -
 drivers/net/ethernet/sfc/io.h            |   7 ++
 drivers/net/ethernet/sfc/tx.c            |  22 ++++--
 drivers/net/macvlan.c                    |   1 -
 drivers/net/usb/qmi_wwan.c               |   7 +-
 drivers/net/vxlan.c                      |   7 +-
 drivers/rtc/rtc-at91rm9200.c             |  16 +++-
 drivers/staging/iio/adc/mxs-lradc.c      |  12 ++-
 drivers/staging/iio/light/tsl2x7x_core.c |   8 +-
 drivers/target/iscsi/iscsi_target_auth.c |  10 +++
 drivers/target/target_core_transport.c   |   4 +
 drivers/usb/class/cdc-acm.c              | 125 ++++++++++++++++++-------------
 drivers/usb/class/cdc-acm.h              |   2 +-
 include/sound/core.h                     |   2 +
 include/uapi/sound/compress_offload.h    |   2 +-
 lib/lz4/lz4_decompress.c                 |   2 +
 lib/lzo/lzo1x_decompress_safe.c          |  62 +++++++++------
 mm/shmem.c                               |   3 +
 mm/slab.c                                |  90 +++++++++++++++++-----
 net/core/dev.c                           |   5 +-
 net/core/rtnetlink.c                     |  23 ++++--
 net/ipv4/datagram.c                      |  20 +++--
 net/ipv4/ipip.c                          |   5 +-
 net/ipv4/udp.c                           |   4 +
 net/ipv6/ip6_tunnel.c                    |   1 +
 net/ipv6/sit.c                           |   5 +-
 net/ipv6/udp.c                           |   8 +-
 net/mac80211/iface.c                     |   1 -
 net/sctp/associola.c                     |   2 +-
 security/integrity/evm/evm_main.c        |  12 ++-
 security/integrity/ima/ima_api.c         |  10 ++-
 security/integrity/ima/ima_crypto.c      |  32 +++++++-
 security/integrity/ima/ima_main.c        |   5 +-
 security/integrity/ima/ima_policy.c      |   6 +-
 security/integrity/integrity.h           |   1 +
 sound/core/control.c                     |  78 ++++++++++++-------
 sound/core/init.c                        |   1 +
 sound/pci/hda/patch_hdmi.c               |  10 ++-
 sound/pci/hda/patch_realtek.c            |  24 ++++++
 sound/soc/codecs/max98090.c              |   3 +
 sound/soc/codecs/tlv320aic3x.c           |   2 +-
 sound/soc/soc-dapm.c                     |  23 +++---
 59 files changed, 625 insertions(+), 263 deletions(-)


