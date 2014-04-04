Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaDDM0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:26:39 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55827 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaDDM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:26:35 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-efi@vger.kernel.org, matt.fleming@intel.com
Cc: linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 0/5] Non-ARM-specific EFI patches needed for ARM ports
Date: Fri,  4 Apr 2014 13:25:45 +0100
Message-Id: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the set of patches from the arm/arm64 UEFI support that are not
in fact architecture specific. This set depends on other EFI patches
already in linux-next.

H. Peter Anvin (1):
  efi: x86: Improve cmdline conversion

Leif Lindholm (1):
  efi: efi-stub-helper cleanup

Mark Salter (1):
  efi: create memory map iteration helper

Roy Franz (2):
  efi: Add shared printk wrapper for consistent prefixing
  efi: Add get_dram_base() helper function

 arch/x86/boot/compressed/eboot.c       |    3 +-
 drivers/firmware/efi/efi-stub-helper.c |  148 +++++++++++++++++++++++---------
 include/linux/efi.h                    |    6 ++
 3 files changed, 116 insertions(+), 41 deletions(-)

-- 
1.7.10.4

