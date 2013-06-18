Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab3FRQKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:10:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab3FRQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:10:07 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 0/7] 3.0.83-stable review
Date: Tue, 18 Jun 2013 09:10:37 -0700
Message-Id: <20130618160911.721012782@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 3.0.83 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 20 16:07:34 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.83-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.83-rc1

Sage Weil <sage@inktank.com>
    ceph: fix statvfs fr_size

Kees Cook <keescook@chromium.org>
    x86: Fix typo in kexec register clearing

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: migration: add migrate_entry_wait_huge()

Rafael Aquini <aquini@redhat.com>
    swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Disable PowerSave by default

Kees Cook <keescook@chromium.org>
    b43: stop format string leaking into error msgs


-------------

Diffstat:

 Makefile                              |  4 ++--
 arch/x86/kernel/relocate_kernel_64.S  |  2 +-
 drivers/gpu/drm/i915/intel_sdvo.c     | 10 ++++++----
 drivers/net/wireless/ath/ath9k/init.c |  3 +--
 drivers/net/wireless/b43/main.c       |  2 +-
 fs/ceph/super.c                       |  7 ++++++-
 fs/ceph/super.h                       |  2 +-
 include/linux/swapops.h               |  3 +++
 mm/hugetlb.c                          |  2 +-
 mm/migrate.c                          | 23 ++++++++++++++++++-----
 mm/swap_state.c                       | 18 +++++++++++++++++-
 11 files changed, 57 insertions(+), 19 deletions(-)


