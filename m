Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3JXTBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:01:30 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54722 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3JXTB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:01:29 -0400
MIME-Version: 1.0
Date: Thu, 24 Oct 2013 15:01:28 -0400
Message-ID: <CA+5PVA5megGZVEFdmDGyeALQux2ppBEJtULm5hY81khhsFk0kA@mail.gmail.com>
Subject: Oct. Fedora Kernel Patch Report
From: Josh Boyer <jwboyer@gmail.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's this months Fedora kernel report.  I intended to get it out
last week, but Greg keeps releasing new stable kernels.  Given he's at
KS right now, I'll finally get it written before another release comes
out.

I've skipped the patches we tend to carry for default option changes
and such.  If people really want me to keep listing those, I'd be
happy to.

josh

Patches we currently have on top of 3.11.6:

tcp-fix-incorrect-ca_state-in-tail-loss-probe.patch (rhbz 989251)
- Backport of upstream commit 031afe4990a7c9dbff41a3a742c44d3e740ea0a1

fix-buslogic.patch (rhbz 1015558)
- Backport of upstream commit 6541932ea2f7de0b0c5203decf666b143ad5fa33

rt2800usb-slow-down-TX-status-polling.patch (rhbz 984696)
- Still pending upstream.  Fixes
https://bugzilla.kernel.org/show_bug.cgi?id=62781

btrfs-relocate-csums-properly-with-prealloc-ext.patch (rhbz 1011714)
- Still pending upstream

fix-radeon-sound.patch (rhbz 1010679)
- Backport of:
  062c2e4363451d49ef840232fe65e8bff0dde2a5
  e7d12c2f98ae1e68c7298e5028048d150fa553a1
  ee0fec312a1c4e26f255955da942562cd8908a4b
  b852c985010a77c850b7548d64bbb964ca462b02
- fixes https://bugs.freedesktop.org/show_bug.cgi?id=69675

cpupower-Fix-segfault-due-to-incorrect-getopt_long-a.patch (rhbz 1000439)
- Queued for next upstream release I believe.  Fixes a segfault in cpupower

dm-cache-policy-mq_fix-large-scale-table-allocation-bug.patch (rhbz 993744)
- Still pending upstream

0001-iwlwifi-don-t-WARN-on-host-commands-sent-when-firmwa.patch (rhbz 896695)
- Backport of commit 8ca95995e64f5d270889badb3e449dca91106a2b

0002-iwlwifi-don-t-WARN-on-bad-firmware-state.patch (rhbz 896695)
- Still pending upstream

vfio-iommu-Fixed-interaction-of-VFIO_IOMMU_MAP_DMA.patch (rhbz 998732)
- Still pending upstream

iommu-Remove-stack-trace-from-broken-irq-remapping-warning.patch (rhbz 982153)
- Still pending upstream

netfilter-nf_conntrack-use-RCU-safe-kfree-for-conntr.patch
- Backport of commit c13a84a830a208fb3443628773c8ca0557773cc7

rt2800-add-support-for-rf3070.patch (rhbz 974072)
- Actually I'm unsure of what the upstream status on this one is.

elevator-Fix-a-race-in-elevator-switching-and-md.patch
elevator-acquire-q-sysfs_lock-in-elevator_change.patch (rhbz 902012)
- I believe these are both queued for the next upstream release

bonding-driver-alb-learning.patch (rhbz 971893)
- Backport of commit 7eacd03810960823393521063734fc8188446bca

Revert-rt2x00pci-Use-PCI-MSIs-whenever-possible.patch
- Backport of commit dfb6b7c109a7f98d324a759599d1b4616f02c79f

ntp-Make-periodic-RTC-update-more-reliable.patch (rhbz 985522)
- I believe this is queued in John Stultz's tree for 3.13

ansi_cprng-Fix-off-by-one-error-in-non-block-size-request.patch (rhbz
1007690 1009136)
- Fixes CVE-2013-4345

media-cx23885-Fix-TeVii-S471-regression-since-introduction-of-ts2020.patch
(rhbz 963715)
- Backport of commit b43ea8068d2090cb1e44632c8a938ab40d2c7419

iwl3945-better-skb-management-in-rx-path.patch
iwl4965-better-skb-management-in-rx-path.patch (rhbz 977040)
  - Backport of commits 45fe142cefa864b685615bcb930159f6749c3667 and
c1de4a9557d9e25e41fc4ba034b9659152205539

ath9k_rx_dma_stop_check.patch (rhbz 892811)
  - Fixes some DMA issue on specific hardware.  Taken from
https://dev.openwrt.org/browser/trunk/package/mac80211/patches/552-ath9k_rx_dma_stop_check.patch?rev=34910

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
- I believe these are all now queued for 3.13 in James Morris' tree.
