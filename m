Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaKHRXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 12:23:11 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34012 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaKHRXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 12:23:09 -0500
From: Darshana Padmadas <darshanapadmadas@gmail.com>
To: devicetree@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        opw-kernel@googlegroups.com,
        Darshana Padmadas <darshanapadmadas@gmail.com>
Subject: [PATCH v5 0/4] Correct vendor-prefix and document device isl29028
Date: Sat,  8 Nov 2014 22:52:04 +0530
Message-Id: <1415467328-9745-1-git-send-email-darshanapadmadas@gmail.com>
X-Mailer: git-send-email 1.9.1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset documents correct and the deprecated vendor-prefix found by checkpatch
warning and also documents information of device isl29028 for compatibility.
Patchset also includes corrected vendor-prefix and device name in compatible
property for files with checkpatch warning of undocumented string "isil,isl29028".

Darshana Padmadas (4):
  dt-bindings: Document correct and deprecated vendor-prefix with device
    isl29028
  dt-bindings: Document deprecated device vendor name to fix related
    warning
  Staging: iio: light: Added correct vendor-prefix for device isl29028
  arch: arm: boot: dts: Correct vendor-prefix for iio device isl29028 in
    compatible property

Changes in v5:
    - Shortened subject in PATCH 1/4 and PATCH 2/4.

 Documentation/devicetree/bindings/i2c/trivial-devices.txt | 2 ++
 Documentation/devicetree/bindings/vendor-prefixes.txt     | 1 +
 drivers/staging/iio/light/isl29028.c                      | 3 ++-
 arch/arm/boot/dts/tegra30-cardhu.dtsi                     | 2 +-
 4 files changed, 6 insertions(+), 2 deletions(-)

-- 
1.9.1

