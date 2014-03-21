Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbaCUB53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:57:29 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44954 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759983AbaCUB51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 21:57:27 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kbuild-all@01.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] x86: vDSO fixes
Date: Thu, 20 Mar 2014 18:57:17 -0700
Message-Id: <cover.1395366931.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <532b9195.3C8GzQgSVEquG2Tq%fengguang.wu@intel.com>
References: <532b9195.3C8GzQgSVEquG2Tq%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 fixes the Xen build.  Patch 2 fixes an embarrassment.

Andy Lutomirski (2):
  x86: Move more vdso definitions into vdso.h
  x86: Finish removing VDSO32_PRELINK

 arch/x86/include/asm/vdso.h  | 38 +++++++++++++++++++++++++++++++++++++-
 arch/x86/vdso/vdso.S         |  2 +-
 arch/x86/vdso/vdso32-setup.c |  7 -------
 arch/x86/vdso/vdso32.S       |  2 +-
 arch/x86/vdso/vdso_image.h   | 30 ------------------------------
 arch/x86/vdso/vdsox32.S      |  2 +-
 arch/x86/vdso/vma.c          |  1 -
 7 files changed, 40 insertions(+), 42 deletions(-)
 delete mode 100644 arch/x86/vdso/vdso_image.h

-- 
1.8.5.3

