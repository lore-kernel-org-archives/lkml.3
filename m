Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaICLdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:33:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbaICLcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:32:54 -0400
From: Laszlo Ersek <lersek@redhat.com>
To: mingo@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com,
        lersek@redhat.com
Subject: [PATCH v2 0/5] beautify EFI memmap logs
Date: Wed,  3 Sep 2014 13:32:18 +0200
Message-Id: <1409743943-16934-1-git-send-email-lersek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes in v2:
- explain with examples how the log's appearance changes, in patches 3-5
  [Ingo]

v1 blurb:

> It's a pain to analyze EFI memmap logs while debugging, especially to
> verify the memory types (an enum) and the memory attributes (a
> bitmap). This series renders those columns human-readable, and unifies
> their formatting between x86, ia64 and arm64.

Thanks
Laszlo

Laszlo Ersek (5):
  efi: add macro for EFI_MEMORY_UCE memory attribute
  efi: introduce efi_md_typeattr_format()
  x86: efi: format EFI memory type & attrs with efi_md_typeattr_format()
  ia64: efi: format EFI memory type & attrs with
    efi_md_typeattr_format()
  arm64: efi: format EFI memory type & attrs with
    efi_md_typeattr_format()

 include/linux/efi.h         |  8 +++++++
 arch/arm64/kernel/efi.c     | 26 +++++----------------
 arch/ia64/kernel/efi.c      |  6 +++--
 arch/x86/platform/efi/efi.c |  7 ++++--
 drivers/firmware/efi/efi.c  | 57 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+), 24 deletions(-)

-- 
1.8.3.1

