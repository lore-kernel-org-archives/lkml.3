Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3EVTtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:49:20 -0400
Received: from mout.gmx.net ([212.227.17.21]:61581 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab3EVTtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:49:19 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX19OnlcjAHROeiClg7Rdt97GoNsFj+VEhRvMaNy1TW
	SHmJstd1tP6TGe
From: Marc Dietrich <marvin24@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] replace large udelay by mdelay
Date: Wed, 22 May 2013 21:48:40 +0200
Message-Id: <cover.1369251478.git.marvin24@gmx.de>
X-Mailer: git-send-email 1.7.9.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bad_udelay is generated on distro kernels which often enable all kinds
of drivers. ARM has a max udelay of 2000, so this patchset converts large
udelays to mdelays. This may also be observed using all_modconfig.

Marc Dietrich (2):
  SCSI: nsp32: replace large udelay by mdelay
  nouveau: replace large udelay by mdelay

 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |    3 ++-
 drivers/scsi/nsp32.c                               |    2 +-
 drivers/scsi/nsp32.h                               |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

-- 
1.7.9.5

