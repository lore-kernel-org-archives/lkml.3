Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaLHXFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:05:09 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57702 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaLHXFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:05:07 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hpa@zytor.com, josh@joshtriplett.org, sam@ravnborg.org
Cc: bpoirier@suse.de, x86@kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 0/2]: x86/arm64: add xenconfig
Date: Mon,  8 Dec 2014 15:04:58 -0800
Message-Id: <1418079900-4640-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This is based on some old set I had lying around. The virtconfig
changes I had proposed a while ago got merged and reused for
tinyconfig, this adapts my original set to use the new mergeconfig.

Not sure who's tree this should go through, last time these were
lost in space and only the non-xen things got cherry picked later,
who's tree should this go through?

Luis R. Rodriguez (2):
  x86, platform, xen, kconfig: clarify kvmconfig is for kvm
  x86, arm, platform, xen, kconfig: add xen defconfig helper

 arch/x86/configs/xen.config |  6 ++++++
 kernel/configs/xen.config   | 32 ++++++++++++++++++++++++++++++++
 scripts/kconfig/Makefile    |  7 ++++++-
 3 files changed, 44 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/configs/xen.config
 create mode 100644 kernel/configs/xen.config

-- 
2.1.1

