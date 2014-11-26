Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaKZWnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:43:14 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52964 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaKZWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:43:13 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 00/11] media: use vb2_ops_wait_prepare/finish helper
Date: Wed, 26 Nov 2014 22:42:23 +0000
Message-Id: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This patch set uses the vb2 ops helpers for wait_prepare and
wait_finish callbacks for drivers which using vb2 helpers.
This patchset is compile tested only.

Changes for v2:
a: Included proper commit message.
b: included Ack.

Lad, Prabhakar (11):
  media: s3c-camif: use vb2_ops_wait_prepare/finish helper
  media: ti-vpe: use vb2_ops_wait_prepare/finish helper
  media: exynos-gsc: use vb2_ops_wait_prepare/finish helper
  media: soc_camera: use vb2_ops_wait_prepare/finish helper
  media: sh_veu: use vb2_ops_wait_prepare/finish helper
  media: marvell-ccic: use vb2_ops_wait_prepare/finish helper
  media: s5p-tv: use vb2_ops_wait_prepare/finish helper
  media: blackfin: use vb2_ops_wait_prepare/finish helper
  media: s5p-mfc: use vb2_ops_wait_prepare/finish helper
  media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper
  media: usb: uvc: use vb2_ops_wait_prepare/finish helper

 drivers/media/platform/blackfin/bfin_capture.c     | 17 ++---------
 drivers/media/platform/davinci/vpif_capture.c      |  2 ++
 drivers/media/platform/exynos-gsc/gsc-core.h       | 12 --------
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  6 ++--
 drivers/media/platform/marvell-ccic/mcam-core.c    | 29 ++++--------------
 drivers/media/platform/s3c-camif/camif-capture.c   | 17 ++---------
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 20 ++-----------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 20 ++-----------
 drivers/media/platform/s5p-tv/mixer_video.c        | 21 ++-----------
 drivers/media/platform/sh_veu.c                    | 35 +++++-----------------
 drivers/media/platform/soc_camera/atmel-isi.c      |  7 +++--
 drivers/media/platform/soc_camera/mx3_camera.c     |  7 +++--
 drivers/media/platform/soc_camera/rcar_vin.c       |  7 +++--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  7 +++--
 drivers/media/platform/soc_camera/soc_camera.c     | 16 ----------
 drivers/media/platform/ti-vpe/vpe.c                | 19 ++++--------
 drivers/media/usb/uvc/uvc_queue.c                  | 18 ++---------
 18 files changed, 59 insertions(+), 202 deletions(-)

-- 
1.9.1

