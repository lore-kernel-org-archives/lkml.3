Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaJGPTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:19:38 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56509 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaJGPTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:19:36 -0400
From: Darshana Padmadas <darshanapadmadas@gmail.com>
To: opw-kernel@googlegroups.com
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Darshana Padmadas <darshanapadmadas@gmail.com>
Subject: [PATCH v4 0/4] Correct vendor-prefix and document device isl29028
Date: Tue,  7 Oct 2014 20:49:25 +0530
Message-Id: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
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
  Documentation: devicetree: bindings: Document correct and deprecated
    vendor-prefix with device isl29028
  Documentation: devicetree: bindings: Document deprecated device vendor
    name to fix related warning
  Staging: iio: light: Added correct vendor-prefix for device isl29028
  arch: arm: boot: dts: Added correct vendor-prefix with device name to
    compatible property

Changes in v4:
    - In PATCH 1/4 gave appropriate description for string describing vendor/chip 
      for deprecated vendor-prefix and device.

 Documentation/devicetree/bindings/i2c/trivial-devices.txt | 2 ++
 Documentation/devicetree/bindings/vendor-prefixes.txt     | 1 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi                     | 2 +-
 drivers/staging/iio/light/isl29028.c                      | 3 ++-
 4 files changed, 6 insertions(+), 2 deletions(-)

-- 
1.9.1

