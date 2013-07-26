Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab3GZU6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:58:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab3GZU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/45] 3.0.88-stable review
Date: Fri, 26 Jul 2013 13:57:20 -0700
Message-Id: <20130726205654.896050165@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.88 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Jul 28 20:54:53 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.88-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.88-rc1

Eldad Zack <eldad@fogrefinery.com>
    ALSA: usb-audio: 6fire: return correct XRUN indication

Steffen Maier <maier@linux.vnet.ibm.com>
    zfcp: status read buffers on first adapter open with link down

Thomas Gleixner <tglx@linutronix.de>
    hrtimers: Move SMP function call to thread context

zhangwei(Jovi) <jovi.zhangwei@huawei.com>
    tracing: Fix irqs-off tag display in syscall tracing

David Jeffery <djeffery@redhat.com>
    lockd: protect nlm_blocked access in nlmsvc_retry_blocked

Barry Grussling <barry@grussling.com>
    usb: cp210x support SEL C662 Vendor/Device

Sami Rahman <sami.rahman@mmbresearch.com>
    USB: cp210x: add MMB and PI ZigBee USB Device Support

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial adapter

Enrico Mioso <mrkiko.rs@gmail.com>
    usb: serial: option: Add ONYX 3G device support

Alexandr \\\"Sky\\\" Ivanov <alexandr.sky@gmail.com>
    USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Daniil Bolsun <dan.bolsun@gmail.com>
    USB: option: append Petatel NP10T device to GSM modems list

Enrico Mioso <mrkiko.rs@gmail.com>
    usb: serial: option.c: remove ONDA MT825UP product ID fromdriver

Dan Williams <dcbw@redhat.com>
    usb: serial: option: add Olivetti Olicard 200

Bjørn Mork <bjorn@mork.no>
    usb: option: add TP-LINK MA260

Enrico Mioso <mrkiko.rs@gmail.com>
    usb: serial: option: blacklist ONDA MT689DC QMI interface

Andi Kleen <andi@firstfloor.org>
    SCSI: Fix incorrect memset in bnx2fc_parse_fcp_rsp

Bjørn Mork <bjorn@mork.no>
    SCSI: megaraid_sas: fix memory leak if SGL has zero length entries

Jan Kara <jack@suse.cz>
    writeback: Fix periodic writeback after fs mount

Eric Dumazet <edumazet@google.com>
    vlan: fix a race in egress prio management

dingtianhong <dingtianhong@huawei.com>
    ifb: fix oops when loading the ifb failed

dingtianhong <dingtianhong@huawei.com>
    dummy: fix oops when loading the dummy failed

dingtianhong <dingtianhong@huawei.com>
    ifb: fix rcu_sched self-detected stalls

Dave Kleikamp <dave.kleikamp@oracle.com>
    sunvnet: vnet_port_remove must call unregister_netdev

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: call udp_push_pending_frames when uncorking a socket with AF_INET pending data

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    l2tp: add missing .owner to struct pppox_proto

Amerigo Wang <amwang@redhat.com>
    ipv6,mcast: always hold idev->lock before mca_lock

Changli Gao <xiaosuo@gmail.com>
    net: Swap ver and type in pppoe_hdr

Dave Jones <davej@redhat.com>
    x25: Fix broken locking in ioctl error paths.

Eric Dumazet <eric.dumazet@gmail.com>
    neighbour: fix a race in neigh_destroy()

Mathias Krause <minipli@googlemail.com>
    af_key: fix info leaks in notify messages

Eric Dumazet <edumazet@google.com>
    ipv6: ip6_sk_dst_check() must not assume ipv6 dst

Gao feng <gaofeng@cn.fujitsu.com>
    ipv6: don't call addrconf_dst_alloc again when enable lo

Linus Lüssing <linus.luessing@web.de>
    bridge: fix switched interval for MLD Query types

Dave Kleikamp <dave.kleikamp@oracle.com>
    sparc: tsb must be flushed before tlb

bob picco <bpicco@meloft.net>
    sparc64 address-congruence property

Olivier DANET <odanet@caramail.com>
    sparc32: vm_area_struct access for old Sun SPARCs.

Peter Zijlstra <peterz@infradead.org>
    perf: Fix perf_lock_task_context() vs RCU

Jiri Olsa <jolsa@redhat.com>
    perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid scenario

Jiri Olsa <jolsa@redhat.com>
    perf: Clone child context from parent context pmu

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Use current_uid() for critical time tracing

Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
    SCSI: mpt2sas: fix firmware failure with wrong task attribute

Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>
    SCSI: zfcp: fix adapter (re)open recovery while link to SAN is down

Gabor Juhos <juhosg@openwrt.org>
    rt2x00: read 5GHz TX power values from the correct offset

Fabio Estevam <fabio.estevam@freescale.com>
    ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK

Thomas Gleixner <tglx@linutronix.de>
    tick: Prevent uncontrolled switch to oneshot mode


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/sparc/kernel/asm-offsets.c           |  2 ++
 arch/sparc/mm/hypersparc.S                |  8 ++++----
 arch/sparc/mm/init_64.c                   |  9 ++++++++-
 arch/sparc/mm/swift.S                     |  8 ++++----
 arch/sparc/mm/tlb.c                       |  2 +-
 arch/sparc/mm/tsunami.S                   |  6 +++---
 arch/sparc/mm/viking.S                    | 10 +++++-----
 drivers/net/dummy.c                       |  4 ++++
 drivers/net/ifb.c                         |  8 +++++++-
 drivers/net/sunvnet.c                     |  2 ++
 drivers/net/wireless/rt2x00/rt2800lib.c   |  4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c     |  3 ++-
 drivers/net/wireless/rt2x00/rt73usb.c     |  3 ++-
 drivers/s390/scsi/zfcp_aux.c              |  5 ++++-
 drivers/s390/scsi/zfcp_fsf.c              | 25 +++++++++++++++++++------
 drivers/scsi/bnx2fc/bnx2fc_io.c           |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 ++++++----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |  6 +-----
 drivers/usb/serial/cp210x.c               |  4 ++++
 drivers/usb/serial/option.c               | 23 +++++++++++++----------
 fs/block_dev.c                            | 10 +++++++++-
 fs/lockd/svclock.c                        |  4 ++++
 include/linux/if_pppox.h                  |  4 ++--
 include/net/addrconf.h                    |  3 +++
 include/net/udp.h                         |  1 +
 kernel/events/core.c                      | 28 +++++++++++++++++++++++++---
 kernel/hrtimer.c                          | 28 +++++++++++++---------------
 kernel/time/tick-broadcast.c              | 10 +++++++++-
 kernel/trace/trace.c                      | 10 +++++++++-
 kernel/trace/trace_syscalls.c             | 18 ++++++++++++++----
 net/8021q/vlan_dev.c                      |  7 +++++++
 net/bridge/br_multicast.c                 |  5 +++--
 net/core/neighbour.c                      | 12 +++++++-----
 net/ipv4/udp.c                            |  3 ++-
 net/ipv6/addrconf.c                       | 31 +++++++++++++++++++++----------
 net/ipv6/ip6_output.c                     |  8 +++++++-
 net/ipv6/mcast.c                          | 18 ++++++++++--------
 net/ipv6/udp.c                            |  7 ++++++-
 net/key/af_key.c                          |  2 ++
 net/l2tp/l2tp_ppp.c                       |  3 ++-
 net/x25/af_x25.c                          | 15 ++++++++-------
 sound/soc/codecs/sgtl5000.h               |  2 +-
 sound/usb/6fire/pcm.c                     |  2 +-
 44 files changed, 262 insertions(+), 117 deletions(-)


