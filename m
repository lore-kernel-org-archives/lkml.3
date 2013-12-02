Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3LBTlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:41:11 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41522 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab3LBTkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:40:33 -0500
MIME-Version: 1.0
Date: Mon, 2 Dec 2013 14:40:33 -0500
X-Google-Sender-Auth: 0l0BDnDLksJzuHkGdpX5XUJbwRk
Message-ID: <CA+5PVA6Mh=tRM5h=TCbg5yjkkFUg2OncJmHBdtBhG7jqf377rg@mail.gmail.com>
Subject: Nov. Fedora Kernel Patch Report
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple days late due to the holidays.  Here are the patches we
currently have on top of 3.12.2:

md-test-mddev-flags-more-safely-in-md_check_recovery.patch (rhbz 1033971)
- In 3.13, should already be CC'd to stable

inet-prevent-leakage-of-uninitialized-memory-to-user.patch
inet-fix-addr_len-msg_namelen-assignment-in-recv_error-and-rxpmtu-functions.patch
(rhbz 1035875)
- Should be heading to 3.13.  Fixes CVE-2013-6405

usbnet-fix-status-interrupt-urb-handling.patch (rhbz 998342)
- In 3.13

via-velocity-fix-netif_receive_skb-use-in-irq-disable.patch (rhbz 1022733)
- Submitted for 3.13 and CC'd to 3.12 stable

xfs-underflow-bug-in-xfs_attrlist_by_handle.patch (rhbz 1033603)
- Submitted and acked, but not queued
http://thread.gmane.org/gmane.comp.file-systems.xfs.general/57654

sunrpc-create-a-new-dummy-pipe-for-gssd-to-hold-open.patch
sunrpc-replace-gssd_running-with-more-reliable-check.patch
nfs-check-gssd-running-before-krb5i-auth.patch
- These fix a 15 second NFS mount delay.  Should be headed upstream
soonish (I think)

drm-radeon-24hz-audio-fixes.patch (rhbz 1010679)
- Should be in 3.13

alx-Reset-phy-speed-after-resume.patch (rhbz 1011362)
- In 3.13

ip6_output-fragment-outgoing-reassembled-skb-properl.patch
netfilter-push-reasm-skb-through-instead-of-original.patch (rhbz 1015905)
- 3.13 and CC'd to stable

ipv6-fix-headroom-calculation-in-udp6_ufo_fragment.patch (rhbz 1030015)
- 3.13.  Fixes CVE-2013-4563

Input-evdev-fall-back-to-vmalloc-for-client-event-buffer.patch
- Fixes high order allocations.  In 3.13

drm-qxl-backport-fixes-for-Fedora.patch
drm-qxl-fix-memory-leak-in-release-list-handling.patch
- Various QXL fixes Dave Airlied thought would be good to have.  In 3.13

cpupower-Fix-segfault-due-to-incorrect-getopt_long-a.patch (rhbz 1000439)
- Queued for next upstream release I believe.  Fixes a segfault in cpupower

dm-cache-policy-mq_fix-large-scale-table-allocation-bug.patch (rhbz 993744)
- Still pending upstream

0002-iwlwifi-don-t-WARN-on-bad-firmware-state.patch (rhbz 896695)
- Still pending upstream

vfio-iommu-Fixed-interaction-of-VFIO_IOMMU_MAP_DMA.patch (rhbz 998732)
- In 3.13

iommu-Remove-stack-trace-from-broken-irq-remapping-warning.patch (rhbz 982153)
- In 3.13

rt2800-add-support-for-rf3070.patch (rhbz 974072)
- In 3.13

elevator-Fix-a-race-in-elevator-switching-and-md.patch
elevator-acquire-q-sysfs_lock-in-elevator_change.patch (rhbz 902012)
- In 3.13

ntp-Make-periodic-RTC-update-more-reliable.patch (rhbz 985522)
- In 3.13

secure-modules.patch
modsign-uefi.patch
sb-hibernate.patch
sysrq-secure-boot.patch
  - Fedora secure boot support.
  - Dear Matthew, this is your fault.  Run sed already and get a new set out.

keys-expand-keyring.patch
keys-krb-support.patch
keys-x509-improv.patch
keyring-quota.patch
- These are all in 3.13 now.  Yay.
