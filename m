Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaLIXgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 18:36:37 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44235 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaLIXfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 18:35:54 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hpa@zytor.com, josh@joshtriplett.org, sam@ravnborg.org
Cc: bpoirier@suse.de, x86@kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 0/2] x86/arm64: add xenconfig
Date: Tue,  9 Dec 2014 15:35:36 -0800
Message-Id: <1418168138-6425-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This v2 addreses some minor feedback on patch 2, and just
mends in the review tags.

Luis R. Rodriguez (2):
  x86, platform, xen, kconfig: clarify kvmconfig is for kvm
  x86, arm, platform, xen, kconfig: add xen defconfig helper

 arch/x86/configs/xen.config |  7 +++++++
 kernel/configs/xen.config   | 30 ++++++++++++++++++++++++++++++
 scripts/kconfig/Makefile    |  7 ++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/configs/xen.config
 create mode 100644 kernel/configs/xen.config

-- 
2.1.1

