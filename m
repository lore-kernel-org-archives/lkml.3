Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaC1RaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:30:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaC1RaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/13] 3.4.85-stable review
Date: Fri, 28 Mar 2014 10:31:50 -0700
Message-Id: <20140328173053.049244535@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.85 release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar 30 17:30:36 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.85-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.85-rc1

Konstantin Khlebnikov <k.khlebnikov@samsung.com>
    ipc/msg: fix race around refcount

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix resume issues on Renesas chips in Samsung laptops

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: VMX: fix use after free of vmx->loaded_vmcs

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: MMU: handle invalid root_hpa at __direct_map

Hans de Goede <hdegoede@redhat.com>
    Input: elantech - improve clickpad detection

Rob Herring <rob.herring@calxeda.com>
    ARM: move outer_cache declaration out of ifdef

Jean Delvare <jdelvare@suse.de>
    i7300_edac: Fix device reference count

Dan Carpenter <dan.carpenter@oracle.com>
    p54: clamp properly instead of just truncating

Ben Hutchings <ben@decadent.org.uk>
    deb-pkg: Fix cross-building linux-headers package

Alexei Starovoitov <ast@plumgrid.com>
    x86: bpf_jit: support negative offsets

Ben Hutchings <ben@decadent.org.uk>
    iwlwifi: Complete backport of "iwlwifi: always copy first 16 bytes of commands"

Josh Durgin <josh.durgin@inktank.com>
    libceph: resend all writes after the osdmap loses the full flag

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ALSA: compress: Pass through return value of open ops callback


-------------

Diffstat:

 Makefile                                         |  4 +--
 arch/arm/include/asm/outercache.h                |  4 +--
 arch/x86/kvm/mmu.c                               |  3 ++
 arch/x86/kvm/vmx.c                               |  2 +-
 arch/x86/net/bpf_jit.S                           |  2 +-
 drivers/edac/i7300_edac.c                        | 38 ++++++++++----------
 drivers/input/mouse/elantech.c                   | 45 ++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |  7 ++--
 drivers/net/wireless/p54/txrx.c                  |  2 +-
 drivers/usb/host/xhci-pci.c                      |  5 +++
 ipc/msg.c                                        |  2 ++
 net/ceph/osd_client.c                            | 28 +++++++++++----
 scripts/package/builddeb                         |  9 +++--
 sound/core/compress_offload.c                    |  2 +-
 14 files changed, 110 insertions(+), 43 deletions(-)


