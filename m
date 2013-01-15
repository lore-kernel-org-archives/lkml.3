Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3AOJgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 04:36:47 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64165 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3AOJgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 04:36:45 -0500
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 15 Jan 2013 14:58:58 +0530
Message-ID: <CA+V-a8vZYJixr=6XLnZpcssjEcJbRa3E7dxgMWOU_p+2BnSYXQ@mail.gmail.com>
Subject: [GIT PULL FOR v3.9] Davinci media trivial fixes
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches for DaVinci media, fixing trivial issues.

Regards,
--Prabhakar Lad

The following changes since commit 3151d14aa6e983aa36d51a80d0477859f9ba12af:

  [media] media: remove __dev* annotations (2013-01-11 13:03:24 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_mauro

Lad, Prabhakar (2):
      davinci: dm355: Fix uninitialized variable compiler warnings
      davinci: dm644x: fix enum ccdc_gama_width and enum
ccdc_data_size comparision warning

Wei Yongjun (1):
      davinci: vpbe: fix missing unlock on error in vpbe_initialize()

 drivers/media/platform/davinci/dm355_ccdc.c  |    2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c |    5 ++++-
 drivers/media/platform/davinci/vpbe.c        |    6 ++++--
 3 files changed, 9 insertions(+), 4 deletions(-)
