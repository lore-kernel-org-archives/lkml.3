Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965816AbaFTJAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:00:15 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37851 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934184AbaFTJAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:00:13 -0400
Date: Fri, 20 Jun 2014 10:00:08 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [GIT PULL] EFI urgent fix
Message-ID: <20140620090008.GU24049@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,

Please pull the following compiler warning fix. Sorry, I've been pretty
slow in getting this pull request sent. Multiple people have reported
hitting it and I've now received 4 patches for the same warning,

  http://article.gmane.org/gmane.linux.kernel.efi/4024
  http://article.gmane.org/gmane.linux.kernel.efi/4017
  http://article.gmane.org/gmane.linux.kernel.efi/3957
  http://article.gmane.org/gmane.linux.kernel.efi/3930

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 6fb8cc82c096fd5ccf277678639193cae07125a0:

  efi: Fix compiler warnings (unused, const, type) (2014-06-19 15:03:05 +0100)

----------------------------------------------------------------
 * Fix a few compiler warnings in the arm64 EFI code that lots of people
   are running into and reporting - Catalin Marinas

----------------------------------------------------------------
Catalin Marinas (1):
      efi: Fix compiler warnings (unused, const, type)

 drivers/firmware/efi/efi.c | 6 +++---
 drivers/firmware/efi/fdt.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
