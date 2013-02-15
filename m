Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3BOWz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:55:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3BOWz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:55:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 0/4] 3.0.65-stable review
Date: Fri, 15 Feb 2013 14:55:49 -0800
Message-Id: <20130215225523.525656849@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.65 release.
There are 4 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Feb 17 22:53:56 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.65-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.65-rc1

Alexander Duyck <alexander.h.duyck@intel.com>
    igb: Remove artificial restriction on RQDPC stat reading

Rafael J. Wysocki <rjw@sisk.pl>
    PCI/PM: Clean up PME state when removing a device

Jan Beulich <JBeulich@suse.com>
    x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Mel Gorman <mgorman@suse.de>
    x86/mm: Check if PUD is large when validating a kernel address


-------------

Diffstat:

 Makefile                       |  4 ++--
 arch/x86/include/asm/pgtable.h |  5 +++++
 arch/x86/mm/init_64.c          |  3 +++
 arch/x86/xen/xen-asm_32.S      | 14 +++++++-------
 drivers/net/igb/igb_main.c     |  8 +++++---
 drivers/pci/remove.c           |  2 ++
 6 files changed, 24 insertions(+), 12 deletions(-)


