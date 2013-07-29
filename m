Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3G2IIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:08:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56811 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab3G2IIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:08:51 -0400
Date: Mon, 29 Jul 2013 09:08:36 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] urgent fix
Message-ID: <20130729080836.GD2515@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to df981edcb9bce00b9c5e4f3cc33f3f98bc9a2394:

  x86, efi: correct call to free_pages (2013-07-26 15:22:32 +0100)

----------------------------------------------------------------
 * The size of memory that gets freed by free_pages() needs to be
   specified in pages, not bytes - Roy Franz.

----------------------------------------------------------------
Roy Franz (1):
      x86, efi: correct call to free_pages

 arch/x86/boot/compressed/eboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
-- 
Matt Fleming, Intel Open Source Technology Center
