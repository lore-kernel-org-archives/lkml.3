Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3EVWSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:18:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3EVWSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:18:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 0/5] 3.4.47-stable review
Date: Wed, 22 May 2013 15:18:06 -0700
Message-Id: <20130522221330.720801923@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.47 release.
There are 5 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri May 24 22:10:47 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.47-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.47-rc1

Alan Cox <alan@linux.intel.com>
    media: mantis: fix silly crash case

Niels Ole Salscheider <niels_ole@salscheider-online.de>
    drm/radeon: Fix VRAM size calculation for VRAM >= 4GB

Mika Westerberg <mika.westerberg@linux.intel.com>
    i2c: designware: always clear interrupts before enabling them

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    hwmon: fix error return code in abituguru_probe()

Gabriel de Perthuis <g2p.code@gmail.com>
    btrfs: don't stop searching after encountering the wrong item


-------------

Diffstat:

 Makefile                                 |  4 ++--
 drivers/gpu/drm/radeon/evergreen.c       |  4 ++--
 drivers/gpu/drm/radeon/radeon_ttm.c      |  2 +-
 drivers/gpu/drm/radeon/si.c              |  4 ++--
 drivers/hwmon/abituguru.c                | 16 ++++++++++------
 drivers/i2c/busses/i2c-designware-core.c |  3 ++-
 drivers/media/dvb/mantis/mantis_dvb.c    |  6 ++++--
 fs/btrfs/ioctl.c                         | 10 +++++-----
 8 files changed, 28 insertions(+), 21 deletions(-)


