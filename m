Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3BOW4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:56:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3BOW4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:56:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 0/8] 3.4.32-stable review
Date: Fri, 15 Feb 2013 14:56:07 -0800
Message-Id: <20130215225430.841634159@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.32 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Feb 17 22:53:47 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.32-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.32-rc1

Alexander Duyck <alexander.h.duyck@intel.com>
    igb: Remove artificial restriction on RQDPC stat reading

Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
    efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter

Rafael J. Wysocki <rjw@sisk.pl>
    PCI/PM: Clean up PME state when removing a device

Jan Beulich <JBeulich@suse.com>
    x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Mel Gorman <mgorman@suse.de>
    x86/mm: Check if PUD is large when validating a kernel address

Stoney Wang <song-bo.wang@hp.com>
    x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems

Kees Cook <keescook@chromium.org>
    x86: Do not leak kernel page mapping locations

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/timer: avoid overflow when programming clock comparator


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/s390/kernel/time.c                   |  3 +++
 arch/x86/include/asm/pgtable.h            |  5 +++++
 arch/x86/kernel/apic/x2apic_phys.c        | 21 +++++++++++----------
 arch/x86/mm/fault.c                       |  8 +++++---
 arch/x86/mm/init_64.c                     |  3 +++
 arch/x86/platform/efi/efi.c               |  2 +-
 arch/x86/xen/xen-asm_32.S                 | 14 +++++++-------
 drivers/net/ethernet/intel/igb/igb_main.c |  8 +++++---
 drivers/pci/remove.c                      |  2 ++
 10 files changed, 44 insertions(+), 26 deletions(-)


