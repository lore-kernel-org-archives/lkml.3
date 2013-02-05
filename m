Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3BEMe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:34:57 -0500
Received: from mga12.intel.com ([143.182.124.36]:2822 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753323Ab3BEMey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:34:54 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/2] initramfs with digital signature protection
Date: Tue,  5 Feb 2013 14:34:48 +0200
Message-Id: <cover.1360067333.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This an RFC for the signed initramfs images, which can be used to provide
verified initial user-space. Please read patch description for the detailed
explanation.

BR,
Dmitry

Dmitry Kasatkin (2):
  export unpack_to_rootfs
  initramfs with digital signature protection

 init/Kconfig         |    7 +++
 init/Makefile        |    1 +
 init/do_mounts.h     |   12 ++++
 init/initramfs.c     |    2 +-
 init/initramfs_sig.c |  171 ++++++++++++++++++++++++++++++++++++++++++++++++++
 init/main.c          |    4 ++
 6 files changed, 196 insertions(+), 1 deletion(-)
 create mode 100644 init/initramfs_sig.c

-- 
1.7.10.4

