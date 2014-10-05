Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaJEI74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 04:59:56 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41046 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaJEI7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 04:59:53 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 00/11] pt3: pci, tc90522, mxl301rf, qm1d1c0042
Date: Sun,  5 Oct 2014 17:59:36 +0900
Message-Id: <cover.1412497399.git.knightrider@are.ma>
X-Mailer: git-send-email 1.8.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** PT3 stable driver ***
Clean Package:
Please pull from
	https://github.com/knight-rider/ptx/tree/master/pt3_dvb

Буди Романто, AreMa Inc (11):
  tc90522: better chip description
  tc90522 is a client
  tc90522: use hardware algorithm & correct CNR
  pt3: add comment
  pt3: merge I2C & DMA handlers
  pt3: namespace cleanup
  mxl301rf: namespace cleanup
  qm1d1c0042: namespace cleanup
  mxl301rf: namespace cleanup & remodelling
  qm1d1c0042: namespace cleanup & remodelling
  pt3: merge I2C & DMA handlers

 drivers/media/dvb-frontends/Kconfig   |    4 +-
 drivers/media/dvb-frontends/Makefile  |    1 +
 drivers/media/dvb-frontends/tc90522.c | 1146 +++++++++---------------
 drivers/media/dvb-frontends/tc90522.h |   41 +-
 drivers/media/pci/pt3/Kconfig         |    2 +-
 drivers/media/pci/pt3/Makefile        |    8 +-
 drivers/media/pci/pt3/pt3.c           | 1557 ++++++++++++++++++---------------
 drivers/media/pci/pt3/pt3.h           |  183 +---
 drivers/media/pci/pt3/pt3_dma.c       |  225 -----
 drivers/media/pci/pt3/pt3_i2c.c       |  240 -----
 drivers/media/tuners/mxl301rf.c       |  550 ++++++------
 drivers/media/tuners/mxl301rf.h       |   23 +-
 drivers/media/tuners/qm1d1c0042.c     |  644 +++++++-------
 drivers/media/tuners/qm1d1c0042.h     |   34 +-
 14 files changed, 1903 insertions(+), 2755 deletions(-)
 delete mode 100644 drivers/media/pci/pt3/pt3_dma.c
 delete mode 100644 drivers/media/pci/pt3/pt3_i2c.c

-- 
1.8.4.5

